# DSL Example: Tiled 32x32 Matrix Matmul

This example shows how to build a `32x32` matrix multiply on top of the current fixed `8x8` matrix engine.

## Goal

Express a larger matrix multiply in the Python DSL by explicitly composing `8x8` matrix-engine tiles.

Semantically:

$$
C_{32\times32} = A_{32\times32} \times B_{32\times32}
$$

Operationally, the DSL expands this into `4x4x4 = 64` logical `8x8` tile multiplies:

$$
C_{i,j} = \sum_{k=0}^{3} A_{i,k} \times B_{k,j}
$$

where each $A_{i,k}$, $B_{k,j}$, and $C_{i,j}$ is one `8x8` tile.

## Source

- Builder example: [tools/dsl/examples/matrix_kernels.py](../tools/dsl/examples/matrix_kernels.py)
- Builder API: [tools/dsl/builder.py](../tools/dsl/builder.py)
- Lowering logic: [tools/dsl/lowering.py](../tools/dsl/lowering.py)
- Compile/lowering tests: [tools/tests/test_dsl_lowering.py](../tools/tests/test_dsl_lowering.py)
- Example compilation tests: [tools/tests/test_dsl_examples.py](../tools/tests/test_dsl_examples.py)
- RTL integration test: [verification/cocotb/integration/test_dsl_matrix_integration.py](../verification/cocotb/integration/test_dsl_matrix_integration.py)

## Kernel shape

The public example is exposed as `build_matrix_matmul_32x32_tiled_kernel()`.

It takes three DMEM bindings:
- `lhs_tiles`
- `rhs_tiles`
- `out_tiles`

These are not plain row-major `32x32` matrices. They are tile-packed arrays of `8x8` blocks laid out contiguously in DMEM.

Input tile packing:
- `lhs_tiles`: 16 tiles of `8x8` `U8`
- `rhs_tiles`: 16 tiles of `8x8` `U8`

Output tile packing:
- `out_tiles`: 16 tiles of `8x8` `U32`

Tile order is row-major over the `4x4` tile grid.

## Why tile-packed layout is required

The current matrix direct-transfer path moves one contiguous `8x8` tile at a time. It does not accept a row stride for fetching a submatrix from a larger row-major `32x32` tensor.

That means a logical `8x8` tile must already be contiguous in DMEM before it can be consumed by `matmul()`.

So this example uses:
- explicit tile packing in memory
- explicit DMEM aliases for each tile
- repeated `matmul(..., accumulate=...)` calls to build the full result

The DSL package now exposes helper functions so callers can convert to and from this layout without hand-authoring the tile order:
- `pack_matrix_matmul_32x32_u8_tiles()`
- `unpack_matrix_matmul_32x32_u8_tiles()`
- `pack_matrix_matmul_32x32_u32_tiles()`
- `unpack_matrix_matmul_32x32_u32_tiles()`

For a runnable compile-and-host-preparation example outside cocotb, see [tools/matrix_matmul_32x32_demo.py](../tools/matrix_matmul_32x32_demo.py).

## DSL pattern

```python
from dsl import KernelBuilder, U8, U32


kb = KernelBuilder("matrix_matmul_32x32_tiled")
lhs_tiles = kb.arg_dmem_tensor("lhs_tiles", shape=(4, 4, 8, 8), dtype=U8)
rhs_tiles = kb.arg_dmem_tensor("rhs_tiles", shape=(4, 4, 8, 8), dtype=U8)
out_tiles = kb.arg_dmem_tensor("out_tiles", shape=(4, 4, 8, 8), dtype=U32)

for tile_row in range(4):
    for tile_col in range(4):
        for tile_k in range(4):
            ...
            kb.matmul(lhs_tile, rhs_tile, out_tile, accumulate=tile_k > 0)

kb.halt()
kernel = kb.build()
```

The concrete implementation uses `dmem_alias()` to bind each logical tile to a fixed word offset under the shared DMEM argument.

## Host-side layout helpers

Typical host-side usage looks like this:

```python
from dsl import (
   pack_matrix_matmul_32x32_u8_tiles,
   unpack_matrix_matmul_32x32_u32_tiles,
)


lhs_row_major = [...1024 U8 elements...]
rhs_row_major = [...1024 U8 elements...]

lhs_tiles = pack_matrix_matmul_32x32_u8_tiles(lhs_row_major)
rhs_tiles = pack_matrix_matmul_32x32_u8_tiles(rhs_row_major)

# write lhs_tiles and rhs_tiles into DMEM, run the kernel, then read back out_tiles

out_row_major = unpack_matrix_matmul_32x32_u32_tiles(out_tiles)
```

These helpers are intentionally small and explicit. They do not perform numeric matmul themselves; they only translate between row-major host layout and the tile-packed DMEM layout expected by the current kernel.

## Standalone demo script

You can exercise the public host-side path without the RTL harness by running:

```bash
python tools/matrix_matmul_32x32_demo.py
```

That script:
- generates deterministic row-major `32x32` inputs
- packs them into tile order with the public helper API
- compiles `build_matrix_matmul_32x32_tiled_kernel()` for a matrix-enabled target
- computes the software golden result
- prints bundle and binding metadata together with small previews of the packed input and expected output buffers

Use `--json` if you want the summary in machine-readable form.

If you want driver-consumable files, emit artifacts with:

```bash
python tools/matrix_matmul_32x32_demo.py --emit-dir <artifact_dir>
```

That produces:
- IMEM words as `matrix_matmul_32x32_imem_words.txt`
- packed `lhs` and `rhs` DMEM images as raw `.bin` files
- expected packed and row-major output images as raw `.bin` files
- a small metadata JSON summary

The matching driver-side usage example is [drivers/example_matrix_matmul_32x32.c](../drivers/example_matrix_matmul_32x32.c).

## Lowering behavior

For each output tile:

1. the first inner-product term lowers as:
   - `MDMVIN lhs`
   - `MDMVIN rhs`
   - `MZERO`
   - `MCOMPUTE`
   - `MDMVOUT out`
2. each remaining inner-product term lowers as:
   - `MDMVIN lhs`
   - `MDMVIN rhs`
   - `MCOMPUTE_ACC`
   - `MDMVOUT out`

For a full `32x32` multiply this produces:
- 16 output tiles
- 64 logical tile multiplies
- 272 matrix-engine ops in total

## Verification

The example is verified in two ways:

1. compile/lowering tests confirm the expected op counts and binding model
2. RTL integration runs the full tiled kernel against a Python golden `32x32` matrix multiply and checks all 1024 `U32` outputs

The RTL coverage also includes a host-style flow that starts from row-major `lhs` and `rhs`, uses the public `pack_matrix_matmul_32x32_u8_tiles()` helpers, runs the tiled kernel, then converts the 1024-word output back to row-major with `unpack_matrix_matmul_32x32_u32_tiles()` before comparing against the software golden result.

## Current limits

This is explicit tiled composition, not automatic matrix tiling.

Current limitations remain:
- the matrix engine still operates on one fixed `8x8` tile at a time
- the larger kernel requires tile-packed DMEM, not plain row-major `32x32` buffers
- there is still no general high-level matrix layout or automatic blocking API in the DSL

## Related reading

- [DSL_EXAMPLE_MATRIX_MATMUL.md](DSL_EXAMPLE_MATRIX_MATMUL.md)
- [DSL_PROGRAMMING_GUIDE.md](DSL_PROGRAMMING_GUIDE.md)
- [DSL.md](DSL.md)