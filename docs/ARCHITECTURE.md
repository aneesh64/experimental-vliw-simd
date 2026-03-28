# VLIW SIMD Architecture - Current Implementation

**Status:** Phase 5+ (Load-Use Hazard Detection + Store Backpressure + Multi-Width Vector ISA + Matrix Integration + HALT Flush Fix + FP8 Matrix Compute)  
**Version:** Load-Use Hazard Detection + Store FIFO Backpressure + Multi-Width Vector Extension + HALT Pipeline Flush Fix + FP8 Matrix Compute Extension  
**Last Updated:** March 28, 2026

---

## Overview

A compiler-trusted VLIW processor with SIMD capabilities, optimized for simplicity and verification.

### Key Design Principles (Post-Simplification)
- **Compiler-Scheduled Pipeline:** Scheduler guarantees RAW/WAW/WAR-safe instruction ordering
- **Hardware Load-Use Hazard Detection:** Pipeline stalls automatically when an instruction reads a register with a pending load result (asynchronous AXI latency cannot be statically scheduled)
- **Minimal Hardware Complexity:** Removed FIFOs, multi-cycle trackers, and defensive logic (except load-use detection)
- **Combinatorial Memory Paths:** 0-cycle AR drive for load requests
- **Single Pending Operations:** One in-flight load, simple register-based tracking
- **Dedicated Matrix Local Memories:** MatrixEngine is not routed through the normal scratch crossbar; it owns separate operand-A, operand-B, and accumulator memories per core

### Pipeline Overview
```
┌────────┐     ┌─────────┐     ┌──────────┐
│ Fetch  │ --> │ Execute │ --> │Writeback │
│  (IF)  │     │  (EX)   │     │  (WB)    │
└────────┘     └─────────┘     └──────────┘
     3-stage pipeline, hardware load-use stalling
```

### Load-Use Hazard Detection (VliwCore)

The pipeline detects data dependencies from pending loads and stalls automatically:

- **Three hazard sources** checked per cycle:
  1. `hazardFromPending` — load already in-flight, decode reads its destination
  2. `hazardFromIssuing` — load being issued this EX cycle, decode reads its destination
  3. `hazardFromWbCommit` — load data arriving at writeback, decode reads its destination
- **Stall path:** `fetch.io.stall := mem.io.stall || loadUseHazard || exLoadUseHazard`
- **Bubble injection:** On decode-side hazard, EX slot valid signals forced `False` (pipeline bubble)
- **Pipeline register hold:** On memory backpressure, all `exSlotsReg` pipeline registers are frozen
- **Coverage:** Checks ALL engine slot types (ALU src1/src2, Load addrReg, Store addrReg/srcReg, VALU src1Base/src2Base/src3Base, Flow operands) including scalar-in-vector-range detection

---

## Core Architecture (VliwCore.scala - 677 LOC)

### Execution Engines (Baseline Configuration)

**1× ALU Engine**
- Operations: ADD, SUB, MUL, XOR, AND, OR, SHL, SHR, LT, EQ, MOD, DIV, CDIV, MAX, MIN
- Latency: 1 cycle for single-cycle ops; DIV/MOD/CDIV use the divider path
- Input: scratch-word source addresses `src1`, `src2`
- Output: scratch-word destination address `dest`

**1× VALU Engine (Vector ALU) — Multi-Width**
- **Element Widths:** 4, 8, 16, 32 (default), 64-bit
- Operations: ADD, SUB, MUL, XOR, AND, OR, SHL, SHR, LT, EQ, VBROADCAST, MULTIPLY_ADD, VCAST
- Lanes: 8 parallel 32-bit lanes
- **Packed Sub-Element Processing:**
  - EW32: 1 element/lane → 8 total (default, backward compatible)
  - EW16: 2 elements/lane → 16 total
  - EW8: 4 elements/lane → 32 total
  - EW4: 8 elements/lane → 64 total
  - EW64: lane pairing (even=lo, odd=hi) → 4 total
- **Widening Operations:** MUL/MULTIPLY_ADD with ew→dw (e.g., 8→16, 8→32, 16→32)
  - **Note:** Widening MULTIPLY_ADD (FMA) has a hardware limitation — see Known Issues #4b.
    Use 2-instruction sequence (widening MUL + packed ADD) as workaround.
- **VCAST:** Type conversion (sign/zero extend or truncate) across widths
- **64-bit:** Carry/borrow chains between lane pairs; no MUL/DIV
- **Signed Mode:** Affects LT→SLT, SHR→SAR, MUL→SMUL, VCAST→sign-extension
- Latency: 1 cycle (except DIV/MOD/CDIV: multi-cycle, EW32 only)
- Input: vector scratch base addresses (src1, src2, src3 for MULTIPLY_ADD)
- Output: vector scratch base destination

**1× Load Engine**
- Operations: LOAD, LOAD_OFFSET, VLOAD, CONST
- Addressing: scratch-resident word address plus encoded offset where applicable
- **Simplified Design:** Single pending load tracked in register
- **0-Cycle AR Drive:** Combinatorial assignment to AXI AR channel
- Latency: Variable (depends on AXI response, typically 2-3 cycles)

**1× Store Engine**  
- Operations: STORE, VSTORE
- Addressing: scratch-resident word address
- Queueing: FIFO-backed request buffering (default depth = 4, configurable)
- Backpressure behavior: pipeline stalls when store queue capacity is exhausted
- AXI completion: AW/W handshake plus B response tracked by store FSM

**1× Flow Engine**
- Operations: SELECT, VSELECT, ADD_IMM, HALT, COND_JUMP, COND_JUMP_REL, JUMP, JUMP_INDIRECT, COREID
- Target: immediate, relative, or scratch-indirect depending on opcode
- Latency: 3-cycle branch delay slot (IF→Decode→EX pipeline depth)
- Scheduler inserts 3 NOP bundles after taken branches (`JUMP_BUBBLE=3`)

**1× Matrix Engine (Per Core, Dedicated Local Memory Path)**
- Fixed v1 shape: 8x8 tiles with 8-bit operand storage and 32-bit accumulator storage
- Operand storage: separate operand-A and operand-B matrix scratchpads per core
- Result storage: separate accumulator memory per core
- ISA model: dedicated matrix slot with MDMVIN, MDMVOUT, MZERO, signed-int8 compute ops, and FP8 E4M3/E5M2 compute ops
- **FP8 compute ops:** `mcompute_fp8_e4m3[_acc]` and `mcompute_fp8_e5m2[_acc]` (opcodes 10–13). Both operand tiles are stored as packed 8-bit FP8 values in matrix-local memory; each element is decoded to FP32 in the MAC stage and accumulated into the 32-bit FP32 accumulator. E4M3 offers higher mantissa precision (3 bits, max ±448, no Inf); E5M2 offers wider dynamic range (2 bits, max ±57344, Inf/NaN representable). See [ISA.md](ISA.md#fp8-format-reference) for full bit-layout and NaN-propagation details.
- **MDMVIN decoupling:** non-matrix bundles may retire while an `MDMVIN` transfer is in progress; only the first subsequent matrix-slot bundle is held in fetch/decode until the transfer completes (EX bubble injected). `MDMVOUT` remains globally blocking until the write drains.
- **SCOPY operations:** `MemoryEngine` implements `SCOPY_M2V`/`SCOPY_V2M` (multi-cycle, VLEN words, managed by micro-sequencer) and `SCOPY_V2S`/`SCOPY_S2V` (single-word copies) for moving data between the normal scratch crossbar and matrix-local memory without a DRAM round-trip.
- Plugin note: MatrixEngine implements `EnginePlugin` for engine inventory/debug only, but reports zero scratch ports because it does not participate in the normal BankedScratchMemory crossbar

### Architectural Operand State
- Scalar operations address 32-bit words in per-core scratch memory
- Vector operations address `VLEN` consecutive 32-bit scratch words starting at a base address
- The default verified configuration uses `scratchSize = 1536` words and `VLEN = 8`
- Matrix operations use dedicated matrix-local operand-A, operand-B, and accumulator memories rather than the normal scratch crossbar

### Instruction Format
- **Bundle Width:** configurable; computed from slot counts and padded to a 64-bit boundary
- **Bundle Order (LSB first):** ALU slots, VALU slots, LOAD slots, STORE slots, MATRIX slots, FLOW slot, then padding
- **Typical Widths:**
  - baseline `1/1/1/1/0/1`: `256` bits
  - matrix-enabled `1/1/1/1/1/1`: `320` bits
- **NOP Encoding:** `valid = 0` for the slot; unused padding bits are zero
- See [ISA.md](ISA.md) for exact slot field layouts and opcode tables.

---

## Memory Subsystem

### IMEM and DMEM Subsystem (2026 Update)

The memory subsystem now features a clear separation between **Instruction Memory (IMEM)** and **Data Memory (DMEM)**, both accessible via the C driver and mapped into the SoC address space.

#### IMEM (Instruction Memory)
- Dedicated region for VLIW bundles.
- Loaded via CSR registers (`IMBAS`, `IMWD`) or AXI-Lite writes.
- Bundles are written as 32-bit words; hardware auto-commits after the last word per bundle.
- Addressing is by bundle index, not byte address.

#### DMEM (Data Memory)
- Main data memory, accessible via AXI4 and optionally via CSR (`DMWA`, `DMWD`).
- Used for program data, results, and host communication.
- Supports both scalar and vector accesses.

#### C Driver Integration
- The C driver provides routines for IMEM/DMEM initialization, program loading, and result retrieval.
- Example boot sequence and memory access code are in DRIVER_API.md.
- The driver ensures correct protocol for bundle writes and memory synchronization.

#### Memory Engine (MemoryEngine.scala)
- Single pending load tracked per core; combinatorial AR drive for low-latency requests.
- Store requests buffered in a FIFO; pipeline stalls only on full queue.
- Alignment and hazard checks enforced in hardware.

#### Banked Scratch Memory
- 8 banks × 192 words = 1536 words per core (default config).
- Word-interleaved addressing for high bandwidth.
- True dual-port for concurrent engine and memory access.
- Write forwarding prevents RAW hazards.

See DRIVER_API.md for C driver usage and ISA.md for slot/field layouts.

----

## SoC Integration (VliwSimdSoc.scala - 244 LOC)

### Address Map

| Region | Base Address | Size | Purpose |
|--------|-------------|------|---------|
| CSR Registers | 0x00000000 | 256 bytes | Control and status registers |
| Instruction Memory | 0x00010000 | Configurable | VLIW bundles (`imemDepth` entries; baseline sim preset: 1024 bundles) |
| Data Memory (AXI) | 0x10000000 | Unlimited | Main memory via AXI4 |
| Scratch Memory | Core-local | Configurable | Fast per-core scratch (`1536` words in the baseline verified preset) |

### Host Interface (HostInterface.scala - ~150 LOC)

**CSR Registers (Memory-Mapped):**

| Offset | Name | Access | Description |
|--------|------|--------|-------------|
| 0x00 | CONTROL | RW | Start/halt bits per core |
| 0x04 | STATUS | RO | Halted/running state per core |
| 0x08 | PC_CORE0 | RW | Program counter for core 0 |
| 0x0C | PC_CORE1 | RW | Program counter for core 1 (if exists) |
| 0x10 | CYCLE_COUNT | RO | Global cycle counter |
| 0x14 | IRQ_ENABLE | RW | Interrupt enable mask |
| 0x18 | IRQ_STATUS | RO | Interrupt status flags |

**IMEM Loading:**
- Host writes bundles via AXI-Lite write transactions
- Address encoding: `[coreBits | imemAddr | wordInBundle | byteOffset]`
- Multi-word bundles accumulated and committed on final word write

**DMEM Access:**
- Host can read/write data memory via AXI4
- Used for preloading input data and reading results

---

## ISA Reference

The implementation-level ISA is documented in [ISA.md](ISA.md).

That file is derived directly from:
- `SlotBundles.scala`
- `VliwSocConfig.scala`
- `DecodeUnit.scala`
- `FlowEngine.scala`
- `MemoryEngine.scala`
- `MatrixEngine.scala`
- `tools/assembler.py`

Use [ISA.md](ISA.md) for:
- opcode tables
- slot bit layouts
- bundle packing order
- assembler tuple forms
- current matrix-slot conventions

---

## Configuration System

### Default Configuration (Sim Preset)
```scala
VliwSocConfig.Sim  // used in simulation and cocotb verification
// nCores=1, nAluSlots=1, nValuSlots=1, nLoadSlots=1, nStoreSlots=1
// nFlowSlots=1, nMatrixSlots=0
// vlen=8, scratchSize=1536, scratchBanks=8
// imemDepth=1024, mainMemWords=16384
// storeQueueDepth=4, loadQueueDepth=8
```

### Production Default Configuration
```scala
VliwSocConfig()  // production default
// imemDepth=4096, mainMemWords=65536
// storeQueueDepth=4, loadQueueDepth=16
// (all other fields identical to Sim preset)
```

### Matrix-Enabled Configuration (test_config_matrix.properties)
```scala
VliwSocConfig.Sim.copy(nMatrixSlots = 1)
// bundle width: 320 bits (10 words)
// passes 62/62 RTL tests including full algorithm and DSL suites
```

---

## Latency Summary

| Operation | Cycles | Notes |
|-----------|--------|-------|
| ALU ops | 1 | ADD, SUB, MUL, shifts, compare |
| DIV/DIVU | Variable | ~32 cycles worst case |
| VALU ops (EW32) | 1 | ADD, SUB, MUL, bitwise, shift, compare |
| VALU packed (EW4/8/16) | 1 | Packed sub-element operations |
| VALU 64-bit (EW64) | 1 | Lane-paired with carry chains |
| VALU widening MUL/FMA | 1 | ew→dw element-wise |
| VCAST | 1 | Widening/narrowing type conversion |
| VBROADCAST | 1 | Scalar → all lanes/sub-elements |
| MULTIPLY_ADD | 1 | Fused multiply-add a*b+c |
| MOD/DIV/CDIV | Variable | EW32 only, ~32 cycles worst case |
| Load (cache hit) | 2-3 | AXI latency dependent |
| Load AR drive | 0 | Combinatorial (Phase 3) |
| Store | 1 | FIFO-backed, stalls only on full |
| Matrix int8 compute (`mcompute`) | Multi-cycle | 8×8 tile, 8 MACs/cycle, ~8–72 cycles per tile |
| Matrix FP8 compute (`mcompute_fp8_e4m3/e5m2`) | Multi-cycle | Same tile loop as int8; FP8 decode adds combinatorial decode stage before MAC |
| MDMVIN (matrix DMA in) | Variable | AXI read of 64 bytes; decoupled — non-matrix ops retire in parallel |
| MDMVOUT (matrix DMA out) | Variable | AXI write of 64 bytes; globally blocking until drain |
| MZERO | Multi-cycle | ~8 cycles to clear 8×8 accumulator tile |
| Branch taken | 3 | 3-cycle delay slot (IF→Decode→EX depth) |
| Branch not taken | 0 | Falls through |

---

## Key Simplifications (Phase 0-3), Extensions (Phase 4-5), and Pipeline Fixes

### HALT Pipeline Flush Fix (March 17, 2026)

The `FetchUnit` now combinatorially suppresses `io.exValid` when `HALT` fires in the EX stage:

```scala
io.exValid := exValidReg && !io.halt
```

**Problem:** Without this fix, the instruction immediately after HALT (at `HALT_PC+1`) was fetched into the decode pipeline and its slots were captured in `exSlotsReg` with `valid=True`. Since `exValidReg := False` is a registered assignment taking effect one cycle later, the post-HALT instruction executed as an implicit delay slot.  

This caused silent data corruption when a shorter program followed a longer one: stale IMEM content at `HALT_PC+1` (left over from the previous program) could contain active STORE instructions that silently overwrote correct results.  

**Fix:** Combinatorial `!io.halt` gate on `io.exValid` ensures the post-HALT instruction's decoded slots see `valid=False` in the same cycle HALT fires — preventing it from entering `exSlotsReg` as valid.

**Note:** The same delay-slot window exists for `JUMP`/`COND_JUMP`, but is currently benign because the scheduler pads taken branches with 3 NOP bundles (`JUMP_BUBBLE=3`).

### Phase 2: Hazard Detection Removal (-116 LOC, partially restored)
- Removed WAW, RAW, WAR hazard checks
- Removed pipeline stall logic and bypassing
- Compiler now guarantees hazard-free schedules for ALU/VALU/Store/Flow
- **Later restored:** Load-use hazard detection (+316 LOC) — asynchronous AXI load latency
  cannot be statically scheduled, requiring hardware stall on load-dependent reads
- Result: Net VliwCore growth 361 → 677 LOC (hazard detection is the dominant contributor)

### Phase 3: Memory Engine Simplification (-57 LOC, +24 LOC hazard metadata)
- **FIFO → Register:** 3-item load queue → single pending load register
- **0-Cycle AR:** Combinatorial AXI AR channel drive
- **Simplified Tracking:** `loadReqValid` + `loadReqEntry` registers only
- **Hazard Metadata:** Added `loadPendingValid`, `loadPendingDestAddr`, `loadPendingIsVector`
  output ports for VliwCore’s load-use hazard detection
- **Alignment Assertions:** Debug-time checks for VLOAD/VSTORE beat boundary overflow
- Result: 367 → 391 LOC (net +24 from hazard metadata and assertions)

### Phase 5+: FP8 Matrix Compute Extension (March 28, 2026)

**Added FP8 E4M3 and E5M2 matrix multiply opcodes to the Matrix Engine:**

- **Four new MATRIX opcodes** (10–13): `mcompute_fp8_e4m3`, `mcompute_fp8_e4m3_acc`,
  `mcompute_fp8_e5m2`, `mcompute_fp8_e5m2_acc`.

- **FP8 decode path in MatrixEngine:** Each operand byte is decoded from its FP8 encoding
  to an internal FP32 representation (exponent unbias + mantissa shift) before the multiply.
  Two independent decode trees exist: one for E4M3 (`fpA_E4M3_shift`, `fpB_E4M3_shift`) and
  one for E5M2 (`fpA_E5M2_shift`, `fpB_E5M2_shift`). The active tree is selected by the
  opcode at the start of the compute state machine.

- **FP32 accumulator:** All four FP8 opcodes accumulate into the existing 32-bit IEEE-754
  FP32 accumulator memory, identical to the int8 path. Switching between int8 and FP8 compute
  within a kernel (on the same accumulator tile) without an intervening `mzero` produces
  undefined results — always zero the tile before changing compute type.

- **Backward compatibility:** Existing int8 programs using `mcompute`/`mcompute_acc` (opcodes
  7–8) are unaffected; opcode decoding is additive.

- **Assembler support:** All four FP8 opcodes are accepted by `tools/assembler.py` with the
  same tuple form as `mcompute`: `(op, dest, srcA, srcB[, srcC[, tileRows[, tileCols[, flags]]]])`.

### Phase 4: Multi-Width Vector ISA Extension

**Added multi-width packed sub-element processing to the VALU engine:**

- **Packed Operations (EW4/8/16):** Each 32-bit lane processes multiple narrower elements
  in parallel. All ALU opcodes (ADD, SUB, MUL, XOR, AND, OR, SHL, SHR, LT, EQ,
  MAX, MIN) plus VBROADCAST and MULTIPLY_ADD support packed mode.

- **64-bit Operations (EW64):** Lane pairing — even lanes hold the low 32 bits, odd lanes
  hold the high 32 bits. Combinational carry/borrow chains propagate between paired lanes.
  Supports ADD, SUB, XOR, AND, OR, SHL, SHR, LT, EQ, MAX, MIN, VBROADCAST.
  No 64-bit MUL/DIV.

- **Widening MUL/FMA:** Source operands at element width (ew), destination at wider
  destination width (dw). Element-wise: processes 32/dw elements per lane.
  Supported combinations: 4→8, 4→16, 4→32, 8→16, 8→32, 16→32.

- **VCAST (Type Conversion):**
  - Widening: zero-extend (unsigned) or sign-extend (signed) to wider type
  - Narrowing: truncate to lower bits
  - src2Base[0] selects lower or upper half of source sub-elements
  - All width combinations supported

- **Signed Mode:** Single flag affects: LT→signed comparison, SHR→arithmetic shift,
  MUL/FMA→signed multiply, VCAST→sign-extension.

- **Backward Compatibility:** ewidth=000 and dwidth=000 default to 32-bit operations.
  Existing programs run unchanged.

---

## Pipeline Diagrams

### Simple ADD Operation
```
Cycle 0: Fetch bundle with ADD
Cycle 1: Decode, execute ADD in ALU, result to WB
Cycle 2: Writeback to register file
```

### Load Operation (Simplified)
```
Cycle 0: Fetch bundle with LW
Cycle 1: Decode, compute address
         → Drive AR combinatorially (addr, valid, etc.)
         → Set loadReqValid, store {rd, coreId, tag}
Cycle 2+: Wait for AXI R channel
Cycle N: R.valid && R.ready
         → Clear loadReqValid
         → Forward data to writeback with tag
```

### Dual-Issue Example (ALU + VALU)
```
Bundle: [ADD r3,r1,r2 | VADD v1,v0,v0 | NOP | NOP]

Cycle 0: Fetch bundle
Cycle 1: Execute both ADD and VADD in parallel
Cycle 2: Writeback r3 (scalar) and v1 (vector) simultaneously
```

---

## Known Limitations

### 1. Single Pending Load
**Impact:** Only one load can be in-flight at a time  
**Rationale:** Simplified for baseline, sufficient for compiler scheduling  
**Workaround:** Compiler schedules loads with sufficient spacing

### 2. Bounded Store Queue Capacity
**Impact:** Store issue can stall when queue + in-flight store capacity is exhausted under sustained AXI write backpressure  
**Rationale:** Keeps total outstanding stores bounded (`storeQueueDepth`, default 4) while preserving correctness  
**Workaround:** Scheduler naturally retries on stall; software can reduce sustained store bursts if needed

### 3. Multi-ALU Writeback Issue
**Impact:** Dual-ALU config shows register writeback = 0 instead of computed value  
**Status:** Under investigation (suspected scheduler multi-slot allocation bug)  
**Workaround:** Use baseline single-ALU configuration

### 4. FetchUnit Stall-Address Correction
**Impact:** During load-use stalls, IMEM address must point to `pc-1` (the instruction being stalled),
not `pc` (the next instruction). Without this, the instruction in-flight when the stall began
would be lost and skipped on stall release.  
**Status:** FIXED — `io.imemAddr := Mux(io.stall, (pc - 1).resized, pc)` ensures correct
instruction re-read during stalls.

---

## Tool Integration

### Scheduler (tools/scheduler.py)
- **Input:** Assembly code (pseudo-assembly)
- **Output:** VLIW bundles with operations packed per engine
- **Constraints:** 
  - No hazards (compiler enforced)
  - Max 1 operation per engine per bundle
  - Single pending load limitation
  - Scalar load/store default to scalar memory domain
  - Vector ops (`vload`/`vstore`/`valu`) target vector memory domain
  - Scalar memory ops explicitly targeting vector banks must not co-issue with vector instructions in the same bundle

### Assembler (tools/assembler.py)
- **Input:** Scheduled bundles (JSON format)
- **Output:** Binary instruction bundles
- **Encoding:** 128-bit bundles with operation bit fields

---

## Verification Status

**Baseline Configuration:**
- 176/176 tests PASS ✅
- **Unit Tests (48):**
  - Divider: 6, ALU: 6, VALU: 7, Flow: 13, Mem: 5, Scratch: 5, Core: 6
- **Integration Tests (128):**
  - Full grouped regression across slot configs, integration domains, algorithms, and driver integration
- Comprehensive coverage:
  - ALU operations, memory operations, control flow, vector operations
  - Load-use hazard detection (scalar/vector), multi-width packed ops
  - Driver integration (program load, arithmetic, memory, control flow, VALU)
- All tests complete within cycle budgets (no timeouts)

---

## References

- [DRIVER_API.md](DRIVER_API.md) - C driver library reference
- [TOOLCHAIN.md](TOOLCHAIN.md) - Build and test procedures
- [KNOWN_ISSUES.md](KNOWN_ISSUES.md) - Detailed issue tracking
- [CHANGELOG.md](CHANGELOG.md) - Development history

---

**For deployment questions, see README.md. For issues, see KNOWN_ISSUES.md.**
