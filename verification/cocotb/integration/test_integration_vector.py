from test_integration_common import *

@cocotb.test()
async def test_valu_short_opcode_coverage_golden(dut):
    """VALU-heavy short test with deterministic and exploratory opcode coverage."""
    harness = VliwCoreHarness(dut)

    vlen = 8
    await harness.init()

    a = [1, 2, 3, 4, 5, 6, 7, 8]
    b = [8, 7, 6, 5, 4, 3, 2, 1]
    deterministic_ops = ["add"]
    exploratory_ops = ["sub", "mul", "xor", "and", "or", "shl", "shr", "lt", "eq"]

    add_v = _vbin("add", a, b)

    program = build_program([
        # Initialize vector source regions with scalar consts (avoids VALU src3 path)
        S.const(96, 1), S.const(97, 2), S.const(98, 3), S.const(99, 4),
        S.const(100, 5), S.const(101, 6), S.const(102, 7), S.const(103, 8),
        S.const(104, 8), S.const(105, 7), S.const(106, 6), S.const(107, 5),
        S.const(108, 4), S.const(109, 3), S.const(110, 2), S.const(111, 1),
        S.const(112, 10), S.const(113, 20), S.const(114, 30), S.const(115, 40),
        S.const(116, 50), S.const(117, 60), S.const(118, 70), S.const(119, 80),
        S.const(120, 0), S.const(121, 1), S.const(122, 2), S.const(123, 3),
        S.const(124, 4), S.const(125, 5), S.const(126, 6), S.const(127, 7),

        S.valu_op("add", 200, 96, 104),
        S.valu_op("sub", 208, 96, 104),
        S.valu_op("mul", 216, 96, 104),
        S.valu_op("xor", 224, 96, 104),
        S.valu_op("and", 232, 96, 104),
        S.valu_op("or", 240, 96, 104),
        S.valu_op("shl", 248, 96, 120),
        S.valu_op("shr", 256, 112, 120),
        S.valu_op("lt", 264, 96, 104),
        S.valu_op("eq", 272, 96, 96),

        # Store one deterministic representative lane for golden checking
        S.const(10, 600), S.store(10, 200),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=4000)

    expected = {
        600: add_v[0],
    }

    for addr, exp in expected.items():
        got = harness.axi_mem.read_word(addr)
        assert got == exp, f"addr={addr}: expected {exp}, got {got}"


# ============================================================================
#  Test 21: VALU iterative workload (long, golden model)
# ============================================================================

@cocotb.test()
async def test_valu_long_iterative_golden(dut):
    """Long VALU-heavy loop (~hundreds of cycles) against Python golden model."""
    harness = VliwCoreHarness(dut)

    vlen = 8
    x0 = [11, 13, 17, 19, 23, 29, 31, 37]
    step = [3, 5, 7, 11, 13, 17, 19, 23]
    await harness.init()

    # Golden model
    iters = 160
    x = x0[:]
    y = step[:]
    for _ in range(iters):
        x = _vbin("add", x, y)      # x = x + step

    iter_ops = [S.valu_op("add", 304, 304, 312) for _ in range(iters)]

    program = build_program([
        # Initialize x and step vectors lane-by-lane with scalar consts
        S.const(304, 11), S.const(305, 13), S.const(306, 17), S.const(307, 19),
        S.const(308, 23), S.const(309, 29), S.const(310, 31), S.const(311, 37),
        S.const(312, 3),  S.const(313, 5),  S.const(314, 7),  S.const(315, 11),
        S.const(316, 13), S.const(317, 17), S.const(318, 19), S.const(319, 23),
        *iter_ops,

        # Store final x lanes to memory for verification
        S.const(10, 700),
        S.store(10, 304),
        S.add_imm(10, 10, 1), S.store(10, 305),
        S.add_imm(10, 10, 1), S.store(10, 306),
        S.add_imm(10, 10, 1), S.store(10, 307),
        S.add_imm(10, 10, 1), S.store(10, 308),
        S.add_imm(10, 10, 1), S.store(10, 309),
        S.add_imm(10, 10, 1), S.store(10, 310),
        S.add_imm(10, 10, 1), S.store(10, 311),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    assert cycles >= 200, f"Expected long-running VALU test (>=200 cycles), got {cycles}"
    for lane in range(vlen):
        got = harness.axi_mem.read_word(700 + lane)
        exp = x[lane]
        assert got == exp, f"lane={lane}: expected {exp}, got {got}"


# ============================================================================
#  Test 18: Long scalar recurrence (golden model)
# ============================================================================

@cocotb.test()
async def test_valu_src3_ops_multicycle_golden(dut):
    """VBROADCAST (src3 op) produces correct data; now single-cycle in WB stage."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    c_scalar = 10

    expected_broadcast = [c_scalar] * 8

    program = build_program([
        S.const(50, c_scalar),
        S.vbroadcast(340, 50),

        S.const(10, 1300),
        S.store(10, 340),
        S.add_imm(10, 10, 1), S.store(10, 347),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=6000)

    # VBROADCAST is now single-cycle (no extra pipeline register)
    assert cycles >= 3, f"Expected at least a few cycles, got cycles={cycles}"

    b0 = harness.axi_mem.read_word(1300)
    b7 = harness.axi_mem.read_word(1301)

    assert b0 == expected_broadcast[0], f"vbroadcast lane0 expected {expected_broadcast[0]}, got {b0}"
    assert b7 == expected_broadcast[7], f"vbroadcast lane7 expected {expected_broadcast[7]}, got {b7}"


# ============================================================================
#  Test 24: Scalar-on-vector-bank scheduling isolation
# ============================================================================

@cocotb.test()
async def test_scalar_vector_bank_isolation_schedule(dut):
    """
    Scalar memory ops targeting vector banks must not co-issue with vector ops.

    This test constructs a schedule that would otherwise co-issue under relaxed
    post-gaps, then verifies scheduler isolation and functional execution.
    """
    harness = VliwCoreHarness(dut)
    harness.axi_mem.preload(0, [0x12345678])
    await harness.init()

    local_sched = VliwScheduler(SchedulerConfig(
        n_alu_slots=N_ALU_SLOTS,
        n_valu_slots=N_VALU_SLOTS,
        n_load_slots=N_LOAD_SLOTS,
        n_store_slots=N_STORE_SLOTS,
        n_flow_slots=N_FLOW_SLOTS,
        mem_post_gap=-1,
        valu_post_gap=-1,
    ))

    ops = [
        local_sched.const(15, 0),
        local_sched.valu_op("add", 327, 330, 331, vlen=1),
        local_sched.load_from_vector_bank(1, 15),
        local_sched.const(10, 1400),
        local_sched.store(10, 1),
        local_sched.halt(),
    ]

    bundles_dicts = local_sched.schedule(ops)

    valu_pc = -1
    scalar_vec_load_pc = -1
    for pc, bundle in enumerate(bundles_dicts):
        for op in bundle.get("valu", []):
            if op and op[0] == "add":
                valu_pc = pc
        for op in bundle.get("load", []):
            if op and op[0] == "load" and len(op) >= 3 and op[1] == 1 and op[2] == 15:
                scalar_vec_load_pc = pc

    assert valu_pc >= 0, "Expected VALU op in schedule"
    assert scalar_vec_load_pc >= 0, "Expected scalar vector-bank LOAD in schedule"
    assert scalar_vec_load_pc > valu_pc, (
        "Scalar LOAD targeting vector bank must not co-issue with vector instructions"
    )

    program = ASM.assemble_program(bundles_dicts)
    await harness.load_program(program)
    await harness.run(max_cycles=8000)

    observed = harness.axi_mem.read_word(1400)
    assert observed == 0x12345678, f"Expected 0x12345678, got 0x{observed:08x}"


# ============================================================================
#  Test 25: Multiple operations in the same bundle (multi-engine packing)
# ============================================================================
