"""
Algorithmic kernel integration tests (DSP / ML / CV) with Python golden references.
"""

import json
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))
if str(PROJECT_ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "tools"))
if str(Path(__file__).parent) not in sys.path:
    sys.path.insert(0, str(Path(__file__).parent))

import cocotb
from assembler import Assembler, AssemblerConfig
from scheduler import VliwScheduler, SchedulerConfig
from harness import VliwCoreHarness
from verification.cocotb.config import load_test_config

CFG = load_test_config(project_root=PROJECT_ROOT)

ASM = Assembler(AssemblerConfig(
    n_alu_slots=CFG.n_alu_slots,
    n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots,
    n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots,
    vlen=CFG.vlen,
    scratch_size=CFG.scratch_size,
    imem_depth=CFG.imem_depth,
))

S = VliwScheduler(SchedulerConfig(
    n_alu_slots=CFG.n_alu_slots,
    n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots,
    n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots,
    mem_post_gap=CFG.mem_post_gap,
))


def build_program(ops, verbose=False):
    bundles_dicts = S.schedule(ops, verbose=verbose)
    return ASM.assemble_program(bundles_dicts)


def _u32(x: int) -> int:
    return x & 0xFFFFFFFF


def _golden_moving_avg2(samples: list[int]) -> list[int]:
    out = [0] * len(samples)
    for i in range(1, len(samples)):
        out[i] = (samples[i] + samples[i - 1]) >> 1
    return out


def _golden_dense1(x: list[int], w: list[int], bias: int) -> int:
    acc = 0
    for xv, wv in zip(x, w):
        acc = _u32(acc + _u32(xv * wv))
    return _u32(acc + bias)


def _golden_threshold(pixels: list[int], threshold: int) -> list[int]:
    return [1 if p < threshold else 0 for p in pixels]


def _golden_invert_u8(pixels: list[int]) -> list[int]:
    return [255 - (p & 0xFF) for p in pixels]


def _write_pgm(path: Path, width: int, height: int, pixels: list[int]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fp:
        fp.write("P2\n")
        fp.write(f"{width} {height}\n")
        fp.write("255\n")
        for row in range(height):
            base = row * width
            line = " ".join(str(pixels[base + col] & 0xFF) for col in range(width))
            fp.write(line + "\n")


def _write_u32_csv(path: Path, width: int, height: int, words: list[int]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fp:
        fp.write(f"# width={width},height={height}\n")
        for row in range(height):
            base = row * width
            line = ",".join(str(words[base + col] & 0xFFFFFFFF) for col in range(width))
            fp.write(line + "\n")


@cocotb.test()
async def test_dsp_moving_average4_golden(dut):
    """DSP kernel: 2-tap moving average over 64 samples."""
    harness = VliwCoreHarness(dut)

    samples = [((i * 11 + 3) & 0xFF) for i in range(64)]
    golden = _golden_moving_avg2(samples)

    harness.axi_mem.preload(0, samples)
    await harness.init()

    program = build_program([
        S.const(0, 1),
        S.const(1, 64),
        S.const(2, 1),
        S.const(4, 400),

        S.label("ma4_scalar_loop"),
        S.const(10, 0), S.add(10, 10, 0), S.load(20, 10),
        S.const(11, 0), S.add(11, 11, 0), S.sub(11, 11, 2), S.load(21, 11),
        S.add(22, 20, 21),
        S.shr(22, 22, 2),
        S.const(12, 0), S.add(12, 12, 4), S.add(12, 12, 0),
        S.store(12, 22),
        S.add(0, 0, 2),
        S.lt(13, 0, 1),
        S.cond_jump(13, "ma4_scalar_loop"),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    for i in range(1, len(samples)):
        got = harness.axi_mem.read_word(400 + i)
        exp = golden[i]
        assert got == exp, f"dsp idx={i}: expected {exp}, got {got}"

    dut._log.info(f"test_dsp_moving_average4_golden: cycles={cycles}, n={len(samples)}")


@cocotb.test()
async def test_dsp_moving_average4_sw_pipeline_golden(dut):
    """DSP kernel (software-pipelined): 2-tap moving average over 64 samples."""
    harness = VliwCoreHarness(dut)

    samples = [((i * 11 + 3) & 0xFF) for i in range(64)]
    golden = _golden_moving_avg2(samples)

    harness.axi_mem.preload(0, samples)
    await harness.init()

    program = build_program([
        S.const(0, 1),
        S.const(1, 64),
        S.const(2, 1),
        S.const(4, 400),

        S.label("ma4_scalar_swp_loop"),
        S.const(10, 0), S.add(10, 10, 0), S.load(20, 10),
        S.const(11, 0), S.add(11, 11, 0), S.sub(11, 11, 2), S.load(21, 11),
        S.add(22, 20, 21),
        S.shr(22, 22, 2),
        S.const(12, 0), S.add(12, 12, 4), S.add(12, 12, 0),
        S.store(12, 22),
        S.add(0, 0, 2),
        S.lt(13, 0, 1),
        S.cond_jump(13, "ma4_scalar_swp_loop"),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    for i in range(1, len(samples)):
        got = harness.axi_mem.read_word(400 + i)
        exp = golden[i]
        assert got == exp, f"dsp swp idx={i}: expected {exp}, got {got}"

    dut._log.info(f"test_dsp_moving_average4_sw_pipeline_golden: cycles={cycles}, n={len(samples)}")


@cocotb.test()
async def test_ml_dense1_inference_golden(dut):
    """ML kernel: single dense neuron inference y=sum(x*w)+b."""
    harness = VliwCoreHarness(dut)

    x = [((i * 5 + 1) & 0x3F) for i in range(32)]
    w = [((i * 7 + 2) & 0x1F) for i in range(32)]
    bias = 123
    golden = _golden_dense1(x, w, bias)

    harness.axi_mem.preload(0, x)
    harness.axi_mem.preload(128, w)
    await harness.init()

    program = build_program([
        # Running address pointers (eliminates per-iteration const+add chains)
        S.const(10, 0),          # x_addr = 0 (running)
        S.const(11, 128),        # w_addr = 128 (running)
        S.const(0, 0),           # counter = 0
        S.const(1, 32),          # limit = 32
        S.const(2, 8),           # step = 8

        # Zero accumulator vector
        S.const(360, 0), S.const(361, 0), S.const(362, 0), S.const(363, 0),
        S.const(364, 0), S.const(365, 0), S.const(366, 0), S.const(367, 0),

        S.label("dense_vec_loop"),
        S.vload(320, 10),        # load 8 x values from x_addr
        S.vload(328, 11),        # load 8 w values from w_addr
        S.valu_op("mul", 368, 320, 328),  # temp = x * w
        S.valu_op("add", 360, 360, 368),  # acc += temp
        S.add_imm(10, 10, 8),   # x_addr += 8
        S.add_imm(11, 11, 8),   # w_addr += 8
        S.add(0, 0, 2),         # counter += 8
        S.lt(12, 0, 1),         # counter < 32?
        S.cond_jump(12, "dense_vec_loop"),

        # Tree reduction: sum all 8 lanes using distinct dest registers
        # to avoid tight read-after-write hazard on the same register.
        S.add(40, 360, 361),     # pair01 = lane0 + lane1
        S.add(41, 362, 363),     # pair23 = lane2 + lane3
        S.add(42, 364, 365),     # pair45 = lane4 + lane5
        S.add(43, 366, 367),     # pair67 = lane6 + lane7
        S.add(44, 40, 41),       # quad0123
        S.add(45, 42, 43),       # quad4567
        S.add(22, 44, 45),       # total

        S.const(24, bias),
        S.add(22, 22, 24),
        S.const(25, 700),
        S.store(25, 22),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    got = harness.axi_mem.read_word(700)
    assert got == golden, f"ml dense1 expected {golden}, got {got}"

    dut._log.info(f"test_ml_dense1_inference_golden: cycles={cycles}, out={got}")


@cocotb.test()
async def test_ml_dense1_inference_sw_pipeline_golden(dut):
    """ML kernel (software-pipelined): single dense neuron inference y=sum(x*w)+b."""
    harness = VliwCoreHarness(dut)

    x = [((i * 5 + 1) & 0x3F) for i in range(32)]
    w = [((i * 7 + 2) & 0x1F) for i in range(32)]
    bias = 123
    golden = _golden_dense1(x, w, bias)

    harness.axi_mem.preload(0, x)
    harness.axi_mem.preload(128, w)
    await harness.init()

    program = build_program([
        # Running address pointers
        S.const(10, 0),          # x_addr = 0 (running)
        S.const(11, 128),        # w_addr = 128 (running)
        S.const(0, 0),           # counter = 0
        S.const(1, 32),          # limit = 32
        S.const(2, 8),           # step = 8

        # Zero accumulator vector
        S.const(360, 0), S.const(361, 0), S.const(362, 0), S.const(363, 0),
        S.const(364, 0), S.const(365, 0), S.const(366, 0), S.const(367, 0),

        S.label("dense_vec_swp_loop"),
        S.vload(320, 10),        # load 8 x values
        S.vload(328, 11),        # load 8 w values
        S.valu_op("mul", 368, 320, 328),
        S.valu_op("add", 360, 360, 368),
        S.add_imm(10, 10, 8),   # x_addr += 8
        S.add_imm(11, 11, 8),   # w_addr += 8
        S.add(0, 0, 2),         # counter += 8
        S.lt(12, 0, 1),
        S.cond_jump(12, "dense_vec_swp_loop"),

        # Tree reduction: sum all 8 lanes using distinct dest registers
        # to avoid tight read-after-write hazard on the same register.
        S.add(40, 360, 361),     # pair01
        S.add(41, 362, 363),     # pair23
        S.add(42, 364, 365),     # pair45
        S.add(43, 366, 367),     # pair67
        S.add(44, 40, 41),       # quad0123
        S.add(45, 42, 43),       # quad4567
        S.add(22, 44, 45),       # total

        S.const(24, bias),
        S.add(22, 22, 24),
        S.const(25, 701),
        S.store(25, 22),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    got = harness.axi_mem.read_word(701)
    assert got == golden, f"ml dense1 swp expected {golden}, got {got}"

    dut._log.info(f"test_ml_dense1_inference_sw_pipeline_golden: cycles={cycles}, out={got}")


@cocotb.test()
async def test_cv_threshold_segmentation_golden(dut):
    """CV kernel: pixel threshold segmentation outputting 0/1 mask.

    Optimised loop: running address registers eliminate per-iteration
    const+add chains; dual-ALU-slot packing increments both addresses in
    one bundle.
    """
    harness = VliwCoreHarness(dut)

    pixels = [((i * 13 + 17) & 0xFF) for i in range(64)]
    threshold = 128
    golden = _golden_threshold(pixels, threshold)

    harness.axi_mem.preload(0, pixels)
    await harness.init()

    out_base = 900

    program = build_program([
        # ---- Setup (executed once) ----
        S.const(0,  0),          # counter = 0
        S.const(1,  64),         # limit = 64
        S.const(9,  1),          # constant 1 (for increments)
        S.const(3,  threshold),  # threshold
        S.const(10, 0),          # in_addr  = 0  (running input address)
        S.const(13, out_base),   # out_addr = 900 (running output address)

        # ---- Loop body ----
        S.label("th_loop"),
        S.load(11, 10),          # pixel = mem[in_addr]
        S.lt(12, 11, 3),         # mask = pixel < threshold
        S.store(13, 12),         # mem[out_addr] = mask
        # Dual-ALU: increment both address registers in one bundle
        S.add(10, 10, 9),        # in_addr++ (ALU slot 0)
        S.add(13, 13, 9),        # out_addr++ (ALU slot 1, packed with above)
        # Loop control
        S.add(0, 0, 9),          # counter++
        S.lt(14, 0, 1),          # counter < limit?
        S.cond_jump(14, "th_loop"),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    for i, exp in enumerate(golden):
        got = harness.axi_mem.read_word(900 + i)
        assert got == exp, f"cv idx={i}: expected {exp}, got {got}"

    dut._log.info(f"test_cv_threshold_segmentation_golden: cycles={cycles}, n={len(pixels)}")


@cocotb.test()
async def test_cv_threshold_segmentation_sw_pipeline_golden(dut):
    """CV kernel (software-pipelined): threshold segmentation, 4 pixels/iteration.

    Optimised: running address registers eliminate const+add per-pixel chains.
    Dual-ALU-slot packing computes all four input addresses together.
    """
    harness = VliwCoreHarness(dut)

    pixels = [((i * 13 + 17) & 0xFF) for i in range(64)]
    threshold = 128
    golden = _golden_threshold(pixels, threshold)

    harness.axi_mem.preload(0, pixels)
    await harness.init()

    out_base = 900

    program = build_program([
        # ---- Setup ----
        S.const(0,  0),          # counter = 0
        S.const(1,  64),         # limit = 64
        S.const(9,  1),          # constant 1
        S.const(49, 4),          # step = 4
        S.const(3,  threshold),  # threshold
        # Running addresses: one base for each of 4 pixels per iteration
        S.const(10, 0),            # in0
        S.const(16, 1),            # in1 = in0+1
        S.const(21, 2),            # in2 = in0+2
        S.const(26, 3),            # in3 = in0+3
        S.const(13, out_base + 0), # out0 = 900
        S.const(19, out_base + 1), # out1 = 901
        S.const(24, out_base + 2), # out2 = 902
        S.const(29, out_base + 3), # out3 = 903

        # ---- Unrolled loop body: 4 pixels per iteration ----
        S.label("th_swp_loop"),
        # pixel 0
        S.load(11, 10),
        S.lt(12, 11, 3),
        S.store(13, 12),
        # pixel 1
        S.load(17, 16),
        S.lt(18, 17, 3),
        S.store(19, 18),
        # pixel 2
        S.load(22, 21),
        S.lt(23, 22, 3),
        S.store(24, 23),
        # pixel 3
        S.load(27, 26),
        S.lt(28, 27, 3),
        S.store(29, 28),

        # Advance all 4 address pairs by 4 (dual-ALU per bundle)
        S.add(10, 10, 49),  S.add(13, 13, 49),   # in0 += 4, out0 += 4
        S.add(16, 16, 49),  S.add(19, 19, 49),   # in1 += 4, out1 += 4
        S.add(21, 21, 49),  S.add(24, 24, 49),   # in2 += 4, out2 += 4
        S.add(26, 26, 49),  S.add(29, 29, 49),   # in3 += 4, out3 += 4

        # Loop control
        S.add(0, 0, 49),         # counter += 4
        S.lt(14, 0, 1),          # counter < limit?
        S.cond_jump(14, "th_swp_loop"),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    for i, exp in enumerate(golden):
        got = harness.axi_mem.read_word(900 + i)
        assert got == exp, f"cv swp idx={i}: expected {exp}, got {got}"

    dut._log.info(f"test_cv_threshold_segmentation_sw_pipeline_golden: cycles={cycles}, n={len(pixels)}")


@cocotb.test()
async def test_full_image_threshold_kernel_with_artifacts(dut):
    """Full-image kernel: threshold 64x64 image; emit input/golden/vliw image files and verify exact output."""
    harness = VliwCoreHarness(dut)

    width = 64
    height = 64
    total = width * height
    in_base = 0
    out_base = 5000
    threshold = 128

    input_pixels = [((row * 37 + col * 13 + 17) & 0xFF) for row in range(height) for col in range(width)]
    golden_pixels = _golden_threshold(input_pixels, threshold)

    harness.axi_mem.preload(in_base, input_pixels)
    await harness.init()

    program = build_program([
        # ---- Setup (executed once) ----
        S.const(0,  0),          # counter = 0
        S.const(1,  total),      # limit
        S.const(9,  1),          # constant 1
        S.const(3,  threshold),  # threshold
        S.const(10, in_base),    # in_addr  (running)
        S.const(13, out_base),   # out_addr (running)

        # ---- Loop body ----
        S.label("img_th_loop"),
        S.load(11, 10),          # pixel = mem[in_addr]
        S.lt(12, 11, 3),         # mask = pixel < threshold
        S.store(13, 12),         # mem[out_addr] = mask
        # Dual-ALU: increment both addresses in one bundle
        S.add(10, 10, 9),        # in_addr++
        S.add(13, 13, 9),        # out_addr++
        # Loop control
        S.add(0, 0, 9),          # counter++
        S.lt(14, 0, 1),          # counter < limit?
        S.cond_jump(14, "img_th_loop"),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=200000)

    vliw_pixels = [harness.axi_mem.read_word(out_base + i) & 0xFF for i in range(total)]
    for i, exp in enumerate(golden_pixels):
        got = vliw_pixels[i]
        assert got == exp, f"full-image threshold idx={i}: expected {exp}, got {got}"

    artifact_dir = PROJECT_ROOT / "verification" / "results" / "full_image_kernel"
    input_pgm = artifact_dir / "input_image_64x64.pgm"
    golden_pgm = artifact_dir / "output_golden_64x64.pgm"
    vliw_pgm = artifact_dir / "output_vliw_64x64.pgm"
    input_csv = artifact_dir / "input_image_64x64_u32.csv"
    golden_csv = artifact_dir / "output_golden_64x64_u32.csv"
    vliw_csv = artifact_dir / "output_vliw_64x64_u32.csv"
    metrics_json = artifact_dir / "run_metrics.json"

    _write_pgm(input_pgm, width, height, input_pixels)
    _write_pgm(golden_pgm, width, height, golden_pixels)
    _write_pgm(vliw_pgm, width, height, vliw_pixels)
    _write_u32_csv(input_csv, width, height, input_pixels)
    _write_u32_csv(golden_csv, width, height, golden_pixels)
    _write_u32_csv(vliw_csv, width, height, vliw_pixels)
    metrics_json.write_text(
        (
            "{\n"
            f"  \"kernel\": \"full_image_threshold\",\n"
            f"  \"width\": {width},\n"
            f"  \"height\": {height},\n"
            f"  \"pixels\": {total},\n"
            f"  \"threshold\": {threshold},\n"
            f"  \"cycles\": {cycles},\n"
            f"  \"cycles_per_pixel\": {cycles / total:.6f}\n"
            "}\n"
        ),
        encoding="utf-8",
    )

    dut._log.info(
        f"test_full_image_threshold_kernel_with_artifacts: cycles={cycles}, "
        f"cpp={cycles / total:.4f}, artifacts={artifact_dir}"
    )


@cocotb.test()
async def test_full_image_threshold_kernel_sw_pipeline_with_artifacts(dut):
    """Full-image SWP kernel: threshold 64x64 image; emit VLIW SWP output and delta metrics."""
    harness = VliwCoreHarness(dut)

    width = 64
    height = 64
    total = width * height
    in_base = 0
    out_base = 10000
    threshold = 128

    input_pixels = [((row * 37 + col * 13 + 17) & 0xFF) for row in range(height) for col in range(width)]
    golden_pixels = _golden_threshold(input_pixels, threshold)

    harness.axi_mem.preload(in_base, input_pixels)
    await harness.init()

    program = build_program([
        # ---- Setup ----
        S.const(0,  0),              # counter = 0
        S.const(1,  total),          # limit
        S.const(9,  1),              # constant 1
        S.const(49, 4),              # step = 4
        S.const(3,  threshold),      # threshold
        # Running addresses for 4 pixels
        S.const(10, in_base + 0),    # in0
        S.const(16, in_base + 1),    # in1
        S.const(21, in_base + 2),    # in2
        S.const(26, in_base + 3),    # in3
        S.const(13, out_base + 0),   # out0
        S.const(19, out_base + 1),   # out1
        S.const(24, out_base + 2),   # out2
        S.const(29, out_base + 3),   # out3

        # ---- Unrolled loop: 4 pixels / iteration ----
        S.label("img_th_swp_loop"),
        # pixel 0
        S.load(11, 10),
        S.lt(12, 11, 3),
        S.store(13, 12),
        # pixel 1
        S.load(17, 16),
        S.lt(18, 17, 3),
        S.store(19, 18),
        # pixel 2
        S.load(22, 21),
        S.lt(23, 22, 3),
        S.store(24, 23),
        # pixel 3
        S.load(27, 26),
        S.lt(28, 27, 3),
        S.store(29, 28),

        # Advance 4 in/out address pairs by 4
        S.add(10, 10, 49),  S.add(13, 13, 49),
        S.add(16, 16, 49),  S.add(19, 19, 49),
        S.add(21, 21, 49),  S.add(24, 24, 49),
        S.add(26, 26, 49),  S.add(29, 29, 49),

        # Loop control
        S.add(0, 0, 49),             # counter += 4
        S.lt(14, 0, 1),
        S.cond_jump(14, "img_th_swp_loop"),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=200000)

    vliw_pixels = [harness.axi_mem.read_word(out_base + i) & 0xFF for i in range(total)]
    for i, exp in enumerate(golden_pixels):
        got = vliw_pixels[i]
        assert got == exp, f"full-image threshold swp idx={i}: expected {exp}, got {got}"

    artifact_dir = PROJECT_ROOT / "verification" / "results" / "full_image_kernel"
    swp_pgm = artifact_dir / "output_vliw_swp_64x64.pgm"
    swp_csv = artifact_dir / "output_vliw_swp_64x64_u32.csv"
    swp_metrics = artifact_dir / "run_metrics_swp.json"
    delta_metrics = artifact_dir / "run_metrics_delta.json"

    _write_pgm(swp_pgm, width, height, vliw_pixels)
    _write_u32_csv(swp_csv, width, height, vliw_pixels)
    swp_metrics.write_text(
        (
            "{\n"
            f"  \"kernel\": \"full_image_threshold_swp\",\n"
            f"  \"width\": {width},\n"
            f"  \"height\": {height},\n"
            f"  \"pixels\": {total},\n"
            f"  \"threshold\": {threshold},\n"
            f"  \"cycles\": {cycles},\n"
            f"  \"cycles_per_pixel\": {cycles / total:.6f}\n"
            "}\n"
        ),
        encoding="utf-8",
    )

    baseline_metrics = artifact_dir / "run_metrics.json"
    if baseline_metrics.exists():
        baseline = json.loads(baseline_metrics.read_text(encoding="utf-8"))
        baseline_cycles = int(baseline["cycles"])
        speedup = baseline_cycles / cycles if cycles > 0 else 0.0
        delta_metrics.write_text(
            (
                "{\n"
                f"  \"baseline_cycles\": {baseline_cycles},\n"
                f"  \"swp_cycles\": {cycles},\n"
                f"  \"cycles_delta\": {baseline_cycles - cycles},\n"
                f"  \"speedup\": {speedup:.6f}\n"
                "}\n"
            ),
            encoding="utf-8",
        )

    dut._log.info(
        f"test_full_image_threshold_kernel_sw_pipeline_with_artifacts: cycles={cycles}, "
        f"cpp={cycles / total:.4f}, artifacts={artifact_dir}"
    )


# ============================================================================
#  Vector DSP kernel: affine transform with VLOAD + VBROADCAST + MADD + VSTORE
# ============================================================================

@cocotb.test()
async def test_dsp_vector_affine_golden(dut):
    """DSP kernel: vector affine transform out[i] = samples[i] * alpha + beta.

    Exercises: VLOAD, VBROADCAST, VALU MUL, VALU ADD, VSTORE.
    Processes 64 samples in groups of 8 (8 iterations).
    """
    harness = VliwCoreHarness(dut)

    alpha = 3
    beta = 17
    samples = [((i * 11 + 7) & 0xFF) for i in range(64)]
    golden = [_u32(s * alpha + beta) for s in samples]

    harness.axi_mem.preload(0, samples)
    await harness.init()

    out_base = 800

    program = build_program([
        # Broadcast alpha and beta into vector registers
        S.const(50, alpha),
        S.vbroadcast(400, 50),       # v_alpha = [3,3,3,3,3,3,3,3]
        S.const(51, beta),
        S.vbroadcast(408, 51),       # v_beta  = [17,17,...,17]

        # Running pointers
        S.const(10, 0),              # in_addr
        S.const(11, out_base),       # out_addr
        S.const(0, 0),              # counter
        S.const(1, 64),             # limit
        S.const(2, 8),              # step

        S.label("affine_loop"),
        S.vload(320, 10),            # load 8 samples
        S.valu_op("mul", 328, 320, 400),  # v_tmp = samples * alpha
        S.valu_op("add", 336, 328, 408),  # v_out = v_tmp + beta
        S.vstore(11, 336),           # store 8 results
        S.add_imm(10, 10, 8),       # in_addr += 8
        S.add_imm(11, 11, 8),       # out_addr += 8
        S.add(0, 0, 2),             # counter += 8
        S.lt(12, 0, 1),
        S.cond_jump(12, "affine_loop"),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    for i, exp in enumerate(golden):
        got = harness.axi_mem.read_word(out_base + i)
        assert got == exp, f"dsp affine idx={i}: expected {exp}, got {got}"

    dut._log.info(f"test_dsp_vector_affine_golden: cycles={cycles}, n={len(samples)}")


# ============================================================================
#  Vector CV kernel: threshold segmentation with VLOAD + VBROADCAST + VALU LT + VSTORE
# ============================================================================

@cocotb.test()
async def test_cv_threshold_vector_golden(dut):
    """CV kernel: vectorised pixel threshold segmentation.

    Exercises: VLOAD, VBROADCAST, VALU LT, VSTORE.
    Processes 64 pixels in groups of 8 (8 iterations) — 8× fewer than scalar.
    """
    harness = VliwCoreHarness(dut)

    pixels = [((i * 13 + 17) & 0xFF) for i in range(64)]
    threshold = 128
    golden = _golden_threshold(pixels, threshold)

    harness.axi_mem.preload(0, pixels)
    await harness.init()

    # out_base must satisfy (base % 16) in {0, 8} so that every
    # VSTORE (8 lanes, step-8 loop) keeps wordOff + 7 <= 15.
    out_base = 1024

    program = build_program([
        # Broadcast threshold into vector register
        S.const(50, threshold),
        S.vbroadcast(400, 50),       # v_threshold = [128]*8

        # Running pointers
        S.const(10, 0),              # in_addr
        S.const(11, out_base),       # out_addr
        S.const(0, 0),              # counter
        S.const(1, 64),             # limit
        S.const(2, 8),              # step

        S.label("cv_vec_loop"),
        S.vload(320, 10),            # load 8 pixels
        S.valu_op("lt", 328, 320, 400),   # mask = pixel < threshold
        S.vstore(11, 328),           # store 8 mask values
        S.add_imm(10, 10, 8),       # in_addr += 8
        S.add_imm(11, 11, 8),       # out_addr += 8
        S.add(0, 0, 2),             # counter += 8
        S.lt(12, 0, 1),
        S.cond_jump(12, "cv_vec_loop"),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    for i, exp in enumerate(golden):
        got = harness.axi_mem.read_word(out_base + i)
        assert got == exp, f"cv vec idx={i}: expected {exp}, got {got}"

    dut._log.info(f"test_cv_threshold_vector_golden: cycles={cycles}, n={len(pixels)}")


# ============================================================================
#  Vector full-image kernel: 64×64 threshold with VLOAD + VALU LT + VSTORE
# ============================================================================

@cocotb.test()
async def test_full_image_threshold_vector_golden(dut):
    """Full-image kernel (vectorised): threshold 64×64 image using VLOAD/VALU/VSTORE.

    Processes 4096 pixels in groups of 8 (512 iterations) vs 4096 scalar iterations.
    Emits same artifacts for direct comparison with scalar versions.
    """
    harness = VliwCoreHarness(dut)

    width = 64
    height = 64
    total = width * height
    in_base = 0
    out_base = 5000
    threshold = 128

    input_pixels = [((row * 37 + col * 13 + 17) & 0xFF)
                    for row in range(height) for col in range(width)]
    golden_pixels = _golden_threshold(input_pixels, threshold)

    harness.axi_mem.preload(in_base, input_pixels)
    await harness.init()

    program = build_program([
        # Broadcast threshold
        S.const(50, threshold),
        S.vbroadcast(400, 50),       # v_threshold = [128]*8

        # Running pointers
        S.const(10, in_base),        # in_addr
        S.const(11, out_base),       # out_addr
        S.const(0, 0),              # counter
        S.const(1, total),          # limit = 4096
        S.const(2, 8),              # step

        S.label("img_vec_loop"),
        S.vload(320, 10),            # load 8 pixels
        S.valu_op("lt", 328, 320, 400),   # mask = pixel < threshold
        S.vstore(11, 328),           # store 8 mask values
        S.add_imm(10, 10, 8),       # in_addr += 8
        S.add_imm(11, 11, 8),       # out_addr += 8
        S.add(0, 0, 2),             # counter += 8
        S.lt(12, 0, 1),
        S.cond_jump(12, "img_vec_loop"),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=200000)

    vliw_pixels = [harness.axi_mem.read_word(out_base + i) & 0xFF for i in range(total)]
    for i, exp in enumerate(golden_pixels):
        got = vliw_pixels[i]
        assert got == exp, f"full-image vec idx={i}: expected {exp}, got {got}"

    # Emit vector version artifacts
    artifact_dir = PROJECT_ROOT / "verification" / "results" / "full_image_kernel"
    vec_pgm = artifact_dir / "output_vliw_vec_64x64.pgm"
    vec_csv = artifact_dir / "output_vliw_vec_64x64_u32.csv"
    vec_metrics = artifact_dir / "run_metrics_vec.json"

    _write_pgm(vec_pgm, width, height, vliw_pixels)
    _write_u32_csv(vec_csv, width, height, vliw_pixels)
    vec_metrics.write_text(
        (
            "{\n"
            f'  "kernel": "full_image_threshold_vec",\n'
            f'  "width": {width},\n'
            f'  "height": {height},\n'
            f'  "pixels": {total},\n'
            f'  "threshold": {threshold},\n'
            f'  "cycles": {cycles},\n'
            f'  "cycles_per_pixel": {cycles / total:.6f}\n'
            "}\n"
        ),
        encoding="utf-8",
    )

    dut._log.info(
        f"test_full_image_threshold_vector_golden: cycles={cycles}, "
        f"cpp={cycles / total:.4f}, artifacts={artifact_dir}"
    )
