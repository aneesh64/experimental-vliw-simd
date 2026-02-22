"""
cocotb testbench for FlowEngine module (Sim config, coreId=0).

FlowEngine is PURELY COMBINATORIAL — no clk or reset ports.
We use Timer delays to allow signal propagation.

Tests:
  - HALT signal
  - SELECT (scalar conditional)
  - ADD_IMM (add immediate)
  - COND_JUMP / COND_JUMP_REL
  - JUMP / JUMP_INDIRECT
  - COREID / NOP
"""

import cocotb
from cocotb.triggers import Timer

# Propagation delay for combinatorial settling
SETTLE = Timer(1, units="ns")


class FlowOp:
    NOP           = 0
    SELECT        = 1
    VSELECT       = 2
    ADD_IMM       = 3
    HALT          = 4
    COND_JUMP     = 5
    COND_JUMP_REL = 6
    JUMP          = 7
    JUMP_INDIRECT = 8
    COREID        = 9


def init_inputs(dut):
    """Set all inputs to a known idle state."""
    dut.io_valid.value = 0
    dut.io_slot_valid.value = 0
    dut.io_slot_opcode.value = 0
    dut.io_slot_dest.value = 0
    dut.io_slot_operandA.value = 0
    dut.io_slot_operandB.value = 0
    dut.io_slot_immediate.value = 0
    dut.io_currentPc.value = 0
    dut.io_operandCond.value = 0
    dut.io_operandA.value = 0
    dut.io_operandB.value = 0
    for i in range(8):
        getattr(dut, f"io_vCond_{i}").value = 0
        getattr(dut, f"io_vSrcA_{i}").value = 0
        getattr(dut, f"io_vSrcB_{i}").value = 0


def set_slot(dut, opcode, dest=0, opA=0, opB=0, imm=0, pc=0,
             cond_data=0, a_data=0, b_data=0):
    dut.io_valid.value = 1
    dut.io_slot_valid.value = 1
    dut.io_slot_opcode.value = opcode
    dut.io_slot_dest.value = dest
    dut.io_slot_operandA.value = opA
    dut.io_slot_operandB.value = opB
    dut.io_slot_immediate.value = imm & 0x3FF
    dut.io_currentPc.value = pc & 0x3FF
    dut.io_operandCond.value = cond_data
    dut.io_operandA.value = a_data
    dut.io_operandB.value = b_data


def clear_slot(dut):
    dut.io_valid.value = 0
    dut.io_slot_valid.value = 0


# ===== Tests =====

@cocotb.test()
async def test_halt(dut):
    """HALT opcode asserts io_halt."""
    init_inputs(dut)
    await SETTLE

    assert int(dut.io_halt.value) == 0, "halt should be 0 when idle"

    set_slot(dut, FlowOp.HALT)
    await SETTLE

    halt_val = int(dut.io_halt.value)
    assert halt_val == 1, f"halt should be 1, got {halt_val}"

    clear_slot(dut)
    await SETTLE
    assert int(dut.io_halt.value) == 0, "halt should deassert when invalid"

    dut._log.info("test_halt: PASS")


@cocotb.test()
async def test_select_true(dut):
    """SELECT: cond != 0 → dest = operandA."""
    init_inputs(dut)
    await SETTLE

    set_slot(dut, FlowOp.SELECT, dest=5, cond_data=1, a_data=42, b_data=99)
    await SETTLE

    valid = int(dut.io_scalarWriteReq_valid.value)
    addr = int(dut.io_scalarWriteReq_payload_addr.value)
    data = int(dut.io_scalarWriteReq_payload_data.value)

    assert valid == 1, "SELECT should produce write"
    assert addr == 5, f"SELECT dest: {addr} != 5"
    assert data == 42, f"SELECT cond=1: should pick A=42, got {data}"

    clear_slot(dut)
    dut._log.info("test_select_true: PASS")


@cocotb.test()
async def test_select_false(dut):
    """SELECT: cond == 0 → dest = operandB."""
    init_inputs(dut)
    await SETTLE

    set_slot(dut, FlowOp.SELECT, dest=5, cond_data=0, a_data=42, b_data=99)
    await SETTLE

    data = int(dut.io_scalarWriteReq_payload_data.value)
    assert data == 99, f"SELECT cond=0: should pick B=99, got {data}"

    clear_slot(dut)
    dut._log.info("test_select_false: PASS")


@cocotb.test()
async def test_add_imm(dut):
    """ADD_IMM: dest = operandA + immediate."""
    init_inputs(dut)
    await SETTLE

    # operandCond carries scratch[operandA] in the RTL
    set_slot(dut, FlowOp.ADD_IMM, dest=10, cond_data=100, imm=50)
    await SETTLE

    valid = int(dut.io_scalarWriteReq_valid.value)
    data = int(dut.io_scalarWriteReq_payload_data.value)
    addr = int(dut.io_scalarWriteReq_payload_addr.value)

    assert valid == 1, "ADD_IMM should produce write"
    assert addr == 10, f"ADD_IMM dest: {addr} != 10"
    assert data == 150, f"ADD_IMM: 100+50 = {data}, expected 150"

    clear_slot(dut)
    dut._log.info("test_add_imm: PASS")


@cocotb.test()
async def test_add_imm_negative(dut):
    """ADD_IMM with large immediate (sign-extended if RTL does so)."""
    init_inputs(dut)
    await SETTLE

    # immediate is 10-bit unsigned; test with max value 1023
    set_slot(dut, FlowOp.ADD_IMM, dest=10, cond_data=1000, imm=1023)
    await SETTLE

    data = int(dut.io_scalarWriteReq_payload_data.value)
    dut._log.info(f"ADD_IMM 1000 + 1023 = {data}")
    # Document what RTL actually does (unsigned add or sign-extended)
    clear_slot(dut)
    dut._log.info("test_add_imm_negative: DONE")


@cocotb.test()
async def test_jump(dut):
    """JUMP: sets jumpTarget to immediate."""
    init_inputs(dut)
    await SETTLE

    set_slot(dut, FlowOp.JUMP, imm=42)
    await SETTLE

    jmp_valid = int(dut.io_jumpTarget_valid.value)
    jmp_target = int(dut.io_jumpTarget_payload.value)

    assert jmp_valid == 1, "JUMP should set jumpTarget valid"
    assert jmp_target == 42, f"JUMP target: {jmp_target} != 42"

    clear_slot(dut)
    dut._log.info("test_jump: PASS")


@cocotb.test()
async def test_cond_jump_taken(dut):
    """COND_JUMP: cond != 0 → jump to immediate."""
    init_inputs(dut)
    await SETTLE

    set_slot(dut, FlowOp.COND_JUMP, cond_data=1, imm=100, pc=50)
    await SETTLE

    jmp_valid = int(dut.io_jumpTarget_valid.value)
    jmp_target = int(dut.io_jumpTarget_payload.value)

    assert jmp_valid == 1, "COND_JUMP taken should set jumpTarget valid"
    assert jmp_target == 100, f"COND_JUMP target: {jmp_target} != 100"

    clear_slot(dut)
    dut._log.info("test_cond_jump_taken: PASS")


@cocotb.test()
async def test_cond_jump_not_taken(dut):
    """COND_JUMP: cond == 0 → no jump."""
    init_inputs(dut)
    await SETTLE

    set_slot(dut, FlowOp.COND_JUMP, cond_data=0, imm=100, pc=50)
    await SETTLE

    jmp_valid = int(dut.io_jumpTarget_valid.value)
    assert jmp_valid == 0, f"COND_JUMP not taken: jumpTarget should be invalid"

    clear_slot(dut)
    dut._log.info("test_cond_jump_not_taken: PASS")


@cocotb.test()
async def test_cond_jump_rel(dut):
    """COND_JUMP_REL: cond != 0 → jump to PC + immediate."""
    init_inputs(dut)
    await SETTLE

    set_slot(dut, FlowOp.COND_JUMP_REL, cond_data=1, imm=10, pc=50)
    await SETTLE

    jmp_valid = int(dut.io_jumpTarget_valid.value)
    jmp_target = int(dut.io_jumpTarget_payload.value)

    assert jmp_valid == 1, "COND_JUMP_REL taken should set jumpTarget valid"
    expected = (50 + 10) & 0x3FF
    assert jmp_target == expected, f"COND_JUMP_REL target: {jmp_target} != {expected}"

    clear_slot(dut)
    dut._log.info("test_cond_jump_rel: PASS")


@cocotb.test()
async def test_cond_jump_rel_negative(dut):
    """COND_JUMP_REL with large offset (wrap test)."""
    init_inputs(dut)
    await SETTLE

    # immediate = 1020, pc = 50 → (50 + 1020) & 0x3FF
    set_slot(dut, FlowOp.COND_JUMP_REL, cond_data=1, imm=1020, pc=50)
    await SETTLE

    jmp_target = int(dut.io_jumpTarget_payload.value)
    expected = (50 + 1020) & 0x3FF
    dut._log.info(f"COND_JUMP_REL 50+1020 mod 1024 = {jmp_target}, expected {expected}")

    clear_slot(dut)
    dut._log.info("test_cond_jump_rel_negative: DONE")


@cocotb.test()
async def test_jump_indirect(dut):
    """JUMP_INDIRECT: jump target from operandA data."""
    init_inputs(dut)
    await SETTLE

    # JUMP_INDIRECT uses io_operandCond (= scratch[operandA]) for the target
    set_slot(dut, FlowOp.JUMP_INDIRECT, cond_data=200)
    await SETTLE

    jmp_valid = int(dut.io_jumpTarget_valid.value)
    jmp_target = int(dut.io_jumpTarget_payload.value)

    assert jmp_valid == 1, "JUMP_INDIRECT should set jumpTarget valid"
    expected = 200 & 0x3FF
    assert jmp_target == expected, f"JUMP_INDIRECT target: {jmp_target} != {expected}"

    clear_slot(dut)
    dut._log.info("test_jump_indirect: PASS")


@cocotb.test()
async def test_coreid(dut):
    """COREID: writes coreId to dest."""
    init_inputs(dut)
    await SETTLE

    set_slot(dut, FlowOp.COREID, dest=7)
    await SETTLE

    valid = int(dut.io_scalarWriteReq_valid.value)
    addr = int(dut.io_scalarWriteReq_payload_addr.value)
    data = int(dut.io_scalarWriteReq_payload_data.value)

    assert valid == 1, "COREID should produce write"
    assert addr == 7, f"COREID dest: {addr} != 7"
    assert data == 0, f"COREID: expected 0, got {data}"

    clear_slot(dut)
    dut._log.info("test_coreid: PASS")


@cocotb.test()
async def test_nop(dut):
    """NOP: no writes, no halt, no jump."""
    init_inputs(dut)
    await SETTLE

    set_slot(dut, FlowOp.NOP)
    await SETTLE

    halt = int(dut.io_halt.value)
    jmp_valid = int(dut.io_jumpTarget_valid.value)
    wr_valid = int(dut.io_scalarWriteReq_valid.value)

    assert halt == 0, "NOP should not halt"
    assert jmp_valid == 0, "NOP should not jump"
    assert wr_valid == 0, "NOP should not write"

    clear_slot(dut)
    dut._log.info("test_nop: PASS")
