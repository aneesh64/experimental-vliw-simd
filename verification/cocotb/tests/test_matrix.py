"""
cocotb testbench for MatrixEngine module.

Focused coverage for the v1 functional matrix path:
  - MZERO clears an 8x8 accumulator tile.
  - MCOMPUTE multiplies operand-A and operand-B tiles into accumulator memory.

The unit under test exposes raw matrix-local memory ports, so this testbench
provides a simple 1-cycle-latency memory model for operand A/B and accumulator
memories.
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge


class MatrixOp:
    NOP = 0
    MCFG = 1
    MMLOAD = 2
    MMSTORE = 3
    MDMVIN = 4
    MDMVOUT = 5
    MPRELOAD = 6
    MCOMPUTE = 7
    MCOMPUTE_ACC = 8
    MZERO = 9


def _s8(value: int) -> int:
    value &= 0xFF
    return value - 256 if value & 0x80 else value


def _u32(value: int) -> int:
    return value & 0xFFFFFFFF


def _safe_int(signal) -> int:
    raw = str(signal.value)
    if any(ch in raw.lower() for ch in ("x", "z")):
        return 0
    return int(signal.value)


def _expected_matmul(a_mem: dict[int, int], b_mem: dict[int, int], accum_mem: dict[int, int], accum: bool) -> list[int]:
    out = []
    for row in range(8):
        for col in range(8):
            total = accum_mem.get(row * 8 + col, 0) if accum else 0
            for k in range(8):
                total += _s8(a_mem[row * 8 + k]) * _s8(b_mem[k * 8 + col])
            out.append(_u32(total))
    return out


async def reset(dut, cycles=5):
    dut.reset.value = 1
    dut.io_valid.value = 0
    dut.io_slots_0_valid.value = 0
    dut.io_slots_0_opcode.value = 0
    dut.io_slots_0_dest.value = 0
    dut.io_slots_0_srcA.value = 0
    dut.io_slots_0_srcB.value = 0
    dut.io_slots_0_srcC.value = 0
    dut.io_slots_0_tileRows.value = 8
    dut.io_slots_0_tileCols.value = 8
    dut.io_slots_0_flags.value = 0
    dut.io_matrixScratchARdData.value = 0
    dut.io_matrixScratchBRdData.value = 0
    dut.io_matrixAccumRdData.value = 0
    for _ in range(cycles):
        await RisingEdge(dut.clk)
    dut.reset.value = 0
    await RisingEdge(dut.clk)


async def matrix_memory_model(dut, a_mem: dict[int, int], b_mem: dict[int, int], accum_mem: dict[int, int]):
    next_a = 0
    next_b = 0
    next_acc = 0
    while True:
        dut.io_matrixScratchARdData.value = next_a
        dut.io_matrixScratchBRdData.value = next_b
        dut.io_matrixAccumRdData.value = next_acc

        await RisingEdge(dut.clk)

        if _safe_int(dut.io_matrixScratchAEn) and _safe_int(dut.io_matrixScratchAWe):
            a_mem[_safe_int(dut.io_matrixScratchAAddr)] = _safe_int(dut.io_matrixScratchAWrData) & 0xFF
        if _safe_int(dut.io_matrixScratchBEn) and _safe_int(dut.io_matrixScratchBWe):
            b_mem[_safe_int(dut.io_matrixScratchBAddr)] = _safe_int(dut.io_matrixScratchBWrData) & 0xFF
        if _safe_int(dut.io_matrixAccumEn) and _safe_int(dut.io_matrixAccumWe):
            accum_mem[_safe_int(dut.io_matrixAccumAddr)] = _safe_int(dut.io_matrixAccumWrData) & 0xFFFFFFFF

        next_a = 0
        next_b = 0
        next_acc = 0
        if _safe_int(dut.io_matrixScratchAEn) and not _safe_int(dut.io_matrixScratchAWe):
            next_a = a_mem.get(_safe_int(dut.io_matrixScratchAAddr), 0)
        if _safe_int(dut.io_matrixScratchBEn) and not _safe_int(dut.io_matrixScratchBWe):
            next_b = b_mem.get(_safe_int(dut.io_matrixScratchBAddr), 0)
        if _safe_int(dut.io_matrixAccumEn) and not _safe_int(dut.io_matrixAccumWe):
            next_acc = accum_mem.get(_safe_int(dut.io_matrixAccumAddr), 0)


async def issue_matrix_slot(dut, opcode: int, dest: int = 0, src_a: int = 0, src_b: int = 0, flags: int = 0):
    dut.io_valid.value = 1
    dut.io_slots_0_valid.value = 1
    dut.io_slots_0_opcode.value = opcode
    dut.io_slots_0_dest.value = dest
    dut.io_slots_0_srcA.value = src_a
    dut.io_slots_0_srcB.value = src_b
    dut.io_slots_0_srcC.value = 0
    dut.io_slots_0_tileRows.value = 8
    dut.io_slots_0_tileCols.value = 8
    dut.io_slots_0_flags.value = flags
    await RisingEdge(dut.clk)
    dut.io_valid.value = 0
    dut.io_slots_0_valid.value = 0


async def wait_not_busy(dut, max_cycles=3000):
    for _ in range(max_cycles):
        await RisingEdge(dut.clk)
        if int(dut.io_busy.value) == 0:
            return
    raise AssertionError(f"Matrix engine remained busy after {max_cycles} cycles")


@cocotb.test()
async def test_mzero_clears_accumulator_tile(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    a_mem = {}
    b_mem = {}
    accum_mem = {idx: _u32(0x1000 + idx) for idx in range(64)}
    cocotb.start_soon(matrix_memory_model(dut, a_mem, b_mem, accum_mem))

    await reset(dut)
    await issue_matrix_slot(dut, MatrixOp.MZERO, dest=0)
    await wait_not_busy(dut)

    for idx in range(64):
        got = accum_mem.get(idx, None)
        assert got == 0, f"MZERO failed at accum[{idx}]: got {got}"


@cocotb.test()
async def test_mcompute_writes_expected_accumulator_tile(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    a_mem = {idx: ((idx % 8) + 1) for idx in range(64)}
    b_mem = {idx: (((idx // 8) + 1) * 2) for idx in range(64)}
    accum_mem = {idx: 0 for idx in range(64)}
    cocotb.start_soon(matrix_memory_model(dut, a_mem, b_mem, accum_mem))

    await reset(dut)
    await issue_matrix_slot(dut, MatrixOp.MCOMPUTE, dest=0, src_a=0, src_b=0)
    await wait_not_busy(dut)

    expected = _expected_matmul(a_mem, b_mem, {idx: 0 for idx in range(64)}, accum=False)
    for idx, exp in enumerate(expected):
        got = accum_mem.get(idx, 0)
        assert got == exp, f"MCOMPUTE mismatch at accum[{idx}]: got {got:#x}, expected {exp:#x}"


@cocotb.test()
async def test_mcompute_acc_accumulates_existing_tile(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    a_mem = {idx: 1 for idx in range(64)}
    b_mem = {idx: 1 for idx in range(64)}
    accum_seed = {idx: idx for idx in range(64)}
    accum_mem = dict(accum_seed)
    cocotb.start_soon(matrix_memory_model(dut, a_mem, b_mem, accum_mem))

    await reset(dut)
    await issue_matrix_slot(dut, MatrixOp.MCOMPUTE_ACC, dest=0, src_a=0, src_b=0)
    await wait_not_busy(dut)

    expected = _expected_matmul(a_mem, b_mem, accum_seed, accum=True)
    for idx, exp in enumerate(expected):
        got = accum_mem.get(idx, 0)
        assert got == exp, f"MCOMPUTE_ACC mismatch at accum[{idx}]: got {got:#x}, expected {exp:#x}"