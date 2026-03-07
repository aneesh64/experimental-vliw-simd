from test_integration_common import *
from tools.dsl import HardwareCapabilities, compile_kernel
from tools.dsl.examples import (
    build_box_blur_3x3_image_kernel,
    build_box_blur_3x3_kernel,
    build_box_blur_3x3_row_kernel,
    build_tileweave_column_gain_kernel,
    build_tileweave_matrix_gain_kernel,
    build_pipelined_fused_dsp_dual_output_kernel,
    build_pipelined_fused_dsp_gain_monitor_kernel,
    build_nested_vector_threshold_mask_kernel,
    build_pipelined_tiled_vector_add_kernel,
    build_pipelined_tiled_vector_mul_kernel,
    build_threshold_clip_kernel,
    build_tileweave_gain_kernel,
    build_tileweave_dual_output_kernel,
    build_tileweave_masked_gain_load_kernel,
    build_tileweave_masked_gain_store_kernel,
    build_vector_threshold_mask_kernel,
)


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_box_blur_3x3_single_pixel_golden(dut):
    """DSL 3x3 box blur example runs through RTL and matches a golden pixel."""
    harness = VliwCoreHarness(dut)

    patch = [
        1, 2, 3,
        4, 5, 6,
        7, 8, 9,
    ]
    expected = sum(patch) // 9

    harness.axi_mem.preload(288, patch)
    await harness.init()

    kernel = build_box_blur_3x3_kernel()
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"input": 288, "output": 320},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=20000)

    got = harness.axi_mem.read_word(320)
    assert got == expected, f"expected {expected}, got {got}"
    dut._log.info(f"test_dsl_box_blur_3x3_single_pixel_golden: cycles={cycles}, out={got}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_box_blur_3x3_row_golden(dut):
    """DSL 3x3 box blur row example runs through RTL and matches golden outputs."""
    harness = VliwCoreHarness(dut)

    patch = [
        1, 2, 3, 4, 5,
        6, 7, 8, 9, 10,
        11, 12, 13, 14, 15,
    ]
    expected = [7, 8, 9]

    harness.axi_mem.preload(352, patch)
    await harness.init()

    kernel = build_box_blur_3x3_row_kernel()
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"input": 352, "output": 384},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=40000)

    for idx, exp in enumerate(expected):
        got = harness.axi_mem.read_word(384 + idx)
        assert got == exp, f"idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_box_blur_3x3_row_golden: cycles={cycles}, out={expected}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_box_blur_3x3_image_golden(dut):
    """DSL 3x3 box blur image example runs through RTL and matches golden outputs."""
    harness = VliwCoreHarness(dut)

    image = [
        1, 2, 3, 4,
        5, 6, 7, 8,
        9, 10, 11, 12,
        13, 14, 15, 16,
    ]
    expected = [6, 7, 10, 11]

    harness.axi_mem.preload(416, image)
    await harness.init()

    kernel = build_box_blur_3x3_image_kernel()
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"input": 416, "output": 448},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=80000)

    for idx, exp in enumerate(expected):
        got = harness.axi_mem.read_word(448 + idx)
        assert got == exp, f"idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_box_blur_3x3_image_golden: cycles={cycles}, out={expected}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_pipelined_tiled_vector_add_golden(dut):
    """DSL software-pipelined tiled vector add runs through RTL and matches golden output."""
    harness = VliwCoreHarness(dut)

    lhs_tiles = [list(range(base, base + 8)) for base in (1, 9)]
    rhs_tiles = [[value * 3 for value in tile] for tile in lhs_tiles]
    lhs = [0] * 24
    rhs = [0] * 24
    golden = [0] * 24
    for tile_idx, (lhs_tile, rhs_tile) in enumerate(zip(lhs_tiles, rhs_tiles)):
        start = tile_idx * 16
        lhs[start:start + 8] = lhs_tile
        rhs[start:start + 8] = rhs_tile
        golden[start:start + 8] = [a + b for a, b in zip(lhs_tile, rhs_tile)]

    harness.axi_mem.preload(512, lhs)
    harness.axi_mem.preload(576, rhs)
    await harness.init()

    kernel = build_pipelined_tiled_vector_add_kernel(tiles=2, tile_elements=8, tile_stride_elements=16, unroll=1)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"lhs": 512, "rhs": 576, "out": 640},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=40000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(640 + idx)
        assert got == exp, f"idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_pipelined_tiled_vector_add_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_pipelined_tiled_vector_mul_golden(dut):
    """DSL software-pipelined tiled vector mul runs through RTL and matches golden output."""
    harness = VliwCoreHarness(dut)

    lhs_tiles = [list(range(base, base + 8)) for base in (2, 10)]
    rhs_tiles = [[value + 1 for value in tile] for tile in lhs_tiles]
    lhs = [0] * 24
    rhs = [0] * 24
    golden = [0] * 24
    for tile_idx, (lhs_tile, rhs_tile) in enumerate(zip(lhs_tiles, rhs_tiles)):
        start = tile_idx * 16
        lhs[start:start + 8] = lhs_tile
        rhs[start:start + 8] = rhs_tile
        golden[start:start + 8] = [a * b for a, b in zip(lhs_tile, rhs_tile)]

    harness.axi_mem.preload(704, lhs)
    harness.axi_mem.preload(736, rhs)
    await harness.init()

    kernel = build_pipelined_tiled_vector_mul_kernel(tiles=2, tile_elements=8, tile_stride_elements=16, unroll=1)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"lhs": 704, "rhs": 736, "out": 768},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=40000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(768 + idx)
        assert got == exp, f"idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_pipelined_tiled_vector_mul_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_pipelined_fused_dsp_gain_monitor_golden(dut):
    """DSL fused DSP gain-monitor kernel runs through RTL and matches golden outputs."""
    harness = VliwCoreHarness(dut)

    gain = 2
    sample_tiles = [list(range(base, base + 8)) for base in (4, 20)]
    samples = [0] * 24
    golden = [0] * 24
    probe = [0] * 4
    meta = [len(sample_tiles)]
    for tile_idx, tile in enumerate(sample_tiles):
        start = tile_idx * 16
        out_tile = [gain * value for value in tile]
        samples[start:start + 8] = tile
        golden[start:start + 8] = out_tile
        probe[2 * tile_idx] = out_tile[0]
        probe[2 * tile_idx + 1] = out_tile[-1]

    harness.axi_mem.preload(1184, samples)
    await harness.init()

    kernel = build_pipelined_fused_dsp_gain_monitor_kernel(
        tiles=2,
        tile_elements=8,
        tile_stride_elements=16,
        unroll=1,
    )
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"samples": 1184, "out": 1248, "probe": 1312, "meta": 1316, "gain": gain},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=50000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(1248 + idx)
        assert got == exp, f"out idx={idx}: expected {exp}, got {got}"
    for idx, exp in enumerate(probe):
        got = harness.axi_mem.read_word(1312 + idx)
        assert got == exp, f"probe idx={idx}: expected {exp}, got {got}"
    assert harness.axi_mem.read_word(1316) == meta[0], f"meta expected {meta[0]}, got {harness.axi_mem.read_word(1316)}"
    dut._log.info(
        f"test_dsl_pipelined_fused_dsp_gain_monitor_golden: cycles={cycles}, probe={probe}, meta={meta}"
    )


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_pipelined_fused_dsp_dual_output_golden(dut):
    """DSL fused DSP dual-output kernel runs through RTL and matches golden outputs."""
    harness = VliwCoreHarness(dut)

    gain = 2
    bias = 3
    sample_tiles = [list(range(base, base + 8)) for base in (6, 22)]
    samples = [0] * 24
    gain_golden = [0] * 24
    bias_golden = [0] * 24
    probe = [0] * 4
    meta = [len(sample_tiles)]
    for tile_idx, tile in enumerate(sample_tiles):
        start = tile_idx * 16
        gain_tile = [gain * value for value in tile]
        bias_tile = [value + bias for value in tile]
        samples[start:start + 8] = tile
        gain_golden[start:start + 8] = gain_tile
        bias_golden[start:start + 8] = bias_tile
        probe[2 * tile_idx] = gain_tile[0]
        probe[2 * tile_idx + 1] = bias_tile[-1]

    harness.axi_mem.preload(1344, samples)
    await harness.init()

    kernel = build_pipelined_fused_dsp_dual_output_kernel(
        tiles=2,
        tile_elements=8,
        tile_stride_elements=16,
        unroll=1,
    )
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={
            "samples": 1344,
            "gain_out": 1408,
            "bias_out": 1472,
            "probe": 1536,
            "meta": 1540,
            "gain": gain,
            "bias": bias,
        },
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=60000)

    for idx, exp in enumerate(gain_golden):
        got = harness.axi_mem.read_word(1408 + idx)
        assert got == exp, f"gain_out idx={idx}: expected {exp}, got {got}"
    for idx, exp in enumerate(bias_golden):
        got = harness.axi_mem.read_word(1472 + idx)
        assert got == exp, f"bias_out idx={idx}: expected {exp}, got {got}"
    for idx, exp in enumerate(probe):
        got = harness.axi_mem.read_word(1536 + idx)
        assert got == exp, f"probe idx={idx}: expected {exp}, got {got}"
    assert harness.axi_mem.read_word(1540) == meta[0], f"meta expected {meta[0]}, got {harness.axi_mem.read_word(1540)}"
    dut._log.info(
        f"test_dsl_pipelined_fused_dsp_dual_output_golden: cycles={cycles}, probe={probe}, meta={meta}"
    )


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_tileweave_gain_golden(dut):
    """TileWeave high-level DSL kernel runs through RTL and matches golden outputs."""
    harness = VliwCoreHarness(dut)

    gain = 2
    sample_tiles = [list(range(base, base + 8)) for base in (8, 24)]
    samples = [0] * 24
    gain_golden = [0] * 24
    for tile_idx, tile in enumerate(sample_tiles):
        start = tile_idx * 16
        gain_tile = [gain * value for value in tile]
        samples[start:start + 8] = tile
        gain_golden[start:start + 8] = gain_tile

    harness.axi_mem.preload(1568, samples)
    await harness.init()

    kernel = build_tileweave_gain_kernel(tiles=2, block_size=8, tile_stride_elements=16)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"samples": 1568, "gain_out": 1632, "gain": gain},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=60000)

    for idx, exp in enumerate(gain_golden):
        got = harness.axi_mem.read_word(1632 + idx)
        assert got == exp, f"gain_out idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_tileweave_gain_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_tileweave_dual_output_golden(dut):
    """TileWeave dual-output kernel runs through RTL and matches golden outputs."""
    harness = VliwCoreHarness(dut)

    gain = 2
    bias = 3
    sample_tiles = [list(range(base, base + 8)) for base in (8, 24)]
    samples = [0] * 24
    gain_golden = [0] * 24
    bias_golden = [0] * 24
    for tile_idx, tile in enumerate(sample_tiles):
        start = tile_idx * 16
        gain_tile = [gain * value for value in tile]
        bias_tile = [value + bias for value in tile]
        samples[start:start + 8] = tile
        gain_golden[start:start + 8] = gain_tile
        bias_golden[start:start + 8] = bias_tile

    harness.axi_mem.preload(1568, samples)
    await harness.init()

    kernel = build_tileweave_dual_output_kernel(tiles=2, block_size=8, tile_stride_elements=16)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"samples": 1568, "gain_out": 1632, "bias_out": 1696, "gain": gain, "bias": bias},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=60000)

    for idx, exp in enumerate(gain_golden):
        got = harness.axi_mem.read_word(1632 + idx)
        assert got == exp, f"gain_out idx={idx}: expected {exp}, got {got}"
    for idx, exp in enumerate(bias_golden):
        got = harness.axi_mem.read_word(1696 + idx)
        assert got == exp, f"bias_out idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_tileweave_dual_output_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_tileweave_gain_tail_golden(dut):
    """TileWeave gain kernel handles non-multiple tail elements via scalar cleanup."""
    harness = VliwCoreHarness(dut)

    gain = 2
    samples = list(range(5, 25))
    gain_golden = [gain * value for value in samples]

    harness.axi_mem.preload(1760, samples)
    await harness.init()

    kernel = build_tileweave_gain_kernel(block_size=8, tile_stride_elements=8, length=20)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"samples": 1760, "gain_out": 1824, "gain": gain},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=60000)

    for idx, exp in enumerate(gain_golden):
        got = harness.axi_mem.read_word(1824 + idx)
        assert got == exp, f"gain_out idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_tileweave_gain_tail_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_tileweave_dual_output_tail_golden(dut):
    """TileWeave dual-output kernel handles non-multiple tail elements via scalar cleanup."""
    harness = VliwCoreHarness(dut)

    gain = 2
    bias = 3
    samples = list(range(7, 27))
    gain_golden = [gain * value for value in samples]
    bias_golden = [value + bias for value in samples]

    harness.axi_mem.preload(1888, samples)
    await harness.init()

    kernel = build_tileweave_dual_output_kernel(block_size=8, tile_stride_elements=8, length=20)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"samples": 1888, "gain_out": 1952, "bias_out": 2016, "gain": gain, "bias": bias},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=60000)

    for idx, exp in enumerate(gain_golden):
        got = harness.axi_mem.read_word(1952 + idx)
        assert got == exp, f"gain_out idx={idx}: expected {exp}, got {got}"
    for idx, exp in enumerate(bias_golden):
        got = harness.axi_mem.read_word(2016 + idx)
        assert got == exp, f"bias_out idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_tileweave_dual_output_tail_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_tileweave_gain_64_golden(dut):
    """TileWeave gain kernel auto-chunks a 64-element block into hardware-vector operations."""
    harness = VliwCoreHarness(dut)

    gain = 2
    samples = list(range(1, 65))
    gain_golden = [gain * value for value in samples]

    harness.axi_mem.preload(2144, samples)
    await harness.init()

    kernel = build_tileweave_gain_kernel(block_size=64, tile_stride_elements=64, length=64)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"samples": 2144, "gain_out": 2272, "gain": gain},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=120000)

    for idx, exp in enumerate(gain_golden):
        got = harness.axi_mem.read_word(2272 + idx)
        assert got == exp, f"gain_out idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_tileweave_gain_64_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_tileweave_masked_gain_load_golden(dut):
    """TileWeave masked load fills OOB lanes with the explicit fallback value."""
    harness = VliwCoreHarness(dut)

    gain = 2
    samples = [5, 6, 7, 8, 9, 99, 99, 99]
    golden = [10, 12, 14, 16, 18, 0, 0, 0]

    harness.axi_mem.preload(2336, samples)
    await harness.init()

    kernel = build_tileweave_masked_gain_load_kernel(block_size=8, valid_elements=5, other=0)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"samples": 2336, "out": 2400, "gain": gain},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=60000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(2400 + idx)
        assert got == exp, f"out idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_tileweave_masked_gain_load_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_tileweave_masked_gain_store_golden(dut):
    """TileWeave masked store preserves untouched lanes outside the valid prefix."""
    harness = VliwCoreHarness(dut)

    gain = 2
    samples = [11, 12, 13, 14, 15, 16, 17, 18]
    initial_out = [777] * 8
    golden = [22, 24, 26, 28, 30, 777, 777, 777]

    harness.axi_mem.preload(2464, samples)
    harness.axi_mem.preload(2528, initial_out)
    await harness.init()

    kernel = build_tileweave_masked_gain_store_kernel(block_size=8, valid_elements=5)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"samples": 2464, "out": 2528, "gain": gain},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=60000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(2528 + idx)
        assert got == exp, f"out idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_tileweave_masked_gain_store_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_tileweave_column_gain_golden(dut):
    """TileWeave strided column kernel scales one row-major matrix column."""
    harness = VliwCoreHarness(dut)

    gain = 2
    matrix = list(range(1, 65))
    out_init = [777] * 64
    golden = out_init[:]
    for row in range(8):
        golden[row * 8] = matrix[row * 8] * gain

    harness.axi_mem.preload(2592, matrix)
    harness.axi_mem.preload(2688, out_init)
    await harness.init()

    kernel = build_tileweave_column_gain_kernel(rows=8, cols=8)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"matrix": 2592, "out": 2688, "gain": gain},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=60000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(2688 + idx)
        assert got == exp, f"out idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_tileweave_column_gain_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_tileweave_matrix_gain_golden(dut):
    """TileWeave affine strided launch scales every column of a row-major matrix."""
    harness = VliwCoreHarness(dut)

    gain = 3
    matrix = list(range(1, 65))
    golden = [value * gain for value in matrix]

    harness.axi_mem.preload(2784, matrix)
    await harness.init()

    kernel = build_tileweave_matrix_gain_kernel(rows=8, cols=8)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"matrix": 2784, "out": 2880, "gain": gain},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=80000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(2880 + idx)
        assert got == exp, f"out idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_tileweave_matrix_gain_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_threshold_clip_golden(dut):
    """DSL threshold clip kernel runs through RTL and matches golden output."""
    harness = VliwCoreHarness(dut)

    values = [3, 10, 12, 7, 21, 9]
    threshold = 10
    golden = [0 if value < threshold else value for value in values]

    harness.axi_mem.preload(832, values)
    await harness.init()

    kernel = build_threshold_clip_kernel(length=6)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"input": 832, "output": 864, "threshold": threshold},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=40000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(864 + idx)
        assert got == exp, f"idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_threshold_clip_golden: cycles={cycles}, out={golden}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_vector_threshold_mask_golden(dut):
    """DSL vector loop kernel runs through RTL and matches golden output."""
    harness = VliwCoreHarness(dut)

    values = [3, 10, 12, 7, 21, 9, 15, 30, 5, 18, 22, 1, 14, 11, 27, 6]
    threshold = 16
    golden = [1 if value < threshold else 0 for value in values]

    harness.axi_mem.preload(928, values)
    await harness.init()

    kernel = build_vector_threshold_mask_kernel(length=16, tile_elements=8)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"input": 928, "out": 992, "threshold": threshold},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=40000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(992 + idx)
        assert got == exp, f"idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_vector_threshold_mask_golden: cycles={cycles}, out={golden}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_nested_vector_threshold_mask_golden(dut):
    """DSL nested vector loop kernel runs through RTL and matches golden output."""
    harness = VliwCoreHarness(dut)

    values = [
        3, 10, 12, 7, 21, 9, 15, 30, 5, 18, 22, 1, 14, 11, 27, 6,
        16, 2, 31, 8, 13, 24, 4, 19, 7, 29, 12, 20, 15, 5, 18, 9,
    ]
    threshold = 16
    golden = [1 if value < threshold else 0 for value in values]

    harness.axi_mem.preload(1056, values)
    await harness.init()

    kernel = build_nested_vector_threshold_mask_kernel(rows=2, cols=16, tile_elements=8)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"input": 1056, "out": 1120, "threshold": threshold},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=60000)

    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(1120 + idx)
        assert got == exp, f"idx={idx}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_nested_vector_threshold_mask_golden: cycles={cycles}, out={golden}")
