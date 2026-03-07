# Python DSL for VLIW SIMD

## Status

This is the first implementation slice of a higher-level Python DSL above the existing scheduler and assembler pipeline.

Current layers:
- Logical kernel construction in [tools/dsl](../tools/dsl)
- TileWeave high-level block frontend in [tools/dsl/tileweave.py](../tools/dsl/tileweave.py)
- Capability-aware lowering into `VliwScheduler`
- Binary emission through `Assembler`
- Initial graph/orchestration support for multi-kernel flows
- Initial layout/tile helpers
- Verified simple kernels in the RTL integration suite

## Design Goals

Priority order:
1. High VLIW packing and SIMD utilization
2. Easier kernel expression than raw `Op` authoring
3. Multi-kernel chaining and multi-engine orchestration

The DSL is hardware-parameterized. It is intended to adapt to:
- instruction additions
- engine/slot-count changes
- vector-length changes
- scratch-size changes
- multi-core topology changes

## Current Modules

### Core package
- [tools/dsl/__init__.py](../tools/dsl/__init__.py)
- [tools/dsl/capabilities.py](../tools/dsl/capabilities.py)
- [tools/dsl/ir.py](../tools/dsl/ir.py)
- [tools/dsl/builder.py](../tools/dsl/builder.py)
- [tools/dsl/lowering.py](../tools/dsl/lowering.py)
- [tools/dsl/graph.py](../tools/dsl/graph.py)
- [tools/dsl/layout.py](../tools/dsl/layout.py)
- [tools/dsl/manifest.py](../tools/dsl/manifest.py)

## Tutorials

- [docs/DSL_TUTORIAL_SCALAR.md](DSL_TUTORIAL_SCALAR.md)
- [docs/DSL_TUTORIAL_TENSOR.md](DSL_TUTORIAL_TENSOR.md)
- [docs/DSL_TILEWEAVE_GUIDE.md](DSL_TILEWEAVE_GUIDE.md)
- [docs/DSL_PROGRAMMING_GUIDE.md](DSL_PROGRAMMING_GUIDE.md)
- [docs/DSL_SOFTWARE_PIPELINING.md](DSL_SOFTWARE_PIPELINING.md)

## Developer guide

- [docs/DSL_DEVELOPER_GUIDE.md](DSL_DEVELOPER_GUIDE.md)

## Worked examples

- [docs/DSL_EXAMPLE_BOX_BLUR_3X3.md](DSL_EXAMPLE_BOX_BLUR_3X3.md)
- [docs/DSL_EXAMPLE_CONTROL_FLOW.md](DSL_EXAMPLE_CONTROL_FLOW.md)

## Verification planning

- [docs/DSL_RTL_VERIFICATION_PLAN.md](DSL_RTL_VERIFICATION_PLAN.md)

## High-level roadmap

- [docs/DSL_HIGH_LEVEL_ROADMAP.md](DSL_HIGH_LEVEL_ROADMAP.md)

### Verified tests
- [tools/tests/test_dsl_capabilities.py](../tools/tests/test_dsl_capabilities.py)
- [tools/tests/test_dsl_lowering.py](../tools/tests/test_dsl_lowering.py)
- [tools/tests/test_dsl_flow_and_graph.py](../tools/tests/test_dsl_flow_and_graph.py)
- [tools/tests/test_dsl_layout.py](../tools/tests/test_dsl_layout.py)
- [tools/tests/test_dsl_manifest.py](../tools/tests/test_dsl_manifest.py)
- [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py)

## Current Feature Set

### Hardware capability model
`HardwareCapabilities` captures the target profile used by lowering:
- core count
- slot counts
- vector length
- scratch size and banks
- IMEM depth
- bundle width
- supported ops and widths
- known hardware limitations

This lets the DSL remain portable across target variants.

### Kernel builder
`KernelBuilder` currently supports:
- scratch scalars and vectors
- DMEM tensor descriptors
- scalar arguments
- DMEM tensor arguments
- constants and address materialization
- scalar and vector arithmetic
- `vbroadcast`, `vcast`
- helper shorthands: `vector_fill`, `vector_map`, `vector_copy`
- scalar/vector bridge helper: `accumulate_lanes()` for explicit lane-wise scalar accumulation
- software-pipelined tiled vector maps via `pipelined_vector_map()`
- reusable tiled iteration via `for_each_tile_1d()`
- vector lane aliases via `lane()` and `store_lane()` for explicit per-lane stores
- TensorView memory helpers: `load_view()`, `store_view()`, `vload_view()`, and `vstore_view()`
- structured control-flow helpers: `if_else()` and `counted_loop()`
- control flow: `label`, `jump`, `cond_jump`
- pointer math via `add_imm`
- `coreid`
- `halt`

### TileWeave high-level frontend
`TileWeaveKernelBuilder` adds a more declarative block-programming façade above `KernelBuilder`.

It is inspired by Triton and intentionally similar in style, but it is repository-specific rather than Triton-compatible.

Current supported subset:
- `program_id(axis=0)`
- `arange(0, block_size)`
- contiguous block `load()` / `store()`
- scalar `splat()`
- elementwise `add`, `sub`, `mul`
- automatic chunking of large logical blocks into repeated hardware-vector operations
- vector `ew` follows the logical value dtype for TileWeave arithmetic and broadcasts
- tail-safe lowering for non-multiple lengths via scalar cleanup on the final partial block
- prefix-mask load/store support for the current TileWeave subset with conservative lowering
- 1D tile/block kernels lowered into the existing scheduler/assembler backend

Current examples:
- `build_tileweave_gain_kernel()`
- `build_tileweave_dual_output_kernel()`

Both the conservative gain-only path and the dual-output path now have RTL-backed validation. The gain-only kernel remains the simplest recommended starting point for new high-level authoring.

### Lowering
`compile_kernel()` performs:
1. scratch allocation
2. argument binding resolution
3. scalar-argument prologue generation
4. lowering into scheduler ops
5. scheduling into bundles
6. optional assembly into binary bundles

### Layout and tiling
Current layout helpers are intentionally small:
- `Layout.contiguous()`
- `TensorView.full()`
- `subtile()`
- `tile_1d()`

These are enough for initial symbolic tile-addressing patterns.

### Graph orchestration
`KernelGraph` and `GraphCompiler` support:
- multiple compiled kernels
- explicit dependencies
- per-node bindings
- single-core, replicated, and explicit launch modes

### Packaging metadata
Both single-kernel and graph compilation results can emit manifests:
- `LoweringResult.to_manifest()`
- `CompiledKernelGraph.to_manifest()`

The manifests summarize bindings, scratch allocation, slot usage, bundle counts, and launch expectations.

## Current Verified Kernels

RTL-verified examples currently include:
- scalar symbolic DMEM load/compute/store kernel with golden result
- scalar symbolic DMEM load/compute/store kernel under randomized AXI read latency
- scalar counting loop with control flow and golden result
- core-aware `coreid()` offset-store smoke kernel with golden RTL result
- vector broadcast kernel with symbolic DMEM binding and golden result
- helper-driven vector fill plus lane-store kernel with golden result
- helper-driven `vector_map("add", ...)` kernel with golden result
- helper-driven packed-8-bit `vector_map("xor", ...)` kernel with golden result
- helper-driven packed-16-bit `vector_map("sub", ...)` kernel with golden result
- helper-driven symbolic DMEM vector load/map/store kernel with golden result
- helper-driven symbolic DMEM `vector_copy()` kernel with golden result
- helper-driven symbolic DMEM `vcast(32->8)` kernel with golden result
- helper-driven symbolic DMEM `vcast(8->16)` kernel with golden result
- helper-driven symbolic DMEM signed `vcast(8->32)` kernel with golden result
- helper-driven symbolic DMEM `vector_map("mul")` kernel with golden result
- 3x3 box blur example kernel for a single output pixel with golden RTL verification
- looped 3x3 box blur row kernel with three golden RTL outputs
- nested-loop 3x3 box blur image kernel with `2x2` golden RTL outputs
- software-pipelined fused DSP gain-monitor kernel with golden RTL output
- software-pipelined fused DSP dual-output kernel with golden RTL output
- TileWeave single-output gain kernel with golden RTL target coverage
- TileWeave dual-output gain/bias kernel with golden RTL target coverage
- TileWeave tail-safe single-output and dual-output kernels with golden RTL target coverage
- TileWeave 64-element block kernel with automatic hardware-vector chunking and golden RTL target coverage
- TileWeave masked-load and masked-store kernels with golden RTL target coverage
- TileWeave row-major strided column kernel with golden RTL target coverage
- TileWeave affine multi-program matrix gain kernel with golden RTL target coverage
- software-pipelined tiled vector add kernel with golden RTL output
- software-pipelined tiled vector mul kernel with golden RTL output
- structured-control-flow threshold clip kernel with golden RTL output
- vector threshold-mask loop kernel with vector instructions plus golden RTL output
- nested vector threshold-mask kernel with nested loops plus golden RTL output

See [verification/cocotb/integration/test_dsl_integration.py](../verification/cocotb/integration/test_dsl_integration.py), [verification/cocotb/integration/test_dsl_helpers_integration.py](../verification/cocotb/integration/test_dsl_helpers_integration.py), and [verification/cocotb/integration/test_dsl_algorithms_integration.py](../verification/cocotb/integration/test_dsl_algorithms_integration.py).

## Relationship to Existing Toolchain

The DSL does not replace the current backend. It lowers into the existing flow documented in [docs/TOOLCHAIN.md](TOOLCHAIN.md):

1. DSL kernel
2. scheduler ops / labels
3. scheduled bundles
4. assembled binary bundles
5. IMEM load and RTL execution

## Known Current Limitations

This is still an early frontend. Important limits today:
- vector lowering currently assumes full-width vectors equal to target `vlen`
- layout helpers are intentionally minimal and mostly 1D-oriented
- graph support is compile-time orchestration metadata only, not a full runtime executor
- advanced tensor algebra and scheduling transforms are not yet implemented
- richer reductions and tensor transforms still need more RTL-safe helper patterns
- TileWeave authoring is a restricted Triton-inspired subset, not full Triton compatibility
- masked/tail-safe block operations are not yet part of the stable high-level subset

## Next Planned Areas

Likely next work items:
- tensor helper ops for copy/map/reduce
- richer tiling and layout algebra
- multi-kernel runtime packaging
- more RTL-backed DSL kernels
- full reference documentation and tutorials
