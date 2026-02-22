"""
Minimal diagnostic test for load writeback.
Runs a simple LOAD → STORE program and traces key signals cycle-by-cycle.
"""
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).parents[3]
for p in [str(PROJECT_ROOT), str(PROJECT_ROOT / "tools"), str(Path(__file__).parent)]:
    if p not in sys.path:
        sys.path.insert(0, p)

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from assembler import Assembler, AssemblerConfig
from scheduler import VliwScheduler, SchedulerConfig
from harness import VliwCoreHarness
from verification.cocotb.config import load_test_config

CFG = load_test_config(project_root=PROJECT_ROOT)
S = VliwScheduler(SchedulerConfig(
    n_alu_slots=CFG.n_alu_slots, n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots, n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots, mem_post_gap=CFG.mem_post_gap
))
ASM = Assembler(AssemblerConfig(
    n_alu_slots=CFG.n_alu_slots, n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots, n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots, vlen=CFG.vlen,
    scratch_size=CFG.scratch_size, imem_depth=CFG.imem_depth
))


def build_program(ops):
    return ASM.assemble_program(S.schedule(ops))


@cocotb.test()
async def test_loop_load_trace(dut):
    """
    Minimal 3-iteration loop with loads, tracing AXI and writeback signals.
    Diagnoses whether repeated loads in a loop cause deadlock.
    """
    harness = VliwCoreHarness(dut)

    data = [((i * 7 + 3) & 0xFF) for i in range(8)]
    harness.axi_mem.preload(0, data)
    await harness.init()

    program = build_program([
        S.const(0, 0),          # acc
        S.const(10, 0),         # addr
        S.const(11, 0),         # idx
        S.const(12, 3),         # limit = 3 iterations
        S.const(13, 1),
        S.const(20, 0),
        S.label("loop"),
        S.load(1, 10),
        S.add_imm(20, 20, 0),
        S.add(0, 0, 1),
        S.add_imm(10, 10, 1),
        S.add(11, 11, 13),
        S.lt(14, 11, 12),
        S.cond_jump(14, "loop"),
        S.const(15, 500),
        S.store(15, 0),
        S.halt(),
    ])

    await harness.load_program(program)
    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0

    cycle = 0
    for i in range(300):
        await RisingEdge(dut.clk)
        cycle += 1

        try:
            halted = int(dut.io_halted.value)
        except ValueError:
            halted = 0

        signals = {}
        for sig_name in [
            "io_dmemAxi_ar_valid", "io_dmemAxi_ar_ready", "io_dmemAxi_ar_payload_addr",
            "io_dmemAxi_r_valid", "io_dmemAxi_r_ready",
            "mem_io_loadWriteReqs_0_valid", "mem_io_loadWriteReqs_0_payload_addr",
            "io_pc",
            "mem_io_valid",
            "loadReqFifo_io_push_valid",
            "memProcessed",
            "anyMemOp",
            "anyMemOpNew",
            "exSlotsReg_valid",
        ]:
            try:
                signals[sig_name] = int(getattr(dut, sig_name).value)
            except Exception:
                signals[sig_name] = -1

        ar_v = signals.get("io_dmemAxi_ar_valid", 0)
        ar_r = signals.get("io_dmemAxi_ar_ready", 0)
        r_v  = signals.get("io_dmemAxi_r_valid", 0)
        r_rdy = signals.get("io_dmemAxi_r_ready", -1)
        lwr_v = signals.get("mem_io_loadWriteReqs_0_valid", 0)
        lwr_a = signals.get("mem_io_loadWriteReqs_0_payload_addr", 0)
        pc = signals.get("io_pc", 0)
        mem_valid = signals.get("mem_io_valid", -1)
        push_v = signals.get("loadReqFifo_io_push_valid", -1)
        mp = signals.get("memProcessed", -1)
        amo = signals.get("anyMemOp", -1)
        amn = signals.get("anyMemOpNew", -1)
        exv = signals.get("exSlotsReg_valid", -1)

        # Always log first 80 cycles, then only interesting
        if cycle <= 80 or ar_v or ar_r or r_v or lwr_v or halted:
            dut._log.info(f"C{cycle:4d}: pc={pc} exV={exv} memV={mem_valid} amo={amo} mp={mp} amn={amn} push={push_v} | AR=({ar_v},{ar_r}) R=({r_v},rdy={r_rdy}) | loadWR=({lwr_v},{lwr_a}) | halt={halted}")

        if halted:
            dut._log.info(f"Halted at cycle {cycle}")
            break

    val = harness.axi_mem.read_word(500)
    expected = sum(data[:3]) & 0xFFFFFFFF
    dut._log.info(f"Result={val}, expected={expected}")
    assert val == expected, f"Expected {expected}, got {val}"


@cocotb.test()
async def test_load_writeback_trace(dut):
    """
    Minimal test: CONST 42 → store to mem[0], load back, store to mem[256].
    Traces key signals every cycle to diagnose load writeback.
    """
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 42),
        S.const(1, 0),
        S.store(1, 0),          # mem[0] = 42
        S.const(30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.load(3, 1),           # s[3] = mem[0] = 42
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.const(5, 256),
        S.store(5, 3),          # mem[256] = s[3]
        S.halt(),
    ])

    await harness.load_program(program)

    # Manual run with signal tracing
    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0

    cycle = 0
    for i in range(200):
        await RisingEdge(dut.clk)
        cycle += 1

        # Read key signals
        try:
            halted = int(dut.io_halted.value)
        except ValueError:
            halted = 0
        try:
            running = int(dut.io_running.value)
        except ValueError:
            running = 0

        # Try to read key diagnostic signals
        signals = {}
        for sig_name in [
            # Load writeback
            "mem_io_loadWriteReqs_0_valid",
            "mem_io_loadWriteReqs_0_payload_addr",
            "mem_io_loadWriteReqs_0_payload_data",
            "wbLoadWrites_0_valid",
            # AXI R channel
            "io_dmemAxi_r_valid",
            "io_dmemAxi_r_payload_data",
            "io_dmemAxi_r_payload_id",
            # AXI AR channel
            "io_dmemAxi_ar_valid",
            "io_dmemAxi_ar_ready",
            "io_dmemAxi_ar_payload_addr",
            # Scratch write en 9
            "wb_io_scratchWriteEn_9",
            # PC for orientation
            "io_pc",
        ]:
            try:
                sig = getattr(dut, sig_name)
                signals[sig_name] = int(sig.value)
            except Exception:
                signals[sig_name] = "N/A"

        # Log cycles where interesting signals fire (or every 5th cycle for orientation)
        r_valid = signals.get("io_dmemAxi_r_valid", 0)
        ar_valid = signals.get("io_dmemAxi_ar_valid", 0)
        ar_ready = signals.get("io_dmemAxi_ar_ready", 0)
        lwr_valid = signals.get("mem_io_loadWriteReqs_0_valid", 0)
        wb_valid = signals.get("wbLoadWrites_0_valid", 0)
        scrwr9 = signals.get("wb_io_scratchWriteEn_9", 0)

        if (lwr_valid == 1 or wb_valid == 1 or scrwr9 == 1 or
                r_valid == 1 or (ar_valid == 1 and ar_ready == 1) or
                halted == 1 or cycle <= 25 or (cycle % 10 == 0)):
            dut._log.info(
                f"C{cycle:3d}: pc={signals.get('io_pc')} run={running} halt={halted} | "
                f"AR=({ar_valid},{ar_ready},addr={signals.get('io_dmemAxi_ar_payload_addr')}) "
                f"R=(v={r_valid},d={signals.get('io_dmemAxi_r_payload_data')}) | "
                f"loadWR=({lwr_valid},{signals.get('mem_io_loadWriteReqs_0_payload_addr')},{signals.get('mem_io_loadWriteReqs_0_payload_data')}) "
                f"wbLoad={wb_valid} scrWrEn9={scrwr9}"
            )

        if halted == 1:
            dut._log.info(f"Halted at cycle {cycle}")
            for _ in range(20):
                await RisingEdge(dut.clk)
            harness.axi_mem.stop()
            break

    val0 = harness.axi_mem.read_word(0)
    val256 = harness.axi_mem.read_word(256)
    dut._log.info(f"AXI mem[0]={val0}, mem[256]={val256}")
    assert val0 == 42, f"Store: expected 42, got {val0}"
    assert val256 == 42, f"Load-store: expected 42, got {val256}"
