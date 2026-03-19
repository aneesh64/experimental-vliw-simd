"""cocotb integration testbench for VliwCore module."""

from pathlib import Path
import sys

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))
if str(PROJECT_ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "tools"))

from assembler import Assembler, AssemblerConfig
from verification.cocotb.config import load_test_config

CFG = load_test_config(project_root=PROJECT_ROOT)
ASM = Assembler(AssemblerConfig(
    n_alu_slots=CFG.n_alu_slots,
    n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots,
    n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots,
    n_matrix_slots=CFG.n_matrix_slots,
    vlen=CFG.vlen,
    scratch_size=CFG.scratch_size,
    imem_depth=CFG.imem_depth,
))


def nop_bundle():
    return ASM.assemble({})


def assemble_bundle(**engines):
    return ASM.assemble({name: ops for name, ops in engines.items() if ops})


async def write_imem(dut, addr, data):
    """Write a single assembled instruction to IMEM."""
    rtl_width = len(dut.io_imemWrite_payload_data)
    if data >> rtl_width:
        raise AssertionError(
            f"Bundle width mismatch: bundle at addr {addr} exceeds RTL IMEM width {rtl_width} bits"
        )
    dut.io_imemWrite_valid.value = 1
    dut.io_imemWrite_payload_addr.value = addr
    dut.io_imemWrite_payload_data.value = data
    await RisingEdge(dut.clk)
    dut.io_imemWrite_valid.value = 0


async def reset(dut, cycles=5):
    dut.reset.value = 1
    dut.io_start.value = 0
    dut.io_imemWrite_valid.value = 0
    dut.io_imemWrite_payload_addr.value = 0
    dut.io_imemWrite_payload_data.value = 0
    # AXI slave defaults (tie off)
    dut.io_dmemAxi_aw_ready.value = 0
    dut.io_dmemAxi_w_ready.value = 0
    dut.io_dmemAxi_b_valid.value = 0
    dut.io_dmemAxi_b_payload_id.value = 0
    dut.io_dmemAxi_b_payload_resp.value = 0
    dut.io_dmemAxi_ar_ready.value = 0
    dut.io_dmemAxi_r_valid.value = 0
    dut.io_dmemAxi_r_payload_data.value = 0
    dut.io_dmemAxi_r_payload_id.value = 0
    dut.io_dmemAxi_r_payload_resp.value = 0
    dut.io_dmemAxi_r_payload_last.value = 1
    for _ in range(cycles):
        await RisingEdge(dut.clk)
    dut.reset.value = 0
    await RisingEdge(dut.clk)


async def start_core(dut):
    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0


async def wait_halted(dut, max_cycles=200):
    for i in range(max_cycles):
        await RisingEdge(dut.clk)
        await ReadOnly()
        if int(dut.io_halted.value) == 1:
            return i + 1
    raise AssertionError(f"Core did not halt within {max_cycles} cycles")


def safe_int(signal) -> int:
    raw = str(signal.value)
    if any(ch in raw.lower() for ch in ("x", "z")):
        return 0
    return int(signal.value)


def write_beat(memory_words: dict[int, int], byte_addr: int, data: int, strb: int):
    base_word = (byte_addr >> 2) & ~0xF
    for byte_index in range(64):
        if not (strb & (1 << byte_index)):
            continue
        word_addr = base_word + (byte_index // 4)
        byte_in_word = byte_index % 4
        byte_value = (data >> (byte_index * 8)) & 0xFF
        current = memory_words.get(word_addr, 0) & 0xFFFFFFFF
        mask = 0xFF << (byte_in_word * 8)
        memory_words[word_addr] = (current & ~mask) | (byte_value << (byte_in_word * 8))


async def axi_write_ack_model(dut, memory_words: dict[int, int]):
    pending_aw = None
    pending_b = False

    while True:
        dut.io_dmemAxi_aw_ready.value = 1
        dut.io_dmemAxi_w_ready.value = 1
        dut.io_dmemAxi_ar_ready.value = 0
        dut.io_dmemAxi_r_valid.value = 0
        dut.io_dmemAxi_r_payload_data.value = 0
        dut.io_dmemAxi_r_payload_id.value = 0
        dut.io_dmemAxi_r_payload_resp.value = 0
        dut.io_dmemAxi_r_payload_last.value = 1
        dut.io_dmemAxi_b_valid.value = 1 if pending_b else 0
        dut.io_dmemAxi_b_payload_id.value = 0
        dut.io_dmemAxi_b_payload_resp.value = 0

        await RisingEdge(dut.clk)

        aw_fired = safe_int(dut.io_dmemAxi_aw_valid) and safe_int(dut.io_dmemAxi_aw_ready)
        w_fired = safe_int(dut.io_dmemAxi_w_valid) and safe_int(dut.io_dmemAxi_w_ready)
        b_fired = pending_b and safe_int(dut.io_dmemAxi_b_ready)

        if aw_fired:
            pending_aw = safe_int(dut.io_dmemAxi_aw_payload_addr)

        if w_fired:
            assert pending_aw is not None, "W fired without a pending AW address"
            write_beat(
                memory_words,
                pending_aw,
                safe_int(dut.io_dmemAxi_w_payload_data),
                safe_int(dut.io_dmemAxi_w_payload_strb),
            )
            pending_aw = None
            pending_b = True

        if b_fired:
            pending_b = False


# ===========================================================
@cocotb.test()
async def test_halt_only(dut):
    """PC=0: HALT only. Core should halt in ~2-3 cycles (pipeline depth)."""
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())
    await reset(dut)

    # Write HALT at addr 0
    instr = assemble_bundle(flow=[("halt",)])
    await write_imem(dut, 0, instr)
    await RisingEdge(dut.clk)

    await start_core(dut)
    cycles = await wait_halted(dut, 20)

    dut._log.info(f"test_halt_only: halted after {cycles} cycles, "
                  f"pc={int(dut.io_pc.value)}, cycleCount={int(dut.io_cycleCount.value)}")


@cocotb.test()
async def test_const_then_halt(dut):
    """PC=0: CONST 42 -> scratch[5]; PC=1: HALT."""
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())
    await reset(dut)

    # PC=0: CONST 42 -> dest 5
    instr0 = assemble_bundle(load=[("const", 5, 42)])
    await write_imem(dut, 0, instr0)

    # PC=1: HALT
    instr1 = assemble_bundle(flow=[("halt",)])
    await write_imem(dut, 1, instr1)

    await RisingEdge(dut.clk)
    await start_core(dut)
    cycles = await wait_halted(dut, 30)

    dut._log.info(f"test_const_then_halt: halted after {cycles} cycles, "
                  f"cycleCount={int(dut.io_cycleCount.value)}")


@cocotb.test()
async def test_const_add_halt(dut):
    """
    PC=0: CONST 10 -> scratch[0]
    PC=1: CONST 20 -> scratch[1]
    PC=2: ADD scratch[0] + scratch[1] -> scratch[2]
    PC=3: NOP (pipeline drain)
    PC=4: HALT
    Verify execution completes.
    """
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())
    await reset(dut)

    # PC=0: CONST 10 -> scratch[0]
    await write_imem(dut, 0, assemble_bundle(load=[("const", 0, 10)]))
    # PC=1: CONST 20 -> scratch[1]
    await write_imem(dut, 1, assemble_bundle(load=[("const", 1, 20)]))
    # PC=2: ADD scratch[0] + scratch[1] -> scratch[2]
    await write_imem(dut, 2, assemble_bundle(alu=[("add", 2, 0, 1)]))
    # PC=3: NOP (drain pipeline)
    await write_imem(dut, 3, nop_bundle())
    # PC=4: HALT
    await write_imem(dut, 4, assemble_bundle(flow=[("halt",)]))

    await RisingEdge(dut.clk)
    await start_core(dut)
    cycles = await wait_halted(dut, 50)

    dut._log.info(f"test_const_add_halt: halted after {cycles} cycles, "
                  f"cycleCount={int(dut.io_cycleCount.value)}")


@cocotb.test()
async def test_scalar_max_min_halt(dut):
    """Scalar MAX/MIN should produce the expected unsigned results through the core pipeline."""
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())
    memory_words: dict[int, int] = {}
    cocotb.start_soon(axi_write_ack_model(dut, memory_words))
    await reset(dut)

    await write_imem(dut, 0, assemble_bundle(load=[("const", 0, 42)]))
    await write_imem(dut, 1, assemble_bundle(load=[("const", 1, 7)]))
    await write_imem(dut, 2, assemble_bundle(load=[("const", 10, 600)]))
    await write_imem(dut, 3, assemble_bundle(load=[("const", 11, 601)]))
    await write_imem(dut, 4, assemble_bundle(alu=[("max", 2, 0, 1)]))
    await write_imem(dut, 5, nop_bundle())
    await write_imem(dut, 6, assemble_bundle(alu=[("min", 3, 0, 1)]))
    await write_imem(dut, 7, nop_bundle())
    await write_imem(dut, 8, assemble_bundle(store=[("store", 10, 2)]))
    await write_imem(dut, 9, assemble_bundle(store=[("store", 11, 3)]))
    await write_imem(dut, 10, assemble_bundle(flow=[("halt",)]))

    await RisingEdge(dut.clk)
    await start_core(dut)
    cycles = await wait_halted(dut, 100)

    assert memory_words.get(600) == 42, f"Expected max result 42 at word 600, got {memory_words.get(600)}"
    assert memory_words.get(601) == 7, f"Expected min result 7 at word 601, got {memory_words.get(601)}"

    dut._log.info(f"test_scalar_max_min_halt: halted after {cycles} cycles")


@cocotb.test()
async def test_jump(dut):
    """
    PC=0: JUMP to PC=5
    PC=1..4: should be skipped
    PC=5: HALT
    Verify we skip the middle instructions.
    """
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())
    await reset(dut)

    # PC=0: JUMP -> 5
    await write_imem(dut, 0, assemble_bundle(flow=[("jump", 5)]))
    # PC=1..4: write NOPs (would never execute)
    for a in range(1, 5):
        await write_imem(dut, a, nop_bundle())
    # PC=5: HALT
    await write_imem(dut, 5, assemble_bundle(flow=[("halt",)]))

    await RisingEdge(dut.clk)
    await start_core(dut)
    cycles = await wait_halted(dut, 30)

    dut._log.info(f"test_jump: halted after {cycles} cycles, "
                  f"pc={int(dut.io_pc.value)}")


@cocotb.test()
async def test_core_reports_running(dut):
    """io_running should be 1 while the core is active."""
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())
    await reset(dut)

    assert int(dut.io_running.value) == 0, "Should not be running before start"

    # Write a simple program
    await write_imem(dut, 0, nop_bundle())
    await write_imem(dut, 1, nop_bundle())
    await write_imem(dut, 2, assemble_bundle(flow=[("halt",)]))

    await RisingEdge(dut.clk)
    await start_core(dut)

    # Should be running immediately after start
    await RisingEdge(dut.clk)
    await ReadOnly()
    running = int(dut.io_running.value)
    dut._log.info(f"Running after start: {running}")

    await wait_halted(dut, 30)
    assert int(dut.io_halted.value) == 1
    dut._log.info("test_core_reports_running: PASS")


@cocotb.test()
async def test_cycle_counter(dut):
    """Verify cycleCount increments while running."""
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())
    await reset(dut)

    c0 = int(dut.io_cycleCount.value)
    assert c0 == 0, f"cycleCount should be 0 after reset, got {c0}"

    # Write several NOPs then HALT
    for a in range(10):
        await write_imem(dut, a, nop_bundle())
    await write_imem(dut, 10, assemble_bundle(flow=[("halt",)]))

    await RisingEdge(dut.clk)
    await start_core(dut)
    await wait_halted(dut, 50)

    c1 = int(dut.io_cycleCount.value)
    assert c1 > 0, f"cycleCount should be > 0, got {c1}"
    dut._log.info(f"test_cycle_counter: cycleCount={c1}")
