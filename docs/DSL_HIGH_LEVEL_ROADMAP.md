# High-Level DSL Roadmap

## Goal

Raise the Python DSL from a helper-oriented vector-kernel builder to a more declarative block-programming model inspired by Triton, while preserving the existing VLIW SIMD backend, scheduler, and verification flow.

## Current Status

The repository now has a first high-level façade in `tools/dsl/tileweave.py`.

Supported subset:

- 1D block kernels
- `program_id(axis=0)`
- `arange(0, block_size)`
- contiguous block `load()`
- contiguous block `store()`
- scalar `splat()`
- elementwise `add`, `sub`, `mul`
- tail-safe lowering for non-multiple lengths via scalar cleanup
- automatic chunking of large logical blocks into hardware-vector-sized operations

Example kernels:

- `build_tileweave_gain_kernel()`
- `build_tileweave_dual_output_kernel()`

The gain-only kernel is the conservative validation target for the first RTL-backed high-level path. Tail-safe single-output and dual-output kernels are now also validated through RTL using scalar cleanup for the final partial block.

## Why a Layered Approach

A full Triton-compatible compiler stack would require major infrastructure that does not exist in this repository today:

- richer tensor and pointer type system
- predication and masked memory operations
- SSA-style expression graph normalization
- loop/block mapping beyond simple 1D tiling
- aggressive schedule search and legality checking
- backend-aware vectorization and memory-layout analysis

The current repository already has a working path for:

- capability-aware lowering
- explicit vector/scalar IR
- scheduling and assembly
- cocotb-backed RTL validation

So the practical direction is:

1. keep the current backend
2. add progressively higher frontends
3. lower them into the existing DSL IR
4. validate each new subset through unit tests and RTL

## TileWeave Near-Term Plan

### Phase 1: Conservative block kernels

Target kernels shaped like:

- single program axis
- contiguous block loads/stores
- elementwise vector math
- scalar broadcasts
- one or two outputs

Needed work:

- stabilize single-output RTL coverage
- improve lowering invariants for repeated block reuse
- add more diagnostics when high-level constructs lower into unsafe schedules

Status update:

- single-output RTL coverage: done
- dual-output RTL coverage: done
- loop-invariant scalar broadcasts hoisted out of the tile loop: done
- tail-safe scalar cleanup for the current elementwise subset: started and RTL-validated
- large logical block auto-chunking for the current elementwise subset: started and RTL-validated

### Phase 2: Masks and tails

Add:

- block masks
- predicated loads/stores
- tail handling for non-multiple lengths
- explicit out-of-bounds policies

Current implementation note:

- non-multiple tails are now supported for the current elementwise subset by lowering the final partial block into scalar load/compute/store cleanup code
- full masked block semantics are still pending

Recent progress:

- explicit prefix-mask load/store support has now started for the current TileWeave subset
- masked loads lower conservatively using explicit fill values for out-of-bounds lanes
- masked stores lower conservatively by only committing the valid prefix

Backend implications:

- predication representation in DSL IR
- masked lowering rules for loads, stores, and arithmetic
- golden-model updates for partial tiles

### Phase 3: Richer pointer algebra

Add:

- affine pointer expressions
- 2D/strided tensor views
- block swizzles and layout helpers

Backend implications:

- explicit address-generation nodes
- scratch and global memory domain modeling
- stronger legality checks for vector memory access patterns

Current implementation note:

- an initial row-major affine strided subset has now started and is RTL-validated
- `arange(..., step=...)` currently lowers conservatively for the verified subset
- non-unit-stride loads/stores may fall back to scalar gather/scatter instead of vector memory operations
- explicit 1D `program_count` launches now allow overlapping affine program strides for verified column-sweep style kernels

### Phase 4: Multi-axis launch model

Add:

- `program_id(1)` and higher-dimensional launch grids
- row/column tile decomposition
- layout-aware image and matrix kernels

Backend implications:

- generalized loop/block lowering
- better mapping between program axes and scheduler-friendly loops

## Exo-Inspired Direction

Exo is useful as inspiration for separating algorithm from schedule.

A practical adaptation here would be:

- keep a pure tensor/block algorithm description
- represent scheduling choices separately
- apply transformations such as:
  - tile size changes
  - unroll changes
  - software-pipeline depth changes
  - scratch buffering choices

This would fit the current stack well because the backend already exposes schedule-sensitive behavior.

## CUCo-Inspired Direction

CUCo is most relevant as a future search and co-design layer, not as a syntax model.

Useful ideas to adopt later:

- search over tile sizes, unroll factors, and layout choices
- architecture-aware legality and cost filtering
- automatic exploration guided by performance counters or RTL results

A realistic future workflow would be:

1. author a kernel in the high-level DSL
2. define a schedule/search space
3. auto-generate candidate lowerings
4. evaluate with simulator or RTL-backed metrics
5. keep the best schedule for the target hardware configuration

## Recommended Architecture

### User-facing layers

1. **Algorithm DSL**
   - TileWeave block authoring with Triton-inspired semantics
   - tensor handles, block expressions, stores
2. **Schedule DSL**
   - tiling, unrolling, software pipelining, buffering
3. **Lowering layer**
   - converts high-level blocks into `KernelBuilder` operations
4. **Backend**
   - existing scheduler, assembler, RTL flow

### Design constraints

- every new frontend construct must lower into existing verified primitives when possible
- keep capability checks explicit so hardware evolution stays manageable
- prefer conservative first implementations, then broaden the legal subset

## Immediate Next Steps

1. keep the TileWeave subset narrow and RTL-verified
2. add masked/tail-safe block kernels
3. introduce a schedule object separate from the algorithm builder
4. add search hooks for tile size and unroll exploration
5. expand docs and tutorials around the high-level frontend
