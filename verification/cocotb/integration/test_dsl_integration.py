from test_integration_common import *
from tools.dsl import HardwareCapabilities, KernelBuilder, U8, U32, build_coreid_offset_store_kernel, compile_kernel
from tools.dsl.layout import tile_1d


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_scalar_count_loop_golden(dut):
    """DSL scalar loop kernel runs through RTL and matches golden result."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    kb = KernelBuilder("dsl_count_loop")
    counter = kb.scalar("counter")
    limit = kb.arg_scalar("limit", default=5)
    one = kb.scalar("one")
    cond = kb.scalar("cond")
    out_ptr = kb.scalar("out_ptr")
    out_buf = kb.arg_dmem_tensor("out", shape=(1,), dtype=U32)

    kb.const(counter, 0)
    kb.const(one, 1)
    kb.label("loop")
    kb.add(counter, counter, one)
    kb.binary("lt", cond, counter, limit)
    kb.cond_jump(cond, "loop")
    kb.address_of(out_ptr, out_buf)
    kb.store(out_ptr, counter)
    kb.halt()

    caps = HardwareCapabilities.from_configs(
        scheduler_config=S.cfg,
        assembler_config=ASM.cfg,
    )
    result = compile_kernel(kb.build(), caps, bindings={"out": 1200}, assemble=True)
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=10000)

    got = harness.axi_mem.read_word(1200)
    exp = 5
    assert got == exp, f"dsl count loop expected {exp}, got {got}"
    dut._log.info(f"test_dsl_scalar_count_loop_golden: cycles={cycles}, out={got}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_vector_u8_add_tile_golden(dut):
    """DSL vector broadcast kernel with symbolic DMEM binding runs through RTL."""
    harness = VliwCoreHarness(dut)

    await harness.init()

    broadcast_value = 10
    golden = [broadcast_value] * 8

    kb = KernelBuilder("dsl_vbroadcast")
    out_buf = kb.arg_dmem_tensor("out", shape=(2,), dtype=U32)
    scalar_value = kb.arg_scalar("scalar_value", default=broadcast_value)
    out_ptr = kb.scalar("out_ptr")
    vec = kb.vector("vec", dtype=U8, scratch_base=340)
    vec_last = kb.scalar("vec_last", scratch_base=347)

    out_tile = tile_1d(out_buf, length=2, start=0)

    kb.address_of_view(out_ptr, out_tile)
    kb.vbroadcast(vec, scalar_value, ew=32)
    kb.store(out_ptr, vec)
    kb.add_imm(out_ptr, out_ptr, 1)
    kb.store(out_ptr, vec_last)
    kb.halt()

    caps = HardwareCapabilities.from_configs(
        scheduler_config=S.cfg,
        assembler_config=ASM.cfg,
    )
    result = compile_kernel(kb.build(), caps, bindings={"out": 32, "scalar_value": broadcast_value}, assemble=True)
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=20000)

    observed = [harness.axi_mem.read_word(32), harness.axi_mem.read_word(33)]
    expected = [golden[0], golden[7]]
    for idx, (got, exp) in enumerate(zip(observed, expected)):
        assert got == exp, f"word={idx}: expected 0x{exp:08X}, got 0x{got:08X}"

    dut._log.info(f"test_dsl_vector_u8_add_tile_golden: cycles={cycles}")


@cocotb.test()  # pyright: ignore[reportAttributeAccessIssue]
async def test_dsl_coreid_offset_store_golden(dut):
    """DSL core-aware smoke kernel stores `coreid()` at an offset derived from the core id."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    kernel = build_coreid_offset_store_kernel(slots=1)
    caps = HardwareCapabilities.from_configs(
        scheduler_config=S.cfg,
        assembler_config=ASM.cfg,
    )
    result = compile_kernel(kernel, caps, bindings={"out": 1280}, assemble=True)
    assert result.binary_bundles is not None

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=10000)

    got = harness.axi_mem.read_word(1280)
    assert got == 0, f"expected coreId=0, got {got}"
    dut._log.info(f"test_dsl_coreid_offset_store_golden: cycles={cycles}, out={got}")
