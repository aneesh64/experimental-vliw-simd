# VLIW SIMD Processor

A simplified VLIW (Very Long Instruction Word) processor with SIMD capabilities, optimized for embedded SoC deployment.

**This repository is an experimental design baseline, intended as a starting point for further improvements and iteration.**

## Status: Experimental Baseline

**Test Results:** 22/23 PASS (95.7%)  
**Architecture:** 3-stage pipeline, compiler-trusted design  
**RTL Size:** 1,105 LOC (15.3% reduction from original)  
**Configuration:** 1 ALU, 1 VALU, 1 Load, 1 Store engines

## Quick Start

### Build RTL
```bash
sbt "runMain vliw.gen.GenerateCore"
# Output: generated_rtl/modules/*.v
```

### Run Tests
```bash
python verification/cocotb/integration/run_integration.py --modules test_integration
# Expected: 22/23 PASS
```

### Use C Driver
```c
#include "vliw_driver.h"

vliw_init(0x00000000);              // Initialize
vliw_load_program(bundles, count);  // Load program
vliw_start();                        // Execute
vliw_wait_done(10000);              // Wait
uint32_t result = vliw_read_dmem(0); // Read result
```

## Architecture

### Pipeline
- **3-stage:** Fetch → Execute → Writeback
- **No hazard detection:** Compiler guarantees safety
- **Zero-cycle AR drive:** Combinatorial memory access

### Execution Engines (Baseline Config)
- **1× ALU:** Add, sub, mul, shift, compare, divide
- **1× VALU:** 16-lane vector operations
- **1× Load:** Combinatorial AR drive, single pending request
- **1× Store:** Direct memory write
- **1× Flow:** Branches, jumps, conditionals

### Memory
- **Banked Scratch:** 16KB (4 banks × 4KB)
- **AXI4 Interface:** 32-bit data, 32-bit address
- **Load Tracking:** Single-item register (simplified)

### SoC Integration
- **CSR Interface:** Memory-mapped control registers at 0x00000000
- **IMEM:** Instruction memory (bundles)
- **DMEM:** Data memory (AXI4)

## Documentation

### Essential Docs
- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Complete architecture reference
- [DRIVER_API.md](docs/DRIVER_API.md) - C driver API reference (30 functions)
- [TOOLCHAIN.md](docs/TOOLCHAIN.md) - Build and test instructions
- [KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md) - Known limitations and workarounds

### Development History
- [CHANGELOG.md](docs/CHANGELOG.md) - Simplification phases 0-5

## Known Issues

### 1. Long Memory Accumulate Timeout
**Impact:** 1 test (test_long_memory_accumulate_golden) times out  
**Severity:** Low (non-blocking for most workloads)  
**Workaround:** None needed for typical use cases

### 2. Dual-ALU Configuration Issue
**Impact:** Multi-ALU configs show register writeback failures  
**Severity:** High (blocks multi-core scaling)  
**Status:** Investigation planned (scheduler multi-slot allocation)  
**Workaround:** Use baseline single-ALU configuration

## Project Structure

```
vliw_simd/
├── src/main/scala/vliw/          # RTL source (Chisel)
│   ├── VliwCore.scala            # Core (361 LOC)
│   ├── MemoryEngine.scala        # Memory (367 LOC)
│   ├── BankedScratchMemory.scala # Scratch (403 LOC)
│   └── soc/                      # SoC integration
│       ├── VliwSimdSoc.scala     # Top-level (244 LOC)
│       └── HostInterface.scala   # CSR block (~150 LOC)
├── vliw_driver.h/c               # C driver library (230 LOC)
├── example_count.c               # Example program
├── tools/                        # Assembler, scheduler
├── verification/                 # Test infrastructure
│   ├── cocotb/                   # Python/cocotb tests
│   └── config/                   # Configuration variants
├── generated_rtl/                # Generated Verilog
└── docs/                         # Documentation
```

## Configuration

Configuration files in `verification/config/`:

- **test_config.properties** (Baseline): 1 ALU, 1 VALU - ✅ Production Ready
- **test_config_alu2.properties**: 2 ALU - ⚠️ Known issue (20/23 tests)
- **test_config_expanded.properties**: 2 ALU, 2 VALU - ⏳ Not tested

## Development

### Prerequisites
- Scala 2.13
- SBT 1.x
- Python 3.8+
- Icarus Verilog (for simulation)
- cocotb (for testing)

### Build and Test Workflow
```bash
# 1. Generate RTL
sbt "runMain vliw.gen.GenerateCore"

# 2. Run unit tests
python verification/cocotb/tests/run_tests.py

# 3. Run integration suite
python verification/cocotb/integration/run_integration.py --modules test_integration

# 4. Check results (expect 22/23 PASS)
```

## Performance

**Baseline Configuration:**
- Throughput: 23,272 ns/s (simulation)
- Test Suite: 88.14s (23 tests)
- Signal Count: 195 signals
- Load Latency: 0-cycle AR drive

## Contributing

See [docs/TOOLCHAIN.md](docs/TOOLCHAIN.md) for build instructions and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for architecture details.

## License

[Specify your license here]

## Contact

[Specify contact information here]
