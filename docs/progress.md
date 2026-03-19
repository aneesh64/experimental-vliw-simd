# WAIT_FOR_LOAD Address-Specific Redesign — Historical Design Notes

> **Status: COMPLETED and SUPERSEDED**  
> This document records the intermediate design for address-specific WAIT_FOR_LOAD
> tracking. The mechanism described here was implemented and is still present in the
> RTL (`loadTrackDepth=4` FIFO in `MemoryEngine.scala`). In practice, **hardware
> load-use hazard detection** in `VliwCore.scala` handles all load-dependent stalls
> automatically — the scheduler no longer emits `wait_for_load` instructions for
> normal kernels. See `docs/ARCHITECTURE.md` for the current design.

---

Redesigned WAIT_FOR_LOAD from a blanket stall (stalls until ANY pending load completes)
to an **address-specific** mechanism using a **register-based FIFO completion queue**.

## Design

### Problem
The original blanket WAIT_FOR_LOAD released the stall as soon as `loadReqValid` cleared
(when AXI R arrived), but the load data still needed 1+ cycles to propagate through the
WB pipeline register (`regWriteReq` → `RegNext`) into `BankedScratchMemory`. This caused
consumers to read stale/zero values.

### Solution: Address-Specific WAIT_FOR_LOAD with Completion Queue

**RTL (MemoryEngine.scala):**
- Added a 4-entry register-based FIFO (`loadTrackValid`, `loadTrackDestAddr`,
  `loadTrackCountdown`, `loadTrackHead/Tail`) that tracks loads between AXI R
  completion and scratch capture.
- When AXI R arrives: push entry with `destAddr` and `countdown=3` into the queue.
- Each cycle: decrement countdown for all valid entries.
- Pop head entry when its countdown reaches 0 (data guaranteed in scratch).
- WAIT_FOR_LOAD(addr) stalls if `addr` matches:
  1. `loadReqEntry.destAddr` while `loadReqValid` (AXI still in-flight), OR
  2. Any queue entry with `countdown ≠ 0` (post-completion countdown)
- Loads are in-order (single AXI ID), so the FIFO head always completes first.

**Scheduler (scheduler.py):**
- `wait_for_load(dest_addr)` now takes a required `dest_addr` parameter.
- Auto-insertion inserts one WAIT_FOR_LOAD per unique pending load base address
  (not one blanket barrier for all pending loads).
- Uses `pending_load_map: Dict[int, int]` (reg → load_base) instead of `pending_load_regs: set`.
- For vloads, all lane registers map to the same base → one WAIT_FOR_LOAD suffices.

**Assembler (assembler.py):**
- `wait_for_load` encoding now passes the dest address as the `dest` field of the
  LoadSlot (was previously hardcoded to 0).

## Files Changed

| File | Change |
|------|--------|
| `src/main/scala/vliw/engine/MemoryEngine.scala` | Queue + address-specific stall logic |
| `tools/scheduler.py` | Per-address barriers, `pending_load_map` |
| `tools/assembler.py` | Encode dest addr in wait_for_load |
| `verification/cocotb/integration/test_integration_memory.py` | Updated tuples |
| `verification/cocotb/integration/test_dsl_matrix_integration.py` | Updated tuples |
| `verification/cocotb/test_smoke.py` | Updated tuples |
| `verification/cocotb/tests/test_core_matrix.py` | Updated tuples |

## Test Results (as of design completion)

**Current status:** All tests pass. The WAIT_FOR_LOAD mechanism is implemented
and working. Hardware load-use hazard detection in `VliwCore` handles the common
case; the completion queue in `MemoryEngine` supports the encodable `wait_for_load`
ISA opcode (opcode 5) for explicit software barriers.

- Baseline unit suite: **passing**
- Integration suite: **passing (176/176)**
- Matrix-enabled suite: **passing (62/62)**

## Architecture Notes

- Queue depth 4 is sufficient: loads are serialized (one AXI transaction at a time),
  so at most 1 entry in AXI-wait + a few in post-completion countdown.
- Countdown = 3 provides ample margin after AXI R for the WB pipeline register to
  capture data in scratch memory (actual capture happens at T_axi+1 via `RegNext`).
- The queue uses `Seq.fill` of individual registers with `switch` for hardware-indexed push,
  and compile-time `for` loops for countdown tick and address matching.
