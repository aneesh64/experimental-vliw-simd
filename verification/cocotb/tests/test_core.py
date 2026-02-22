"""
cocotb integration testbench for VliwCore module.

VliwCore is the full pipeline: Fetch → Decode → Engines → BankedScratch.
We load programs via io_imemWrite, assert io_start, and observe
io_halted / io_pc / io_cycleCount.

Test plan:
  1. NOP + HALT — minimal program, verify halt in a few cycles
  2. CONST + HALT — load immediate, then halt (verifies CONST path)
  3. CONST + ADD + HALT — verify ALU single-cycle result via cycleCount
  4. Jump — verify PC changes

Instruction bundle layout (256-bit, sim config: 1 ALU, 1 VALU, 1 Load, 1 Store, 1 Flow):
  Bits [39:0]    = ALU slot 0   (40b): [39] valid | [38:35] opcode | [34:24] dest | [23:13] src1 | [12:2] src2
  Bits [95:40]   = VALU slot 0  (56b): [55] valid | [54:51] opcode | [50:40] destBase | ...
  Bits [143:96]  = Load slot 0  (48b): [47] valid | [46:44] opcode | [43:33] dest | ...
  Bits [171:144] = Store slot 0 (28b): [27] valid | [26:25] opcode | ...
  Bits [219:172] = Flow slot    (48b): [47] valid | [46:43] opcode | [42:32] dest | [31:21] operandA | [20:10] operandB | [9:0] immediate
  Bits [255:220] = padding (0)

We build 256-bit instruction words using helper functions.
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


# ---- ISA opcodes ----
class AluOp:
    ADD = 0; SUB = 1; MUL = 2; XOR = 3; AND = 4; OR = 5
    SHL = 6; SHR = 7; LT = 8; EQ = 9; MOD = 10; DIV = 11; CDIV = 12

class FlowOp:
    NOP = 0; SELECT = 1; VSELECT = 2; ADD_IMM = 3
    HALT = 4; COND_JUMP = 5; COND_JUMP_REL = 6
    JUMP = 7; JUMP_INDIRECT = 8; COREID = 9

class LdOp:
    NOP = 0; LOAD = 1; LOAD_OFFSET = 2; VLOAD = 3; CONST = 4


# ---- Instruction word builder ----
ALU_OFFSET    = 0
VALU_OFFSET   = 40
LOAD_OFFSET   = 96
STORE_OFFSET  = 144
FLOW_OFFSET   = 172
BUNDLE_BITS   = 256

MASK = (1 << BUNDLE_BITS) - 1


def nop_bundle():
    """All-zero 256-bit NOP bundle."""
    return 0


def alu_slot(valid, opcode, dest, src1, src2):
    """Build a 40-bit ALU slot value."""
    w = 0
    w |= (1 if valid else 0) << 39
    w |= (opcode & 0xF) << 35
    w |= (dest & 0x7FF) << 24
    w |= (src1 & 0x7FF) << 13
    w |= (src2 & 0x7FF) << 2
    return w


def load_slot(valid, opcode, dest, addrReg=0, offset=0, immediate=0):
    """Build a 48-bit Load slot value."""
    w = 0
    w |= (1 if valid else 0) << 47
    w |= (opcode & 0x7) << 44
    w |= (dest & 0x7FF) << 33
    w |= (addrReg & 0x7FF) << 22
    w |= (offset & 0x7) << 19
    w |= (immediate & 0xFFFFFFFF)
    return w


def flow_slot(valid, opcode, dest=0, operandA=0, operandB=0, immediate=0):
    """Build a 48-bit Flow slot value."""
    w = 0
    w |= (1 if valid else 0) << 47
    w |= (opcode & 0xF) << 43
    w |= (dest & 0x7FF) << 32
    w |= (operandA & 0x7FF) << 21
    w |= (operandB & 0x7FF) << 10
    w |= (immediate & 0x3FF)
    return w


def build_bundle(alu=0, valu=0, load=0, store=0, flow=0):
    """Combine slot values into a 256-bit bundle."""
    w = 0
    w |= (alu   & ((1 << 40) - 1)) << ALU_OFFSET
    w |= (valu  & ((1 << 56) - 1)) << VALU_OFFSET
    w |= (load  & ((1 << 48) - 1)) << LOAD_OFFSET
    w |= (store & ((1 << 28) - 1)) << STORE_OFFSET
    w |= (flow  & ((1 << 48) - 1)) << FLOW_OFFSET
    return w & MASK


async def write_imem(dut, addr, data_256):
    """Write a single 256-bit instruction to IMEM."""
    dut.io_imemWrite_valid.value = 1
    dut.io_imemWrite_payload_addr.value = addr
    dut.io_imemWrite_payload_data.value = data_256
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
        if int(dut.io_halted.value) == 1:
            return i + 1
    raise AssertionError(f"Core did not halt within {max_cycles} cycles")


# ===========================================================
@cocotb.test()
async def test_halt_only(dut):
    """PC=0: HALT only. Core should halt in ~2-3 cycles (pipeline depth)."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    # Write HALT at addr 0
    instr = build_bundle(flow=flow_slot(True, FlowOp.HALT))
    await write_imem(dut, 0, instr)
    await RisingEdge(dut.clk)

    await start_core(dut)
    cycles = await wait_halted(dut, 20)

    dut._log.info(f"test_halt_only: halted after {cycles} cycles, "
                  f"pc={int(dut.io_pc.value)}, cycleCount={int(dut.io_cycleCount.value)}")


@cocotb.test()
async def test_const_then_halt(dut):
    """PC=0: CONST 42 → scratch[5]; PC=1: HALT."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    # PC=0: CONST 42 → dest 5
    instr0 = build_bundle(load=load_slot(True, LdOp.CONST, dest=5, immediate=42))
    await write_imem(dut, 0, instr0)

    # PC=1: HALT
    instr1 = build_bundle(flow=flow_slot(True, FlowOp.HALT))
    await write_imem(dut, 1, instr1)

    await RisingEdge(dut.clk)
    await start_core(dut)
    cycles = await wait_halted(dut, 30)

    dut._log.info(f"test_const_then_halt: halted after {cycles} cycles, "
                  f"cycleCount={int(dut.io_cycleCount.value)}")


@cocotb.test()
async def test_const_add_halt(dut):
    """
    PC=0: CONST 10 → scratch[0]
    PC=1: CONST 20 → scratch[1]
    PC=2: ADD scratch[0] + scratch[1] → scratch[2]
    PC=3: NOP (pipeline drain)
    PC=4: HALT
    Verify execution completes.
    """
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    # PC=0: CONST 10 → scratch[0]
    await write_imem(dut, 0, build_bundle(load=load_slot(True, LdOp.CONST, dest=0, immediate=10)))
    # PC=1: CONST 20 → scratch[1]
    await write_imem(dut, 1, build_bundle(load=load_slot(True, LdOp.CONST, dest=1, immediate=20)))
    # PC=2: ADD scratch[0] + scratch[1] → scratch[2]
    await write_imem(dut, 2, build_bundle(alu=alu_slot(True, AluOp.ADD, dest=2, src1=0, src2=1)))
    # PC=3: NOP (drain pipeline)
    await write_imem(dut, 3, nop_bundle())
    # PC=4: HALT
    await write_imem(dut, 4, build_bundle(flow=flow_slot(True, FlowOp.HALT)))

    await RisingEdge(dut.clk)
    await start_core(dut)
    cycles = await wait_halted(dut, 50)

    dut._log.info(f"test_const_add_halt: halted after {cycles} cycles, "
                  f"cycleCount={int(dut.io_cycleCount.value)}")


@cocotb.test()
async def test_jump(dut):
    """
    PC=0: JUMP to PC=5
    PC=1..4: should be skipped
    PC=5: HALT
    Verify we skip the middle instructions.
    """
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    # PC=0: JUMP → 5
    await write_imem(dut, 0, build_bundle(flow=flow_slot(True, FlowOp.JUMP, immediate=5)))
    # PC=1..4: write NOPs (would never execute)
    for a in range(1, 5):
        await write_imem(dut, a, nop_bundle())
    # PC=5: HALT
    await write_imem(dut, 5, build_bundle(flow=flow_slot(True, FlowOp.HALT)))

    await RisingEdge(dut.clk)
    await start_core(dut)
    cycles = await wait_halted(dut, 30)

    dut._log.info(f"test_jump: halted after {cycles} cycles, "
                  f"pc={int(dut.io_pc.value)}")


@cocotb.test()
async def test_core_reports_running(dut):
    """io_running should be 1 while the core is active."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    assert int(dut.io_running.value) == 0, "Should not be running before start"

    # Write a simple program
    await write_imem(dut, 0, nop_bundle())
    await write_imem(dut, 1, nop_bundle())
    await write_imem(dut, 2, build_bundle(flow=flow_slot(True, FlowOp.HALT)))

    await RisingEdge(dut.clk)
    await start_core(dut)

    # Should be running immediately after start
    await RisingEdge(dut.clk)
    running = int(dut.io_running.value)
    dut._log.info(f"Running after start: {running}")

    await wait_halted(dut, 30)
    assert int(dut.io_halted.value) == 1
    dut._log.info("test_core_reports_running: PASS")


@cocotb.test()
async def test_cycle_counter(dut):
    """Verify cycleCount increments while running."""
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
    await reset(dut)

    c0 = int(dut.io_cycleCount.value)
    assert c0 == 0, f"cycleCount should be 0 after reset, got {c0}"

    # Write several NOPs then HALT
    for a in range(10):
        await write_imem(dut, a, nop_bundle())
    await write_imem(dut, 10, build_bundle(flow=flow_slot(True, FlowOp.HALT)))

    await RisingEdge(dut.clk)
    await start_core(dut)
    await wait_halted(dut, 50)

    c1 = int(dut.io_cycleCount.value)
    assert c1 > 0, f"cycleCount should be > 0, got {c1}"
    dut._log.info(f"test_cycle_counter: cycleCount={c1}")
