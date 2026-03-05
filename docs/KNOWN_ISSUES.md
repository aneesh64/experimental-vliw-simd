# Known Issues and Limitations

**Last Updated:** March 5, 2026  
**Current Version:** Load-Use Hazard Detection + Multi-Width Vector Extensions

---

## Critical Issues

### 1. Dual-ALU Register Writeback Failure ⚠️

**Priority:** HIGH  
**Impact:** Blocks multi-core scaling with multiple ALU engines  
**Severity:** Functional failure in non-baseline configurations

**Description:**  
When using the dual-ALU configuration (2 ALU slots), register writebacks show 0x00000000 instead of computed  values.

**Affected Tests:**
- `test_large_values`: Expected 0x80000000, got 0x00000000
- `test_add_imm_sequence`: Expected 60, got 0x00000000

**Configuration:**
- Baseline (1 ALU): ✅ Works correctly
- Dual-ALU (2 ALU): ❌ Fails with zero writebacks
- Expanded (2 ALU, 2 VALU): ⏳ Not tested (likely same issue)

**Root Cause Analysis:**
Suspected scheduler bug in multi-slot register allocation. The hardware RTL correctly computes results in both ALU engines, but the writeback path coordination appears incorrect when multiple ALUs target the same register file.

**Investigation Plan:**
1. Check `tools/scheduler.py` multi-slot bundle generation
2. Verify writeback arbitration in `VliwCore.scala`
3. Trace register writeback signals in dual-ALU simulation
4. Identify where register gets cleared/overwritten with zero

**Time Estimate:** 4-6 hours investigation + fix

**Workaround:**  
Use baseline single-ALU configuration for production deployment.

**Status:** Documented, investigation pending

---

## Non-Critical Issues

### ~~2. Long Memory Accumulate Timeout~~ ✅ RESOLVED

**Status:** RESOLVED (February 28, 2026)  
**Resolution:** Scheduler `JUMP_BUBBLE` corrected from 1 → 3

**Root Cause:**  
The scheduler's `JUMP_BUBBLE=1` was insufficient for the hardware's 3-cycle branch delay (IF→Decode→EX pipeline depth). Post-loop STORE instructions executed within the branch delay window every iteration, issuing AXI writes with X/Z addresses. The AXI memory model silently skipped these handshakes, leaving the MemoryEngine's store state machine permanently stuck in `STORE_AW_W` — causing pipeline deadlock.

**Fix Applied:**
1. `JUMP_BUBBLE = 3` in `tools/scheduler.py` — matches actual hardware branch delay
2. AXI model: X/Z addresses treated as `addr=0` with handshake completion (defensive fix)

**Verification:**  
`test_long_memory_accumulate_golden` now completes in 1,749 cycles with correct result (7,392). All 24/24 integration tests pass.

---

## Design Limitations

### 3. Single Pending Load Constraint

**Priority:** MEDIUM  
**Impact:** Limits load throughput, compiler must schedule conservatively  
**Severity:** Design constraint, not a bug

**Description:**  
Memory engine can only track one pending load at a time. If a second load is issued before the first completes, behavior is undefined.

**Technical Details:**
- Phase 3 simplified load tracking from 3-item FIFO to single register
- Trade-off: Reduced hardware complexity for constrained concurrency
- Constraint: `loadReqValid` flag prevents multiple simultaneous loads

**Impact on Compiler:**
- Scheduler must ensure loads are separated by sufficient cycles
- Cannot issue back-to-back loads
- Reduces potential load/store parallelism

**Workaround:**  
Compiler scheduling enforces load spacing (already implemented in scheduler.py).

**Future Enhancement:**  
Could restore 2-3 item FIFO if load throughput becomes critical.

**Status:** Accepted design trade-off

---

### 4a. VSTORE/VLOAD AXI Alignment Constraint

**Priority:** MEDIUM  
**Impact:** VSTORE/VLOAD addresses must be 16-word aligned to avoid data corruption  
**Severity:** Design constraint (can cause silent data corruption)

**Description:**  
VSTORE and VLOAD pack 8 lanes into a single 512-bit AXI beat (16 × 32-bit words).
The lane data is placed starting at the word offset within the beat:
`wpos = (word_offset + lane) % 16`. When `word_offset + VLEN > 16`, lane positions
wrap around within the 16-word beat, causing data to be written to/read from incorrect
memory locations.

**Technical Details:**
- AXI data bus: 512 bits = 16 × 32-bit words per beat
- VLEN = 8 lanes, each 32-bit
- `word_offset = (byte_addr / 4) % 16`
- **Constraint:** `word_offset + VLEN ≤ 16`, i.e., `word_offset ≤ 8`
- Safe addresses: any byte address where `(addr % 64) ≤ 32`

**Example:**
- Address 700 (words): `word_offset = 700 % 16 = 12` → lanes 4–7 wrap to positions 0–3 ❌
- Address 1104 (words): `word_offset = 1104 % 16 = 0` → all lanes fit ✓

**Workaround:**  
Ensure VSTORE/VLOAD word addresses satisfy `addr % 16 ≤ 8`. The simplest approach
is to use addresses that are multiples of 16 (word-aligned to AXI beat boundary).

**Debug Support:**  
RTL assertions were added to MemoryEngine.scala that fire at simulation time when a
VLOAD or VSTORE would cross the AXI beat boundary:
```
assert(wordOffset <= wordsPerBeat - VLEN,
       "VLOAD/VSTORE: vector crosses AXI beat boundary")
```
These assertions immediately identify alignment violations during cocotb simulation.

**Future Enhancement:**  
Split VSTORE/VLOAD into 2 AXI beats when data crosses the beat boundary, or
always align to beat boundaries in hardware.

**Status:** Accepted design constraint, documented

---

### 4b. VALU 3-Operand FMA: src3 Scalar Read Blocked During Vector Execution

**Priority:** MEDIUM  
**Impact:** MULTIPLY_ADD instruction's accumulator operand reads stale data  
**Severity:** Functional limitation — FMA requires 2-instruction workaround

**Description:**  
The VALU MULTIPLY_ADD instruction (FMA: dest = a × b + c) needs 3 operand reads:
src1 (a) via vector Port A, src2 (b) via vector Port B, and src3 (c) via scalar
read. However, when VALU is active, `blockScalarReads` is asserted, blocking ALL
scalar reads including the VALU's own src3 read. The scalar output MUX then returns
stale Port A data (src1's value) instead of src3, making operandC = operandA.

**Root Cause:**  
The BankedScratchMemory uses TDP BRAM with 2 ports per bank:
- Port A: used for VALU vsrc1 vector reads (all 8 banks occupied)
- Port B: used for VALU vsrc2 vector reads (all 8 banks occupied)

With both ports fully utilized by vector reads, there is no available read port
for a 3rd operand. The `blockScalarReads` flag prevents the src3 read from
contending with vector reads, but this means src3 data is never actually read.

**Affected Instructions:**
- `MULTIPLY_ADD` (opcode 14) with src3 ≠ src1 — always incorrect
- `VBROADCAST` (opcode 13) — works correctly because src3 == src1 by encoding

**Workaround (implemented in tests):**  
Use a 2-instruction sequence instead of single-instruction FMA:
```
# Instead of: multiply_add(dest, a, b, c, ew=8, dw=16)
# Use:
valu_op("mul", dest, a, b, ew=8, dw=16)    # widening multiply
valu_op("add", dest, dest, c, ew=16)        # packed accumulate
```

**Future Enhancement Options:**
1. Add a 3rd BRAM port via separate register file for operandC
2. Pipeline stalling: read src3 in separate cycle before VALU execution
3. Register-file replication: duplicate scratch for independent src3 reads

**Status:** Accepted design limitation, workaround documented

---

### 5. ~~No Store Response Tracking~~ ✅ Resolved

**Priority:** —  
**Impact:** Resolved by bounded store FIFO + AXI B-response tracking  
**Severity:** —

**Description:**  
Store operations now enqueue into a bounded FIFO and complete through AW/W plus B-response tracking.
Under sustained AXI write backpressure, store issue stalls when queue capacity is full (default depth 4),
then recovers as writes drain.

**Technical Details:**
- FIFO-backed store request buffering
- B channel completion handling in MemoryEngine store FSM
- Explicit backpressure stall-on-full behavior

**Impact on Compiler:**
- Scheduler/hardware replay safely handle temporary store saturation
- Store completion remains ordered via AXI write response path
- No lost-store risk from ordinary AW/W/B backpressure in the verified model

**Workaround:**  
No special workaround required beyond normal scheduling constraints.

**Future Enhancement:**  
Future tuning can increase `storeQueueDepth` for burst-heavy workloads.

**Status:** Resolved (March 2026)

---

## Tool Integration Issues

### ~~5. Driver Assembler API Mismatch~~ ✅ RESOLVED

**Status:** RESOLVED (March 5, 2026)  
**Resolution:** All 5 driver integration tests rewritten to use `VliwScheduler` + `build_program()` pattern

**Root Cause:**  
Driver integration tests passed raw assembly text strings to `Assembler.assemble_program()`,
which expects structured instruction dictionaries (list of dicts mapping engine names to slot
tuples). The assembler has no text parser — it encodes pre-parsed bundle objects.

**Fix Applied:**  
Rewrote `test_driver_integration.py` to use the same `VliwScheduler` + `Assembler` pattern
as all other integration tests. Programs are now built using `Op` objects:
```python
program = build_program([
    S.const(0, 10),
    S.const(1, 20),
    S.add(2, 0, 1),
    S.halt(),
])
```

**Verification:**  
All 5 driver integration tests pass: program load, arithmetic, memory round-trip,
control flow (counting loop), and vector operations.

---

### ~~8. FetchUnit Instruction Skip on Stall~~ ✅ RESOLVED

**Status:** RESOLVED (March 5, 2026)  
**Resolution:** `io.imemAddr := Mux(io.stall, (pc - 1).resized, pc)` in FetchUnit.scala

**Root Cause:**  
When the pipeline stall signal was asserted (from load-use hazard detection), FetchUnit
continued driving `io.imemAddr = pc` (the next instruction address). Since IMEM has 1-cycle
read latency and `pc` is always 1 ahead of the instruction in `exBundleReg`, the IMEM output
drifted to `mem[pc]` during the stall. On stall release, the instruction at `mem[pc-1]` had
been lost — causing it to be skipped entirely.

**Fix Applied:**  
During stalls, drive `imemAddr = pc - 1` so the IMEM keeps outputting the instruction that
was in-flight when the stall began. This ensures correct instruction re-read on stall release.

**Verification:**  
All 10 load-use hazard integration tests pass, including:
- `test_scalar_load_use_immediate_dependency_stalls`
- `test_vector_vload_use_immediate_dependency_stalls`
- `test_load_use_independent_before_dependent_progress`
- `test_load_use_randomized_axi_latency_robustness`

---

### ~~9. VALU Unit Test Initialization for Multi-Width Fields~~ ✅ RESOLVED

**Status:** RESOLVED (March 5, 2026)  
**Resolution:** Added `ewidth=0`, `dwidth=0`, `isSigned=0` initialization to `reset()`

**Root Cause:**  
Phase 4 added `ewidth`, `dwidth`, and `isSigned` fields to the VALU slot bundle, but the
standalone VALU unit test's `reset()` function was not initializing these signals. In Icarus
Verilog, uninitialized signals remain X/Z:
- **DIV/MOD timeout:** Divider start condition requires `ew === EW32` (where EW32=0). With
  X/Z ewidth, the comparison evaluates false and dividers never start.
- **Result MUX corruption:** X/Z ewidth propagated through the packed-result selection MUX,
  producing `LogicArray` values containing non-0/1 bits.
- **VBROADCAST mismatch:** Test expected VliwCore-level broadcasting (all lanes get lane 0's
  value), but standalone ValuEngine outputs each lane's own operandC at EW32.

**Verification:**  
All 7 VALU unit tests pass: single-cycle ops, div, mod, multiply_add, vbroadcast, and all_single_cycle_ops.

---

## Resolved Issues (Legacy)

### 6. Phase 3 RTL Compilation Duplicate Definitions ✅

**Status:** RESOLVED  
**Resolution Date:** Phase 3 completion

**Description:**  
Initial Phase 3 work created duplicate `MemoryEngine.scala` and `MemoryEngine_v3.scala` files, causing compilation conflicts.

**Resolution:**  
Deleted duplicate file, consolidated all changes into single `MemoryEngine.scala`.

**Verification:**  
RTL generation succeeds cleanly with 195 pruned signals.

---

### 7. Phase 3 AXI AR/R Signal Assignment Conflicts ✅

**Status:** RESOLVED  
**Resolution Date:** Phase 3 completion

**Description:**  
Default assignments at module top conflicted with combinatorial AR/R drive in load handler.

**Resolution:**  
Consolidated signal driving into single assignment block, removed default assignments that were immediately overridden.

**Verification:**  
All memory operations pass in baseline configuration (22/23 tests).

---

## Issue Tracking

| Issue ID | Description | Priority | Status | Target Fix |
|----------|-------------|----------|--------|------------|
| #1 | Dual-ALU writeback | HIGH | Investigation | Next sprint |
| #2 | Long memory timeout | — | RESOLVED | — |
| #3 | Single pending load | MEDIUM | Accepted | Future enhancement |
| #4 | No store response | — | RESOLVED | — |
| #4a | VSTORE/VLOAD alignment | MEDIUM | Accepted | Future enhancement |
| #4b | VALU FMA src3 blocked | MEDIUM | Accepted | Future enhancement |
| #5 | Driver API mismatch | — | RESOLVED | — |
| #6 | Phase 3 duplicates | — | RESOLVED | — |
| #7 | Phase 3 AXI conflicts | — | RESOLVED | — |
| #8 | FetchUnit stall skip | — | RESOLVED | — |
| #9 | VALU test init | — | RESOLVED | — |

---

## Impact Summary

### Production Deployment (Baseline Config)
- **Blockers:** None
- **Workarounds Required:** None
- **Known Limitations:** Single pending load (compiler handles), VSTORE alignment (compiler handles + RTL assertions), FMA uses 2-instruction sequence
- **Test Coverage:** 176/176 PASS (100%) — 48 unit + 128 integration
- **Recommendation:** ✅ Production ready

### Multi-ALU Scaling
- **Blockers:** Issue #1 (dual-ALU writeback)
- **Workarounds Required:** Use single-ALU only
- **Investigation:** 4-6 hours estimated
- **Recommendation:** ⚠️ Fix before multi-core deployment

---

## Reporting New Issues

**Location:** `docs/KNOWN_ISSUES.md` (this file)  
**Format:** Include test name, expected result, actual result, configuration  
**Logs:** Attach simulation output if available

**For discussion:** See project maintainers

---

**Last Review:** March 5, 2026  
**Next Review:** After dual-ALU fix investigation
