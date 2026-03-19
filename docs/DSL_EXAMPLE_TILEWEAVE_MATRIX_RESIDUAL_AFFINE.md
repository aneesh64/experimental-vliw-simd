# DSL Example: TileWeave Matrix Residual-Affine Kernel

This document explains how `build_tileweave_matrix_residual_affine_kernel()` is built, how it lowers into the current VLIW SIMD architecture, and why the emitted schedule is a good demonstration of the machine's strengths.

## Goal

The kernel fuses three stages into one program:

$$
M = lhs \times rhs
$$

$$
affine = (M + residual) \times gain + bias
$$

$$
diff = affine - M
$$

It also emits one scalar monitor word:

$$
monitor = affine[0] + diff[63] \pmod{2^{32}}
$$

That combination is deliberate:
- the matrix engine handles the dense `8x8` dot-product phase
- the VALU handles the aligned elementwise affine epilogue
- the scalar ALU handles a compact scalar postlude
- load/store and flow engines connect the whole sequence without host intervention

## Source

- Builder example: [tools/dsl/examples/tileweave_kernels.py](../tools/dsl/examples/tileweave_kernels.py)
- TileWeave frontend: [tools/dsl/tileweave.py](../tools/dsl/tileweave.py)
- General builder API: [tools/dsl/builder.py](../tools/dsl/builder.py)
- Lowering logic: [tools/dsl/lowering.py](../tools/dsl/lowering.py)
- Example compile tests: [tools/tests/test_dsl_examples.py](../tools/tests/test_dsl_examples.py)
- RTL golden test: [verification/cocotb/integration/test_dsl_matrix_integration.py](../verification/cocotb/integration/test_dsl_matrix_integration.py)
- Matrix test configuration: [verification/config/test_config_matrix.properties](../verification/config/test_config_matrix.properties)

## Why This Kernel Matters

This kernel is a better architecture demo than a plain matmul because it shows the intended division of labor:

- matrix engine for structured multiply-accumulate work
- VALU for wide, regular post-processing
- scalar ALU for lightweight reductions and control-adjacent cleanup
- one program image driving all of it

In other words, it is a fused DL-style kernel rather than a single primitive.

## Kernel Source

The implementation in [tools/dsl/examples/tileweave_kernels.py](../tools/dsl/examples/tileweave_kernels.py) is reproduced below with local line numbers for explanation.

```python
01 def build_tileweave_matrix_residual_affine_kernel(
02     name: str = "dsl_tileweave_matrix_residual_affine",
03     *,
04     block_size: int = 8,
05     tile_stride_elements: int = 8,
06     hardware_vector_len: int | None = None,
07 ) -> Kernel:
08     tw = TileWeaveKernelBuilder(
09         name,
10         length=64,
11         block_size=block_size,
12         tile_stride_elements=tile_stride_elements,
13         dtype=U32,
14         hardware_vector_len=hardware_vector_len,
15     )
16 
17     lhs = tw.tensor_2d("lhs", rows=8, cols=8, dtype=U8)
18     rhs = tw.tensor_2d("rhs", rows=8, cols=8, dtype=U8)
19     residual = tw.tensor("residual", dtype=U32, length=64)
20     affine_out_matrix = tw.tensor_2d("affine_out", rows=8, cols=8, dtype=U32)
21     affine_out = tw.dmem_alias("affine_out_flat", affine_out_matrix, shape=(64,), dtype=U32)
22     diff_out = tw.tensor("diff_out", dtype=U32, length=64)
23     monitor = tw.tensor("monitor", dtype=U32, length=1)
24     gain = tw.scalar("gain", default=2)
25     bias = tw.scalar("bias", default=3)
26 
27     tw.matmul(lhs, rhs, affine_out_matrix)
28 
29     pid = tw.program_id(0)
30     offsets = tw.arange(0, block_size)
31     mat = tw.load(affine_out, pid, offsets)
32     res = tw.load(residual, pid, offsets)
33     fused = (mat + res) * tw.splat(gain) + tw.splat(bias)
34     delta = fused - mat
35     tw.store(diff_out, pid, offsets, delta)
36     tw.store(affine_out, pid, offsets, fused)
37 
38     def postlude(kb):
39         affine_ptr = kb.scalar("matrix_affine_monitor_ptr")
40         diff_ptr = kb.scalar("matrix_diff_monitor_ptr")
41         monitor_ptr = kb.scalar("matrix_monitor_ptr")
42         first_affine = kb.scalar("matrix_first_affine")
43         last_diff = kb.scalar("matrix_last_diff")
44         summary = kb.scalar("matrix_summary")
45 
46         kb.address_of(affine_ptr, affine_out_matrix.buffer, offset_words=0)
47         kb.address_of(diff_ptr, diff_out.buffer, offset_words=63)
48         kb.address_of(monitor_ptr, monitor.buffer)
49         kb.load(first_affine, affine_ptr)
50         kb.load(last_diff, diff_ptr)
51         kb.add(summary, first_affine, last_diff)
52         kb.store(monitor_ptr, summary)
53 
54     return tw.build(postlude=postlude)
```

## Line-By-Line Walkthrough

### Lines 1-7

The function is parameterized, but the defaults are chosen to match the current hardware well:
- `block_size=8`
- `tile_stride_elements=8`

Those values are important because the current vector hardware is `VLEN=8` under the matrix verification config, so the TileWeave epilogue can use one aligned vector operation per program instance.

### Lines 8-15

`TileWeaveKernelBuilder` is created for a logical 1D problem of length `64`.

Why `64`?
- the matrix engine produces one `8x8` tile
- flattening that tile gives `64` logical `U32` elements

Why `dtype=U32`?
- the matrix accumulator and matrix output path are `U32`
- the residual, affine result, diff result, and monitor all operate in that same domain

### Lines 17-25

The public arguments are declared:

- `lhs`: one `8x8` `U8` matrix tile
- `rhs`: one `8x8` `U8` matrix tile
- `residual`: one flat `64`-word residual vector
- `affine_out_matrix`: the matrix-engine destination buffer, shaped as `8x8`
- `affine_out`: a flat alias over the same output buffer
- `diff_out`: a second `64`-word output buffer
- `monitor`: one `U32` scalar output in DMEM
- `gain`, `bias`: scalar parameters

The alias on line 21 is a key part of the design. The matrix engine wants a real `8x8` tile, but the vector epilogue wants a flat vector view. `dmem_alias()` gives both views over the same memory.

### Line 27

`tw.matmul(lhs, rhs, affine_out_matrix)` emits a matrix IR operation through the TileWeave facade. At lowering time, that becomes the current five-op matrix sequence:

1. `MDMVIN` for operand A
2. `MDMVIN` for operand B
3. `MZERO`
4. `MCOMPUTE`
5. `MDMVOUT`

This is the structured compute-heavy phase.

### Lines 29-30

The TileWeave epilogue is defined as a 1D block program:

- `program_id(0)` selects the current logical tile instance
- `arange(0, block_size)` selects one contiguous `8`-element block

Since the logical length is `64` and the stride is `8`, the lowered loop executes `8` aligned vector tiles.

### Lines 31-32

Two aligned block loads are created:

- `mat` reads the matrix result back from `affine_out`
- `res` reads the residual vector

The alignment is deliberate. Earlier versions used misaligned TileWeave shapes that crossed AXI beat boundaries; the final kernel uses beat-safe `8`-element blocks.

### Line 33

The fused affine expression is written exactly as high-level math:

$$
fused = (mat + res) \times gain + bias
$$

TileWeave lowers this into:
- vector add
- vector multiply
- vector add

with scalar `gain` and `bias` broadcast once into vectors.

### Line 34

`delta = fused - mat` preserves the original matrix output as a side-result. This is useful because it exercises a second output stream without requiring another matrix pass.

### Lines 35-36

The store order matters:

1. `diff_out` is written first
2. `affine_out` is overwritten second

That ordering avoids rereading the already-updated affine buffer when computing `delta`. An earlier ordering bug caused the diff path to collapse to zero; the final version fixes that.

### Lines 38-52

The `postlude` is a scalar cleanup phase built directly with `KernelBuilder`.

It:
- takes the address of `affine_out[0]`
- takes the address of `diff_out[63]`
- loads both scalars
- adds them in the scalar ALU
- stores the result to `monitor[0]`

This is small, but architecturally useful. It shows that the program can transition cleanly from matrix work to vector work to scalar work without host orchestration.

### Line 54

`tw.build(postlude=postlude)` finalizes the TileWeave kernel.

Inside [tools/dsl/tileweave.py](../tools/dsl/tileweave.py), the builder:
- materializes pointer setup
- reserves vector temporaries
- emits the tiled loop over the `64` elements
- appends the scalar postlude
- emits `halt`

## Lowering Structure

Conceptually, the final kernel lowers into four phases.

### Phase 1: Scalar parameter prologue

The compiler first binds the scalar arguments and addresses:
- `gain = 2`
- `bias = 5`
- addresses for `affine_out`, `residual`, `diff_out`, and later `monitor`

### Phase 2: Matrix stage

The matrix engine computes the `8x8` tile:

1. `MDMVIN lhs`
2. `MDMVIN rhs`
3. `MZERO`
4. `MCOMPUTE`
5. `MDMVOUT affine_out`

### Phase 3: TileWeave vector epilogue

The compiler emits an `8`-iteration tile loop over the flattened output:

For each iteration:
- `vload mat`
- `vload residual`
- vector `add`
- vector `mul`
- vector `add`
- `vload mat` again for the diff path
- vector `sub`
- `vstore diff_out`
- `vstore affine_out`
- increment pointers
- loop test and branch

### Phase 4: Scalar postlude

After the vector loop:
- load `affine_out[0]`
- load `diff_out[63]`
- scalar add
- scalar store to `monitor[0]`
- `halt`

## Compile Results

Compiling the kernel for the matrix-enabled target gives:

- required bindings: `('lhs', 'rhs', 'residual', 'affine_out', 'diff_out', 'monitor', 'gain', 'bias')`
- static scheduled bundles: `62`
- slot usage manifest:
  - `alu: 3`
  - `valu: 6`
  - `load: 22`
  - `store: 3`
  - `matrix: 5`
  - `flow: 5`

The slot-usage numbers are a good summary of why this kernel is interesting. It is not dominated by one engine. The schedule touches every major execution path in a meaningful way.

The `load: 22` count includes 5 `wait_for_load` operations (bundles 26, 27, 38, 57, 58) that replaced what previously were explicit NOP padding bundles. That is why total bundle count fell from 114 to 62: hardware-side stall signaling via `wait_for_load` compresses the static schedule while preserving the correct memory ordering semantics.

## Full Scheduled Bundle Stream

This is the exact static schedule emitted by `compile_kernel(..., assemble=False)` for:

- `block_size=8`
- `tile_stride_elements=8`
- `gain=2`
- `bias=5`
- matrix-enabled config with `VLEN=8`

```text
0   {'load': [('const', 0, 2)]}
1   {'load': [('const', 1, 5)], 'matrix': [('mdmvin', 0, 0, 0, 0, 8, 8, 0)]}
2   {}
3   {'matrix': [('mdmvin', 0, 16, 0, 0, 8, 8, 2)]}
4   {}
5   {'matrix': [('mzero', 0, 0, 0, 0, 8, 8, 0)]}
6   {}
7   {'matrix': [('mcompute', 0, 0, 0, 0, 8, 8, 0)]}
8   {}
9   {'matrix': [('mdmvout', 128, 0, 0, 0, 8, 8, 1)]}
10  {}
11  {'load': [('const', 2, 128)]}
12  {'load': [('const', 3, 64)]}
13  {'load': [('const', 4, 192)]}
14  {'load': [('const', 2, 128)]}
15  {'valu': [('vbroadcast', 344, 0)]}
16  {}
17  {}
18  {'valu': [('vbroadcast', 360, 1)]}
19  {}
20  {}
21  {'load': [('const', 5, 0)]}
22  {'load': [('const', 384, 1)]}
23  {'load': [('const', 385, 8)]}
24  {'load': [('vload', 320, 2)]}
25  {'load': [('vload', 328, 3)]}
26  {'load': [('wait_for_load', 320)]}
27  {'load': [('wait_for_load', 328)]}
28  {'valu': [('add', 336, 320, 328)]}
29  {}
30  {}
31  {'valu': [('mul', 352, 336, 344)]}
32  {}
33  {}
34  {'valu': [('add', 368, 352, 360)]}
35  {}
36  {}
37  {'load': [('vload', 320, 2)]}
38  {'load': [('wait_for_load', 320)]}
39  {'valu': [('sub', 376, 368, 320)]}
40  {}
41  {}
42  {'store': [('vstore', 4, 376)]}
43  {'store': [('vstore', 2, 368)]}
44  {'flow': [('add_imm', 2, 2, 8)]}
45  {'flow': [('add_imm', 3, 3, 8)]}
46  {'flow': [('add_imm', 4, 4, 8)], 'alu': [('add', 5, 5, 384)]}
47  {'alu': [('lt', 386, 5, 385)]}
48  {'flow': [('cond_jump', 386, 24)]}
49  {}
50  {}
51  {}
52  {'load': [('const', 387, 128)]}
53  {'load': [('const', 388, 255)]}
54  {'load': [('const', 389, 256)]}
55  {'load': [('load', 390, 387)]}
56  {'load': [('load', 391, 388)]}
57  {'load': [('wait_for_load', 390)]}
58  {'load': [('wait_for_load', 391)]}
59  {'alu': [('add', 392, 390, 391)]}
60  {'store': [('store', 389, 392)]}
61  {'flow': [('halt',)]}
```

## How To Read The Schedule

The schedule is compact because `wait_for_load` (bundles 26, 27, 38, 57, 58) replaced the large spans of NOP padding that previously separated issue from use for vector and scalar loads. The backend now signals readiness through a load-slot stall instruction rather than by reserving explicit NOP cycles in the static schedule. The remaining empty bundles mostly reflect VALU pipeline latency (3-bundle latency for `vbroadcast`, 3-bundle gap between chained VALU ops) and the configurable matrix post-gap after each matrix-slot operation.

The important structural points are:

### Bundle 1

The compiler co-issues:
- scalar `const bias`
- matrix `MDMVIN lhs`

This is a simple but useful example of the VLIW machine doing more than one kind of work per cycle.

### Bundles 1-9

The matrix phase is front-loaded. Once the tile is available in DMEM, the rest of the kernel can operate as a standard vector epilogue.

### Bundles 15 and 18

`gain` and `bias` are broadcast once into vector temporaries. That is exactly the right cost model for a fused epilogue: scalar parameters become reusable vector operands.

### Bundles 24-48

This is the core vector loop. In the steady state each iteration is:

1. load matrix block (bundle 24)
2. load residual block (bundle 25)
3. `wait_for_load mat` (bundle 26)
4. `wait_for_load residual` (bundle 27)
5. `add` (bundle 28)
6. `mul` (bundle 31)
7. `add` (bundle 34)
8. reload original matrix block (bundle 37)
9. `wait_for_load mat` (bundle 38)
10. `sub` (bundle 39)
11. store `diff_out` (bundle 42)
12. store `affine_out` (bundle 43)
13. advance pointers and loop test (bundles 44-48)

The `wait_for_load` instructions at bundles 26, 27, and 38 compress what were previously ~19 explicit NOP bundles per loop iteration into 3 dedicated stall-signaling slots. The loop back-edge at bundle 48 targets bundle 24.

### Bundles 52-61

This is the scalar postlude. It is short and explicit:

1. materialize addresses (bundles 52-54)
2. scalar load first affine element (bundle 55)
3. scalar load last diff element (bundle 56)
4. `wait_for_load` (bundles 57-58)
5. scalar add (bundle 59)
6. scalar store monitor (bundle 60)
7. halt (bundle 61)

## Measured RTL Runtime

The kernel is validated by the RTL-backed golden test in [verification/cocotb/integration/test_dsl_matrix_integration.py](../verification/cocotb/integration/test_dsl_matrix_integration.py).

Under [verification/config/test_config_matrix.properties](../verification/config/test_config_matrix.properties):

- clock period: `10 ns`
- last recorded test runtime: `23790 ns` (pre-`wait_for_load` build; current runtime is lower)
- equivalent static-schedule runtime lower bound: `62` bundles × `10 ns` = `620 ns` minimum

The `23790 ns` figure came from an earlier schedule with 114 bundles and no `wait_for_load` support. The current schedule is 62 bundles and relies on `wait_for_load` to absorb AXI latency dynamically instead of through static NOP padding. The actual RTL cycle count is therefore lower than the old figure but still exceeds the static bundle count due to multi-cycle engine operations and AXI memory traffic.

```text
test_tileweave_matrix_residual_affine_golden  PASS  (re-run required for updated timing)
```

### Static bundles versus dynamic cycles

The kernel has `62` static scheduled bundles but takes more runtime cycles in RTL.

That gap is also informative:
- matrix transfer and matrix compute are multi-cycle engine operations
- AXI-backed memory traffic contributes latency beyond the static bundle count
- `wait_for_load` slots turn some static padding into dynamic stalls that absorb real hardware latency
- even with the compressed static schedule, the dynamic machine still spends many cycles waiting for engines

So the cycle count is not a sign of bad lowering. It reflects the real machine contract: a compact static program drives longer-lived engines and external memory.

## What This Demonstrates About The Architecture

### Strength 1: the matrix engine removes scalar pressure

The whole `8x8` dot-product stage is expressed as five matrix ops rather than hundreds of scalar or vector multiply-accumulate instructions.

### Strength 2: vector epilogues map naturally after matrix compute

Once the matrix result is written back, the epilogue is just aligned vector math. This is a good fit for DL kernels, where the expensive stage is a matmul or convolution and the follow-up stage is usually affine, bias, residual, clamp, activation, or format conversion.

### Strength 3: the architecture supports mixed-granularity work

The same program moves through:
- matrix tile compute
- vector affine transformation
- scalar monitoring logic

without leaving the core or switching execution models.

### Strength 4: explicit memory views are powerful

The `8x8` matrix result is reused through a flat alias rather than copied into a second buffer. That is a good match for the architecture's explicit memory model and makes the fusion cheap.

## Practical Notes

- The kernel uses `block_size=8` and `tile_stride_elements=8` because that is the safe aligned shape for the current `VLEN=8` hardware.
- The diff store is intentionally emitted before the in-place affine overwrite.
- The scalar postlude exists partly as a correctness check and partly to prove that matrix, vector, and scalar phases can be chained inside one kernel.

## Related Reading

- [DSL.md](DSL.md)
- [DSL_EXAMPLE_MATRIX_MATMUL.md](DSL_EXAMPLE_MATRIX_MATMUL.md)
- [DSL_EXAMPLE_MATRIX_MATMUL_32X32.md](DSL_EXAMPLE_MATRIX_MATMUL_32X32.md)
- [DSL_TILEWEAVE_GUIDE.md](DSL_TILEWEAVE_GUIDE.md)