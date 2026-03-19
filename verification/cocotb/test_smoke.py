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
from cocotb.triggers import RisingEdge, ClockCycles, ReadOnly, NextTimeStep

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


def _set_axi4_master_defaults(dut, prefix: str):
    for name, value in (
        ("aw_valid", 0),
        ("aw_payload_addr", 0),
        ("aw_payload_id", 0),
        ("aw_payload_len", 0),
        ("aw_payload_size", 0),
        ("aw_payload_burst", 0),
        ("w_valid", 0),
        ("w_payload_data", 0),
        ("w_payload_strb", 0),
        ("w_payload_last", 0),
        ("b_ready", 0),
        ("ar_valid", 0),
        ("ar_payload_addr", 0),
        ("ar_payload_id", 0),
        ("ar_payload_len", 0),
        ("ar_payload_size", 0),
        ("ar_payload_burst", 0),
        ("r_ready", 0),
    ):
        getattr(dut, f"{prefix}_{name}").value = value


def _initialize_host_interfaces(dut):
    _set_axilite_master_defaults(dut, "io_csrAxi")
    _set_axilite_master_defaults(dut, "io_imemAxi")
    _set_axi4_master_defaults(dut, "io_dmemAxi")


def _dmem_sig(dut, name: str):
    return getattr(dut, f"io_dmemAxi_{name}")


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


def _dmem_word_bytes(dut) -> int:
    return len(_dmem_sig(dut, "w_payload_data")) // 8


def _dmem_full_strb(dut) -> int:
    return (1 << _dmem_word_bytes(dut)) - 1


def _dmem_size_code(dut) -> int:
    import math

    return int(math.log2(_dmem_word_bytes(dut)))


async def _await_high(signal, clock, timeout_cycles: int, message: str):
    for _ in range(timeout_cycles):
        await RisingEdge(clock)
        if int(signal.value) == 1:
            return
    raise AssertionError(message)


async def _read_single_retry(dmem, clock, addr: int, axi_id: int, attempts: int = 4, word_only: bool = False):
    last_error = None
    for _ in range(attempts):
        try:
            if word_only:
                return await dmem.read_word(addr, axi_id=axi_id)
            return await dmem.read_single(addr, axi_id=axi_id)
        except ValueError as exc:
            last_error = exc
            await ClockCycles(clock, 4)
    raise last_error


async def _axi4_write_address_phase(dut, clock, addr: int, axi_id: int, timeout_cycles: int = 40):
    _dmem_sig(dut, "aw_payload_addr").value = addr
    _dmem_sig(dut, "aw_payload_id").value = axi_id
    _dmem_sig(dut, "aw_payload_len").value = 0
    _dmem_sig(dut, "aw_payload_size").value = _dmem_size_code(dut)
    _dmem_sig(dut, "aw_payload_burst").value = 1
    _dmem_sig(dut, "aw_valid").value = 1

    await _await_high(_dmem_sig(dut, "aw_ready"), clock, timeout_cycles, "AW channel did not handshake")
    _dmem_sig(dut, "aw_valid").value = 0


async def _axi4_write_data_phase(dut, clock, data: int, strb: int, last: int = 1, timeout_cycles: int = 40):
    _dmem_sig(dut, "w_payload_data").value = data
    _dmem_sig(dut, "w_payload_strb").value = strb
    _dmem_sig(dut, "w_payload_last").value = last
    _dmem_sig(dut, "w_valid").value = 1

    await _await_high(_dmem_sig(dut, "w_ready"), clock, timeout_cycles, "W channel did not handshake")
    _dmem_sig(dut, "w_valid").value = 0


async def _axi4_read_address_phase(dut, clock, addr: int, axi_id: int, timeout_cycles: int = 40):
    _dmem_sig(dut, "ar_payload_addr").value = addr
    _dmem_sig(dut, "ar_payload_id").value = axi_id
    _dmem_sig(dut, "ar_payload_len").value = 0
    _dmem_sig(dut, "ar_payload_size").value = _dmem_size_code(dut)
    _dmem_sig(dut, "ar_payload_burst").value = 1
    _dmem_sig(dut, "ar_valid").value = 1

    await _await_high(_dmem_sig(dut, "ar_ready"), clock, timeout_cycles, "AR channel did not handshake")
    _dmem_sig(dut, "ar_valid").value = 0


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
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
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
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
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
        raise AssertionError("Core did not halt within timeout")

    # Check that core is halted
    status = await csr.read(CSR_STATUS)
    assert status & 0x02, f"Core 0 not halted: status=0x{status:08X}"

    # Check IRQ
    irq = int(dut.io_irq.value)
    assert irq == 1, f"IRQ not asserted after halt"

    dut._log.info("const_add_halt: PASS")


@cocotb.test()
async def test_core_can_restart_after_halt(dut):
    """Start the core twice and verify it leaves halt cleanly and halts again on the same program."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
    await reset_dut(dut, clock)

    csr, imem, _ = make_drivers(dut, clock)

    asm_cfg = AssemblerConfig(
        n_alu_slots=CFG.n_alu_slots, n_valu_slots=CFG.n_valu_slots, n_load_slots=CFG.n_load_slots,
        n_store_slots=CFG.n_store_slots, n_flow_slots=CFG.n_flow_slots,
        imem_depth=CFG.imem_depth, scratch_size=CFG.scratch_size
    )
    asm = Assembler(asm_cfg)

    program = [
        {"load": [("const", 0, 7)]},
        {"load": [("const", 1, 11)]},
        {"alu": [("+", 2, 0, 1)]},
        {"flow": [("halt",)]},
    ]

    await load_program(imem, asm, program, clock)

    async def wait_for_halt(timeout_polls: int = 200):
        last_status = 0
        for _ in range(timeout_polls):
            await ClockCycles(clock, 5)
            last_status = await csr.read(CSR_STATUS)
            if last_status & 0x02:
                return last_status
        raise AssertionError(f"Core did not halt within timeout; status=0x{last_status:08X}")

    await csr.write(CSR_CTRL, 0x01)
    first_status = await wait_for_halt()
    first_cycles = await csr.read(CSR_CYCLE_COUNT)
    assert first_status & 0x02, f"Expected halt after first run, got status=0x{first_status:08X}"
    assert int(dut.io_irq.value) == 1, "IRQ should assert after the first halt"

    await csr.write(CSR_CTRL, 0x01)

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

    dut._log.info("test_core_can_restart_after_halt: PASS")


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


@cocotb.test()
async def test_dmem_axi_single_beat_roundtrip_with_ids(dut):
    """Verify a host AXI write/read roundtrip with explicit BRESP/RRESP/ID checks."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
    await reset_dut(dut, clock)

    _, _, dmem = make_drivers(dut, clock)

    addr = 0x40
    write_data = 0x1234ABCD
    write_resp, write_id = await dmem.write_single_with_meta(addr, write_data, axi_id=0xA)
    read_data, read_resp, read_id, read_last = await dmem.read_single_with_meta(addr, axi_id=0x5)

    assert write_resp == 0, f"Expected OKAY BRESP, got {write_resp}"
    assert write_id == 0xA, f"Expected BID 0xA, got 0x{write_id:X}"
    assert read_resp == 0, f"Expected OKAY RRESP, got {read_resp}"
    assert read_id == 0x5, f"Expected RID 0x5, got 0x{read_id:X}"
    assert read_last == 1, "Single-beat AXI read must assert RLAST"
    assert read_data == write_data, f"Expected 0x{write_data:08X}, got 0x{read_data:08X}"


@cocotb.test()
async def test_dmem_axi_write_channel_decoupling_and_b_backpressure(dut):
    """Verify AW/W channel decoupling and that B remains stable until BREADY."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
    await reset_dut(dut, clock)

    _, _, dmem = make_drivers(dut, clock)

    addr = 0x80
    axi_id = 0x3
    data = 0xCAFEBABE

    await _axi4_write_address_phase(dut, clock, addr, axi_id)

    for _ in range(4):
        await RisingEdge(clock)
        await ReadOnly()
        assert int(_dmem_sig(dut, "b_valid").value) == 0, "BVALID asserted before W handshake"

    await NextTimeStep()
    await _axi4_write_data_phase(dut, clock, data, strb=_dmem_full_strb(dut))

    await _await_high(_dmem_sig(dut, "b_valid"), clock, 40, "B channel did not respond")
    observed_bid = int(_dmem_sig(dut, "b_payload_id").value)
    observed_bresp = int(_dmem_sig(dut, "b_payload_resp").value)

    for _ in range(4):
        await RisingEdge(clock)
        await ReadOnly()
        assert int(_dmem_sig(dut, "b_valid").value) == 1, "BVALID dropped before BREADY"
        assert int(_dmem_sig(dut, "b_payload_id").value) == observed_bid, "BID changed under backpressure"
        assert int(_dmem_sig(dut, "b_payload_resp").value) == observed_bresp, "BRESP changed under backpressure"

    await NextTimeStep()
    _dmem_sig(dut, "b_ready").value = 1
    await RisingEdge(clock)
    _dmem_sig(dut, "b_ready").value = 0
    await RisingEdge(clock)
    await ReadOnly()
    assert int(_dmem_sig(dut, "b_valid").value) == 0, "BVALID should clear after B handshake"

    assert observed_bresp == 0, f"Expected OKAY BRESP, got {observed_bresp}"
    assert observed_bid == axi_id, f"Expected BID 0x{axi_id:X}, got 0x{observed_bid:X}"

    await NextTimeStep()
    read_back = await dmem.read_single(addr, axi_id=0x4)
    assert read_back == data, f"Expected 0x{data:08X}, got 0x{read_back:08X}"


@cocotb.test()
async def test_dmem_axi_read_backpressure_and_r_channel_stability(dut):
    """Verify R remains stable until RREADY and that RID/RLAST match the request."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
    await reset_dut(dut, clock)

    _, _, dmem = make_drivers(dut, clock)

    addr = 0xC0
    data = 0x0BADF00D
    await dmem.write_single(addr, data, axi_id=0x1)

    axi_id = 0x7
    await _axi4_read_address_phase(dut, clock, addr, axi_id)
    await _await_high(_dmem_sig(dut, "r_valid"), clock, 40, "R channel did not respond")

    observed_data = int(_dmem_sig(dut, "r_payload_data").value)
    observed_rid = int(_dmem_sig(dut, "r_payload_id").value)
    observed_rresp = int(_dmem_sig(dut, "r_payload_resp").value)
    observed_last = int(_dmem_sig(dut, "r_payload_last").value)

    for _ in range(4):
        await RisingEdge(clock)
        await ReadOnly()
        assert int(_dmem_sig(dut, "r_valid").value) == 1, "RVALID dropped before RREADY"
        assert int(_dmem_sig(dut, "r_payload_data").value) == observed_data, "RDATA changed under backpressure"
        assert int(_dmem_sig(dut, "r_payload_id").value) == observed_rid, "RID changed under backpressure"
        assert int(_dmem_sig(dut, "r_payload_resp").value) == observed_rresp, "RRESP changed under backpressure"
        assert int(_dmem_sig(dut, "r_payload_last").value) == observed_last, "RLAST changed under backpressure"

    await NextTimeStep()
    _dmem_sig(dut, "r_ready").value = 1
    await RisingEdge(clock)
    _dmem_sig(dut, "r_ready").value = 0
    await RisingEdge(clock)
    await ReadOnly()
    assert int(_dmem_sig(dut, "r_valid").value) == 0, "RVALID should clear after R handshake"

    assert observed_data == data, f"Expected 0x{data:08X}, got 0x{observed_data:08X}"
    assert observed_rid == axi_id, f"Expected RID 0x{axi_id:X}, got 0x{observed_rid:X}"
    assert observed_rresp == 0, f"Expected OKAY RRESP, got {observed_rresp}"
    assert observed_last == 1, "Single-beat AXI read must assert RLAST"


@cocotb.test()
async def test_dmem_axi_wstrb_partial_write(dut):
    """Verify byte strobes update only the selected bytes on the AXI W channel."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
    await reset_dut(dut, clock)

    _, _, dmem = make_drivers(dut, clock)

    addr = 0x100
    original = 0x11223344
    masked = 0x55667788
    expected = 0x11663388

    await dmem.write_single(addr, original, axi_id=0x2)
    await dmem.write_single(addr, masked, axi_id=0x6, strb=0b0101)
    read_back = await dmem.read_single(addr, axi_id=0x9)

    assert read_back == expected, f"Expected masked write result 0x{expected:08X}, got 0x{read_back:08X}"


@cocotb.test()
async def test_dmem_axi_incrementing_burst_roundtrip(dut):
    """Verify incrementing AXI bursts preserve ordering, IDs, and RLAST semantics."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
    await reset_dut(dut, clock)

    _, _, dmem = make_drivers(dut, clock)

    addr = 0x180
    words = [0x11111111, 0x22222222, 0x33333333, 0x44444444]
    bresp, bid = await dmem.write_burst_with_meta(addr, words, axi_id=0xB)
    read_words, rresps, rids, lasts = await dmem.read_burst_with_meta(addr, len(words), axi_id=0xC)

    assert bresp == 0, f"Expected OKAY BRESP, got {bresp}"
    assert bid == 0xB, f"Expected BID 0xB, got 0x{bid:X}"
    assert read_words == words, f"Burst readback mismatch: expected {words}, got {read_words}"
    assert rresps == [0] * len(words), f"Expected all OKAY RRESP values, got {rresps}"
    assert rids == [0xC] * len(words), f"Expected RID 0xC on all beats, got {rids}"
    assert lasts == [0, 0, 0, 1], f"Expected RLAST only on final beat, got {lasts}"


@cocotb.test()
async def test_core_dmem_scalar_roundtrip(dut):
    """Verify the SoC core can load from shared DMEM and store the result back for host readback."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
    await reset_dut(dut, clock)

    csr, imem, dmem = make_drivers(dut, clock)

    asm_cfg = AssemblerConfig(
        n_alu_slots=CFG.n_alu_slots,
        n_valu_slots=CFG.n_valu_slots,
        n_load_slots=CFG.n_load_slots,
        n_store_slots=CFG.n_store_slots,
        n_flow_slots=CFG.n_flow_slots,
        n_matrix_slots=CFG.n_matrix_slots,
        vlen=CFG.vlen,
        scratch_size=CFG.scratch_size,
        imem_depth=CFG.imem_depth,
    )
    asm = Assembler(asm_cfg)

    await dmem.write_single(0x0, 0x13579BDF, axi_id=0x1)

    program = [
        {"load": [("const", 10, 0)]},
        {"load": [("load", 0, 10)]},
        {"load": [("wait_for_load", 0)]},
        {"load": [("const", 11, 128)]},
        {"store": [("store", 11, 0)]},
        {},
        {},
        {"flow": [("halt",)]},
    ]

    await load_program(imem, asm, program, clock)
    await csr.write(CSR_CTRL, 0x01)

    for _ in range(200):
        await ClockCycles(clock, 5)
        status = await csr.read(CSR_STATUS)
        if status & 0x02:
            break
    else:
        result_probe = None
        try:
            result_probe = await dmem.read_word(128 * 4, axi_id=0x4, timeout_cycles=200)
        except AssertionError as exc:
            result_probe = f"read_failed:{exc}"
        raise AssertionError(
            "Core did not halt in SoC scalar DMEM roundtrip test; "
            f"status=0x{status:08X}; result_probe={result_probe}; "
            f"core={_soc_core_debug_snapshot(dut)}; axi={_soc_axi_debug_snapshot(dut)}"
        )

    await ClockCycles(clock, 20)
    loopback_addr = 0x280
    loopback_data = 0xA5A5C3C3
    try:
        await dmem.write_single(loopback_addr, loopback_data, axi_id=0x2, timeout_cycles=400)
    except AssertionError as exc:
        raise AssertionError(f"{exc}; AXI snapshot: {_soc_axi_debug_snapshot(dut)}") from exc
    loopback_read = await dmem.read_single(loopback_addr, axi_id=0x3, timeout_cycles=400)
    assert loopback_read == loopback_data, f"Post-halt host loopback failed: expected 0x{loopback_data:08X}, got 0x{loopback_read:08X}"

    try:
        result = await dmem.read_word(128 * 4, axi_id=0x4, timeout_cycles=400)
    except AssertionError as exc:
        raise AssertionError(f"{exc}; AXI snapshot: {_soc_axi_debug_snapshot(dut)}") from exc
    assert result == 0x13579BDF, f"Expected 0x13579BDF, got 0x{result:08X}"


@cocotb.test()
async def test_dmem_axi_host_core_contention_roundtrip(dut):
    """Run host burst traffic while the core performs a scalar DMEM roundtrip and verify both complete cleanly."""
    clock = dut.clk
    cocotb.start_soon(Clock(clock, 10, unit="ns").start())

    _initialize_host_interfaces(dut)
    await reset_dut(dut, clock)

    csr, imem, dmem = make_drivers(dut, clock)

    asm_cfg = AssemblerConfig(
        n_alu_slots=CFG.n_alu_slots,
        n_valu_slots=CFG.n_valu_slots,
        n_load_slots=CFG.n_load_slots,
        n_store_slots=CFG.n_store_slots,
        n_flow_slots=CFG.n_flow_slots,
        n_matrix_slots=CFG.n_matrix_slots,
        vlen=CFG.vlen,
        scratch_size=CFG.scratch_size,
        imem_depth=CFG.imem_depth,
    )
    asm = Assembler(asm_cfg)

    source_word = 0x2468ACE0
    result_word_addr = 512
    await dmem.write_single(0x0, source_word, axi_id=0x1)

    program = [
        {"load": [("const", 10, 0)]},
        {"load": [("load", 0, 10)]},
        {"load": [("wait_for_load", 0)]},
        {"load": [("const", 11, result_word_addr)]},
        {"store": [("store", 11, 0)]},
        {},
        {},
        {"flow": [("halt",)]},
    ]

    await load_program(imem, asm, program, clock)

    async def host_traffic():
        await ClockCycles(clock, 20)
        burst_base_addr = 0x1000
        burst_words_a = [0xDEAD0001, 0xDEAD0002, 0xDEAD0003, 0xDEAD0004]

        bresp_a, bid_a = await dmem.write_burst_with_meta(burst_base_addr, burst_words_a, axi_id=0x9)
        read_a, resp_a, rid_a, last_a = await dmem.read_burst_with_meta(burst_base_addr, len(burst_words_a), axi_id=0x6)

        assert bresp_a == 0, f"Expected OKAY BRESP, got {bresp_a}"
        assert bid_a == 0x9, f"Unexpected BID: {bid_a}"
        assert read_a == burst_words_a, f"Host burst A mismatch: expected {burst_words_a}, got {read_a}"
        assert resp_a == [0] * len(burst_words_a), f"Unexpected read responses for burst A: {resp_a}"
        assert rid_a == [0x6] * len(burst_words_a), f"Unexpected RIDs for burst A: {rid_a}"
        assert last_a[-1] == 1 and all(last == 0 for last in last_a[:-1]), f"Unexpected RLAST pattern for burst A: {last_a}"

    host_task = cocotb.start_soon(host_traffic())
    await csr.write(CSR_CTRL, 0x01)
    await host_task

    for _ in range(400):
        await ClockCycles(clock, 5)
        status = await csr.read(CSR_STATUS)
        if status & 0x02:
            break
    else:
        raise AssertionError("Core did not halt during host/core AXI contention test")

    await ClockCycles(clock, 20)
    result_word = await _read_single_retry(dmem, clock, result_word_addr * 4, axi_id=0x2, word_only=True)
    assert result_word == source_word, f"Expected copied word 0x{source_word:08X}, got 0x{result_word:08X}"
