"""Minimal debug test to trace VliwCore execution through integration harness."""
import os
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))
if str(PROJECT_ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "tools"))
if str(Path(__file__).parent) not in sys.path:
    sys.path.insert(0, str(Path(__file__).parent))

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
from assembler import Assembler, AssemblerConfig
from scheduler import VliwScheduler, SchedulerConfig
from harness import VliwCoreHarness
from verification.cocotb.config import load_test_config

CFG = load_test_config(project_root=PROJECT_ROOT)
N_ALU_SLOTS = CFG.n_alu_slots
N_VALU_SLOTS = CFG.n_valu_slots
N_LOAD_SLOTS = CFG.n_load_slots
N_STORE_SLOTS = CFG.n_store_slots
N_FLOW_SLOTS = CFG.n_flow_slots

ASM = Assembler(AssemblerConfig(
    n_alu_slots=N_ALU_SLOTS, n_valu_slots=N_VALU_SLOTS, n_load_slots=N_LOAD_SLOTS,
    n_store_slots=N_STORE_SLOTS, n_flow_slots=N_FLOW_SLOTS, vlen=CFG.vlen,
    scratch_size=CFG.scratch_size, imem_depth=CFG.imem_depth
))

S = VliwScheduler(SchedulerConfig(
    n_alu_slots=N_ALU_SLOTS, n_valu_slots=N_VALU_SLOTS, n_load_slots=N_LOAD_SLOTS,
    n_store_slots=N_STORE_SLOTS, n_flow_slots=N_FLOW_SLOTS,
    mem_post_gap=CFG.mem_post_gap
))


def build_program(ops, verbose=False):
    bundles_dicts = S.schedule(ops, verbose=verbose)
    return ASM.assemble_program(bundles_dicts)


@cocotb.test()
async def test_debug_halt_only(dut):
    """Minimal HALT — should halt in a few cycles."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([S.halt()], verbose=True)
    dut._log.info(f"Program has {len(program)} bundles")
    for i, b in enumerate(program):
        dut._log.info(f"  PC {i}: {b:#066x}")

    await harness.load_program(program)

    # Manually trace instead of calling run()
    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0

    for i in range(30):
        await RisingEdge(dut.clk)
        pc = int(dut.io_pc.value)
        halted = int(dut.io_halted.value)
        running = int(dut.io_running.value)
        dut._log.info(f"  cycle {i}: pc={pc} running={running} halted={halted}")
        if halted:
            dut._log.info(f"Halted after {i+1} cycles!")
            return

    raise AssertionError("Did not halt within 30 cycles")


@cocotb.test()
async def test_debug_const_halt(dut):
    """CONST + HALT — should halt in a few cycles."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([S.const(0, 42), S.halt()], verbose=True)
    dut._log.info(f"Program has {len(program)} bundles")
    for i, b in enumerate(program):
        dut._log.info(f"  PC {i}: {b:#066x}")

    await harness.load_program(program)

    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0

    for i in range(30):
        await RisingEdge(dut.clk)
        pc = int(dut.io_pc.value)
        halted = int(dut.io_halted.value)
        running = int(dut.io_running.value)
        dut._log.info(f"  cycle {i}: pc={pc} running={running} halted={halted}")
        if halted:
            dut._log.info(f"Halted after {i+1} cycles!")
            return

    raise AssertionError("Did not halt within 30 cycles")


@cocotb.test()
async def test_debug_const_store_halt(dut):
    """CONST + STORE + HALT — tests AXI interaction."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 42),
        S.const(1, 0),
        S.store(1, 0),
        S.halt(),
    ], verbose=True)
    dut._log.info(f"Program has {len(program)} bundles")
    for i, b in enumerate(program):
        dut._log.info(f"  PC {i}: {b:#066x}")

    await harness.load_program(program)

    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0

    for i in range(200):
        await RisingEdge(dut.clk)
        pc = int(dut.io_pc.value)
        halted = int(dut.io_halted.value)
        running = int(dut.io_running.value)
        # AXI traffic
        aw_valid = int(dut.io_dmemAxi_aw_valid.value)
        aw_ready = int(dut.io_dmemAxi_aw_ready.value)
        w_valid = int(dut.io_dmemAxi_w_valid.value)
        w_ready = int(dut.io_dmemAxi_w_ready.value)
        b_valid = int(dut.io_dmemAxi_b_valid.value)
        b_ready = int(dut.io_dmemAxi_b_ready.value)
        # Internal stall + store debug
        try:
            mem_stall = int(dut.mem.io_stall.value)
        except Exception:
            mem_stall = -1
        try:
            w_data = int(dut.io_dmemAxi_w_payload_data.value)
        except Exception:
            w_data = -1
        try:
            aw_addr = int(dut.io_dmemAxi_aw_payload_addr.value)
        except Exception:
            aw_addr = -1
        try:
            ex_store_valid = int(dut.exSlotsReg_storeSlots_0_valid.value)
        except Exception:
            ex_store_valid = -1
        try:
            mem_state = int(dut.mem.state.value)
        except Exception:
            mem_state = -1
        try:
            ex_store_addr = int(dut.exSlotsReg_storeSlots_0_addrReg.value)
        except Exception:
            ex_store_addr = -1
        try:
            ex_store_src = int(dut.exSlotsReg_storeSlots_0_srcReg.value)
        except Exception:
            ex_store_src = -1
        try:
            # The capStoreData register inside MemEngine
            cap_store = int(dut.mem.capStoreData.value)
        except Exception:
            cap_store = -1
        try:
            cap_addr_val = int(dut.mem.capAddr.value)
        except Exception:
            cap_addr_val = -1

        if aw_valid or w_valid or b_valid or halted or i < 20 or mem_stall:
            dut._log.info(
                f"  cycle {i}: pc={pc} stall={mem_stall} "
                f"sV={ex_store_valid} aR={ex_store_addr} sR={ex_store_src} "
                f"capA={cap_addr_val:#x} capD={cap_store:#x} mSt={mem_state} "
                f"AW={aw_valid}/{aw_ready}@{aw_addr:#x} W={w_valid}/{w_ready}={w_data:#x} B={b_valid}/{b_ready}")
        if halted:
            result = harness.axi_mem.read_word(0)
            dut._log.info(f"Halted after {i+1} cycles! mem[0]={result}")
            assert result == 42
            return

    raise AssertionError("Did not halt within 200 cycles")


@cocotb.test()
async def test_debug_add_sub(dut):
    """ADD+SUB with two stores — trace detailed pipeline."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 100),
        S.const(1, 200),
        S.add(2, 0, 1),          # s[2] = 300
        S.const(3, 50),
        S.sub(4, 2, 3),          # s[4] = 250
        S.const(10, 0),          # addr = 0
        S.store(10, 2),          # mem[0] = 300
        S.add_imm(10, 10, 1),    # addr = 1
        S.store(10, 4),          # mem[1] = 250
        S.halt(),
    ], verbose=True)

    dut._log.info(f"add_sub: {len(program)} bundles")
    await harness.load_program(program)

    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0

    for i in range(100):
        await RisingEdge(dut.clk)
        pc = int(dut.io_pc.value)
        halted = int(dut.io_halted.value)
        running = int(dut.io_running.value)
        try:
            mem_stall = int(dut.mem.io_stall.value)
        except Exception:
            mem_stall = -1
        try:
            aw_valid = int(dut.io_dmemAxi_aw_valid.value)
            w_valid = int(dut.io_dmemAxi_w_valid.value)
            b_valid = int(dut.io_dmemAxi_b_valid.value)
        except Exception:
            aw_valid = w_valid = b_valid = 0
        try:
            flow_halt = int(dut.flow.io_halt.value)
        except Exception:
            flow_halt = -1

        if i < 40 or halted or mem_stall or aw_valid or w_valid or b_valid:
            dut._log.info(
                f"  [{i:3d}] pc={pc:2d} run={running} halt={halted} "
                f"stall={mem_stall} fH={flow_halt} "
                f"AW={aw_valid} W={w_valid} B={b_valid}")
        if halted:
            m0 = harness.axi_mem.read_word(0)
            m1 = harness.axi_mem.read_word(1)
            dut._log.info(f"Halted after {i+1} cycles! mem[0]={m0} mem[1]={m1}")
            assert m0 == 300, f"Expected 300, got {m0}"
            assert m1 == 250, f"Expected 250, got {m1}"
            return

    raise AssertionError("Did not halt within 100 cycles")


