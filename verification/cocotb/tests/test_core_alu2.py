"""Focused dual-ALU VliwCore regressions.

These tests intentionally run only under the 2-ALU configuration and verify
architectural results, not just halt behavior. The goal is to catch regressions
where both ALU slots compute but one or both writebacks disappear before they
become visible through later stores.
"""

from pathlib import Path
import os
import sys

import cocotb

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))
if str(PROJECT_ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "tools"))
INTEGRATION_DIR = PROJECT_ROOT / "verification" / "cocotb" / "integration"
if str(INTEGRATION_DIR) not in sys.path:
    sys.path.insert(0, str(INTEGRATION_DIR))

from assembler import Assembler, AssemblerConfig
from verification.cocotb.config import load_test_config
from verification.cocotb.integration.harness import VliwCoreHarness

_ALU2_DEFAULT = PROJECT_ROOT / "verification" / "config" / "test_config_alu2.properties"
_active_cfg = load_test_config(project_root=PROJECT_ROOT)
CFG = _active_cfg if _active_cfg.n_alu_slots >= 2 else load_test_config(config_path=_ALU2_DEFAULT, project_root=PROJECT_ROOT)
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


def _bundle(**engines):
    return ASM.assemble({name: ops for name, ops in engines.items() if ops})


def _nop():
    return ASM.assemble({})


def _require_dual_alu():
    assert CFG.n_alu_slots >= 2, "Dual-ALU regression requires slots.alu >= 2"


@cocotb.test()
async def test_dual_alu_parallel_writeback_large_and_small_results(dut):
    """Two ALU writes in one bundle must both survive to later scalar stores."""
    _require_dual_alu()

    harness = VliwCoreHarness(dut, clock_period_ns=CFG.clock_period_ns)
    await harness.init()

    program = [
        _bundle(load=[("const", 0, 0x7FFFFFFF)]),
        _bundle(load=[("const", 1, 1)]),
        _bundle(load=[("const", 2, 20)]),
        _bundle(load=[("const", 3, 40)]),
        _bundle(load=[("const", 10, 256)]),
        _bundle(load=[("const", 11, 257)]),
        _nop(),
        _bundle(alu=[("add", 4, 0, 1), ("add", 5, 2, 3)]),
        _nop(),
        _nop(),
        _bundle(store=[("store", 10, 4)]),
        _bundle(store=[("store", 11, 5)]),
        _nop(),
        _nop(),
        _bundle(flow=[("halt",)]),
    ]

    await harness.load_program(program)
    await harness.run(max_cycles=4000)

    assert harness.axi_mem.read_word(256) == 0x80000000, (
        f"Expected dual-ALU large-value writeback 0x80000000, got 0x{harness.axi_mem.read_word(256):08X}"
    )
    assert harness.axi_mem.read_word(257) == 60, (
        f"Expected second dual-ALU writeback 60, got 0x{harness.axi_mem.read_word(257):08X}"
    )


@cocotb.test()
async def test_dual_alu_chained_writeback_sequence(dut):
    """Results written by both ALU slots must remain usable as operands in later bundles."""
    _require_dual_alu()

    harness = VliwCoreHarness(dut, clock_period_ns=CFG.clock_period_ns)
    await harness.init()

    program = [
        _bundle(load=[("const", 0, 10)]),
        _bundle(load=[("const", 1, 20)]),
        _bundle(load=[("const", 2, 30)]),
        _bundle(load=[("const", 3, 40)]),
        _bundle(load=[("const", 6, 5)]),
        _bundle(load=[("const", 10, 300)]),
        _bundle(load=[("const", 11, 301)]),
        _nop(),
        _bundle(alu=[("add", 4, 0, 1), ("add", 5, 2, 3)]),
        _nop(),
        _nop(),
        _bundle(alu=[("add", 4, 4, 6), ("add", 5, 5, 6)]),
        _nop(),
        _nop(),
        _bundle(store=[("store", 10, 4)]),
        _bundle(store=[("store", 11, 5)]),
        _nop(),
        _nop(),
        _bundle(flow=[("halt",)]),
    ]

    await harness.load_program(program)
    await harness.run(max_cycles=4000)

    assert harness.axi_mem.read_word(300) == 35, (
        f"Expected chained dual-ALU result 35, got 0x{harness.axi_mem.read_word(300):08X}"
    )
    assert harness.axi_mem.read_word(301) == 75, (
        f"Expected chained dual-ALU result 75, got 0x{harness.axi_mem.read_word(301):08X}"
    )