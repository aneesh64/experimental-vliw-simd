# Full Image Kernel Plan (No Architecture Changes)

## Goal
Add one end-to-end image-processing kernel test that:
- Processes a full image buffer in AXI memory
- Uses the existing VLIW ISA/RTL only (no hardware changes)
- Checks full-output golden correctness
- Reports cycle counts and derived throughput metrics

## Proposed Kernel (Phase 1)
- Kernel: 3x3 box blur (uint8-like data in 32-bit words)
- Reason: deterministic, common CV primitive, clear golden reference
- I/O:
  - Input image: `H x W` words at AXI base `IN_BASE`
  - Output image: `H x W` words at AXI base `OUT_BASE`
  - Border policy: copy input border unchanged (simple + deterministic)

## Test Shape
- New file section in `test_algorithms.py` (or `test_image_kernels.py` if separation is preferred)
- New cocotb test:
  - `test_cv_box_blur_full_image_golden`
- Image size for first pass:
  - `64 x 64` (4096 pixels/words)
- Golden model:
  - Pure Python reference with exact integer math and border handling

## Kernel Implementation Strategy
1. Row-major traversal using nested loops flattened to one loop where possible.
2. Use scratch registers for:
  - Current index
  - Row stride (`W`)
   - Pointers for previous/current/next rows
3. Use vector chunks (`VLEN=8`) when feasible for row segments.
4. Use `vload -> valu -> vstore` for interior body where operations map cleanly.
5. Keep border rows/columns scalar for correctness and simpler control flow.

## Software-Pipelining Strategy
- Start with correctness-first scalar/vector hybrid baseline.
- Add software-pipelined variant:
  - Precompute next row/column addresses while current chunk computes
  - Reduce loop-control overhead via unrolling by 2 chunks where stable
- Keep both baseline and SWP variants under same golden vectors.

## Metrics to Capture
- Total cycles from harness (`run()`)
- Cycles per pixel: `cycles / (H*W)`
- Optional speedup metric in log:
  - `baseline_cycles / swp_cycles`

## Validation Criteria
- Exact output match vs Python golden for all pixels
- No unknown/X activity in AXI model
- Deterministic cycle counts across reruns (within expected simulator stability)

## Execution Plan
1. Add deterministic image generator + golden function.
2. Implement baseline full-image kernel test and validate correctness.
3. Record baseline cycles at config `a2-v2-l1-s1-f1`.
4. Implement SW-pipelined variant with same vectors/golden.
5. Record and report cycle delta + per-pixel metrics.
6. Integrate into normal regression module list.

## Risks / Mitigations
- Risk: scheduler packing causes hazards for aggressive unrolls
  - Mitigation: keep dependent VALU chains explicit; avoid unsafe same-cycle dependencies
- Risk: border handling complexity introduces off-by-one errors
  - Mitigation: enforce simple border-copy rule and test targeted edge coordinates first
- Risk: large test runtime
  - Mitigation: start with `64x64`, optionally add a smaller smoke size test
