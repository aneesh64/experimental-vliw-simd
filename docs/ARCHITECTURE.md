# VLIW SIMD Architecture - Current Implementation

**Status:** Phase 3 Complete (Memory Engine Simplified)  
**Version:** Baseline Production-Ready Configuration  
**Last Updated:** February 21, 2026

---

## Overview

A compiler-trusted VLIW processor with SIMD capabilities, optimized for simplicity and verification.

### Key Design Principles (Post-Simplification)
- **No Runtime Hazard Detection:** Compiler guarantees safe instruction scheduling
- **Minimal Hardware Complexity:** Removed FIFOs, multi-cycle trackers, and defensive logic
- **Combinatorial Memory Paths:** 0-cycle AR drive for load requests
- **Single Pending Operations:** One in-flight load, simple register-based tracking

### Pipeline Overview
```
┌────────┐     ┌─────────┐     ┌──────────┐
│ Fetch  │ --> │ Execute │ --> │Writeback │
│  (IF)  │     │  (EX)   │     │  (WB)    │
└────────┘     └─────────┘     └──────────┘
     3-stage pipeline, no stalls, no bypassing
```

---

## Core Architecture (VliwCore.scala - 361 LOC)

### Execution Engines (Baseline Configuration)

**1× ALU Engine**
- Operations: ADD, SUB, MUL, SLL, SRL, SRA, SLT, SLTU, DIV, DIVU
- Latency: 1 cycle (except DIV: multi-cycle with unsigned divider)
- Input: rs1, rs2 (registers or immediates)
- Output: rd (destination register)

**1× VALU Engine (Vector ALU)**
- Operations: VADD, VSUB, VMUL, VMAC (multiply-accumulate)
- Lanes: 16 parallel 32-bit lanes
- Latency: 1 cycle (VMAC: 3 cycles for full MAC operation)
- Input: Vector registers (vrs1, vrs2, vrs3 for VMAC)
- Output: Vector destination register (vrd)

**1× Load Engine**
- Operations: LW (load word)
- Addressing: Register + immediate offset
- **Simplified Design:** Single pending load tracked in register
- **0-Cycle AR Drive:** Combinatorial assignment to AXI AR channel
- Latency: Variable (depends on AXI response, typically 2-3 cycles)

**1× Store Engine**  
- Operations: SW (store word), VSW (vector store)
- Addressing: Register + immediate offset
- Latency: 1 cycle (fire-and-forget, no response tracking)

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

### Memory Engine (MemoryEngine.scala - 367 LOC)

**Simplified Design (Phase 3):**
- **Load Tracking:** Single-item register replaces 3-item FIFO
  - `loadReqValid` (1-bit flag)
  - `loadReqEntry` (register holding {rd, coreId, wbTag})
- **AR Channel:** Combinatorial drive (0-cycle latency from request to AR valid)
- **Constraint:** Only one pending load at a time per core

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
- Fire-and-forget (no response tracking)
- AW and W channels driven directly
- No backpressure handling (assumes AXI always ready)

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

### VALU Instructions (32-bit)
```
[31:27] opcode (5 bits)
[26:24] vrd (3 bits) - vector destination register
[23:21] vrs1 (3 bits) - vector source 1
[20:18] vrs2 (3 bits) - vector source 2
[17:15] vrs3 (3 bits) - vector source 3 (for VMAC)
[14:0]  reserved/immediate
```

**Opcodes:**
- 0x10: VADD (vector add)
- 0x11: VSUB (vector subtract)
- 0x12: VMUL (vector multiply)
- 0x13: VMAC (vector multiply-accumulate: vrd := vrs1 * vrs2 + vrs3)

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
- **Baseline (test_config.properties):** 1-1-1-1-1 → ✅ 24/24 tests PASS
- **Dual-ALU (test_config_alu2.properties):** 2-1-1-1-1 → ⚠️ Writeback issue (see KNOWN_ISSUES.md)
- **Expanded (test_config_expanded.properties):** 2-2-1-1-1 → ⏳ Not tested

---

## Latency Summary

| Operation | Cycles | Notes |
|-----------|--------|-------|
| ALU ops | 1 | ADD, SUB, MUL, shifts, compare |
| DIV/DIVU | Variable | ~32 cycles worst case |
| VALU ops | 1 | VADD, VSUB, VMUL |
| VMAC | 3 | Multiply-accumulate pipeline |
| Load (cache hit) | 2-3 | AXI latency dependent |
| Load AR drive | 0 | Combinatorial (Phase 3) |
| Store | 1 | Fire-and-forget |
| Branch taken | 3 | 3-cycle delay slot (IF→Decode→EX depth) |
| Branch not taken | 0 | Falls through |

---

## Key Simplifications (Phase 0-3)

### Phase 2: Hazard Detection Removal (-116 LOC)
- Removed WAW, RAW, WAR hazard checks
- Removed pipeline stall logic
- Compiler now guarantees hazard-free schedules
- Result: 87.9% signal reduction, 2.12× simulation speedup

### Phase 3: Memory Engine Simplification (-57 LOC)
- **FIFO → Register:** 3-item load queue → single pending load register
- **0-Cycle AR:** Combinatorial AXI AR channel drive
- **Simplified Tracking:** `loadReqValid` + `loadReqEntry` registers only
- Result: 27% memory engine reduction, cleaner FSM

Total RTL reduction: **-173 LOC (15.3%)**

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

### 2. No Store Response Tracking
**Impact:** Stores are fire-and-forget, no confirmation of completion  
**Rationale:** Simplifies hardware, assumes AXI always ready  
**Workaround:** Compiler adds sufficient padding after stores before dependent operations

### 3. Multi-ALU Writeback Issue
**Impact:** Dual-ALU config shows register writeback = 0 instead of computed value  
**Status:** Under investigation (suspected scheduler multi-slot allocation bug)  
**Workaround:** Use baseline single-ALU configuration

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
- 24/24 tests PASS ✅
- Comprehensive coverage:
  - ALU operations (10+ tests)
  - Memory operations (5+ tests)
  - Control flow (3+ tests)
  - Vector operations (4+ tests)
- All tests complete within cycle budgets (no timeouts)

**Simulation Performance:**
- Throughput: 23,272 ns/s
- Full suite: 88.14 seconds
- Signal count: 195 optimized signals

---

## References

- [DRIVER_API.md](DRIVER_API.md) - C driver library reference
- [TOOLCHAIN.md](TOOLCHAIN.md) - Build and test procedures
- [KNOWN_ISSUES.md](KNOWN_ISSUES.md) - Detailed issue tracking
- [CHANGELOG.md](CHANGELOG.md) - Development history

---

**For deployment questions, see README.md. For issues, see KNOWN_ISSUES.md.**
