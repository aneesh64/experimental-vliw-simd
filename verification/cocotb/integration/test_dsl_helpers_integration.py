from test_integration_common import *
from tools.dsl import HardwareCapabilities, KernelBuilder, U8, U16, U32, compile_kernel
from tools.dsl.layout import tile_1d


def _pack_subs(values: list[int], ew: int) -> int:
    mask = (1 << ew) - 1
    word = 0
    for idx, value in enumerate(values):
        word |= (value & mask) << (idx * ew)
    return word & 0xFFFFFFFF


def _extract_subs(word: int, ew: int) -> list[int]:
    mask = (1 << ew) - 1
    return [(word >> (idx * ew)) & mask for idx in range(32 // ew)]


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_scalar_symbolic_load_compute_store_golden(dut):
    """DSL scalar symbolic DMEM load/compute/store kernel runs through RTL."""
    harness = VliwCoreHarness(dut)

    input_value = 37
    bias_value = 5
    golden = input_value + bias_value

    harness.axi_mem.preload(144, [input_value])
    await harness.init()

    kb = KernelBuilder("dsl_scalar_symbolic_load_store")
    in_buf = kb.arg_dmem_tensor("in_buf", shape=(1,), dtype=U32)
    out_buf = kb.arg_dmem_tensor("out_buf", shape=(1,), dtype=U32)
    bias = kb.arg_scalar("bias", default=bias_value)
    in_ptr = kb.scalar("in_ptr")
    out_ptr = kb.scalar("out_ptr")
    value = kb.scalar("value")
    acc = kb.scalar("acc")

    kb.address_of(in_ptr, in_buf)
    kb.load(value, in_ptr)
    kb.add(acc, value, bias)
    kb.address_of(out_ptr, out_buf)
    kb.store(out_ptr, acc)
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"in_buf": 144, "out_buf": 160, "bias": bias_value},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=10000)

    got = harness.axi_mem.read_word(160)
    assert got == golden, f"expected {golden}, got {got}"
    dut._log.info(f"test_dsl_scalar_symbolic_load_compute_store_golden: cycles={cycles}, out={got}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vector_fill_store_lanes_golden(dut):
    """DSL helper methods produce a vector fill kernel that runs through RTL."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    fill_value = 21

    kb = KernelBuilder("dsl_helper_fill")
    scalar_value = kb.arg_scalar("scalar_value", default=fill_value)
    out_buf = kb.arg_dmem_tensor("out", shape=(2,), dtype=U32)
    out_ptr = kb.scalar("out_ptr")
    vec = kb.vector("vec", dtype=U8, scratch_base=340)

    kb.address_of(out_ptr, out_buf)
    kb.vector_fill(vec, scalar_value, ew=32)
    kb.store_lane(out_ptr, vec, 0)
    kb.add_imm(out_ptr, out_ptr, 1)
    kb.store_lane(out_ptr, vec, 7, alias_name="vec_last")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(kb.build(), caps, bindings={"out": 48, "scalar_value": fill_value}, assemble=True)
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=10000)

    assert harness.axi_mem.read_word(48) == fill_value
    assert harness.axi_mem.read_word(49) == fill_value
    dut._log.info(f"test_dsl_helper_vector_fill_store_lanes_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vector_map_add_golden(dut):
    """DSL helper vector_map kernel runs through RTL and matches golden values."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    lhs_value = 7
    rhs_value = 11
    expected = lhs_value + rhs_value

    kb = KernelBuilder("dsl_helper_map_add")
    lhs_scalar = kb.arg_scalar("lhs_scalar", default=lhs_value)
    rhs_scalar = kb.arg_scalar("rhs_scalar", default=rhs_value)
    out_buf = kb.arg_dmem_tensor("out", shape=(2,), dtype=U32)
    out_ptr = kb.scalar("out_ptr")
    lhs_vec = kb.vector("lhs_vec", dtype=U32, scratch_base=320)
    rhs_vec = kb.vector("rhs_vec", dtype=U32, scratch_base=328)
    out_vec = kb.vector("out_vec", dtype=U32, scratch_base=336)

    kb.address_of(out_ptr, out_buf)
    kb.vector_fill(lhs_vec, lhs_scalar, ew=32)
    kb.vector_fill(rhs_vec, rhs_scalar, ew=32)
    kb.vector_map("add", out_vec, lhs_vec, rhs_vec, ew=32)
    kb.store_lane(out_ptr, out_vec, 0)
    kb.add_imm(out_ptr, out_ptr, 1)
    kb.store_lane(out_ptr, out_vec, 7, alias_name="out_vec_last")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"out": 64, "lhs_scalar": lhs_value, "rhs_scalar": rhs_value},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=10000)

    assert harness.axi_mem.read_word(64) == expected
    assert harness.axi_mem.read_word(65) == expected
    dut._log.info(f"test_dsl_helper_vector_map_add_golden: cycles={cycles}, out={expected}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vload_vstore_vector_map_golden(dut):
    """DSL TensorView helpers support symbolic DMEM vector load/compute/store."""
    harness = VliwCoreHarness(dut)

    lhs = [1, 2, 3, 4, 5, 6, 7, 8]
    rhs = [10, 20, 30, 40, 50, 60, 70, 80]
    golden = [a + b for a, b in zip(lhs, rhs)]

    harness.axi_mem.preload(96, lhs)
    harness.axi_mem.preload(104, rhs)
    await harness.init()

    kb = KernelBuilder("dsl_helper_vload_vstore_add")
    lhs_buf = kb.arg_dmem_tensor("lhs", shape=(8,), dtype=U32)
    rhs_buf = kb.arg_dmem_tensor("rhs", shape=(8,), dtype=U32)
    out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U32)
    lhs_vec = kb.vector("lhs_vec", dtype=U32, scratch_base=320)
    rhs_vec = kb.vector("rhs_vec", dtype=U32, scratch_base=328)
    out_vec = kb.vector("out_vec", dtype=U32, scratch_base=336)

    kb.vload_view(lhs_vec, tile_1d(lhs_buf, length=8), addr_name="lhs_ptr")
    kb.vload_view(rhs_vec, tile_1d(rhs_buf, length=8), addr_name="rhs_ptr")
    kb.vector_map("add", out_vec, lhs_vec, rhs_vec, ew=32)
    kb.vstore_view(tile_1d(out_buf, length=8), out_vec, addr_name="out_ptr")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"lhs": 96, "rhs": 104, "out": 112},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=10000)

    for lane, exp in enumerate(golden):
        got = harness.axi_mem.read_word(112 + lane)
        assert got == exp, f"lane={lane}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_helper_vload_vstore_vector_map_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vector_copy_golden(dut):
    """DSL helper vector_copy kernel preserves symbolic DMEM vector contents."""
    harness = VliwCoreHarness(dut)

    src = [13, 21, 34, 55, 89, 144, 233, 377]
    harness.axi_mem.preload(176, src)
    await harness.init()

    kb = KernelBuilder("dsl_helper_vector_copy")
    src_buf = kb.arg_dmem_tensor("src", shape=(8,), dtype=U32)
    out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U32)
    src_vec = kb.vector("src_vec", dtype=U32, scratch_base=320)
    copy_vec = kb.vector("copy_vec", dtype=U32, scratch_base=328)

    kb.vload_view(src_vec, tile_1d(src_buf, length=8), addr_name="src_ptr")
    kb.vector_copy(copy_vec, src_vec, ew=32)
    kb.vstore_view(tile_1d(out_buf, length=8), copy_vec, addr_name="out_ptr")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"src": 176, "out": 192},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=10000)

    for lane, exp in enumerate(src):
        got = harness.axi_mem.read_word(192 + lane)
        assert got == exp, f"lane={lane}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_helper_vector_copy_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vcast_32to8_golden(dut):
    """DSL helper vcast kernel narrows symbolic DMEM vector contents through RTL."""
    harness = VliwCoreHarness(dut)

    src = [0x12345678] * 8
    expected = 0x78
    harness.axi_mem.preload(208, src)
    await harness.init()

    kb = KernelBuilder("dsl_helper_vcast_32to8")
    src_buf = kb.arg_dmem_tensor("src", shape=(8,), dtype=U32)
    out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U32)
    src_vec = kb.vector("src_vec", dtype=U32, scratch_base=320)
    cast_vec = kb.vector("cast_vec", dtype=U32, scratch_base=328)

    kb.vload_view(src_vec, tile_1d(src_buf, length=8), addr_name="src_ptr")
    kb.vcast(cast_vec, src_vec, ew=32, dw=8, signed=0, upper=0)
    kb.vstore_view(tile_1d(out_buf, length=8), cast_vec, addr_name="out_ptr")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"src": 208, "out": 224},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=10000)

    for lane in range(8):
        got = harness.axi_mem.read_word(224 + lane)
        assert got == expected, f"lane={lane}: expected 0x{expected:08X}, got 0x{got:08X}"
    dut._log.info(f"test_dsl_helper_vcast_32to8_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vector_map_mul_golden(dut):
    """DSL helper vector_map mul kernel runs through RTL with symbolic DMEM buffers."""
    harness = VliwCoreHarness(dut)

    lhs = [2, 3, 4, 5, 6, 7, 8, 9]
    rhs = [10, 20, 30, 40, 50, 60, 70, 80]
    golden = [a * b for a, b in zip(lhs, rhs)]

    harness.axi_mem.preload(240, lhs)
    harness.axi_mem.preload(248, rhs)
    await harness.init()

    kb = KernelBuilder("dsl_helper_vload_vstore_mul")
    lhs_buf = kb.arg_dmem_tensor("lhs", shape=(8,), dtype=U32)
    rhs_buf = kb.arg_dmem_tensor("rhs", shape=(8,), dtype=U32)
    out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U32)
    lhs_vec = kb.vector("lhs_vec", dtype=U32, scratch_base=320)
    rhs_vec = kb.vector("rhs_vec", dtype=U32, scratch_base=328)
    out_vec = kb.vector("out_vec", dtype=U32, scratch_base=336)

    kb.vload_view(lhs_vec, tile_1d(lhs_buf, length=8), addr_name="lhs_ptr")
    kb.vload_view(rhs_vec, tile_1d(rhs_buf, length=8), addr_name="rhs_ptr")
    kb.vector_map("mul", out_vec, lhs_vec, rhs_vec, ew=32)
    kb.vstore_view(tile_1d(out_buf, length=8), out_vec, addr_name="out_ptr")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"lhs": 240, "rhs": 248, "out": 256},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=10000)

    for lane, exp in enumerate(golden):
        got = harness.axi_mem.read_word(256 + lane)
        assert got == exp, f"lane={lane}: expected {exp}, got {got}"
    dut._log.info(f"test_dsl_helper_vector_map_mul_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vector_map_sub_u16_golden(dut):
    """DSL helper vector_map supports packed 16-bit subtract kernels through RTL."""
    harness = VliwCoreHarness(dut)

    lhs = []
    rhs = []
    golden = []
    for lane in range(8):
        lhs_subs = [(100 + lane * 2 + k) & 0xFFFF for k in range(2)]
        rhs_subs = [(50 + lane + k) & 0xFFFF for k in range(2)]
        lhs_word = _pack_subs(lhs_subs, 16)
        rhs_word = _pack_subs(rhs_subs, 16)
        lhs.append(lhs_word)
        rhs.append(rhs_word)
        golden.append(_pack_subs([((a - b) & 0xFFFF) for a, b in zip(lhs_subs, rhs_subs)], 16))

    harness.axi_mem.preload(320, lhs)
    harness.axi_mem.preload(328, rhs)
    await harness.init()

    kb = KernelBuilder("dsl_helper_vload_vstore_sub_u16")
    lhs_buf = kb.arg_dmem_tensor("lhs", shape=(8,), dtype=U16)
    rhs_buf = kb.arg_dmem_tensor("rhs", shape=(8,), dtype=U16)
    out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U16)
    lhs_vec = kb.vector("lhs_vec", dtype=U16, scratch_base=320)
    rhs_vec = kb.vector("rhs_vec", dtype=U16, scratch_base=328)
    out_vec = kb.vector("out_vec", dtype=U16, scratch_base=336)

    kb.vload_view(lhs_vec, tile_1d(lhs_buf, length=8), addr_name="lhs_ptr")
    kb.vload_view(rhs_vec, tile_1d(rhs_buf, length=8), addr_name="rhs_ptr")
    kb.vector_map("sub", out_vec, lhs_vec, rhs_vec, ew=16)
    kb.vstore_view(tile_1d(out_buf, length=8), out_vec, addr_name="out_ptr")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"lhs": 320, "rhs": 328, "out": 336},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=12000)

    for lane, exp in enumerate(golden):
        got = harness.axi_mem.read_word(336 + lane)
        assert got == exp, f"lane={lane}: expected 0x{exp:08X}, got 0x{got:08X}"
    dut._log.info(f"test_dsl_helper_vector_map_sub_u16_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vcast_8to16_golden(dut):
    """DSL helper vcast kernel widens packed 8-bit symbolic DMEM vector contents to 16-bit through RTL."""
    harness = VliwCoreHarness(dut)

    src = [_pack_subs([0xAA, 0xBB, 0xCC, 0xDD], 8)] * 8
    golden = _pack_subs([0x00AA, 0x00BB], 16)
    harness.axi_mem.preload(352, src)
    await harness.init()

    kb = KernelBuilder("dsl_helper_vcast_8to16")
    src_buf = kb.arg_dmem_tensor("src", shape=(8,), dtype=U8)
    out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U16)
    src_vec = kb.vector("src_vec", dtype=U8, scratch_base=320)
    cast_vec = kb.vector("cast_vec", dtype=U16, scratch_base=328)

    kb.vload_view(src_vec, tile_1d(src_buf, length=8), addr_name="src_ptr")
    kb.vcast(cast_vec, src_vec, ew=8, dw=16, signed=0, upper=0)
    kb.vstore_view(tile_1d(out_buf, length=8), cast_vec, addr_name="out_ptr")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"src": 352, "out": 368},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=12000)

    for lane in range(8):
        got = harness.axi_mem.read_word(368 + lane)
        assert got == golden, f"lane={lane}: expected 0x{golden:08X}, got 0x{got:08X}"
    dut._log.info(f"test_dsl_helper_vcast_8to16_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vector_map_xor_u8_golden(dut):
    """DSL helper vector_map supports packed 8-bit xor kernels through RTL."""
    harness = VliwCoreHarness(dut)

    lhs = []
    rhs = []
    golden = []
    for lane in range(8):
        lhs_subs = [(0x10 + lane + k) & 0xFF for k in range(4)]
        rhs_subs = [(0xA0 + lane + 2 * k) & 0xFF for k in range(4)]
        lhs_word = _pack_subs(lhs_subs, 8)
        rhs_word = _pack_subs(rhs_subs, 8)
        lhs.append(lhs_word)
        rhs.append(rhs_word)
        golden.append(_pack_subs([(a ^ b) & 0xFF for a, b in zip(lhs_subs, rhs_subs)], 8))

    harness.axi_mem.preload(384, lhs)
    harness.axi_mem.preload(392, rhs)
    await harness.init()

    kb = KernelBuilder("dsl_helper_vload_vstore_xor_u8")
    lhs_buf = kb.arg_dmem_tensor("lhs", shape=(8,), dtype=U8)
    rhs_buf = kb.arg_dmem_tensor("rhs", shape=(8,), dtype=U8)
    out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U8)
    lhs_vec = kb.vector("lhs_vec", dtype=U8, scratch_base=320)
    rhs_vec = kb.vector("rhs_vec", dtype=U8, scratch_base=328)
    out_vec = kb.vector("out_vec", dtype=U8, scratch_base=336)

    kb.vload_view(lhs_vec, tile_1d(lhs_buf, length=8), addr_name="lhs_ptr")
    kb.vload_view(rhs_vec, tile_1d(rhs_buf, length=8), addr_name="rhs_ptr")
    kb.vector_map("xor", out_vec, lhs_vec, rhs_vec, ew=8)
    kb.vstore_view(tile_1d(out_buf, length=8), out_vec, addr_name="out_ptr")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"lhs": 384, "rhs": 392, "out": 400},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=12000)

    for lane, exp in enumerate(golden):
        got = harness.axi_mem.read_word(400 + lane)
        assert got == exp, f"lane={lane}: expected 0x{exp:08X}, got 0x{got:08X}"
    dut._log.info(f"test_dsl_helper_vector_map_xor_u8_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_helper_vcast_8to32_signed_golden(dut):
    """DSL helper vcast kernel sign-extends packed 8-bit symbolic DMEM vector contents to 32-bit through RTL."""
    harness = VliwCoreHarness(dut)

    src = [_pack_subs([0xF0, 0x7F, 0x01, 0x80], 8)] * 8
    golden = 0xFFFFFFF0
    harness.axi_mem.preload(416, src)
    await harness.init()

    kb = KernelBuilder("dsl_helper_vcast_8to32_signed")
    src_buf = kb.arg_dmem_tensor("src", shape=(8,), dtype=U8)
    out_buf = kb.arg_dmem_tensor("out", shape=(8,), dtype=U32)
    src_vec = kb.vector("src_vec", dtype=U8, scratch_base=320)
    cast_vec = kb.vector("cast_vec", dtype=U32, scratch_base=328)

    kb.vload_view(src_vec, tile_1d(src_buf, length=8), addr_name="src_ptr")
    kb.vcast(cast_vec, src_vec, ew=8, dw=32, signed=1, upper=0)
    kb.vstore_view(tile_1d(out_buf, length=8), cast_vec, addr_name="out_ptr")
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"src": 416, "out": 432},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=12000)

    for lane in range(8):
        got = harness.axi_mem.read_word(432 + lane)
        assert got == golden, f"lane={lane}: expected 0x{golden:08X}, got 0x{got:08X}"
    dut._log.info(f"test_dsl_helper_vcast_8to32_signed_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_scalar_symbolic_load_compute_store_stress_golden(dut):
    """DSL scalar symbolic load/compute/store stays correct under randomized AXI read latency."""
    harness = VliwCoreHarness(dut, axi_latency_mode="stress", axi_latency_n=12, axi_seed=123)

    input_value = 37
    bias_value = 5
    golden = input_value + bias_value

    harness.axi_mem.preload(144, [input_value])
    await harness.init()

    kb = KernelBuilder("dsl_scalar_symbolic_load_store_stress")
    in_buf = kb.arg_dmem_tensor("in_buf", shape=(1,), dtype=U32)
    out_buf = kb.arg_dmem_tensor("out_buf", shape=(1,), dtype=U32)
    bias = kb.arg_scalar("bias", default=bias_value)
    in_ptr = kb.scalar("in_ptr")
    out_ptr = kb.scalar("out_ptr")
    value = kb.scalar("value")
    acc = kb.scalar("acc")

    kb.address_of(in_ptr, in_buf)
    kb.load(value, in_ptr)
    kb.add(acc, value, bias)
    kb.address_of(out_ptr, out_buf)
    kb.store(out_ptr, acc)
    kb.halt()

    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kb.build(),
        caps,
        bindings={"in_buf": 144, "out_buf": 160, "bias": bias_value},
        assemble=True,
    )
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=12000)

    got = harness.axi_mem.read_word(160)
    assert got == golden, f"expected {golden}, got {got}"
    assert harness.axi_mem.read_txn_count >= 1, "Expected at least one AXI read under stress mode"
    dut._log.info(f"test_dsl_scalar_symbolic_load_compute_store_stress_golden: cycles={cycles}, seed={harness.axi_seed}")
