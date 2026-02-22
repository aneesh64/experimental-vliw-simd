"""
cocotb testbench for BankedScratchMemory module.

Port summary (Sim config: 1 ALU, 1 VALU, 1 Load, 1 Store, 1 Flow):
  - 9 scalar read ports   (scalarReadAddr_0..8, scalarReadEn_0..8 → scalarReadData_0..8)
  - 2×8 VALU read ports   (valuReadAddr_0_0..7 / 1_0..7, valuReadEn → valuReadData)
  - 28 write ports         (writeAddr_0..27, writeData_0..27, writeEn_0..27)
  - io_conflict output

Tests:
  1. Single-port write & read back
  2. Multi-port concurrent writes (different banks)
  3. Write conflict detection (same bank, simultaneous)
  4. Vector read consistency
  5. Reset clears outputs
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

N_SCALAR_READ = 9
N_VALU_READ   = 2  # groups, 8 lanes each
VLEN          = 8
N_WRITE       = 28
N_BANKS       = 8


async def reset(dut, cycles=5):
    dut.reset.value = 1
    dut.io_valuActive.value = 0
    dut.io_vectorReadActive.value = 0
    dut.io_blockScalarReads.value = 0
    # Deassert all write enables
    for i in range(N_WRITE):
        getattr(dut, f"io_writeEn_{i}").value = 0
        getattr(dut, f"io_writeAddr_{i}").value = 0
        getattr(dut, f"io_writeData_{i}").value = 0
    # Deassert all scalar read enables
    for i in range(N_SCALAR_READ):
        getattr(dut, f"io_scalarReadEn_{i}").value = 0
        getattr(dut, f"io_scalarReadAddr_{i}").value = 0
    # Deassert VALU read enables
    for g in range(N_VALU_READ):
        for l in range(VLEN):
            getattr(dut, f"io_valuReadEn_{g}_{l}").value = 0
            getattr(dut, f"io_valuReadAddr_{g}_{l}").value = 0
    for _ in range(cycles):
        await RisingEdge(dut.clk)
    dut.reset.value = 0
    await RisingEdge(dut.clk)


def bank_of(addr):
    """Which bank an 11-bit address maps to."""
    return addr % N_BANKS


@cocotb.test()
async def test_write_and_scalar_read(dut):
    """Write values through port 0, read them back via scalar port 0."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    test_vals = [(0, 0xAAAA_0000), (1, 0xBBBB_1111), (8, 0xCCCC_2222), (16, 0xDDDD_3333)]

    for addr, data in test_vals:
        dut.io_writeEn_0.value   = 1
        dut.io_writeAddr_0.value = addr
        dut.io_writeData_0.value = data
        await RisingEdge(dut.clk)
        dut.io_writeEn_0.value = 0
        await RisingEdge(dut.clk)

    # Now read back from scalar port 0
    for addr, expected in test_vals:
        dut.io_scalarReadEn_0.value   = 1
        dut.io_scalarReadAddr_0.value = addr
        await RisingEdge(dut.clk)         # address registered
        await RisingEdge(dut.clk)         # BRAM 1-cycle latency
        got = int(dut.io_scalarReadData_0.value)
        assert got == expected, f"addr={addr}: {got:#x} != {expected:#x}"

    dut._log.info("test_write_and_scalar_read: PASS")


@cocotb.test()
async def test_concurrent_writes_different_banks(dut):
    """Write through multiple ports to different banks simultaneously — no conflict."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    # Use write port 0..7, addresses mapping to banks 0..7
    for i in range(8):
        getattr(dut, f"io_writeEn_{i}").value   = 1
        getattr(dut, f"io_writeAddr_{i}").value  = i       # addr i → bank i
        getattr(dut, f"io_writeData_{i}").value  = 0x100 + i

    await RisingEdge(dut.clk)

    # Conflict should be 0 (different banks)
    conflict = int(dut.io_conflict.value)
    dut._log.info(f"Conflict after concurrent diff-bank writes: {conflict}")

    for i in range(8):
        getattr(dut, f"io_writeEn_{i}").value = 0
    await RisingEdge(dut.clk)

    # Verify reads
    for i in range(8):
        dut.io_scalarReadEn_0.value   = 1
        dut.io_scalarReadAddr_0.value = i
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        got = int(dut.io_scalarReadData_0.value)
        assert got == (0x100 + i), f"bank {i}: {got:#x} != {0x100+i:#x}"

    dut._log.info("test_concurrent_writes_different_banks: PASS")


@cocotb.test()
async def test_conflict_detection(dut):
    """Three scalar reads targeting one bank should raise conflict."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    # Two reads in one bank are supported (Port A + Port B).
    # Third read in the same bank should assert conflict.
    dut.io_scalarReadEn_0.value   = 1
    dut.io_scalarReadAddr_0.value = 0     # bank 0

    dut.io_scalarReadEn_1.value   = 1
    dut.io_scalarReadAddr_1.value = 8     # bank 0 = 8 % 8

    dut.io_scalarReadEn_2.value   = 1
    dut.io_scalarReadAddr_2.value = 16    # bank 0 = 16 % 8

    await RisingEdge(dut.clk)

    conflict = int(dut.io_conflict.value)
    assert conflict == 1, f"Expected conflict=1 but got {conflict}"

    # Disable all and verify conflict clears
    dut.io_scalarReadEn_0.value = 0
    dut.io_scalarReadEn_1.value = 0
    dut.io_scalarReadEn_2.value = 0
    await RisingEdge(dut.clk)

    conflict = int(dut.io_conflict.value)
    assert conflict == 0, f"Expected conflict=0 after disable but got {conflict}"

    dut._log.info("test_conflict_detection: PASS")


@cocotb.test()
async def test_valu_read(dut):
    """Write 8 consecutive addresses, read them back as a VALU group."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)
    dut.io_valuActive.value = 1
    dut.io_vectorReadActive.value = 1
    dut.io_blockScalarReads.value = 1

    base_addr = 0
    expected = []
    # Write addresses 0..7 one at a time (different banks)
    for lane in range(VLEN):
        addr = base_addr + lane
        data = 0x1000 * (lane + 1)
        expected.append(data)
        dut.io_writeEn_0.value   = 1
        dut.io_writeAddr_0.value = addr
        dut.io_writeData_0.value = data
        await RisingEdge(dut.clk)
        dut.io_writeEn_0.value = 0
        await RisingEdge(dut.clk)

    # Read via VALU read group 0
    for lane in range(VLEN):
        getattr(dut, f"io_valuReadEn_0_{lane}").value   = 1
        getattr(dut, f"io_valuReadAddr_0_{lane}").value  = base_addr + lane

    await RisingEdge(dut.clk)   # address registered
    await RisingEdge(dut.clk)   # BRAM latency

    for lane in range(VLEN):
        got = int(getattr(dut, f"io_valuReadData_0_{lane}").value)
        assert got == expected[lane], f"lane {lane}: {got:#x} != {expected[lane]:#x}"

    # Disable reads
    for lane in range(VLEN):
        getattr(dut, f"io_valuReadEn_0_{lane}").value = 0

    dut._log.info("test_valu_read: PASS")


@cocotb.test()
async def test_multiple_scalar_reads_same_cycle(dut):
    """Read from multiple scalar ports in the same cycle."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    # Write addresses 0..4 one at a time
    for i in range(5):
        dut.io_writeEn_0.value   = 1
        dut.io_writeAddr_0.value = i
        dut.io_writeData_0.value = 100 + i
        await RisingEdge(dut.clk)
    dut.io_writeEn_0.value = 0
    await RisingEdge(dut.clk)

    # Read from port 0..4 simultaneously
    for i in range(5):
        getattr(dut, f"io_scalarReadEn_{i}").value   = 1
        getattr(dut, f"io_scalarReadAddr_{i}").value = i

    await RisingEdge(dut.clk)   # registered addr
    await RisingEdge(dut.clk)   # BRAM latency

    for i in range(5):
        got = int(getattr(dut, f"io_scalarReadData_{i}").value)
        expected = 100 + i
        assert got == expected, f"port {i}: {got} != {expected}"
        getattr(dut, f"io_scalarReadEn_{i}").value = 0

    dut._log.info("test_multiple_scalar_reads_same_cycle: PASS")
