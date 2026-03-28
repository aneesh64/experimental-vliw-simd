# DSL Example: TurboQuant-Style 32x32 Score Kernel

This example shows how the repository maps a minimal public-description-inspired TurboQuant flow onto the existing fixed `8x8` matrix engine.

It is not a paper-exact reproduction. It is a practical approximation shaped around the current hardware:
- fixed `8x8` Hadamard-like block rotation
- signed coarse quantization
- full `32`-dimensional residual sign correction
- matrix-engine-heavy score accumulation

Two kernel variants are provided:
- **`build_turboquant_score_32x32_kernel()`** — default, full `32`-dimensional residual (529 bundles)
- **`build_turboquant_score_32x32_compact_kernel()`** — compact depth-1 residual slice (337 bundles)

## Goal

Given `32x32` signed key and query matrices, compute an approximate score matrix:

$$
S \approx K Q^T
$$

The approximation is built from two terms:

$$
S \approx S_{coarse} + S_{residual}
$$

where:
- $S_{coarse}$ comes from a `32`-dimensional coarse quantized representation
- $S_{residual}$ comes from the full `32`-dimensional `1`-bit residual sign matrix

The final kernel keeps the expensive work in matrix instructions rather than scalar post-processing.

## Quantization and what the demo actually measures

### What the encoding does

Each input element is split into two `int8` values that the matrix engine can multiply natively:

| Component | Value range | Stored as |
|---|---|---|
| Coarse code $c_i$ | $[-7, 7]$ (4-bit range, clipped to `_TURBOQUANT_QMAX = 7`) | `int8` |
| Residual sign $b_i$ | $\{-1, +1\}$ | `int8` |

Both components are stored as full bytes because the matrix engine consumes `int8` tiles. There is **no bit-packing**.

### DMEM footprint: this demo does not compress

Each original matrix becomes *two* `int8` matrices in DMEM:

| Buffer | Represents | DMEM bytes |
|---|---|---|
| `coarse_keys_tiles` | coarse codes for keys | 1024 |
| `residual_keys_tiles` | residual signs for keys | 1024 |
| `coarse_queries_tiles` | coarse codes for queries (transposed) | 1024 |
| `residual_queries_tiles` | residual signs for queries (transposed) | 1024 |
| **Total (encoded)** | | **4096 bytes** |
| Keys + queries as `int8` (unencoded) | | 2048 bytes |
| Keys + queries as `float32` (unencoded) | | 8192 bytes |

The encoded form uses **2× the storage** of unencoded `int8`. The encoding is purely about approximation quality, not storage savings.

### What the benefit actually is

The point of the encoding is **approximation quality per compute cost**:

- After the Hadamard rotation, energy is spread more evenly across dimensions, making the coarse `int8` quantizer (clipped to $\pm 7$) much more accurate per matmul than a naive quantizer on the raw values.
- The residual sign correction adds a second `int8 × int8` matmul that recovers the direction of each rounding error.

The demo validates this by comparing the hardware output against `golden_turboquant_scores_32x32()`, which applies the same two-term approximation in Python. The RTL result must match the Python golden exactly — confirming that the matrix engine computes the same two `int8 × int8` matmuls in silicon.

---

## Compression pipeline: actual bit-packing on hardware

The score kernel above computes projection scores but stores them as full `U32` — no actual storage savings. A second kernel (`build_turboquant_binarize_32x32_kernel`) implements genuine compression by extracting the sign bit from each score and packing 32 bits per row into a single `U32` word.

### Two-kernel architecture

The compression pipeline chains two kernels, driven by C host code:

| Kernel | Engine | Input | Output | Bundles |
|---|---|---|---|---|
| **K1**: `turboquant_score_32x32` | Matrix | 4 × 1024B I8 tiles | 32×32 U32 scores (4096B) | 529 |
| **K2**: `turboquant_binarize_32x32` | Vector + Scalar | 32×32 U32 scores | 32 packed U32 words (128B) | 122 |

### Compression achieved

| Metric | Value |
|---|---|
| Input bits (32×32 scores × 8 bits each) | 8192 |
| Output bits (32 packed U32 words) | 1024 |
| **Compression ratio** | **8×** |

### DMEM layout for the pipeline

Both kernels share the same DMEM address space — Kernel 2 reads directly from where Kernel 1 wrote, with no data movement between kernels:

| Region | Word offset | Size | Used by |
|---|---|---|---|
| Coarse keys tiles | 0 | 256 words | K1 input |
| Coarse queries tiles | 256 | 256 words | K1 input |
| Residual keys tiles | 512 | 256 words | K1 input |
| Residual queries tiles | 768 | 256 words | K1 input |
| Score matrix (U32) | 1024 | 1024 words | K1 output → K2 input |
| Compressed output | 2048 | 32 words | K2 output |

### How the binarize kernel works

Kernel 2 uses a `counted_loop` over 32 rows. For each row:

1. **Load scores**: Four `vload` operations read 8 consecutive U32 scores into vector scratch (4 groups × 8 lanes = 32 scores per row).
2. **Extract sign bits**: `vector_binary("shr", v, 31)` shifts bit 31 to position 0. `vector_binary("xor", shifted, ones_vec)` flips: `hash_bit = 1 − sign_bit`.
3. **Pack 32 bits via scalar ALU**: 32 `lane` extractions feed into a scalar accumulation loop: `packed = (packed << 1) | hash_bit`, packing MSB-first into a single `U32`.
4. **Store**: `scalar_store` writes the packed word to DMEM at `compressed_base + row`.

The vector engine handles the parallel sign extraction while the scalar engine handles the serial bit packing — both engines are utilized in a single kernel.

### Engine utilization across the pipeline

| Engine | K1 (projection) | K2 (binarize) |
|---|---|---|
| Matrix | 528 slots (all matmul) | — |
| Vector | — | shr, xor per group |
| Scalar | — | shl, or per bit, loop control |
| Flow | 1 (halt) | 1 (halt) |

### Running the compression pipeline

```bash
# CLI summary
python tools/turboquant_demo.py --compress

# Emit artifacts for both kernels
python tools/turboquant_demo.py --compress --emit-dir generated/turboquant_compress_demo
```

### C driver flow

The C driver (`drivers/example_turboquant_compress.c`) implements the full DDR → DMEM → K1 → K2 → DMEM → DDR flow:

1. Load K1 and K2 IMEM programs and input data from artifact files
2. Write I8 input matrices to DDR
3. DMA input tiles from DDR to DMEM
4. Load K1 IMEM, start core, wait for HALT
5. Reset core, load K2 IMEM, start core, wait for HALT
6. DMA compressed output from DMEM to DDR
7. Read back 32 packed U32 words and verify against golden expected output

---

## Feasibility of further compression

### Nibble packing (4-bit coarse codes)

The ISA also supports packing the 4-bit coarse codes themselves. After computing coarse codes:

1. `vector_binary("and", ..., ew=8)` with mask `0x0F` isolates the low nibble
2. `vector_binary("shl", ..., ew=8)` by 4 shifts partner values to high nibble
3. `vector_binary("or", ..., ew=8)` combines two nibbles per byte

This would yield an additional 2× reduction on the coarse code storage. A compressed-format scoring kernel would need to **unpack nibbles back to `int8`** before each `mcompute`, adding a few VALU bundles per tile.

### Why the score kernel still uses `int8`

The score computation kernel keeps inputs as full `int8` because:

- The matrix engine's `mcompute` takes `int8` tiles directly via `mdmvin` — zero unpacking overhead
- The two-term approximation is correct regardless of storage format
- Compression savings apply to the *stored index* (large, cold, bandwidth-bound), not the hot compute path

## Source

- Builder example and golden model: [tools/dsl/examples/matrix_kernels.py](../tools/dsl/examples/matrix_kernels.py)
- Public exports: [tools/dsl/examples/__init__.py](../tools/dsl/examples/__init__.py)
- Top-level DSL exports: [tools/dsl/__init__.py](../tools/dsl/__init__.py)
- Standalone demo and artifact emitter: [tools/turboquant_demo.py](../tools/turboquant_demo.py)
- Example compilation tests: [tools/tests/test_dsl_examples.py](../tools/tests/test_dsl_examples.py)
- RTL matrix integration test: [verification/cocotb/integration/test_dsl_matrix_integration.py](../verification/cocotb/integration/test_dsl_matrix_integration.py)
- RTL driver-style integration test: [verification/cocotb/integration/test_driver_integration.py](../verification/cocotb/integration/test_driver_integration.py)
- Driver usage example (score only): [drivers/example_turboquant_32x32.c](../drivers/example_turboquant_32x32.c)
- Driver usage example (compression pipeline): [drivers/example_turboquant_compress.c](../drivers/example_turboquant_compress.c)
- Emitted artifact bundle: [generated/turboquant_32x32_demo](../generated/turboquant_32x32_demo)

## Public API

The example exposes seven public entry points:

- `encode_turboquant_matrix_32x32(values)`
- `golden_turboquant_scores_32x32(keys, queries)`
- `golden_turboquant_scores_32x32_compact(keys, queries)`
- `golden_turboquant_compress_32x32(keys, queries)`
- `build_turboquant_score_32x32_kernel()`
- `build_turboquant_score_32x32_compact_kernel()`
- `build_turboquant_binarize_32x32_kernel()`

The first four are host-side helpers. The last three build DSL kernels.

## Golden model

The golden path intentionally mirrors the hardware-facing layout.

### 1. Input shape

The host starts with two row-major signed `32x32` matrices:
- `keys`
- `queries`

Each element is expected to be in a small signed range. The demo uses deterministic values in `[-4, 4]`.

### 2. Fixed block rotation

Each row is partitioned into four `8`-element blocks. Each block is transformed by:

$$
x' = D H x
$$

where:
- $H$ is a fixed `8x8` Hadamard-like matrix
- $D$ is a fixed diagonal sign-flip pattern

This spreads energy more evenly before quantization, which is the main public intuition behind TurboQuant-style preprocessing.

### 3. Coarse quantization

The rotated `32`-element row is quantized into a signed coarse code:

$$
c_i = \operatorname{clip}(\operatorname{round}(x'_i / \Delta), -7, 7)
$$

The repository uses a fixed low-precision coarse code rather than row-adaptive metadata. That keeps the format simple and keeps the kernel metadata-free.

### 4. Residual signs

The quantization residual is reduced to signs:

$$
r = x' - \Delta c
$$

$$
b_i = \operatorname{sign}(r_i) \in \{-1, +1\}
$$

For the **full-residual kernel**, the entire `32x32` residual sign matrix is used directly.

For the **compact kernel**, only the first `8`-column slice (one tile column) of the residual key matrix and the corresponding first `8`-row slice of the residual query matrix are used, providing a depth-1 residual accumulation at lower IMEM cost.

### 5. Score construction

The golden score is formed as:

$$
S_{coarse} = C_K C_Q^T
$$

$$
S_{residual} = B_K B_Q^T
$$

$$
S = S_{coarse} + S_{residual}
$$

This is the exact value the RTL path is checked against.

## Kernel shape

### Full-residual kernel (`build_turboquant_score_32x32_kernel`)

It takes five DMEM bindings:
- `coarse_keys_tiles`
- `coarse_queries_tiles`
- `residual_keys_tiles`
- `residual_queries_tiles`
- `out_tiles`

Input layout:
- `coarse_keys_tiles`: `4x4x8x8` signed tiles, `1024` bytes total
- `coarse_queries_tiles`: `4x4x8x8` signed tiles, `1024` bytes total
- `residual_keys_tiles`: `4x4x8x8` signed tiles, `1024` bytes total
- `residual_queries_tiles`: `4x4x8x8` signed tiles, `1024` bytes total

Output layout:
- `out_tiles`: `4x4x8x8` `U32` tiles, `4096` bytes total

Binding word offsets used by the demo and RTL tests:
- `coarse_keys_tiles = 0`
- `coarse_queries_tiles = 256`
- `residual_keys_tiles = 512`
- `residual_queries_tiles = 768`
- `out_tiles = 1024`

### Compact kernel (`build_turboquant_score_32x32_compact_kernel`)

Uses a depth-1 residual path with smaller tile buffers:

- `coarse_keys_tiles`: `4x4x8x8` signed tiles, `1024` bytes total
- `coarse_queries_tiles`: `4x4x8x8` signed tiles, `1024` bytes total
- `residual_keys_slice`: `4x1x8x8` signed tiles, `256` bytes (32×8 matrix)
- `residual_queries_t_slice`: `1x4x8x8` signed tiles, `256` bytes (8×32 matrix)

Binding word offsets:
- `coarse_keys_tiles = 0`
- `coarse_queries_tiles = 256`
- `residual_keys_slice = 512`
- `residual_queries_t_slice = 576`
- `out_tiles = 640`

## Why full 32D residual is now the default

Earlier versions used the compact depth-1 sketch because a full `32`-dimensional residual matmul compiled to more than `1024` bundles when the scheduler inserted idle bundles between matrix operations (`matrix_post_gap=1`):

| Variant | Gap=1 | Gap=0 |
|---|---|---|
| Compact (depth-1) | 673 bundles | **337 bundles** |
| Full 32D residual | **1057 bundles** — exceeds limit | **529 bundles** — fits |

With `matrix_post_gap=0` (current default), the full-residual variant compiles to `529` bundles — well within the `1024`-bundle IMEM limit. The full residual path provides a deeper correction signal and is the more accurate approximation.

## Lowered execution flow

### Full-residual kernel

For each `8x8` output tile (16 tiles total for 32×32):

1. zero the accumulator
2. run four coarse tile multiplies across the `32`-dimensional coarse depth
3. run four residual tile multiplies (accumulating) across the full `32`-dimensional residual depth
4. write the tile back to DMEM

The matrix op counts:
- `16` `MZERO`
- `16` `MCOMPUTE`
- `112` `MCOMPUTE_ACC`
- `128` `MDMVOUT`

The compiled summary:
- `529` bundles
- `529` binary bundles
- `528` matrix-slot uses

### Compact kernel

For each `8x8` output tile:

1. zero the accumulator
2. run four coarse tile multiplies
3. run one residual tile multiply (depth-1 sketch)
4. write the tile back to DMEM

The matrix op counts:
- `16` `MZERO`
- `16` `MCOMPUTE`
- `64` `MCOMPUTE_ACC`
- `80` `MDMVOUT`

- `337` bundles, `336` matrix-slot uses

## Emitted artifacts

### Kernel 1 (score projection)

The score kernel can emit a driver-facing artifact bundle:

```bash
python tools/turboquant_demo.py --emit-dir generated/turboquant_32x32_demo
```

The repository includes one emitted instance at [generated/turboquant_32x32_demo](../generated/turboquant_32x32_demo) reflecting the **full-residual** kernel.

Human-readable emitted files:
- [generated/turboquant_32x32_demo/turboquant_32x32_instruction_bundles.txt](../generated/turboquant_32x32_demo/turboquant_32x32_instruction_bundles.txt)
- [generated/turboquant_32x32_demo/turboquant_32x32_imem_words.txt](../generated/turboquant_32x32_demo/turboquant_32x32_imem_words.txt)
- [generated/turboquant_32x32_demo/turboquant_32x32_metadata.json](../generated/turboquant_32x32_demo/turboquant_32x32_metadata.json)

The emitted metadata records:
- bundle count: `529`
- bundle width: `320` bits
- words per bundle: `10`
- IMEM word count: `5290`

### Kernel 2 (binarize)

The compression pipeline emits artifacts for both kernels together:

```bash
python tools/turboquant_demo.py --compress --emit-dir generated/turboquant_compress_demo
```

K2-specific files emitted to that directory:

| File | Contents |
|---|---|
| `turboquant_compress_k2_bundles.txt` | 122 assembled 320-bit bundle images |
| `turboquant_compress_k2_imem_words.txt` | 976 little-endian 32-bit IMEM words |
| `turboquant_compress_metadata.json` | Both kernel metadata, compression ratio |
| `turboquant_compress_expected_scores_u32_le.bin` | 1024 U32 golden scores from K1 |
| `turboquant_compress_expected_compressed_u32_le.bin` | 32 U32 packed binary codes (K2 output) |

The K2 metadata records:
- bundle count: `122`
- bundle width: `320` bits
- words per bundle: `10`
- IMEM word count: `976`
- slot usage: `alu: 66, valu: 10, load: 16, store: 1, flow: 7`

## Scheduled Bundle Stream

For the full-residual kernel, the compile manifest is:
- static scheduled bundles: `529`
- slot usage manifest:
   - `alu: 0`
   - `valu: 0`
   - `load: 0`
   - `store: 0`
   - `matrix: 528`
   - `flow: 1`

### Execution pattern per output tile

Each output tile executes `8` depth slices: `4` coarse followed by `4` residual. The matrix engine does not hold partial sums in-register across depth steps — it writes the accumulator back to DMEM after every compute and continues on the next `mdmvin` pair. The pattern per tile is:

1. `mdmvin` coarse key, `mdmvin` coarse query → `mzero` → `mcompute` → `mdmvout` (first coarse slice, 5 bundles)
2. `mdmvin` + `mdmvin` → `mcompute_acc` → `mdmvout` for each of coarse slices 2–4 (4 bundles × 3 = 12)
3. `mdmvin` residual key, `mdmvin` residual query → `mcompute_acc` → `mdmvout` for each of residual slices 1–4 (4 bundles × 4 = 16)

Total per tile: `5 + 12 + 16 = 33` bundles. Total across 16 tiles: `33 × 16 = 528` matrix bundles + `1` halt = `529` bundles.

### Leading bundle stream

The beginning of the emitted program for the full-residual kernel looks like this:

```text
0   {'matrix': [('mdmvin', 0, 0, 0, 0, 8, 8, 0)]}
1   {'matrix': [('mdmvin', 0, 256, 0, 0, 8, 8, 2)]}
2   {'matrix': [('mzero', 0, 0, 0, 0, 8, 8, 0)]}
3   {'matrix': [('mcompute', 0, 0, 0, 0, 8, 8, 0)]}
4   {'matrix': [('mdmvout', 1024, 0, 0, 0, 8, 8, 1)]}
5   {'matrix': [('mdmvin', 0, 16, 0, 0, 8, 8, 0)]}
6   {'matrix': [('mdmvin', 0, 320, 0, 0, 8, 8, 2)]}
7   {'matrix': [('mcompute_acc', 0, 0, 0, 0, 8, 8, 0)]}
8   {'matrix': [('mdmvout', 1024, 0, 0, 0, 8, 8, 1)]}
9   {'matrix': [('mdmvin', 0, 32, 0, 0, 8, 8, 0)]}
10  {'matrix': [('mdmvin', 0, 384, 0, 0, 8, 8, 2)]}
11  {'matrix': [('mcompute_acc', 0, 0, 0, 0, 8, 8, 0)]}
12  {'matrix': [('mdmvout', 1024, 0, 0, 0, 8, 8, 1)]}
13  {'matrix': [('mdmvin', 0, 48, 0, 0, 8, 8, 0)]}
14  {'matrix': [('mdmvin', 0, 448, 0, 0, 8, 8, 2)]}
15  {'matrix': [('mcompute_acc', 0, 0, 0, 0, 8, 8, 0)]}
16  {'matrix': [('mdmvout', 1024, 0, 0, 0, 8, 8, 1)]}
17  {'matrix': [('mdmvin', 0, 512, 0, 0, 8, 8, 0)]}
18  {'matrix': [('mdmvin', 0, 768, 0, 0, 8, 8, 2)]}
19  {'matrix': [('mcompute_acc', 0, 0, 0, 0, 8, 8, 0)]}
20  {'matrix': [('mdmvout', 1024, 0, 0, 0, 8, 8, 1)]}
21  {'matrix': [('mdmvin', 0, 528, 0, 0, 8, 8, 0)]}
22  {'matrix': [('mdmvin', 0, 832, 0, 0, 8, 8, 2)]}
23  {'matrix': [('mcompute_acc', 0, 0, 0, 0, 8, 8, 0)]}
24  {'matrix': [('mdmvout', 1024, 0, 0, 0, 8, 8, 1)]}
25  {'matrix': [('mdmvin', 0, 544, 0, 0, 8, 8, 0)]}
26  {'matrix': [('mdmvin', 0, 896, 0, 0, 8, 8, 2)]}
27  {'matrix': [('mcompute_acc', 0, 0, 0, 0, 8, 8, 0)]}
28  {'matrix': [('mdmvout', 1024, 0, 0, 0, 8, 8, 1)]}
29  {'matrix': [('mdmvin', 0, 560, 0, 0, 8, 8, 0)]}
30  {'matrix': [('mdmvin', 0, 960, 0, 0, 8, 8, 2)]}
31  {'matrix': [('mcompute_acc', 0, 0, 0, 0, 8, 8, 0)]}
32  {'matrix': [('mdmvout', 1024, 0, 0, 0, 8, 8, 1)]}
33  {'matrix': [('mdmvin', 0, 0, 0, 0, 8, 8, 0)]}
34  {'matrix': [('mdmvin', 0, 272, 0, 0, 8, 8, 2)]}
35  {'matrix': [('mzero', 0, 0, 0, 0, 8, 8, 0)]}
36  {'matrix': [('mcompute', 0, 0, 0, 0, 8, 8, 0)]}
```

### How to read the pattern

The structure is regular:

1. `mdmvin` loads a coarse key tile (addr `0`, `16`, `32`, `48` for the four depth slices of tile-row 0)
2. `mdmvin` loads a coarse query tile (addr `256`, `320`, `384`, `448` for depth slices 0–3 of tile-col 0)
3. `mzero` then `mcompute` for the very first depth slice of each new output tile; `mcompute_acc` for all subsequent slices
4. `mdmvout` writes the partial accumulation back to the output tile in DMEM
5. After the four coarse slices (bundles 0–16), the residual slices begin at bundle 17: `mdmvin` residual key at `512`, `528`, `544`, `560`; `mdmvin` residual query at `768`, `832`, `896`, `960`
6. Bundle 33 begins tile `[0][1]`: the key address resets to `0` (same tile-row) and the query address shifts to `272` (`256 + 16`) for column 1

### Tail of the program

The program ends with the last residual slices of tile `[3][3]` (output word address `1984 = 1024 + 15 × 64`) and a single halt:

```text
520  {'matrix': [('mdmvin', 0, 736, 0, 0, 8, 8, 0)]}
521  {'matrix': [('mdmvin', 0, 944, 0, 0, 8, 8, 2)]}
522  {'matrix': [('mcompute_acc', 0, 0, 0, 0, 8, 8, 0)]}
523  {'matrix': [('mdmvout', 1984, 0, 0, 0, 8, 8, 1)]}
524  {'matrix': [('mdmvin', 0, 752, 0, 0, 8, 8, 0)]}
525  {'matrix': [('mdmvin', 0, 1008, 0, 0, 8, 8, 2)]}
526  {'matrix': [('mcompute_acc', 0, 0, 0, 0, 8, 8, 0)]}
527  {'matrix': [('mdmvout', 1984, 0, 0, 0, 8, 8, 1)]}
528  {'flow': [('halt',)]}
```

The last residual key tile is `rk[3][3]` at word `752` (`512 + 15 × 16`), and the last residual query tile is `rq[3][3]` at word `1008` (`768 + 15 × 16`). After the final `mdmvout` the program immediately halts.

### Bundles vs assembled words

The two generated instruction files have separate roles:
- `turboquant_32x32_instruction_bundles.txt` is the assembled `320`-bit bundle image
- `turboquant_32x32_imem_words.txt` is the same program exploded into `10` little-endian `32`-bit words per bundle for the driver-side IMEM loader

For understanding the program shape, the symbolic schedule above is the better view.

## Binarize kernel (K2) scheduled bundle stream

For the binarize kernel, the compile manifest is:
- static scheduled bundles: `122`
- IMEM word count: `976`
- slot usage manifest:
   - `alu: 66`
   - `valu: 10`
   - `load: 16`
   - `store: 1`
   - `matrix: 0`
   - `flow: 7`

### Program structure

The binarize kernel has three phases:

| Phase | Bundles | Description |
|---|---|---|
| Prologue | 0–12 (13 static) | Load constants; broadcast shift/ones vectors |
| Loop body | 13–117 (105 static, ×32 dynamic) | Sign extraction + bit packing + store per row |
| Tail | 118–121 (4 static) | Pipeline drain + halt |

**Dynamic execution**: 13 prologue + 32 × 105 loop body + 4 tail = **3377 dynamic bundles**.

### Prologue (bundles 0–12)

All scalar constants and vector broadcast operands are set up once before the loop:

```text
0   {'load': [('const', 0, 31)]}           # r0 = 31 (shift amount)
1   {'load': [('const', 1, 1)]}            # r1 = 1 (ones constant for XOR)
2   {'valu': [('vbroadcast', 320, 0)]}     # shift31_vec@320 = broadcast(r0)
3   {}
4   {}
5   {'valu': [('vbroadcast', 328, 1)]}     # ones_vec@328 = broadcast(r1)
6   {}
7   {}
8   {'load': [('const', 3, 1024)]}        # r3 = scores base word offset
9   {'load': [('const', 4, 2048)]}        # r4 = compressed output word offset
10  {'load': [('const', 6, 0)]}           # r6 = loop counter
11  {'load': [('const', 384, 1)]}         # r384 = loop step
12  {'load': [('const', 385, 32)]}        # r385 = loop limit (32 rows)
```

### Loop body per row (bundles 13–117): sign extraction

Each row loads four groups of 8 U32 scores, extracts sign bits via vector shr/xor, and scatters the hash bits into 32 scalar lanes. The four groups are processed sequentially, each following the same pattern:

```text
13  {'load': [('vload', 336, 3)]}          # v_in@336 = scores[r3+0..7] (cols 0–7)
14  {'load': [('wait_for_load', 336)]}     # wait for memory latency
15  {'valu': [('shr', 344, 336, 320)]}    # v_shifted@344 = v_in >> 31 (sign bit to bit 0)
16  {}
17  {}
18  {'valu': [('xor', 352, 344, 328)]}    # v_bits_0@352 = v_shifted ^ 1 (hash_bit = 1 - sign)
19  {}
20  {}
21  {'flow': [('add_imm', 5, 3, 8)]}      # r5 = r3 + 8 (next group address)
22  {'load': [('vload', 336, 5)]}          # v_in@336 = scores[r3+8..15] (cols 8–15)
...
27  {'valu': [('xor', 360, 344, 328)]}    # v_bits_1@360 = hash bits for cols 8–15
...
36  {'valu': [('xor', 368, 344, 328)]}    # v_bits_2@368 = hash bits for cols 16–23
...
45  {'valu': [('xor', 376, 344, 328)]}    # v_bits_3@376 = hash bits for cols 24–31
```

After all four group loads, scratch registers `352`–`383` hold the 32 hash bits (8 lanes × 4 groups), one per vector lane alias.

### Loop body per row (bundles 48–112): bit packing

The 32 hash bits are packed MSB-first into a single `U32` using 64 scalar `shl`/`or` pairs:

```text
48  {'load': [('const', 2, 0)]}           # r2 = 0 (packed word accumulator)
49  {'alu': [('shl', 2, 2, 1)]}          # r2 <<= 1
50  {'alu': [('or', 2, 2, 383)]}         # r2 |= hash_bit(col 31)  — bit 0 after first shift
51  {'alu': [('shl', 2, 2, 1)]}          # r2 <<= 1
52  {'alu': [('or', 2, 2, 382)]}         # r2 |= hash_bit(col 30)
...
111 {'alu': [('shl', 2, 2, 1)]}
112 {'alu': [('or', 2, 2, 352)]}         # r2 |= hash_bit(col 0)  — final LSB
```

After 64 iterations: bit `i` of `r2` = `hash_bit` for column `i`. Each hash bit is 1 when the projection score is non-negative, 0 when negative.

### Loop epilogue (bundles 113–117)

```text
113 {'store': [('store', 4, 2)]}                          # compressed[r4] = r2 (packed word)
114 {'flow': [('add_imm', 3, 3, 32)]}                    # r3 += 32 (advance scores pointer by one row)
115 {'flow': [('add_imm', 4, 4, 1)], 'alu': [('add', 6, 6, 384)]}  # r4 += 1; counter += 1
116 {'alu': [('lt', 386, 6, 385)]}                       # r386 = (counter < 32)
117 {'flow': [('cond_jump', 386, 13)]}                   # if r386: jump to bundle 13
```

The loop iterates 32 times (one per row). After the final row's store, the condition fails and execution falls through to the tail.

### Tail (bundles 118–121)

```text
118 {}
119 {}
120 {}
121 {'flow': [('halt',)]}
```

Three empty bundles drain any pending pipeline effects, followed by halt.

### How to read the K2 pattern

1. All vector ops use word-addressed scratch: `shift31_vec` at 320, `ones_vec` at 328, `v_in` at 336, `v_shifted` at 344, `v_bits_0..3` at 352/360/368/376
2. Each vector register holds 8 U32 lanes; four such vectors cover all 32 columns per row
3. The scalar ALU has no parallel-reduce instruction, so bit packing is sequential: 2 ALU bundles per bit × 32 bits = 64 bundles per row
4. The 3 empty bundles after `cond_jump` are branch-delay slots required by the ISA

## Full example flow

The complete flow is:

1. Start from deterministic row-major `keys` and `queries`
2. Run `golden_turboquant_scores_32x32()` to build:
   - coarse tile-packed inputs
   - residual tile-packed inputs (full 32×32)
   - expected packed output
   - expected row-major output
3. Build the matrix-enabled kernel with `build_turboquant_score_32x32_kernel()`
4. Compile and assemble it with fixed DMEM bindings
5. Emit bundle-level and IMEM-word program images
6. Load the IMEM program and DMEM buffers through the C driver or RTL harness
7. Execute until HALT
8. Read back `out_tiles`
9. Compare against the golden packed output image

That same sequence is covered in three places:
- standalone emitter/demo script
- RTL DSL golden integration test
- RTL driver-style integration test

## Verification

The example is verified in three layers:

1. Python compile and artifact tests verify the kernel shape, op counts, and emitted artifact files
2. RTL DSL integration runs the kernel directly against the Python golden model
3. RTL driver integration exercises the host-style preload, start, halt, and readback flow

## Relevance to KV cache compression

The compression pipeline implemented here maps directly onto one of the most bandwidth-critical problems in large-language-model inference: compressing the **key-value (KV) cache**.

### What is the KV cache problem

During autoregressive LLM decoding each generated token must attend over every prior token's key and query vectors. With long sequences and large models the KV cache becomes the dominant DRAM bottleneck:

- A 70B-parameter model running sequences of 32K tokens may need **hundreds of gigabytes** of KV cache in `bfloat16`.
- Every decode step streams this entire cache through memory — at 1 token/step, bandwidth is the throughput ceiling.
- Reducing KV cache precision from 16-bit to 1-bit binary codes would yield a **16× bandwidth reduction** at the cost of attention-score approximation error.

### How this hardware pipeline maps onto the problem

| LLM concept | This demo | Hardware engine |
|---|---|---|
| Key matrix (32 tokens × 32 hidden dims) | `keys[32×32]` I8 input | — |
| Query vector (1 token × 32 dims) | `queries[32×32]` I8 input | — |
| Hadamard rotation pre-processing | `encode_turboquant_matrix_32x32()` (host-side) | — |
| Approximate attention scores `Q Kᵀ` | `turboquant_score_32x32` kernel | Matrix engine |
| Binary quantization of scores | `turboquant_binarize_32x32` kernel | Vector + Scalar engines |
| Compressed KV entries stored to DRAM | `compressed[32]` U32 words | DMEM → DDR |

In a real inference scenario:

1. **Offline (KV write path)**: As each new token is processed, its key vector is Hadamard-rotated on-host, then the matrix engine accumulates coarse + residual projection scores. The binarize kernel converts the score row to a packed 32-bit binary code which is written back to the KV cache in DRAM — **32 bytes instead of 512 bytes** for a 32-dim key.
2. **Online (attention query path)**: For each decode step, the same pipeline runs with the current query. The resulting 32 packed binary codes (one per stored token) are compared against the compressed keys using popcount-based Hamming similarity instead of full dot products.

### Why the 8× compression ratio matters for memory bandwidth

| Format | Bytes per key vector (32D) | Bandwidth at 1M tokens |
|---|---|---|
| `float32` | 128 bytes | 128 MB |
| `int8` (uncompressed) | 32 bytes | 32 MB |
| Binary codes (this demo, 1 bit/dim) | 4 bytes | 4 MB |

The binary-code path uses **32× less bandwidth** than `float32` and **8× less** than `int8`, at the cost of representing each attention score as a Hamming distance rather than a full dot product.

### Approximation quality trade-off

The two-term score `S = S_coarse + S_residual` improves ranking quality vs. a direct 1-bit hash:

- The coarse term corrects for large-scale quantization error (the `int8` clip at `±7`).
- The residual term corrects for rounding direction, recovering the sign of the approximation error at the expense of one extra `int8 × int8` matmul.
- The final binarization on `S` (not on the raw inputs) produces better locality-sensitive hash codes than hashing the raw activations directly.

This is the same motivation as KVQuant, GQA with binary attention, and similar production techniques — approximating attention with compressed keys to trade small accuracy loss for large memory-bandwidth savings.

### What would be needed for a production implementation

The repository currently demonstrates the kernel mechanics. A production KV cache compression system would additionally require:

- **Online rotation**: moving the Hadamard rotation into a DSL kernel (feasible with the vector engine)
- **Streaming pipeline**: pipelining token writes to avoid recomputing projections at query time
- **Popcount scoring**: a kernel that computes Hamming distances between a compressed query code and all stored key codes in DRAM
- **Top-k selection**: integrating the Hamming scores into the full attention softmax path

All four steps are expressible with the current ISA; the existing kernels implement the heaviest sub-problem (the matmul + binarize path) and demonstrate that the hardware can sustain the required throughput.

## Current limits

Current limitations remain explicit:
- this is a TurboQuant-style approximation, not a paper-exact implementation
- the transform matrix is fixed, not runtime-trained
- the coarse quantizer is fixed and metadata-free
- the matrix engine still consumes fixed contiguous `8x8` tiles, so the host must pre-pack DMEM buffers

## Related reading

- [DSL_EXAMPLE_MATRIX_MATMUL_32X32.md](DSL_EXAMPLE_MATRIX_MATMUL_32X32.md)
- [DRIVER_API.md](DRIVER_API.md)
- [DSL_PROGRAMMING_GUIDE.md](DSL_PROGRAMMING_GUIDE.md)
- [DSL.md](DSL.md)