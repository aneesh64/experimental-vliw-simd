# TileWeave Guide

## What TileWeave Is

`TileWeave` is the high-level block-kernel frontend in the Python DSL.

It is **inspired by Triton** and intentionally similar in feel, but it is **not Triton-compatible**. The goal is to give this repository a compact block-programming layer that lowers into the existing VLIW SIMD backend, scheduler, assembler, and RTL verification flow.

Implementation entry point:
- [tools/dsl/tileweave.py](../tools/dsl/tileweave.py)

Reference examples:
- [tools/dsl/examples/tileweave_kernels.py](../tools/dsl/examples/tileweave_kernels.py)

## Current Supported Subset

- 1D block programs
- `program_id(axis=0)`
- `arange(0, block_size)`
- affine `arange(..., step=...)` for the current row-major strided subset
- `load()` / `store()`
- `splat()` for scalar broadcast
- elementwise `add`, `sub`, `mul`
- automatic chunking when logical blocks exceed hardware `vlen`
- scalar tail cleanup for non-multiple lengths
- prefix-mask load/store for the current valid-prefix subset
- explicit `program_count` for overlapping affine launches

## Mental Model

Each TileWeave program describes one logical block.

The backend then lowers that block into:
1. pointer setup
2. vector or scalar memory access
3. vector compute or conservative scalar fallback
4. store sequences
5. tile-loop structure over the whole input

## Minimal Example

```python
from dsl import TileWeaveKernelBuilder, U32


def build_gain_kernel():
    tw = TileWeaveKernelBuilder(
        "gain_kernel",
        length=24,
        block_size=8,
        tile_stride_elements=16,
        dtype=U32,
    )

    samples = tw.tensor("samples")
    out = tw.tensor("out")
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, 8)
    x = tw.load(samples, pid, offsets)
    tw.store(out, pid, offsets, x * tw.splat(gain))
    return tw.build()
```

Compile it through the normal backend:

```python
from dsl import HardwareCapabilities, compile_kernel

kernel = build_gain_kernel()
result = compile_kernel(
    kernel,
    HardwareCapabilities.from_configs(),
    assemble=False,
    bindings={"samples": 2304, "out": 2368, "gain": 2},
)
```

## Common Patterns

### Contiguous elementwise map

Use this for gain, bias, clamp-prep, and other pointwise work:

```python
pid = tw.program_id(0)
offsets = tw.arange(0, block_size)
x = tw.load(samples, pid, offsets)
tw.store(out, pid, offsets, x * tw.splat(gain))
```

### Dual output

Use one load and write two derived streams:

```python
x = tw.load(samples, pid, offsets)
tw.store(gain_out, pid, offsets, x * tw.splat(gain))
tw.store(bias_out, pid, offsets, x + tw.splat(bias))
```

### Valid-prefix masking

Use when a final partial tile must not commit out-of-bounds lanes:

```python
mask = tw.mask_prefix(valid_elements)
x = tw.load(samples, pid, offsets, mask=mask, other=0)
tw.store(out, pid, offsets, x * tw.splat(gain), mask=mask)
```

### Row-major column access

Use affine strided offsets for column sweeps over row-major tensors:

```python
offsets = tw.arange(0, rows * cols, step=cols)
column = tw.load(matrix, pid, offsets)
tw.store(out, pid, offsets, column * tw.splat(gain))
```

### Full matrix column sweep

Use `program_count` with an overlapping launch stride:

```python
tw = TileWeaveKernelBuilder(
    "matrix_gain",
    length=rows,
    block_size=rows,
    tile_stride_elements=1,
    program_count=cols,
)
```

Each program starts one element later, which makes one logical program map to one matrix column in the current row-major affine subset.

## When TileWeave Uses Scalar Fallback

TileWeave stays conservative when needed.

The frontend may lower through scalar gather/scatter when:
- stride is non-unit
- a masked subset is smaller than hardware `vlen`
- a final tail block is not full width

This is intentional. The first goal is RTL-safe semantics, then broader vector legality.

## Current Limits

Not yet stable as general-purpose surface area:
- `program_id(1)` and multi-axis launch grids
- arbitrary per-lane masks
- reductions
- generalized tensor algebra
- arbitrary 2D view composition
- schedule search/autotuning

## Verified Reference Kernels

- `build_tileweave_gain_kernel()`
- `build_tileweave_dual_output_kernel()`
- `build_tileweave_masked_gain_load_kernel()`
- `build_tileweave_masked_gain_store_kernel()`
- `build_tileweave_column_gain_kernel()`
- `build_tileweave_matrix_gain_kernel()`

## Recommended Next Reading

- [DSL.md](DSL.md)
- [DSL_PROGRAMMING_GUIDE.md](DSL_PROGRAMMING_GUIDE.md)
- [DSL_SOFTWARE_PIPELINING.md](DSL_SOFTWARE_PIPELINING.md)
- [DSL_HIGH_LEVEL_ROADMAP.md](DSL_HIGH_LEVEL_ROADMAP.md)
