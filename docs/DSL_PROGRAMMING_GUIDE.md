# DSL Programming Guide

## Purpose

This guide shows how to use the Python DSL for realistic kernels, from low-level `KernelBuilder` code to higher-level `TileWeave` block authoring.

`TileWeave` is **inspired by Triton**. It uses a similar block-programming style, but lowers into this repository's existing VLIW SIMD backend.

## Choosing the Right Layer

### Use `KernelBuilder` when you need:
- explicit scratch management
- custom control flow
- software pipelining details
- lane extraction or scalar side effects
- tight control over exact low-level lowering

### Use `TileWeaveKernelBuilder` when you need:
- pointwise vector kernels
- block loads/stores
- affine row-major strided access
- simple multi-output expressions
- a Triton-like authoring style with conservative lowering

## Workflow

1. choose the abstraction layer
2. build the kernel
3. compile with `compile_kernel()`
4. bind symbolic DMEM/scalar arguments
5. validate with unit tests and RTL-backed integration tests

## Example 1: Streaming gain stage

Real-world use: DSP front-end scaling, calibration, or audio gain.

```python
from dsl import TileWeaveKernelBuilder, U32


def build_stream_gain(length: int = 256, block_size: int = 8):
    tw = TileWeaveKernelBuilder(
        "stream_gain",
        length=length,
        block_size=block_size,
        tile_stride_elements=block_size,
        dtype=U32,
    )
    samples = tw.tensor("samples")
    out = tw.tensor("out")
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, block_size)
    x = tw.load(samples, pid, offsets)
    tw.store(out, pid, offsets, x * tw.splat(gain))
    return tw.build()
```

Why this layer works:
- simple pointwise map
- no custom control flow
- backend can keep contiguous vector accesses on the vector path

## Example 2: Dual-output preprocessing stage

Real-world use: one pass that prepares both a scaled stream and a biased stream for later consumers.

```python
from dsl import TileWeaveKernelBuilder, U32


def build_dual_preprocess(length: int = 256, block_size: int = 8):
    tw = TileWeaveKernelBuilder(
        "dual_preprocess",
        length=length,
        block_size=block_size,
        tile_stride_elements=block_size,
        dtype=U32,
    )
    samples = tw.tensor("samples")
    gain_out = tw.tensor("gain_out")
    bias_out = tw.tensor("bias_out")
    gain = tw.scalar("gain", default=2)
    bias = tw.scalar("bias", default=3)

    pid = tw.program_id(0)
    offsets = tw.arange(0, block_size)
    x = tw.load(samples, pid, offsets)
    tw.store(gain_out, pid, offsets, x * tw.splat(gain))
    tw.store(bias_out, pid, offsets, x + tw.splat(bias))
    return tw.build()
```

Why this matters:
- one load can feed multiple outputs
- matches many post-load staging pipelines in DSP and ML preprocessing

## Example 3: Tail-safe packet processing

Real-world use: buffers whose final chunk is smaller than the hardware vector width.

```python
from dsl import TileWeaveKernelBuilder, U32


def build_tail_safe_gain(length: int = 20, block_size: int = 8):
    tw = TileWeaveKernelBuilder(
        "tail_safe_gain",
        length=length,
        block_size=block_size,
        tile_stride_elements=block_size,
        dtype=U32,
    )
    samples = tw.tensor("samples")
    out = tw.tensor("out")
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, block_size)
    x = tw.load(samples, pid, offsets)
    tw.store(out, pid, offsets, x * tw.splat(gain))
    return tw.build()
```

What happens:
- full blocks lower normally
- the final partial block lowers through scalar cleanup
- semantics stay correct without requiring full arbitrary mask support

## Example 4: Row-major column pass for separable transforms

Real-world use: separable blur, DCT-style column pass, matrix column scaling.

```python
from dsl import TileWeaveKernelBuilder, U32


def build_column_gain(rows: int = 8, cols: int = 8):
    tw = TileWeaveKernelBuilder(
        "column_gain",
        length=rows,
        block_size=rows,
        tile_stride_elements=rows,
        dtype=U32,
    )
    matrix = tw.tensor("matrix", length=rows * cols)
    out = tw.tensor("out", length=rows * cols)
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, rows * cols, step=cols)
    column = tw.load(matrix, pid, offsets)
    tw.store(out, pid, offsets, column * tw.splat(gain))
    return tw.build()
```

Why this is useful:
- expresses row-major affine strided access directly
- gives a concrete building block toward separable image and transform kernels
- lowers conservatively through scalar gather/scatter when needed

## Example 5: Full matrix column sweep

Real-world use: applying one column operation to every column in a tile.

```python
from dsl import TileWeaveKernelBuilder, U32


def build_matrix_gain(rows: int = 8, cols: int = 8):
    tw = TileWeaveKernelBuilder(
        "matrix_gain",
        length=rows,
        block_size=rows,
        tile_stride_elements=1,
        program_count=cols,
        dtype=U32,
    )
    matrix = tw.tensor("matrix", length=rows * cols)
    out = tw.tensor("out", length=rows * cols)
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, rows * cols, step=cols)
    column = tw.load(matrix, pid, offsets)
    tw.store(out, pid, offsets, column * tw.splat(gain))
    return tw.build()
```

Why this matters:
- programs can overlap in launch space even when each program touches a strided column
- gives a bridge from 1D launch semantics toward later multi-axis launch support

## Example 6: Software-pipelined vector math with `KernelBuilder`

Real-world use: throughput-sensitive tiled streaming kernels.

```python
from dsl import KernelBuilder, U32


kb = KernelBuilder("tiled_add")
lhs = kb.arg_dmem_tensor("lhs", shape=(24,), dtype=U32)
rhs = kb.arg_dmem_tensor("rhs", shape=(24,), dtype=U32)
out = kb.arg_dmem_tensor("out", shape=(24,), dtype=U32)

kb.pipelined_vector_map(
    "add",
    lhs,
    rhs,
    out,
    tiles=2,
    tile_elements=8,
    tile_stride_elements=16,
    ew=32,
    unroll=1,
)
kb.halt()
```

Use this layer when schedule shape matters more than authoring convenience.

## Example 7: Control-heavy scalar post-processing

Real-world use: thresholding, state-machine updates, scalar metadata emission.

```python
from dsl import KernelBuilder, U32


kb = KernelBuilder("threshold_clip")
in_buf = kb.arg_dmem_tensor("input", shape=(6,), dtype=U32)
out_buf = kb.arg_dmem_tensor("output", shape=(6,), dtype=U32)
threshold = kb.arg_scalar("threshold", default=10)
```

For full working patterns, see:
- [DSL_EXAMPLE_CONTROL_FLOW.md](DSL_EXAMPLE_CONTROL_FLOW.md)
- [tools/dsl/examples/control_flow_kernels.py](../tools/dsl/examples/control_flow_kernels.py)

## Example 8: Fixed-size matrix multiply

Real-world use: one `8x8` tile multiply on the matrix engine without manually authoring matrix transfer and compute ops.

```python
from dsl import KernelBuilder, U8, U32


kb = KernelBuilder("matrix_matmul_8x8")
lhs = kb.arg_dmem_tensor("lhs", shape=(8, 8), dtype=U8)
rhs = kb.arg_dmem_tensor("rhs", shape=(8, 8), dtype=U8)
out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

kb.matmul(lhs, rhs, out)
kb.halt()
```

Why this layer works:
- expresses one logical matrix op instead of raw matrix-engine micro-ops
- lowering inserts the required `MDMVIN`, `MZERO` or `MCOMPUTE_ACC`, `MCOMPUTE`, and `MDMVOUT` sequence
- capability checks fail early on targets without matrix support

Current limits:
- only fixed `8x8` `U8 x U8 -> U32` tiles are supported
- tensors must be DMEM-backed
- larger matrix tiling is not yet automatic

For the full worked example and the accumulate variant, see:
- [DSL_EXAMPLE_MATRIX_MATMUL.md](DSL_EXAMPLE_MATRIX_MATMUL.md)
- [tools/dsl/examples/matrix_kernels.py](../tools/dsl/examples/matrix_kernels.py)

## Example 9: Tiled 32x32 matrix multiply on the 8x8 engine

Real-world use: larger GEMM-style workloads mapped onto the current fixed-size matrix engine.

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
```

Why this layer works:
- shows how to scale beyond one `8x8` tile without dropping into raw scheduler ops
- keeps the implementation inside the supported `KernelBuilder.matmul()` path
- is RTL-verified against a Python golden `32x32` matrix multiply

Important constraint:
- the current matrix transfer path expects each `8x8` tile to be contiguous in DMEM, so the example uses tile-packed buffers rather than plain row-major `32x32` storage

For host-side integration, use the row-major conversion helpers exposed by the DSL package:
- `pack_matrix_matmul_32x32_u8_tiles()` for input matrices
- `unpack_matrix_matmul_32x32_u32_tiles()` for output matrices

For the full walkthrough, see:
- [DSL_EXAMPLE_MATRIX_MATMUL_32X32.md](DSL_EXAMPLE_MATRIX_MATMUL_32X32.md)

## Compilation Pattern

```python
from dsl import HardwareCapabilities, compile_kernel

caps = HardwareCapabilities.from_configs()
result = compile_kernel(
    kernel,
    caps,
    assemble=False,
    bindings={...},
)
```

Inspect:
- `result.required_bindings`
- `result.resolved_bindings`
- `result.scratch_map`
- `result.scheduled_bundles`

## Verification Pattern

### Fast checks
- compile-only tests in [tools/tests/test_dsl_examples.py](../tools/tests/test_dsl_examples.py)
- lowering checks in [tools/tests/test_dsl_lowering.py](../tools/tests/test_dsl_lowering.py)

### RTL-backed checks
- [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py)
- [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py)
- [verification/cocotb/integration/test_dsl_algorithms_integration.py](../verification/cocotb/integration/test_dsl_algorithms_integration.py)

## Recommended Design Rules

- prefer `TileWeave` for clean pointwise block kernels
- drop to `KernelBuilder` for explicit schedule and control-flow work
- keep the first implementation conservative and RTL-verified
- only broaden legality once compile and RTL coverage exist
- use row-major affine strided patterns as stepping stones toward full 2D kernels

## Where to Go Next

- [DSL.md](DSL.md)
- [DSL_TILEWEAVE_GUIDE.md](DSL_TILEWEAVE_GUIDE.md)
- [DSL_DEVELOPER_GUIDE.md](DSL_DEVELOPER_GUIDE.md)
- [DSL_HIGH_LEVEL_ROADMAP.md](DSL_HIGH_LEVEL_ROADMAP.md)
