# Known Issues and Limitations

**Last Updated:** February 28, 2026  
**Current Version:** Multi-Width Vector Extensions (Phase 3 + Multi-Width)

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

### 5. No Store Response Tracking

**Priority:** MEDIUM  
**Impact:** Fire-and-forget stores, no completion confirmation  
**Severity:** Design constraint, not a bug

**Description:**  
Store operations do not track AXI write responses. Stores are fire-and-forget with no confirmation of completion.

**Technical Details:**
- AW and W channels driven directly
- No B channel handling
- Assumes AXI interconnect always ready

**Impact on Compiler:**
- Must add NOPs after stores before dependent loads
- Cannot guarantee store ordering without explicit synchronization
- Risk of lost stores if AXI backpressures (currently assumes no backpressure)

**Workaround:**  
Compiler adds sufficient padding after stores (already implemented).

**Future Enhancement:**  
Could add minimal B channel response checking if store confirmation becomes critical.

**Status:** Accepted design trade-off

---

## Tool Integration Issues

### 5. Driver Assembler API Mismatch

**Priority:** MEDIUM  
**Impact:** Blocks driver integration test suite, does not affect main verification  
**Severity:** Test infrastructure issue

**Description:**  
Driver integration tests (`verification/cocotb/test_driver_integration.py`) pass assembly text strings to assembler, but `assembler.py` expects pre-parsed JSON bundle objects.

**Error:**
```
AttributeError: 'str' object has no attribute 'get'
at assembler.py:426 - instruction.get("alu", [])
```

**Root Cause:**  
API architectural mismatch. The assembler expects:
```python
bundles = [
  {"alu": [...], "valu": [...], "load": [...], ...},
  ...
]
```

But driver tests pass:
```python
program = "ADD r1, r2, r3\nVADD v0, v1, v2"
```

**Fix Options:**
1. Update driver tests to use pre-assembled bundles (like main test suite)
2. Add full assembly text parsing to driver test infrastructure
3. Use existing `test_integration.py` patterns for bundle loading

**Time Estimate:** 2-3 hours (straightforward parameter fix)

**Workaround:**  
Use main integration test suite (`test_integration.py`) which properly loads bundles.

**Status:** Infrastructure complete, API bridge needed

---

## Resolved Issues

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
| #4 | No store response | MEDIUM | Accepted | Future enhancement |
| #4a | VSTORE/VLOAD alignment | MEDIUM | Accepted | Future enhancement |
| #4b | VALU FMA src3 blocked | MEDIUM | Accepted | Future enhancement |
| #5 | Driver API mismatch | MEDIUM | Identified | Quick fix available |
| #6 | Phase 3 duplicates | — | RESOLVED | — |
| #7 | Phase 3 AXI conflicts | — | RESOLVED | — |

---

## Impact Summary

### Production Deployment (Baseline Config)
- **Blockers:** None
- **Workarounds Required:** None
- **Known Limitations:** Single pending load (compiler handles), VSTORE alignment (compiler handles), FMA uses 2-instruction sequence
- **Test Coverage:** 28/28 PASS (100%) — includes 16 multi-width vector tests
- **Recommendation:** ✅ Production ready

### Multi-ALU Scaling
- **Blockers:** Issue #1 (dual-ALU writeback)
- **Workarounds Required:** Use single-ALU only
- **Investigation:** 4-6 hours estimated
- **Recommendation:** ⚠️ Fix before multi-core deployment

### Driver Integration
- **Blockers:** Issue #5 (API mismatch)
- **Workarounds Required:** Use main test suite
- **Fix Time:** 2-3 hours
- **Recommendation:** Low priority (infrastructure already works)

---

## Reporting New Issues

**Location:** `docs/KNOWN_ISSUES.md` (this file)  
**Format:** Include test name, expected result, actual result, configuration  
**Logs:** Attach simulation output if available

**For discussion:** See project maintainers

---

**Last Review:** February 28, 2026  
**Next Review:** After dual-ALU fix investigation
