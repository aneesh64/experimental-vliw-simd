"""
cocotb testbench for UnsignedDivider module.

Tests:
  - Basic division correctness (quotient and remainder)
  - Edge cases: divide by 1, large numbers, powers of 2
  - Back-to-back operations (start on done cycle)
  - Busy flag behavior
  - Latency check (exactly dataWidth+1 = 33 cycles)
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles, Timer
import random


MASK32 = 0xFFFFFFFF
DIV_LATENCY = 33  # 32-bit width + 1


async def reset(dut, cycles=5):
    dut.reset.value = 1
    dut.io_start.value = 0
    dut.io_dividend.value = 0
    dut.io_divisor.value = 0
    for _ in range(cycles):
        await RisingEdge(dut.clk)
    dut.reset.value = 0
    await RisingEdge(dut.clk)


async def do_divide(dut, dividend, divisor, check=True):
    """Start a division and wait for done. Returns (quotient, remainder, cycles)."""
    dut.io_dividend.value = dividend & MASK32
    dut.io_divisor.value = divisor & MASK32
    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0

    cycles = 0
    for _ in range(DIV_LATENCY + 5):
        await RisingEdge(dut.clk)
        cycles += 1
        if int(dut.io_done.value) == 1:
            q = int(dut.io_quotient.value)
            r = int(dut.io_remainder.value)
            if check and divisor != 0:
                exp_q = dividend // divisor
                exp_r = dividend % divisor
                assert q == exp_q, f"{dividend}/{divisor}: quotient {q} != expected {exp_q}"
                assert r == exp_r, f"{dividend}%{divisor}: remainder {r} != expected {exp_r}"
            return q, r, cycles

    raise AssertionError(f"Division {dividend}/{divisor} did not complete in {DIV_LATENCY+5} cycles")


@cocotb.test()
async def test_basic_division(dut):
    """Test simple division cases."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    test_cases = [
        (10, 3),      # 3 remainder 1
        (100, 7),     # 14 remainder 2
        (255, 16),    # 15 remainder 15
        (1000, 1),    # divide by 1
        (0, 5),       # zero dividend
        (7, 7),       # equal
        (5, 10),      # divisor > dividend
        (MASK32, 1),  # max value / 1
        (MASK32, 2),  # max value / 2
        (1, MASK32),  # 1 / max = 0 remainder 1
    ]

    for dividend, divisor in test_cases:
        q, r, cyc = await do_divide(dut, dividend, divisor)
        dut._log.info(f"{dividend} / {divisor} = {q} rem {r} (took {cyc} cycles)")

    dut._log.info("test_basic_division: PASS")


@cocotb.test()
async def test_latency(dut):
    """Verify division takes exactly DIV_LATENCY cycles."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    _, _, cyc = await do_divide(dut, 100, 7)
    assert cyc == DIV_LATENCY, f"Expected {DIV_LATENCY} cycles, got {cyc}"

    dut._log.info(f"test_latency: PASS ({cyc} cycles)")


@cocotb.test()
async def test_busy_flag(dut):
    """Verify busy is high during computation, low otherwise."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    assert int(dut.io_busy.value) == 0, "busy should be 0 after reset"

    dut.io_dividend.value = 100
    dut.io_divisor.value = 7
    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0

    # Should be busy on the next cycle
    await RisingEdge(dut.clk)
    assert int(dut.io_busy.value) == 1, "busy should be 1 after start"

    # Wait for done
    for _ in range(DIV_LATENCY + 2):
        await RisingEdge(dut.clk)
        if int(dut.io_done.value) == 1:
            break

    # After done, busy should be 0 next cycle
    await RisingEdge(dut.clk)
    assert int(dut.io_busy.value) == 0, "busy should be 0 after done"

    dut._log.info("test_busy_flag: PASS")


@cocotb.test()
async def test_back_to_back(dut):
    """Test starting a new division immediately after done."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    pairs = [(100, 7), (200, 13), (999, 37), (12345, 67)]

    for dividend, divisor in pairs:
        q, r, _ = await do_divide(dut, dividend, divisor)
        # After done, immediately start next (done cycle)
        # do_divide waits for done, so we can chain

    dut._log.info("test_back_to_back: PASS")


@cocotb.test()
async def test_random_exhaustive(dut):
    """Test 50 random division cases."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    rng = random.Random(42)
    for i in range(50):
        dividend = rng.randint(0, MASK32)
        divisor = rng.randint(1, MASK32)
        q, r, _ = await do_divide(dut, dividend, divisor)

    dut._log.info("test_random_exhaustive: PASS (50 cases)")


@cocotb.test()
async def test_powers_of_two(dut):
    """Test division by powers of 2 (should match shift)."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    dividend = 0xDEADBEEF
    for shift in range(1, 32):
        divisor = 1 << shift
        q, r, _ = await do_divide(dut, dividend, divisor)
        assert q == dividend >> shift, f"div by 2^{shift}: {q} != {dividend >> shift}"
        assert r == dividend & (divisor - 1), f"mod 2^{shift}: {r} != {dividend & (divisor-1)}"

    dut._log.info("test_powers_of_two: PASS")
