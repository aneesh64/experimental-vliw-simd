"""
cocotb smoke tests for the VLIW SIMD SoC.

Tests:
  1. CSR read-back: verify config registers return correct values
  2. IMEM loader: verify DDR→IMEM DMA via CSR
  3. CONST + ADD + HALT: load program from DDR, start, verify halt + IRQ
  4. Core restart: halt, restart, verify second halt
  5. Golden model (standalone): pure Python model check
  6. Golden model (loop): pure Python model with branching
  7. Core DMEM scalar roundtrip: core loads/stores through DDR

Assumes VliwSimdSoc generated with VliwSocConfig.Sim (1 core, 1 slot each).
The SoC exposes two external interfaces:
  - io_csrAxi  : AXI4-Lite slave (host CSR access)
  - io_dmemAxi : AXI4 master     (DDR access for data + IMEM loading)

Programs and data live in DDR (simulated by Axi4MemoryModel).
The host triggers the hardware IMEM loader via CSR to DMA instruction
bundles from DDR into on-chip IMEM before starting execution.
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
from cocotb.triggers import RisingEdge, ClockCycles, ReadOnly, NextTimeStep

from axi_drivers import AxiLiteDriver
from golden_model import GoldenModel
from assembler import Assembler, AssemblerConfig
from verification.cocotb.config import load_test_config, bundle_width_bits
from verification.cocotb.integration.axi_mem_model import Axi4MemoryModel

CFG = load_test_config(project_root=PROJECT_ROOT)


# ============================================================================
#  Constants
# ============================================================================

# AXI beat geometry (512-bit bus → 64 bytes → 16 × 32-bit words per beat)
AXI_DATA_BYTES   = 64
WORDS_PER_BEAT   = AXI_DATA_BYTES // 4

# DDR memory model size (32-bit words)
DDR_MEM_WORDS    = 65536

# DDR layout:  program bundles stored above the data region
PROG_DDR_BYTE_BASE = 0x10000   # 64 KB offset
PROG_DDR_WORD_BASE = PROG_DDR_BYTE_BASE // 4

# Bundle geometry (derived from config)
BUNDLE_WIDTH = bundle_width_bits(
    CFG.n_alu_slots, CFG.n_valu_slots, CFG.n_load_slots,
    CFG.n_store_slots, CFG.n_flow_slots, CFG.n_matrix_slots,
)
WORDS_PER_BUNDLE = BUNDLE_WIDTH // 32


# ============================================================================
#  CSR Register Map Constants (must match HostInterface.scala)
# ============================================================================

CSR_CTRL              = 0x000
CSR_STATUS            = 0x004
CSR_CYCLE_COUNT       = 0x008
CSR_CORE_COUNT        = 0x00C
CSR_VLEN              = 0x010
CSR_SCRATCH_SIZE      = 0x014
CSR_IMEM_DEPTH        = 0x018
CSR_BUNDLE_WIDTH      = 0x01C
CSR_SLOT_CONFIG       = 0x020
CSR_IMEM_SRC_ADDR     = 0x030
CSR_IMEM_BUNDLE_COUNT = 0x034
CSR_IMEM_STATUS       = 0x038
CSR_CORE_PC_BASE      = 0x100
CSR_CORE_CYC_BASE     = 0x200

CTRL_START = 0x01
CTRL_RESET = 0x02
CTRL_LOAD  = 0x04


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


def make_csr_driver(dut, clock):
    """Create AXI-Lite driver for the CSR port."""
    return AxiLiteDriver(dut, "io_csrAxi", clock)


def make_ddr_model(dut, latency=0):
    """Create an AXI4 slave memory model attached to the DDR master port."""
    return Axi4MemoryModel(dut, prefix="io_dmemAxi",
                           mem_words=DDR_MEM_WORDS, latency=latency)


def _set_axilite_master_defaults(dut, prefix: str):
    for name, value in (
        ("aw_valid", 0),
        ("aw_payload_addr", 0),
        ("aw_payload_prot", 0),
        ("w_valid", 0),
        ("w_payload_data", 0),
        ("w_payload_strb", 0),
        ("b_ready", 0),
        ("ar_valid", 0),
        ("ar_payload_addr", 0),
        ("ar_payload_prot", 0),
        ("r_ready", 0),
    ):
        getattr(dut, f"{prefix}_{name}").value = value


def _set_axi4_slave_defaults(dut, prefix: str):
    """Set default values on slave-side AXI4 signals (testbench drives these)."""
    for name, value in (
        ("ar_ready", 0),
        ("r_valid", 0),
        ("r_payload_data", 0),
        ("r_payload_resp", 0),
        ("r_payload_id", 0),
        ("r_payload_last", 0),
        ("aw_ready", 0),
        ("w_ready", 0),
        ("b_valid", 0),
        ("b_payload_resp", 0),
        ("b_payload_id", 0),
    ):
        getattr(dut, f"{prefix}_{name}").value = value


def _initialize_host_interfaces(dut):
    """Set all AXI port signals to safe defaults before reset."""
    _set_axilite_master_defaults(dut, "io_csrAxi")
    _set_axi4_slave_defaults(dut, "io_dmemAxi")


def _sig_int(dut, name: str):
    signal = getattr(dut, name, None)
    if signal is None:
        return None
    try:
        return int(signal.value)
    except ValueError:
        return str(signal.value)


def _soc_axi_debug_snapshot(dut) -> str:
    signal_names = (
        "cores_0_io_dmemAxi_aw_valid",
        "memSub_io_corePorts_0_aw_ready",
        "cores_0_io_dmemAxi_w_valid",
        "memSub_io_corePorts_0_w_ready",
        "memSub_io_corePorts_0_b_valid",
        "cores_0_io_dmemAxi_b_ready",
        "io_dmemAxi_aw_valid",
        "io_dmemAxi_aw_ready",
        "io_dmemAxi_w_valid",
        "io_dmemAxi_w_ready",
        "io_dmemAxi_b_valid",
        "io_dmemAxi_b_ready",
    )
    parts = []
    for name in signal_names:
        value = _sig_int(dut, name)
        if value is not None:
            parts.append(f"{name}={value}")
    return ", ".join(parts)


def _soc_core_debug_snapshot(dut) -> str:
    signal_names = (
        "cores_0_io_halted",
        "cores_0_fetch_io_halted",
        "cores_0_fetch_io_pc",
        "cores_0_fetch_io_stall",
        "cores_0_fetch_io_replayStall",
        "cores_0_fetch_io_matrixStall",
        "cores_0_flow_io_halt",
        "cores_0_mem_io_stall",
        "cores_0_mem_io_scalarStoreBusy",
        "cores_0_exSlotsReg_valid",
    )
    return ", ".join(f"{name}={_sig_int(dut, name)}" for name in signal_names)


def _log2(x):
    import math
    return int(math.log2(x)) if x > 1 else 0


def _pack_bundles_into_ddr(ddr_model, asm, program):
    """Assemble a program and pack bundles into the DDR model at PROG_DDR_WORD_BASE.

    Each bundle is stored in one AXI beat (16 × 32-bit words).
    Lower WORDS_PER_BUNDLE words hold the instruction data; upper words are zero.

    Returns the number of bundles packed.
    """
    for pc, instr in enumerate(program):
        bundle = asm.assemble(instr)
        words = asm.to_word_list(bundle, 32)
        # Pad to a full AXI beat
        beat_words = list(words) + [0] * (WORDS_PER_BEAT - len(words))
        beat_word_addr = PROG_DDR_WORD_BASE + pc * WORDS_PER_BEAT
        ddr_model.preload(beat_word_addr, beat_words)
    return len(program)


async def trigger_imem_load(csr, bundle_count, timeout_polls=200, clock=None):
    """Set IMEM source address and bundle count, trigger load, wait for done."""
    await csr.write(CSR_IMEM_SRC_ADDR, PROG_DDR_BYTE_BASE)
    await csr.write(CSR_IMEM_BUNDLE_COUNT, bundle_count)
    await csr.write(CSR_CTRL, CTRL_LOAD)

    for _ in range(timeout_polls):
        await ClockCycles(clock, 5)
        status = await csr.read(CSR_IMEM_STATUS)
        if status & 0x02:  # bit 1 = done
            return
    raise AssertionError("IMEM loader did not finish within timeout")


async def load_program(csr, ddr_model, asm, program, clock):
    """Assemble, pack into DDR, and trigger IMEM DMA load."""
    n_bundles = _pack_bundles_into_ddr(ddr_model, asm, program)
    await trigger_imem_load(csr, n_bundles, clock=clock)


def _make_asm():
    """Create an Assembler with Sim-matching config."""
    return Assembler(AssemblerConfig(
        n_alu_slots=CFG.n_alu_slots,
        n_valu_slots=CFG.n_valu_slots,
        n_load_slots=CFG.n_load_slots,
        n_store_slots=CFG.n_store_slots,
        n_flow_slots=CFG.n_flow_slots,
        n_matrix_slots=getattr(CFG, 'n_matrix_slots', 0),
        vlen=CFG.vlen,
        scratch_size=CFG.scratch_size,
        imem_depth=CFG.imem_depth,
    ))


async def _setup(dut):
    """Common test setup: clock, init, reset, CSR driver, DDR model."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())
    _initialize_host_interfaces(dut)
    await reset_dut(dut, clock)

    csr = make_csr_driver(dut, clock)
    ddr = make_ddr_model(dut)
    ddr.start()

    return clock, csr, ddr


# ============================================================================
#  Test Cases
# ============================================================================

@cocotb.test()
async def test_csr_readback(dut):
    """Verify CSR config registers return correct values for Sim config."""
    clock, csr, ddr = await _setup(dut)

    core_count = await csr.read(CSR_CORE_COUNT)
    assert core_count == 1, f"CORE_COUNT: expected 1, got {core_count}"

    vlen = await csr.read(CSR_VLEN)
    assert vlen == CFG.vlen, f"VLEN: expected {CFG.vlen}, got {vlen}"

    scratch_size = await csr.read(CSR_SCRATCH_SIZE)
    assert scratch_size == CFG.scratch_size, f"SCRATCH_SIZE: expected {CFG.scratch_size}, got {scratch_size}"

    imem_depth = await csr.read(CSR_IMEM_DEPTH)
    assert imem_depth == CFG.imem_depth, f"IMEM_DEPTH: expected {CFG.imem_depth}, got {imem_depth}"

    bundle_w = await csr.read(CSR_BUNDLE_WIDTH)
    assert bundle_w == BUNDLE_WIDTH, f"BUNDLE_WIDTH: expected {BUNDLE_WIDTH}, got {bundle_w}"

    ddr.stop()
    dut._log.info("CSR readback: PASS")


@cocotb.test()
async def test_imem_loader_status(dut):
    """Verify the IMEM loader DMA: set CSR, trigger, poll done."""
    clock, csr, ddr = await _setup(dut)
    asm = _make_asm()

    program = [
        {"load": [("const", 0, 42)]},
        {"flow": [("halt",)]},
    ]
    n = _pack_bundles_into_ddr(ddr, asm, program)

    # Before load: status should be idle (not busy, not done)
    status_before = await csr.read(CSR_IMEM_STATUS)
    assert (status_before & 0x01) == 0, f"Loader should not be busy before start, got 0x{status_before:X}"

    await csr.write(CSR_IMEM_SRC_ADDR, PROG_DDR_BYTE_BASE)
    await csr.write(CSR_IMEM_BUNDLE_COUNT, n)
    await csr.write(CSR_CTRL, CTRL_LOAD)

    # Wait for done
    for _ in range(200):
        await ClockCycles(clock, 2)
        status = await csr.read(CSR_IMEM_STATUS)
        if status & 0x02:
            break
    else:
        raise AssertionError("IMEM loader did not reach DONE state")

    ddr.stop()
    dut._log.info("IMEM loader status: PASS")


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
    clock, csr, ddr = await _setup(dut)
    asm = _make_asm()

    program = [
        {"load": [("const", 0, 100)]},
        {"load": [("const", 1, 200)]},
        {"alu": [("+", 2, 0, 1)]},
        {"flow": [("halt",)]},
    ]

    await load_program(csr, ddr, asm, program, clock)

    # Start execution
    await csr.write(CSR_CTRL, CTRL_START)

    # Wait for halt
    for _ in range(200):
        await ClockCycles(clock, 5)
        status = await csr.read(CSR_STATUS)
        if status & 0x02:
            break
    else:
        raise AssertionError("Core did not halt within timeout")

    status = await csr.read(CSR_STATUS)
    assert status & 0x02, f"Core 0 not halted: status=0x{status:08X}"

    irq = int(dut.io_irq.value)
    assert irq == 1, f"IRQ not asserted after halt"

    ddr.stop()
    dut._log.info("const_add_halt: PASS")


@cocotb.test()
async def test_core_can_restart_after_halt(dut):
    """Start the core twice and verify it halts cleanly both times."""
    clock, csr, ddr = await _setup(dut)
    asm = _make_asm()

    program = [
        {"load": [("const", 0, 7)]},
        {"load": [("const", 1, 11)]},
        {"alu": [("+", 2, 0, 1)]},
        {"flow": [("halt",)]},
    ]

    await load_program(csr, ddr, asm, program, clock)

    async def wait_for_halt(timeout_polls: int = 200):
        last_status = 0
        for _ in range(timeout_polls):
            await ClockCycles(clock, 5)
            last_status = await csr.read(CSR_STATUS)
            if last_status & 0x02:
                return last_status
        raise AssertionError(f"Core did not halt within timeout; status=0x{last_status:08X}")

    # First run
    await csr.write(CSR_CTRL, CTRL_START)
    first_status = await wait_for_halt()
    first_cycles = await csr.read(CSR_CYCLE_COUNT)
    assert first_status & 0x02, f"Expected halt after first run, got status=0x{first_status:08X}"
    assert int(dut.io_irq.value) == 1, "IRQ should assert after the first halt"

    # Second run (program is still in IMEM)
    await csr.write(CSR_CTRL, CTRL_START)

    cleared = False
    for _ in range(20):
        await ClockCycles(clock, 2)
        status = await csr.read(CSR_STATUS)
        if (status & 0x02) == 0:
            cleared = True
            break
    assert cleared, "Core did not leave halted state after restart"
    assert int(dut.io_irq.value) == 0, "IRQ should deassert while the restarted core is running"

    second_status = await wait_for_halt()
    second_cycles = await csr.read(CSR_CYCLE_COUNT)
    assert second_status & 0x02, f"Expected halt after second run, got status=0x{second_status:08X}"
    assert second_cycles > first_cycles, (
        f"Cycle counter did not advance across restart: first={first_cycles}, second={second_cycles}"
    )
    assert int(dut.io_irq.value) == 1, "IRQ should reassert after the second halt"

    ddr.stop()
    dut._log.info("test_core_can_restart_after_halt: PASS")


@cocotb.test()
async def test_golden_model_standalone(dut):
    """Verify the Python golden model independently (no RTL needed)."""
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
    """Verify the golden model with a simple counting loop."""
    model = GoldenModel(scratch_size=CFG.scratch_size, vlen=CFG.vlen, core_id=0)

    program = [
        {"load": [("const", 0, 0)]},       # counter = 0
        {"load": [("const", 1, 1)]},       # increment = 1
        {"load": [("const", 2, 10)]},      # limit = 10
        {"alu": [("+", 0, 0, 1)]},          # counter += increment
        {"alu": [("<", 3, 0, 2)]},          # scratch[3] = (counter < 10)
        {"flow": [("cond_jump", 3, 3)]},    # if scratch[3] != 0, jump to PC=3
        {"flow": [("halt",)]},
    ]

    model.load_program(program)
    cycles = model.run(max_cycles=1000)

    assert model.scratch[0] == 10, f"scratch[0]={model.scratch[0]}, expected 10"
    assert model.halted, "Model should be halted"

    dut._log.info(f"Golden model loop: PASS (counter={model.scratch[0]}, {cycles} cycles)")


@cocotb.test()
async def test_core_dmem_scalar_roundtrip(dut):
    """Verify the SoC core can load from DDR and store the result back."""
    clock, csr, ddr = await _setup(dut)
    asm = _make_asm()

    # Pre-load a test word at DDR word address 0 (byte address 0x0)
    test_word = 0x13579BDF
    ddr.preload(0, [test_word])

    result_word_addr = 128  # core stores result to word address 128

    program = [
        {"load": [("const", 10, 0)]},           # scratch[10] = 0 (DMEM addr)
        {"load": [("load", 0, 10)]},             # load scratch[0] from DMEM[0]
        {"load": [("wait_for_load", 0)]},        # wait for load completion
        {"load": [("const", 11, result_word_addr)]},  # scratch[11] = 128
        {"store": [("store", 11, 0)]},           # store scratch[0] to DMEM[128]
        {},
        {},
        {"flow": [("halt",)]},
    ]

    await load_program(csr, ddr, asm, program, clock)
    await csr.write(CSR_CTRL, CTRL_START)

    for _ in range(400):
        await ClockCycles(clock, 5)
        status = await csr.read(CSR_STATUS)
        if status & 0x02:
            break
    else:
        raise AssertionError(
            f"Core did not halt in SoC scalar DMEM roundtrip test; "
            f"status=0x{status:08X}; core={_soc_core_debug_snapshot(dut)}; "
            f"axi={_soc_axi_debug_snapshot(dut)}"
        )

    # Wait a few cycles for any in-flight AXI writes to complete
    await ClockCycles(clock, 20)

    # Read result from the DDR model.
    # The MemoryEngine stores using 512-bit beats with byte strobes.
    # The word at result_word_addr ends up at DDR word address
    # (result_word_addr aligned to beat boundary) + offset within beat.
    result = ddr.read_word(result_word_addr)
    assert result == test_word, f"Expected 0x{test_word:08X}, got 0x{result:08X}"

    ddr.stop()
    dut._log.info("test_core_dmem_scalar_roundtrip: PASS")
