# 30 FPS Feasibility Plan (1080p @ 100 MHz)

## Baseline from measured run
- Kernel: full-image threshold (SWP)
- Measured cycles for 64x64: 123,914
- Cycles per pixel (cpp): 123,914 / 4,096 = 30.2524

## Performance target
- Goal: 30 FPS at 1920x1080, 100 MHz
- Required cpp:
  - cpp_target = 100e6 / (30 * 1920 * 1080) = 1.6075
- Required speedup vs current:
  - 30.2524 / 1.6075 = 18.82x

## Why current architecture is far from target
1. Memory-side serialization dominates
   - vload/vstore behavior is functionally vector but throughput is effectively serialized by memory engine/FSM behavior.
2. Pixel format inefficiency
   - Current pipeline treats one pixel per 32-bit word, wasting bus width and scratch bandwidth.
3. Control overhead
   - Flow loop control, scalar address generation, and conservative scheduling consume many cycles/pixel.
4. Packing hazards
   - Scheduler avoids aggressive slot packing because of potential RAW/WAW and memory hazards.

## Can we process 8 pixels per cycle?
Yes, for threshold-class kernels, if all of the following are true:
1. Data representation is packed uint8 lanes (8+ pixels per vector op).
2. Memory path can sustain at least one vector read + one vector write per cycle or equivalent burst amortization.
3. Scratch/VRF banking avoids same-cycle conflicts for lane reads/writes.
4. Scheduler + scoreboard permit issuing VALU + MEM without unsafe hazards.

If any one of these is missing, effective throughput collapses below 8 px/clk.

## Phased architecture plan (resource-aware)

### Phase 1: Vector memory throughput first (highest ROI)
Changes:
- Convert vload/vstore to true vector transactions (lane-packed beat handling, not lane-serialized progression).
- Add burst-capable memory micro-FSM with prefetch/write-combine for contiguous vectors.
- Introduce packed 8-bit lane mode in scratch/VALU path for image kernels.

Expected gain:
- 3.0x to 5.0x on memory-bound image kernels.

Resource impact (rough):
- LUT: +15% to +30%
- BRAM: +10% to +25%
- DSP: minimal for threshold, low for linear filters

Risk:
- AXI protocol corner cases, alignment/stride bugs.

---

### Phase 2: Address/control compression and hazard-safe packing
Changes:
- Add hardware loop support (repeat count + loop end target) to reduce flow-slot overhead.
- Add post-increment addressing modes (base + auto-inc) for load/store slots.
- Add lightweight scoreboard/forwarding rules in scheduler model to safely pack more ALU/VALU/MEM operations.

Expected gain:
- Additional 1.4x to 2.0x.

Resource impact (rough):
- LUT: +8% to +15%
- BRAM: +0% to +5%
- DSP: none

Risk:
- Scheduler/RTL contract drift if hazard rules are not explicit.

---

### Phase 3: Double-buffered tile streaming
Changes:
- Tile-based DMA into scratch (ping/pong buffers), overlap compute and memory transfers.
- Explicit software-visible prefetch/commit semantics to hide DDR latency.

Expected gain:
- Additional 1.5x to 2.5x depending on memory latency.

Resource impact (rough):
- LUT: +10% to +20%
- BRAM: +20% to +40% (buffering)
- DSP: none

Risk:
- BRAM pressure can limit max image/tile dimensions.

---

### Phase 4: Multi-core scaling (if needed)
Changes:
- Replicate cores and partition frame by rows/tiles.
- Shared/interleaved AXI arbitration with bandwidth QoS.

Expected gain:
- Near-linear until memory bandwidth saturates.
- 2 cores: ~1.7x to 2.0x typical.
- 4 cores: ~2.8x to 3.6x typical unless memory widened.

Resource impact (rough):
- LUT/FF/DSP: near linear with core count.
- BRAM: near linear unless shared scratch is redesigned.

Risk:
- Memory bottleneck dominates if AXI width/frequency is unchanged.

## Feasibility matrix (using current cpp=30.2524)

Assume representative speedups:
- Phase 1: 4.0x
- Phase 2: 1.6x (cumulative 6.4x)
- Phase 3: 1.8x (cumulative 11.52x)
- 2 cores: x2 (cumulative 23.04x)

Projected cpp and FPS:
- After Phase 1 only: cpp=7.56 -> ~6.4 FPS
- After Phase 1+2: cpp=4.73 -> ~10.2 FPS
- After Phase 1+2+3: cpp=2.63 -> ~18.4 FPS
- After Phase 1+2+3 + 2 cores: cpp=1.31 -> ~36.9 FPS

Conclusion:
- 30 FPS is unlikely from "just 2 cores" on current architecture.
- 30 FPS becomes realistic with architectural memory/packing changes plus 2-core replication.

## Hazard-safe VLIW packing policy updates
1. Separate issue classes:
- MEM issue: at most one vector read + one vector write transaction class per cycle unless dual memory pipelines exist.
- VALU issue: allow dual-slot only for independent destinations unless forwarding guarantees are modeled.

2. Explicit dependency latencies:
- src3/multicycle ops keep conservative latency annotation (already started).
- vload-to-VALU and VALU-to-vstore latencies must be first-class in scheduler metadata.

3. Bank/conflict awareness:
- Add scratch bank mapping into scheduler cost model, not only post-gap heuristics.

4. Kernel templates:
- Prefer fixed pattern templates for image loops to avoid pathological scheduler choices.

## Recommended implementation order
1. Phase 1 memory throughput + packed pixel mode.
2. Phase 2 loop/address opcodes + scheduler hazard model sync.
3. Re-measure full-image threshold and one 3x3 kernel.
4. Phase 3 tiling overlap.
5. Add core replication only after single-core memory efficiency is high.

## Immediate next experiment (low risk)
- Keep architecture unchanged for now and add a packed-data simulation model in scheduler/assembler tests to estimate benefit ceiling.
- Then prototype only vload/vstore packed mode in RTL and re-run full-image artifacts for direct cpp delta.
