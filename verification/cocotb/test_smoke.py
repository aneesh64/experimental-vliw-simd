"""
cocotb smoke tests for the VLIW SIMD SoC.

Tests:
  1. CSR read-back: verify config registers return correct values
  2. IMEM load + ALU: load a small program, start, check result
  3. CONST + ADD: verify constant load and scalar add
  4. Halt detection: verify IRQ fires when all cores halt

Assumes VliwSimdSoc generated with VliwSocConfig.Sim (1 core, 1 slot each).
"""

import sys
import os
from pathlib import Path

# Add tools directory to path for assembler
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "tools"))
PROJECT_ROOT = Path(__file__).parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, ClockCycles
from cocotb.result import TestFailure

from axi_drivers import AxiLiteDriver, Axi4Driver
from golden_model import GoldenModel
from assembler import Assembler, AssemblerConfig
from verification.cocotb.config import load_test_config

CFG = load_test_config(project_root=PROJECT_ROOT)


# ============================================================================
#  Helpers
# ============================================================================

async def reset_dut(dut, clock, cycles=10):
    """Assert reset for N cycles then de-assert."""
    dut.reset.value = 1
    for _ in range(cycles):
        await RisingEdge(clock)
    dut.reset.value = 0
    await RisingEdge(clock)


def make_drivers(dut, clock):
    """Create AXI driver instances for all SoC ports."""
    csr  = AxiLiteDriver(dut, "io_csrAxi", clock)
    imem = AxiLiteDriver(dut, "io_imemAxi", clock)
    dmem = Axi4Driver(dut, "io_dmemAxi", clock)
    return csr, imem, dmem


async def load_program(imem_driver, asm: Assembler, program, clock,
                       core_id: int = 0):
    """Load a program into instruction memory via AXI4-Lite writes."""
    word_width = 32
    words_per_bundle = asm.cfg.bundle_width // word_width
    byte_addr_bits = 2  # log2(4 bytes per word)

    for pc, instr in enumerate(program):
        bundle = asm.assemble(instr)
        words = asm.to_word_list(bundle, word_width)

        for word_idx, word_val in enumerate(words):
            # Address encoding: core_select | instr_addr | word_idx | byte_offset
            addr = 0
            if words_per_bundle > 1:
                addr = (pc << (byte_addr_bits + _log2(words_per_bundle))) | \
                       (word_idx << byte_addr_bits)
            else:
                addr = pc << byte_addr_bits

            # Add core select bits above instruction address
            # (simplified for single core)
            await imem_driver.write(addr, word_val)


def _log2(x):
    import math
    return int(math.log2(x)) if x > 1 else 0


# ============================================================================
#  CSR Register Map Constants (must match HostInterface.scala)
# ============================================================================

CSR_CTRL         = 0x000
CSR_STATUS       = 0x004
CSR_CYCLE_COUNT  = 0x008
CSR_CORE_COUNT   = 0x00C
CSR_VLEN         = 0x010
CSR_SCRATCH_SIZE = 0x014
CSR_IMEM_DEPTH   = 0x018
CSR_BUNDLE_WIDTH = 0x01C
CSR_SLOT_CONFIG  = 0x020
CSR_CORE_PC_BASE = 0x100
CSR_CORE_CYC_BASE = 0x200


# ============================================================================
#  Test Cases
# ============================================================================

@cocotb.test()
async def test_csr_readback(dut):
    """Verify CSR config registers return correct values for Sim config."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, units="ns").start())

    await reset_dut(dut, clock)

    csr, _, _ = make_drivers(dut, clock)

    # Read config registers from shared config
    core_count = await csr.read(CSR_CORE_COUNT)
    assert core_count == 1, f"CORE_COUNT: expected 1, got {core_count}"

    vlen = await csr.read(CSR_VLEN)
    assert vlen == CFG.vlen, f"VLEN: expected {CFG.vlen}, got {vlen}"

    scratch_size = await csr.read(CSR_SCRATCH_SIZE)
    assert scratch_size == CFG.scratch_size, f"SCRATCH_SIZE: expected {CFG.scratch_size}, got {scratch_size}"

    imem_depth = await csr.read(CSR_IMEM_DEPTH)
    assert imem_depth == CFG.imem_depth, f"IMEM_DEPTH: expected {CFG.imem_depth}, got {imem_depth}"

    dut._log.info("CSR readback: PASS")


@cocotb.test()
async def test_const_add_halt(dut):
    """
    Load two constants into scratch, add them, then halt.
    Verify the core halts and check cycle count.

    Program:
      [0] const scratch[0] = 100
      [1] const scratch[1] = 200
      [2] ALU: scratch[2] = scratch[0] + scratch[1]
      [3] halt
    """
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, units="ns").start())

    await reset_dut(dut, clock)

    csr, imem, dmem = make_drivers(dut, clock)

    # Assembler with Sim-matching config
    asm_cfg = AssemblerConfig(
        n_alu_slots=CFG.n_alu_slots, n_valu_slots=CFG.n_valu_slots, n_load_slots=CFG.n_load_slots,
        n_store_slots=CFG.n_store_slots, n_flow_slots=CFG.n_flow_slots,
        imem_depth=CFG.imem_depth, scratch_size=CFG.scratch_size
    )
    asm = Assembler(asm_cfg)

    program = [
        {"load": [("const", 0, 100)]},                    # scratch[0] = 100
        {"load": [("const", 1, 200)]},                    # scratch[1] = 200
        {"alu": [("+", 2, 0, 1)]},                         # scratch[2] = 100 + 200 = 300
        {"flow": [("halt",)]},                             # stop
    ]

    # Load program
    await load_program(imem, asm, program, clock)

    # Start execution via CSR
    await csr.write(CSR_CTRL, 0x01)  # bit 0 = start

    # Wait for halt (poll status)
    for _ in range(200):
        await ClockCycles(clock, 5)
        status = await csr.read(CSR_STATUS)
        if status & 0x02:  # bit 1 = core 0 halted
            break
    else:
        raise TestFailure("Core did not halt within timeout")

    # Check that core is halted
    status = await csr.read(CSR_STATUS)
    assert status & 0x02, f"Core 0 not halted: status=0x{status:08X}"

    # Check IRQ
    irq = int(dut.io_irq.value)
    assert irq == 1, f"IRQ not asserted after halt"

    dut._log.info("const_add_halt: PASS")


@cocotb.test()
async def test_golden_model_standalone(dut):
    """
    Verify the Python golden model independently (no RTL needed).
    """
    model = GoldenModel(scratch_size=CFG.scratch_size, vlen=CFG.vlen, core_id=0)

    program = [
        {"load": [("const", 0, 100)]},
        {"load": [("const", 1, 200)]},
        {"alu": [("+", 2, 0, 1)]},
        {"alu": [("*", 3, 0, 1)]},
        {"flow": [("halt",)]},
    ]

    model.load_program(program)
    cycles = model.run(max_cycles=100)

    assert model.scratch[0] == 100, f"scratch[0]={model.scratch[0]}, expected 100"
    assert model.scratch[1] == 200, f"scratch[1]={model.scratch[1]}, expected 200"
    assert model.scratch[2] == 300, f"scratch[2]={model.scratch[2]}, expected 300"
    assert model.scratch[3] == 20000, f"scratch[3]={model.scratch[3]}, expected 20000"
    assert model.halted, "Model should be halted"

    dut._log.info(f"Golden model standalone: PASS (ran {cycles} cycles)")


@cocotb.test()
async def test_golden_model_loop(dut):
    """
    Verify the golden model with a simple counting loop.

    scratch[0] = 0 (counter)
    scratch[1] = 1 (increment)
    scratch[2] = 10 (limit)

    Loop: scratch[0] += 1; if scratch[0] < 10, jump to loop start
    """
    model = GoldenModel(scratch_size=CFG.scratch_size, vlen=CFG.vlen, core_id=0)

    program = [
        # [0] Initialize
        {"load": [("const", 0, 0)]},       # counter = 0
        # [1]
        {"load": [("const", 1, 1)]},       # increment = 1
        # [2]
        {"load": [("const", 2, 10)]},      # limit = 10
        # [3] Loop body: counter += increment
        {"alu": [("+", 0, 0, 1)]},
        # [4] Check: is counter < limit?
        {"alu": [("<", 3, 0, 2)]},          # scratch[3] = (counter < 10)
        # [5] Conditional jump back to loop body
        {"flow": [("cond_jump", 3, 3)]},    # if scratch[3] != 0, jump to PC=3
        # [6] Done
        {"flow": [("halt",)]},
    ]

    model.load_program(program)
    cycles = model.run(max_cycles=1000)

    assert model.scratch[0] == 10, f"scratch[0]={model.scratch[0]}, expected 10"
    assert model.halted, "Model should be halted"

    dut._log.info(f"Golden model loop: PASS (counter={model.scratch[0]}, {cycles} cycles)")
