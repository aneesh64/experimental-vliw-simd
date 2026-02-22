"""
Configuration-portable integration tests for slot matrix sweeps.
Designed to run reliably across varying ALU/VALU slot counts.
"""

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
from assembler import Assembler, AssemblerConfig
from scheduler import VliwScheduler, SchedulerConfig
from harness import VliwCoreHarness
from verification.cocotb.config import load_test_config

CFG = load_test_config(project_root=PROJECT_ROOT)

ASM = Assembler(AssemblerConfig(
    n_alu_slots=CFG.n_alu_slots,
    n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots,
    n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots,
    vlen=CFG.vlen,
    scratch_size=CFG.scratch_size,
    imem_depth=CFG.imem_depth,
))

S = VliwScheduler(SchedulerConfig(
    n_alu_slots=CFG.n_alu_slots,
    n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots,
    n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots,
    mem_post_gap=CFG.mem_post_gap,
))


def build_program(ops, verbose=False):
    bundles_dicts = S.schedule(ops, verbose=verbose)
    return ASM.assemble_program(bundles_dicts)


@cocotb.test()
async def test_cfg_halt_sanity(dut):
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([S.halt()])
    await harness.load_program(program)
    cycles = await harness.run(max_cycles=200)

    assert cycles > 0


@cocotb.test()
async def test_cfg_scalar_arithmetic(dut):
    harness = VliwCoreHarness(dut)
    await harness.init()

    # ((20 + 22) * 3) = 126
    program = build_program([
        S.const(0, 20),
        S.const(1, 22),
        S.const(2, 3),
        S.add(3, 0, 1),
        S.mul(4, 3, 2),
        S.const(10, 1200),
        S.store(10, 4),
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=2000)

    got = harness.axi_mem.read_word(1200)
    assert got == 126, f"Expected 126, got {got}"


@cocotb.test()
async def test_cfg_short_loop(dut):
    harness = VliwCoreHarness(dut)
    await harness.init()

    # sum(1..16)=136
    program = build_program([
        S.const(0, 0),
        S.const(1, 1),
        S.const(2, 17),
        S.const(3, 1),
        S.label("loop"),
        S.add(0, 0, 1),
        S.add(1, 1, 3),
        S.lt(4, 1, 2),
        S.cond_jump(4, "loop"),
        S.const(10, 1201),
        S.store(10, 0),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=8000)

    got = harness.axi_mem.read_word(1201)
    assert got == 136, f"Expected 136, got {got}"
    assert cycles >= 20
