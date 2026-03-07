# VLIW SIMD Processor

A VLIW SIMD processor project with:
- SpinalHDL RTL generation
- scheduler + assembler tooling
- cocotb-based verification
- a Python DSL for kernel authoring

## Overview

This repository contains two tightly connected layers:
1. a baseline VLIW SIMD hardware platform targeted at FPGA-friendly bring-up
2. a Python kernel DSL that lowers into the existing scheduler and assembler backend

The high-level DSL frontend is now called `TileWeave`.

`TileWeave` is **inspired by Triton** and uses a similar block-programming style, but it is not Triton-compatible. It is a repository-specific frontend designed to stay conservative, extensible, and RTL-verifiable.

## Status

### Hardware
- production-ready baseline configuration
- 3-stage pipeline with hardware load-use hazard detection
- baseline engine mix: 1 ALU, 1 VALU, 1 Load, 1 Store, 1 Flow

### DSL
- low-level `KernelBuilder` layer available for explicit scalar/vector kernels
- high-level `TileWeaveKernelBuilder` layer available for Triton-inspired block kernels
- verified TileWeave coverage includes:
  - gain kernels
  - dual-output kernels
  - tail-safe scalar cleanup
  - large logical block auto-chunking
  - masked valid-prefix load/store
  - row-major strided column kernels
  - affine multi-program matrix column sweeps

For a fuller status snapshot, see [docs/STATUS.md](docs/STATUS.md).

## Quick Start

### Generate RTL
```bash
sbt "runMain vliw.gen.GenerateCore"
```

### Run the main verification flows
```bash
python verification/cocotb/tests/run_tests.py
python verification/cocotb/integration/run_integration.py --modules test_slot_configs,test_integration,test_algorithms,test_driver_integration,test_integration_scalar,test_integration_memory,test_integration_control,test_integration_vector,test_algorithms_kernels,test_algorithms_multiwidth
```

### Run focused DSL regressions
```bash
python -m pytest tools/tests/test_dsl_examples.py tools/tests/test_dsl_lowering.py -q
python verification/cocotb/integration/run_integration.py --modules test_dsl_integration,test_dsl_helpers_integration,test_dsl_algorithms_integration
```

## Documentation Map

### Start here
- [docs/README.md](docs/README.md)
- [docs/STATUS.md](docs/STATUS.md)

### Hardware
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- [docs/TOOLCHAIN.md](docs/TOOLCHAIN.md)
- [docs/DRIVER_API.md](docs/DRIVER_API.md)
- [docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md)

### DSL
- [docs/DSL.md](docs/DSL.md)
- [docs/DSL_QUICKSTART.md](docs/DSL_QUICKSTART.md)
- [docs/DSL_PROGRAMMING_GUIDE.md](docs/DSL_PROGRAMMING_GUIDE.md)
- [docs/DSL_TILEWEAVE_GUIDE.md](docs/DSL_TILEWEAVE_GUIDE.md)
- [docs/DSL_DEVELOPER_GUIDE.md](docs/DSL_DEVELOPER_GUIDE.md)
- [docs/DSL_HIGH_LEVEL_ROADMAP.md](docs/DSL_HIGH_LEVEL_ROADMAP.md)

## Repository Layout

High-level structure:
- [src/main/scala/vliw](src/main/scala/vliw) — RTL source
- [tools](tools) — assembler, scheduler, DSL, and tests
- [verification](verification) — cocotb test infrastructure
- [drivers](drivers) — C driver support
- [docs](docs) — project documentation

## License

[MIT](LICENSE)
