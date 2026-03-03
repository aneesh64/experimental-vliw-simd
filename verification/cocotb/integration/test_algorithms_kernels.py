from test_algorithms_common import *

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


# ============================================================================
#  Multi-Width Vector Operations: helpers
# ============================================================================

def _u32(x: int) -> int:
    return x & 0xFFFFFFFF


def _pack_subs(values: list[int], ew: int) -> int:
    """Pack sub-element values into a 32-bit word at element width ew."""
    mask = (1 << ew) - 1
    result = 0
    for i, v in enumerate(values):
        result |= (v & mask) << (i * ew)
    return result & 0xFFFFFFFF


def _extract_subs(word: int, ew: int) -> list[int]:
    """Extract all sub-elements from a 32-bit word at element width ew."""
    n = 32 // ew
    mask = (1 << ew) - 1
    return [(word >> (i * ew)) & mask for i in range(n)]


def _to_signed(val: int, bits: int) -> int:
    mask = (1 << bits) - 1
    val = val & mask
    if val >= (1 << (bits - 1)):
        return val - (1 << bits)
    return val


def _from_signed(val: int, bits: int) -> int:
    return val & ((1 << bits) - 1)


# ============================================================================
#  Test: Packed 8-bit ADD across all 8 lanes (32 elements total)
# ============================================================================

@cocotb.test()
async def test_dsp_8bit_pixel_affine(dut):
    """DSP kernel: packed 8-bit pixel affine: out = clamp(pixel * alpha + beta).

    Uses packed 8-bit operations to process 32 pixels per iteration (4/lane × 8 lanes).
    Processes 64 pixels in 2 iterations.
    """
    harness = VliwCoreHarness(dut)

    alpha = 2
    beta = 10
    pixels = [((i * 7 + 3) & 0x3F) for i in range(64)]  # keep small to avoid overflow
    golden_subs = [((p * alpha + beta) & 0xFF) for p in pixels]

    # Pack into 32-bit words (4 pixels per word, 8 words = 32 pixels per batch)
    def pack_pixels(flat_list, start, count):
        words = []
        for w in range(count // 4):
            idx = start + w * 4
            words.append(_pack_subs(flat_list[idx:idx+4], 8))
        return words

    # First batch: pixels 0..31
    batch1 = pack_pixels(pixels, 0, 32)
    # Second batch: pixels 32..63
    batch2 = pack_pixels(pixels, 32, 32)

    harness.axi_mem.preload(0, batch1)
    harness.axi_mem.preload(8, batch2)
    await harness.init()

    out_base = 2512  # must be 16-word aligned for VSTORE

    program = build_program([
        # Broadcast alpha and beta as packed 8-bit
        S.const(50, alpha),
        S.vbroadcast(400, 50, ew=8),      # v_alpha = packed 8-bit [alpha]*4 per lane
        S.const(51, beta),
        S.vbroadcast(408, 51, ew=8),      # v_beta = packed 8-bit [beta]*4 per lane

        # Process batch 1 (addr 0)
        S.const(10, 0),
        S.vload(200, 10),                  # load 8 packed-8-bit words
        S.valu_op("mul", 216, 200, 400, ew=8),
        S.valu_op("add", 224, 216, 408, ew=8),
        S.const(12, out_base),
        S.vstore(12, 224),

        # Process batch 2 (addr 8)
        S.const(10, 8),
        S.vload(200, 10),
        S.valu_op("mul", 216, 200, 400, ew=8),
        S.valu_op("add", 224, 216, 408, ew=8),
        S.const(12, out_base + 8),
        S.vstore(12, 224),

        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Verify
    golden_words = pack_pixels(golden_subs, 0, 32) + pack_pixels(golden_subs, 32, 32)
    for i, exp in enumerate(golden_words):
        got = harness.axi_mem.read_word(out_base + i)
        assert got == exp, (
            f"8-bit pixel affine word {i}: expected 0x{exp:08X}, got 0x{got:08X}")

    dut._log.info(f"test_dsp_8bit_pixel_affine: PASS, cycles={cycles}")


# ============================================================================
#  Test: 16-bit VCAST + widening MUL pipeline (typical ML inference pattern)
# ============================================================================

@cocotb.test()
async def test_ml_8bit_widening_dot_product(dut):
    """ML kernel: 8-bit inputs widened to 16-bit, accumulated with widening MUL + ADD.

    Pattern: load 8-bit weights and activations, widening multiply to 16-bit,
    then accumulate with packed 16-bit ADD (2-instruction MAC sequence).
    """
    harness = VliwCoreHarness(dut)

    # 32 weights and 32 activations (4 packed per word × 8 lanes)
    weights = [(i * 3 + 1) & 0x0F for i in range(32)]   # keep small
    activations = [(i * 2 + 1) & 0x0F for i in range(32)]

    w_words = [_pack_subs(weights[i*4:(i+1)*4], 8) for i in range(8)]
    a_words = [_pack_subs(activations[i*4:(i+1)*4], 8) for i in range(8)]
    # Accumulator starts at zero (16-bit packed)
    acc_words = [0] * 8

    harness.axi_mem.preload(0, a_words)
    harness.axi_mem.preload(8, w_words)
    harness.axi_mem.preload(16, acc_words)
    await harness.init()

    out_base = 2600

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),            # activations
        S.const(11, 8),
        S.vload(208, 11),            # weights
        S.const(14, 16),
        S.vload(240, 14),            # accumulator (zeros)
        # Widening MAC: 2-instruction sequence (widening MUL + packed ADD)
        # because hardware's 2-port BRAM cannot read 3 vector operands at once.
        S.valu_op("mul", 216, 200, 208, ew=8, dw=16),   # widening MUL
        S.valu_op("add", 216, 216, 240, ew=16),          # accumulate
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Golden: for each lane, 2 widened products + accumulator
    for lane in range(8):
        a_subs = _extract_subs(a_words[lane], 8)
        w_subs = _extract_subs(w_words[lane], 8)
        c_subs = _extract_subs(acc_words[lane], 16)
        # nDest=2: sub[0]=a[0]*w[0]+c[0], sub[1]=a[1]*w[1]+c[1]
        r0 = (a_subs[0] * w_subs[0] + c_subs[0]) & 0xFFFF
        r1 = (a_subs[1] * w_subs[1] + c_subs[1]) & 0xFFFF
        golden = _pack_subs([r0, r1], 16)
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden, (
            f"Widen FMA 8→16 lane {lane}: expected 0x{golden:08X}, got 0x{got:08X}")

    dut._log.info(f"test_ml_8bit_widening_dot_product: PASS, cycles={cycles}")
