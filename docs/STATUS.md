# Project Status

## Repository Snapshot

**Date:** March 7, 2026

### Baseline hardware status
- production-ready baseline VLIW SIMD core
- 3-stage pipeline with hardware load-use hazard stalling
- baseline configuration: 1 ALU, 1 VALU, 1 Load, 1 Store, 1 Flow

### DSL status
- low-level `KernelBuilder` layer is stable for scalar/vector kernel construction
- `TileWeave` high-level frontend is available and RTL-verified for the current subset
- TileWeave is inspired by Triton, but is not Triton-compatible

### Recently verified DSL coverage
- TileWeave single-output gain kernel
- TileWeave dual-output kernel
- TileWeave tail-safe scalar cleanup
- TileWeave large-block auto-chunking
- TileWeave masked valid-prefix load/store
- TileWeave row-major strided column kernel
- TileWeave explicit affine multi-program matrix column sweep

## Open frontiers
- multi-axis launch support
- richer 2D tensor views
- arbitrary per-lane masking
- reductions and broader tensor algebra
- schedule search and autotuning hooks

## Where status details live
- architecture details: [ARCHITECTURE.md](ARCHITECTURE.md)
- DSL overview: [DSL.md](DSL.md)
- TileWeave frontend guide: [DSL_TILEWEAVE_GUIDE.md](DSL_TILEWEAVE_GUIDE.md)
- high-level roadmap: [DSL_HIGH_LEVEL_ROADMAP.md](DSL_HIGH_LEVEL_ROADMAP.md)
- known issues: [KNOWN_ISSUES.md](KNOWN_ISSUES.md)
