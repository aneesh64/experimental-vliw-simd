# DSL Software Pipelining

This document introduces a higher-level DSL helper for tiled load/compute/store kernels.

## Goal

Express a common optimized pattern with less manual pointer bookkeeping:
1. load the next tile from memory
2. compute on the current tile
3. store the previous result back to memory

The DSL helper currently targets tiled rank-1 DMEM buffers and binary vector kernels.

## New helper

`KernelBuilder.software_pipeline_binary()` emits a callback-driven software-pipelined tiled kernel.

`KernelBuilder.pipelined_vector_map()` remains available as a convenience wrapper for direct vector-map kernels.

## Shape

```python
kb.software_pipeline_binary(
    lhs,
    rhs,
    out,
    tiles=4,
    tile_elements=8,
    tile_stride_elements=16,
    unroll=2,
    name_prefix="tiled_add",
    compute=lambda inner_kb, lhs_stage, rhs_stage, out_stage: inner_kb.vector_map(
        "add",
        out_stage,
        lhs_stage,
        rhs_stage,
        ew=32,
    ),
)
kb.halt()
```

Arguments:
- `lhs`, `rhs`, `out`: rank-1 DMEM buffers
- `tiles`: number of tiles to process
- `tile_elements`: elements per tile
- `tile_stride_elements`: optional spacing between tile starts for beat alignment
- `compute`: callback that emits the tile-local computation
- `unroll`: compile-time batch size for the steady-state pipeline

## What it emits

For `unroll=2`, the helper builds a double-buffered schedule shape:
- prologue: load tiles `0` and `1`
- steady state: load tiles `2` and `3` while computing and storing tiles `0` and `1`
- epilogue: compute and store the last loaded batch

This is still explicit lowering into scheduler operations, but the DSL surface is much shorter and easier to read.

## Worked example

See [tools/dsl/examples/pipelined_vector_add.py](../tools/dsl/examples/pipelined_vector_add.py).

The high-level pipelined version is:

```python
kb = KernelBuilder("dsl_pipelined_tiled_vector_add")
lhs = kb.arg_dmem_tensor("lhs", shape=(32,), dtype=U32)
rhs = kb.arg_dmem_tensor("rhs", shape=(32,), dtype=U32)
out = kb.arg_dmem_tensor("out", shape=(32,), dtype=U32)

kb.software_pipeline_binary(
    lhs,
    rhs,
    out,
    tiles=4,
    tile_elements=8,
    tile_stride_elements=16,
    unroll=2,
    name_prefix="tiled_add",
    compute=lambda inner_kb, lhs_stage, rhs_stage, out_stage: inner_kb.vector_map(
        "add",
        out_stage,
        lhs_stage,
        rhs_stage,
        ew=32,
    ),
)
kb.halt()
```

For the current RTL-backed golden kernel, the same abstraction is exercised with `tiles=2`, `tile_stride_elements=16`, and `unroll=1` as the conservative path. The `unroll=2` variant is still covered by lowering tests and bundle-count comparison.

The same staged abstraction is also exercised by a tiled vector-multiply kernel in the RTL suite. Only the `compute` callback changes.

The RTL suite now also includes a fused DSP-style staged kernel that combines:
- vector gain on each loaded tile
- scalar sideband probe extraction for the first and last lane of each tile
- scalar task bookkeeping stored to a metadata buffer

That kernel demonstrates data parallelism in the VALU path, instruction-level packing of independent ALU/load work where the scheduler can issue it, and task-level overlap between load and compute/store stages across tiles.

The staged examples now also include a dual-output DSP kernel that emits both:
- `gain_out = samples * gain`
- `bias_out = samples + bias`

while still producing scalar sideband probes and metadata. This gives a conservative RTL-backed example of one input stream feeding two vector result streams inside the same tiled software pipeline.

## Verification

This abstraction is covered by:
- unit comparison against a naive tiled kernel in [tools/tests/test_dsl_examples.py](../tools/tests/test_dsl_examples.py)
- RTL golden verification in [verification/cocotb/integration/test_dsl_algorithms_integration.py](../verification/cocotb/integration/test_dsl_algorithms_integration.py)

## Why this is more developer-friendly

The kernel author can now focus on the tile-local computation:
- how to combine `lhs_stage` and `rhs_stage`
- whether the kernel is `add`, `mul`, or another binary map

The DSL helper owns the repetitive parts:
- stage-buffer construction
- double-buffered load/compute/store ordering
- tile-address generation
- aligned tile spacing
- prologue and epilogue emission

## Current limits

- rank-1 DMEM buffers only
- fixed tile count at DSL construction time
- compile-time unrolling, not a dynamic runtime unroll factor
- currently specialized to binary tiled load/compute/store pipelines

## Next extensions

- pipelined unary maps and reductions
- scalar epilogues on vector tiles
- explicit prologue and epilogue callbacks
- parameterized loop generators for image and stencil kernels
