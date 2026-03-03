from test_integration_common import *

@cocotb.test()
async def test_counting_loop(dut):
    """Count from 0 to 4 using a loop. Final counter = 5."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 0),          # counter = 0
        S.const(1, 5),          # limit = 5
        S.const(2, 1),          # increment = 1
        S.label("loop"),
        S.add(0, 0, 2),         # counter++
        S.lt(3, 0, 1),          # counter < limit?
        S.cond_jump(3, "loop"),
        # After loop: counter = 5
        S.const(10, 0),
        S.store(10, 0),         # mem[0] = counter
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=2000)

    result = harness.axi_mem.read_word(0)
    assert result == 5, f"Expected counter=5, got {result}"


# ============================================================================
#  Test 8: Unconditional jump
# ============================================================================

@cocotb.test()
async def test_unconditional_jump(dut):
    """Jump over an overwrite. s[0] should remain 111."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 111),
        S.jump("skip"),
        S.const(0, 999),        # should be skipped
        S.label("skip"),
        S.const(10, 0),
        S.store(10, 0),         # mem[0] = 111 (not 999)
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=500)

    result = harness.axi_mem.read_word(0)
    assert result == 111, f"Expected 111, got {result}"


# ============================================================================
#  Test 9: SELECT (conditional move)
# ============================================================================
