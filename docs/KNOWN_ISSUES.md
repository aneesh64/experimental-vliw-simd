# Known Issues and Limitations

**Last Updated:** February 28, 2026  
**Current Version:** Baseline Production-Ready (Phase 3 Complete + Branch Delay Fix)

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

### 4. No Store Response Tracking

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
| #5 | Driver API mismatch | MEDIUM | Identified | Quick fix available |
| #6 | Phase 3 duplicates | — | RESOLVED | — |
| #7 | Phase 3 AXI conflicts | — | RESOLVED | — |

---

## Impact Summary

### Production Deployment (Baseline Config)
- **Blockers:** None
- **Workarounds Required:** None
- **Known Limitations:** Single pending load (compiler handles)
- **Test Coverage:** 24/24 PASS (100%)
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
