# VLIW SIMD Architecture - Current Implementation

**Status:** Phase 5+ (Load-Use Hazard Detection + Store Backpressure + Multi-Width Vector ISA)  
**Version:** Load-Use Hazard Detection + Store FIFO Backpressure + Multi-Width Vector Extension  
**Last Updated:** March 5, 2026

---

## Overview

A compiler-trusted VLIW processor with SIMD capabilities, optimized for simplicity and verification.

### Key Design Principles (Post-Simplification)
- **Compiler-Scheduled Pipeline:** Scheduler guarantees RAW/WAW/WAR-safe instruction ordering
- **Hardware Load-Use Hazard Detection:** Pipeline stalls automatically when an instruction reads a register with a pending load result (asynchronous AXI latency cannot be statically scheduled)
- **Minimal Hardware Complexity:** Removed FIFOs, multi-cycle trackers, and defensive logic (except load-use detection)
- **Combinatorial Memory Paths:** 0-cycle AR drive for load requests
- **Single Pending Operations:** One in-flight load, simple register-based tracking

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
- Operations: ADD, SUB, MUL, SLL, SRL, SRA, SLT, SLTU, DIV, DIVU
- Latency: 1 cycle (except DIV: multi-cycle with unsigned divider)
- Input: rs1, rs2 (registers or immediates)
- Output: rd (destination register)

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
- Input: Vector registers (src1, src2, src3 for MULTIPLY_ADD)
- Output: Vector destination register

**1× Load Engine**
- Operations: LW (load word)
- Addressing: Register + immediate offset
- **Simplified Design:** Single pending load tracked in register
- **0-Cycle AR Drive:** Combinatorial assignment to AXI AR channel
- Latency: Variable (depends on AXI response, typically 2-3 cycles)

**1× Store Engine**  
- Operations: SW (store word), VSW (vector store)
- Addressing: Register + immediate offset
- Queueing: FIFO-backed request buffering (default depth = 4, configurable)
- Backpressure behavior: pipeline stalls when store queue capacity is exhausted
- AXI completion: AW/W handshake plus B response tracked by store FSM

**1× Flow Engine**
- Operations: JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU
- Target: PC-relative or register-based
- Latency: 3-cycle branch delay slot (IF→Decode→EX pipeline depth)
- Scheduler inserts 3 NOP bundles after taken branches (`JUMP_BUBBLE=3`)

### Register File
- **Scalar Registers:** 32 × 32-bit general-purpose registers (r0-r31)
  - r0 hardwired to 0
  - r1 typically used as link register
- **Vector Registers:** 8 × 16-lane × 32-bit vector registers (v0-v7)

### Instruction Format
- **Bundle Width:** 128 bits (4 × 32-bit words)
- **Encoding:** One operation per engine per bundle
  - [31:0] - ALU operation
  - [63:32] - VALU operation  
  - [95:64] - Memory operation (Load/Store)
  - [127:96] - Flow operation
- **NOP Encoding:** All zeros for unused engine slots

---

## Memory Subsystem

### Memory Engine (MemoryEngine.scala - 391 LOC)

**Simplified Design (Phase 3):**
- **Load Tracking:** Single-item register replaces 3-item FIFO
  - `loadReqValid` (1-bit flag)
  - `loadReqEntry` (register holding {rd, coreId, wbTag})
- **Load-Use Hazard Metadata:** Exports pending load info for VliwCore hazard detection:
  - `loadPendingValid` — true when a load is in-flight
  - `loadPendingDestAddr` — scratch destination address of pending load
  - `loadPendingIsVector` — true if pending load is a vector burst load
- **AR Channel:** Combinatorial drive (0-cycle latency from request to AR valid)
- **Constraint:** Only one pending load at a time per core
- **Alignment Assertions:** Debug-time assertions catch VLOAD/VSTORE beat boundary overflow:
  - `assert(wordOffset <= wordsPerBeat - VLEN)` for both VLOAD and VSTORE

**Load Request Flow:**
```
Cycle 0: Load instruction decoded
         → loadAddr computed
         → AR signals driven combinatorially
         → loadReqValid := true
         
Cycle 1+: Wait for AXI R channel
          → When R.ready && R.valid:
             - loadReqValid := false
             - Send to writeback with wbTag
```

**Store Operations:**
- Store requests enqueue into a bounded FIFO
- MemoryEngine drains queue through AW/W then waits for B response
- Pipeline stalls only when a new store arrives and total in-flight + queued capacity is full
- **VSTORE Alignment Constraint:** Word address must satisfy `addr % 16 ≤ 8`
  (8 lanes at word offsets 0–7 within a 16-word AXI beat). See Known Issues #4a.

### Banked Scratch Memory (BankedScratchMemory.scala - 403 LOC)

**Configuration:**
- **4 banks** × 4KB = 16KB total per core
- **Word-interleaved addressing:**
  - addr[1:0] → bank select
  - addr[N:2] → address within bank
- **True Dual-Port:** Simultaneous read and write

**Write Forwarding:**
- If read and write to same address: forward written data
- Prevents RAW hazards within same cycle

**Ports:**
- Port A: Execution engines (read/write)
- Port B: Load/store operations (read/write)

---

## SoC Integration (VliwSimdSoc.scala - 244 LOC)

### Address Map

| Region | Base Address | Size | Purpose |
|--------|-------------|------|---------|
| CSR Registers | 0x00000000 | 256 bytes | Control and status registers |
| Instruction Memory | 0x00010000 | 16KB | VLIW bundles (max 4K bundles) |
| Data Memory (AXI) | 0x10000000 | Unlimited | Main memory via AXI4 |
| Scratch Memory | Core-local | 16KB | Fast per-core scratch |

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

## Instruction Encoding

### ALU Instructions (32-bit)
```
[31:27] opcode (5 bits)
[26:22] rd (5 bits) - destination register
[21:17] rs1 (5 bits) - source register 1
[16:12] rs2 (5 bits) - source register 2
[11:0]  imm (12 bits) - immediate value (sign-extended)
```

**Opcodes:**
- 0x00: ADD
- 0x01: SUB
- 0x02: MUL
- 0x03: SLL (shift left logical)
- 0x04: SRL (shift right logical)
- 0x05: SRA (shift right arithmetic)
- 0x06: SLT (set less than)
- 0x07: SLTU (set less than unsigned)
- 0x08: DIV
- 0x09: DIVU

### VALU Instructions (56-bit)
```
[55]    valid (1 bit)        — 1 = active slot
[54:51] opcode (4 bits)      — ALU/VALU operation
[50:40] destBase (11 bits)   — destination scratch base address
[39:29] src1Base (11 bits)   — source 1 scratch base address
[28:18] src2Base (11 bits)   — source 2 scratch base address
[17:7]  src3Base (11 bits)   — source 3 scratch base (MULTIPLY_ADD accumulator)
[6:4]   ewidth (3 bits)      — element width code
[3:1]   dwidth (3 bits)      — destination element width code (widening/VCAST)
[0]     signed (1 bit)       — 0=unsigned, 1=signed
```

**Element Width Encoding (ewidth/dwidth):**

| Code | Width | Elements/Lane | Total Elements |
|------|-------|---------------|----------------|
| 000  | 32-bit (default) | 1 | 8 |
| 001  | 8-bit | 4 | 32 |
| 010  | 16-bit | 2 | 16 |
| 011  | 4-bit | 8 | 64 |
| 100  | 64-bit (lane pair) | — | 4 |

**VALU Opcodes:**

| Code | Mnemonic | Description |
|------|----------|-------------|
| 0 | ADD | Packed addition |
| 1 | SUB | Packed subtraction |
| 2 | MUL | Packed multiply (or widening when dw≠ew) |
| 3 | XOR | Bitwise XOR |
| 4 | AND | Bitwise AND |
| 5 | OR | Bitwise OR |
| 6 | SHL | Packed shift left |
| 7 | SHR | Packed shift right (arithmetic if signed) |
| 8 | LT | Packed less-than (signed if signed flag set) |
| 9 | EQ | Packed equal |
| 10 | MOD | Modulo (EW32 only, multi-cycle) |
| 11 | DIV | Division (EW32 only, multi-cycle) |
| 12 | CDIV | Ceiling division (EW32 only, multi-cycle) |
| 13 | VBROADCAST | Broadcast scalar to all lanes/sub-elements |
| 14 | MULTIPLY_ADD | Fused multiply-add a*b+c (widening when dw≠ew) |
| 15 | VCAST | Type cast between element widths |

**VCAST Details:**
- Widening (ew < dw): Zero-extend (unsigned) or sign-extend (signed)
- Narrowing (ew > dw): Truncate to lower dw bits
- src2Base[0] selects lower half (0) or upper half (1) of source sub-elements

**64-bit Lane Pairing:**
```
Lane 0 (lo) + Lane 1 (hi) → 64-bit element 0
Lane 2 (lo) + Lane 3 (hi) → 64-bit element 1
Lane 4 (lo) + Lane 5 (hi) → 64-bit element 2
Lane 6 (lo) + Lane 7 (hi) → 64-bit element 3
```
- ADD/SUB: Carry/borrow chain from even lane to odd lane
- LT/EQ: Combined comparison across both halves
- XOR/AND/OR: Independent per-lane (width-agnostic)
- SHL/SHR: Cross-lane shift with 6-bit shift amount from lo lane
- No 64-bit MUL, DIV, MOD, CDIV

### Memory Instructions (32-bit)
```
[31:27] opcode (5 bits)
[26:22] rd/rs (5 bits) - destination (load) or source (store)
[21:17] base (5 bits) - base address register
[16:0]  offset (17 bits) - address offset (sign-extended)
```

**Opcodes:**
- 0x20: LW (load word)
- 0x21: SW (store word)
- 0x22: VLW (vector load - loads to vector register)
- 0x23: VSW (vector store - stores from vector register)

### Flow Instructions (32-bit)
```
[31:27] opcode (5 bits)
[26:22] rd/rs (5 bits) - link register or comparison source
[21:17] rs1 (5 bits) - comparison source (for branches)
[16:0]  target (17 bits) - PC-relative offset or absolute address
```

**Opcodes:**
- 0x30: JAL (jump and link)
- 0x31: JALR (jump and link register)
- 0x32: BEQ (branch if equal)
- 0x33: BNE (branch if not equal)
- 0x34: BLT (branch if less than)
- 0x35: BGE (branch if greater or equal)
- 0x36: BLTU (branch if less than unsigned)
- 0x37: BGEU (branch if greater or equal unsigned)

---

## Configuration System

### Default Configuration (Baseline)
```scala
VliwSocConfig(
  numCores = 1,
  aluSlots = 1,
  valuSlots = 1,
  loadSlots = 1,
  storeSlots = 1,
  flowSlots = 1,
  numScalarRegs = 32,
  numVectorRegs = 8,
  vlen = 16,
  imemDepth = 4096,
  scratchBanks = 4,
  scratchDepthPerBank = 1024
)
```

### Tested Configurations
- **Baseline (test_config.properties):** 1-1-1-1-1 → ✅ 176/176 tests PASS
- **Dual-ALU (test_config_alu2.properties):** 2-1-1-1-1 → ⚠️ Writeback issue (see KNOWN_ISSUES.md)
- **Expanded (test_config_expanded.properties):** 2-2-1-1-1 → ⏳ Not tested

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
| Branch taken | 3 | 3-cycle delay slot (IF→Decode→EX depth) |
| Branch not taken | 0 | Falls through |

---

## Key Simplifications (Phase 0-3) and Extensions (Phase 4)

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

### Phase 4: Multi-Width Vector ISA Extension

**Added multi-width packed sub-element processing to the VALU engine:**

- **Packed Operations (EW4/8/16):** Each 32-bit lane processes multiple narrower elements
  in parallel. All ALU opcodes (ADD, SUB, MUL, XOR, AND, OR, SHL, SHR, LT, EQ) plus
  VBROADCAST and MULTIPLY_ADD support packed mode.

- **64-bit Operations (EW64):** Lane pairing — even lanes hold the low 32 bits, odd lanes
  hold the high 32 bits. Combinational carry/borrow chains propagate between paired lanes.
  Supports ADD, SUB, XOR, AND, OR, SHL, SHR, LT, EQ, VBROADCAST. No 64-bit MUL/DIV.

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
