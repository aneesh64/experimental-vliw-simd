# Project Status

## Repository Snapshot

**Date:** March 19, 2026

### Baseline hardware status
- production-ready baseline VLIW SIMD core
- 3-stage pipeline with hardware load-use hazard stalling
- baseline configuration: 1 ALU, 1 VALU, 1 Load, 1 Store, 1 Flow
- ISA extended with scalar `max/min`, signed or unsigned vector `max/min`, and multi-width VALU support
- HALT pipeline flush fix: `FetchUnit` combinatorially gates `exValid` on `!halt` to prevent delay-slot execution at `HALT_PC+1`
- optional v1 matrix slot supports 8x8 int8 -> int32 matrix-local transfer and compute flows
- MDMVIN transfers are decoupled: non-matrix bundles may retire during an in-flight MDMVIN; only the next matrix bundle waits (EX bubble)
- SCOPY operations (opcodes 6-9) enable scratchpad-to-scratchpad copies between matrix-local and vector/scalar scratch without a DRAM round-trip

### DSL status
- low-level `KernelBuilder` layer is stable for scalar/vector kernel construction
- `TileWeave` high-level frontend is available and RTL-verified for the current subset
- TileWeave is inspired by Triton, but is not Triton-compatible
- DSL scalar `select()` lowering available for conditional assignment without branches
- 32×32 tiled matrix multiply available via `build_matrix_matmul_32x32_tiled_kernel()` with host tile-packing helpers

### Recently verified DSL coverage
- TileWeave single-output gain kernel
- TileWeave dual-output kernel
- TileWeave tail-safe scalar cleanup
- TileWeave large-block auto-chunking
- TileWeave masked valid-prefix load/store
- TileWeave row-major strided column kernel
- TileWeave explicit affine multi-program matrix column sweep
- 8×8 matmul accumulate kernel
- 32×32 tiled matmul via explicit 8×8 tile composition
- pipelined multi-matrix residual-affine kernel (lower-level KernelBuilder style)
- threshold-clip algorithm kernel (using DSL `select()` lowering)

### Verification summary
- Baseline config: **176/176 tests passing**
- Matrix-enabled config: **62/62 tests passing** (full algorithm, DSL, helpers, and multiwidth suites)
- 2-ALU config (`test_config_alu2.properties`): targeted writeback regression passes
- 2-ALU / 2-VALU config (`test_config_a2_v2.properties`): targeted writeback regression passes

## Open frontiers
- multi-axis launch support
- richer 2D tensor views
- arbitrary per-lane masking
- reductions and broader tensor algebra
- schedule search and autotuning hooks

## Where status details live
- architecture details: [ARCHITECTURE.md](ARCHITECTURE.md)
- ISA reference: [ISA.md](ISA.md)
- DSL overview: [DSL.md](DSL.md)
- TileWeave frontend guide: [DSL_TILEWEAVE_GUIDE.md](DSL_TILEWEAVE_GUIDE.md)
- high-level roadmap: [DSL_HIGH_LEVEL_ROADMAP.md](DSL_HIGH_LEVEL_ROADMAP.md)
- known issues: [KNOWN_ISSUES.md](KNOWN_ISSUES.md)
