# VLIW SIMD Processor

A simplified VLIW (Very Long Instruction Word) processor with SIMD capabilities, optimized for embedded SoC deployment.

**This repository contains a production-ready baseline VLIW SIMD processor design with multi-width VALU support, hardware load-use hazard detection, and comprehensive verification suites.**

## Status: Production Ready (Baseline)

**Verification Snapshot (Mar 2026):** 176/176 PASS (100%) — 48 unit tests + 128 integration tests  
**Architecture:** 3-stage pipeline with hardware load-use hazard stalling  
**Configuration:** 1 ALU, 1 VALU, 1 Load, 1 Store engines

## Quick Start

### Build RTL
```bash
sbt "runMain vliw.gen.GenerateCore"
# Output: generated_rtl/modules/*.v
```

### Run Tests
```bash
# Unit tests (48 tests: divider, alu, valu, flow, mem, scratch, core)
python verification/cocotb/tests/run_tests.py

# Full integration regression (128 tests across grouped modules)
python verification/cocotb/integration/run_integration.py --modules test_slot_configs,test_integration,test_algorithms,test_driver_integration,test_integration_scalar,test_integration_memory,test_integration_control,test_integration_vector,test_algorithms_kernels,test_algorithms_multiwidth

# Recent verified status:
# - Unit tests: 48/48 PASS (divider 6, alu 6, valu 7, flow 13, mem 5, scratch 5, core 6)
# - Integration tests: 128/128 PASS (all grouped modules)
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
- **Load-use hazard detection:** Hardware stalls on data dependencies from pending loads
- **Compiler-scheduled:** RAW/WAW/WAR hazards resolved by scheduler; only load-use hazards handled in hardware
- **Zero-cycle AR drive:** Combinatorial memory access

### Execution Engines (Baseline Config)
- **1× ALU:** Add, sub, mul, shift, compare, divide
- **1× VALU:** 8-lane vector operations with multi-width packed execution
- **1× Load:** Combinatorial AR drive, single pending request, load-use hazard metadata
- **1× Store:** FIFO-backed AXI write path (default queue depth 4), stalls on full
- **1× Flow:** Branches, jumps, conditionals

### VALU Capabilities
- **Element widths:** EW32, EW16, EW8, EW4, EW64 (lane pairing for 64-bit)
- **Opcodes:** lane-wise ALU ops + `VBROADCAST`, `MULTIPLY_ADD`, `VCAST`
- **Width-aware fields:** VALU slot includes `ewidth`, `dwidth`, and `signed`
- **Widening paths:** `MUL`/`MULTIPLY_ADD` with widening and cast conversion paths

### Memory
- **Banked Scratch:** 16KB (4 banks × 4KB)
- **AXI4 Interface:** 512-bit data, 32-bit address
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

### ~~1. Long Memory Accumulate Timeout~~ ✅ Resolved
**Root Cause:** Scheduler `JUMP_BUBBLE` was 1 instead of 3 (3-cycle branch delay).  
**Fix:** `JUMP_BUBBLE=3` in scheduler + AXI model X/Z address robustness.  
**Result:** Test now completes in 1,749 cycles with correct result.

### ~~2. FetchUnit Instruction Skip on Stall~~ ✅ Resolved
**Root Cause:** During load-use stalls, FetchUnit drove `imemAddr=pc` instead of `pc-1`, causing IMEM output to advance and the stalled instruction to be lost.  
**Fix:** `io.imemAddr := Mux(io.stall, (pc - 1).resized, pc)` in FetchUnit.scala.  
**Result:** All load-use hazard tests pass correctly.

### ~~3. Driver Integration API Mismatch~~ ✅ Resolved  
**Root Cause:** Tests passed raw assembly text to `Assembler.assemble_program()` which expects structured dicts.  
**Fix:** Rewrote all 5 driver tests to use `VliwScheduler` + `build_program()` pattern.  
**Result:** 5/5 driver integration tests pass.

### 4. Dual-ALU Configuration Issue
**Impact:** Multi-ALU configs show register writeback failures  
**Severity:** High (blocks multi-core scaling)  
**Status:** Investigation planned (scheduler multi-slot allocation)  
**Workaround:** Use baseline single-ALU configuration

## Project Structure

```
vliw_simd/
├── src/main/scala/vliw/                    # RTL source (SpinalHDL)
│   ├── core/                               # Core pipeline + decode/fetch/writeback
│   ├── engine/                             # ALU/VALU/Flow/Memory engines
│   │   └── valu/                           # VALU helper abstractions (packed/widen/cast)
│   ├── memory/                             # Scratch + memory subsystems
│   └── gen/                                # RTL generators
├── drivers/                                # C driver library
├── example_count.c               # Example program
├── tools/                        # Assembler, scheduler
│   └── tests/                    # Toolchain scheduler tests
├── verification/                 # Test infrastructure
│   ├── cocotb/                   # Python/cocotb tests
│   │   └── integration/           # Grouped suites: scalar/memory/control/vector + algorithms
│   └── config/                   # Configuration variants
├── generated_rtl/                # Generated Verilog
└── docs/                         # Documentation
```

## Configuration

Configuration files in `verification/config/`:

- **test_config.properties** (Baseline): 1 ALU, 1 VALU - ✅ 176/176 tests passing
- **test_config_alu2.properties**: 2 ALU - ⚠️ Known writeback issue
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

# 2. Run unit tests (48 tests)
python verification/cocotb/tests/run_tests.py

# 3. Run integration regression (128 tests, auto-detects RTL changes)
python verification/cocotb/integration/run_integration.py --modules test_slot_configs,test_integration,test_algorithms,test_driver_integration,test_integration_scalar,test_integration_memory,test_integration_control,test_integration_vector,test_algorithms_kernels,test_algorithms_multiwidth

# Optional: run individual integration domains
python verification/cocotb/integration/run_integration.py --modules test_integration_scalar
python verification/cocotb/integration/run_integration.py --modules test_integration_memory
python verification/cocotb/integration/run_integration.py --modules test_integration_control
python verification/cocotb/integration/run_integration.py --modules test_integration_vector

# 4. Check results
# Use --rebuild-rtl to force RTL regeneration, --no-rtl to skip
```

## Performance

**Baseline Configuration:**
- Throughput: ~19,000 ns/s (simulation)
- **176/176 tests passing** (48 unit + 128 integration)
- Signal Count: 195 signals
- Load Latency: 0-cycle AR drive
- Load-use hazard stalling: automatic pipeline stall on data dependency from pending loads

## Contributing

See [docs/TOOLCHAIN.md](docs/TOOLCHAIN.md) for build instructions and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for architecture details.

## License

[MIT]
