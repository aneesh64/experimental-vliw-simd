"""
cocotb testbench for AluEngine module (Sim config: 1 ALU slot).

Tests all 15 ALU opcodes including the multi-cycle DIV/MOD/CDIV
which use the fire-and-forget UnsignedDivider.

Port naming (from generated Verilog):
        io_slots_0_valid, io_slots_0_opcode[4:0], io_slots_0_dest[10:0],
    io_slots_0_src1[10:0], io_slots_0_src2[10:0]
    io_valid
    io_operandA_0[31:0], io_operandB_0[31:0]
    io_writeReqs_0_valid, io_writeReqs_0_payload_addr[10:0],
    io_writeReqs_0_payload_data[31:0]
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles
import random
import struct
from verification.cocotb.golden_model import _f32_binop, _i32_to_f32_bits, _u32_to_f32_bits, _f32_to_i32_bits, _f32_to_u32_bits

MASK32 = 0xFFFFFFFF

# ALU opcode encoding (must match AluOpcode in SlotBundles.scala)
class Op:
    ADD  = 0
    SUB  = 1
    MUL  = 2
    XOR  = 3
    AND  = 4
    OR   = 5
    SHL  = 6
    SHR  = 7
    LT   = 8
    EQ   = 9
    MOD  = 10
    DIV  = 11
    CDIV = 12
    MAX  = 13
    MIN  = 14
    FADD = 18
    FSUB = 19
    FMUL = 20
    FMAX = 21
    FMIN = 22
    I2F  = 23
    F2I  = 24
    U2F  = 25
    F2U  = 26


def f32_to_bits(value: float) -> int:
    return struct.unpack("<I", struct.pack("<f", float(value)))[0]


def expected_result(op, a, b):
    """Python reference for each ALU opcode."""
    a, b = a & MASK32, b & MASK32
    if op == Op.ADD:  return (a + b) & MASK32
    if op == Op.SUB:  return (a - b) & MASK32
    if op == Op.MUL:  return (a * b) & MASK32
    if op == Op.XOR:  return a ^ b
    if op == Op.AND:  return a & b
    if op == Op.OR:   return a | b
    if op == Op.SHL:  return (a << (b & 31)) & MASK32
    if op == Op.SHR:  return a >> (b & 31)
    if op == Op.LT:   return 1 if a < b else 0
    if op == Op.EQ:   return 1 if a == b else 0
    if op == Op.MOD:  return a % b if b else 0
    if op == Op.DIV:  return a // b if b else 0
    if op == Op.CDIV: return ((a + b - 1) // b) if b else 0
    if op == Op.MAX:  return a if a >= b else b
    if op == Op.MIN:  return a if a <= b else b
    raise ValueError(f"Unknown opcode {op}")


async def reset(dut, cycles=5):
    dut.reset.value = 1
    dut.io_valid.value = 0
    dut.io_slots_0_valid.value = 0
    dut.io_slots_0_opcode.value = 0
    dut.io_slots_0_dest.value = 0
    dut.io_slots_0_src1.value = 0
    dut.io_slots_0_src2.value = 0
    dut.io_operandA_0.value = 0
    dut.io_operandB_0.value = 0
    for _ in range(cycles):
        await RisingEdge(dut.clk)
    dut.reset.value = 0
    await RisingEdge(dut.clk)


async def fire_alu(dut, opcode, a, b, dest=5):
    """Issue an ALU operation for one cycle."""
    dut.io_valid.value = 1
    dut.io_slots_0_valid.value = 1
    dut.io_slots_0_opcode.value = opcode
    dut.io_slots_0_dest.value = dest
    dut.io_slots_0_src1.value = 0  # not used — operands fed directly
    dut.io_slots_0_src2.value = 0
    dut.io_operandA_0.value = a & MASK32
    dut.io_operandB_0.value = b & MASK32
    await RisingEdge(dut.clk)
    # De-assert after 1 cycle
    dut.io_valid.value = 0
    dut.io_slots_0_valid.value = 0


async def wait_fp_write(dut, latency, dest):
    for cycle in range(latency - 1):
        await RisingEdge(dut.clk)
        assert int(dut.io_writeReqs_0_valid.value) == 0, f"FP32 op completed too early at cycle {cycle + 1}"

    await RisingEdge(dut.clk)
    assert int(dut.io_writeReqs_0_valid.value) == 1, f"FP32 op did not complete at latency {latency}"
    assert int(dut.io_writeReqs_0_payload_addr.value) == dest
    return int(dut.io_writeReqs_0_payload_data.value)


async def check_single_cycle_result(dut, opcode, a, b, dest=5):
    """Fire a single-cycle ALU op and check the combinatorial result."""
    dut.io_valid.value = 1
    dut.io_slots_0_valid.value = 1
    dut.io_slots_0_opcode.value = opcode
    dut.io_slots_0_dest.value = dest
    dut.io_operandA_0.value = a & MASK32
    dut.io_operandB_0.value = b & MASK32

    await RisingEdge(dut.clk)

    # For single-cycle ops, the write should be valid on this same cycle
    valid = int(dut.io_writeReqs_0_valid.value)
    data = int(dut.io_writeReqs_0_payload_data.value)
    addr = int(dut.io_writeReqs_0_payload_addr.value)

    exp = expected_result(opcode, a, b)

    dut.io_valid.value = 0
    dut.io_slots_0_valid.value = 0

    assert valid == 1, f"Op {opcode}: writeReq not valid"
    assert addr == dest, f"Op {opcode}: dest addr {addr} != {dest}"
    assert data == exp, f"Op {opcode}: result {data} != expected {exp} (a={a}, b={b})"
    return data


@cocotb.test()
async def test_single_cycle_ops(dut):
    """Test all single-cycle ALU operations."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    test_vectors = [
        (Op.ADD,  100, 200,  300),
        (Op.ADD,  MASK32, 1, 0),       # overflow wraps
        (Op.SUB,  300, 100,  200),
        (Op.SUB,  0, 1,     MASK32),   # underflow wraps
        (Op.MUL,  100, 200,  20000),
        (Op.MUL,  65536, 65536, 0),    # overflow wraps to 0
        (Op.XOR,  0xFF00FF00, 0x0FF00FF0, 0xF0F0F0F0),
        (Op.AND,  0xFF00FF00, 0x0F0F0F0F, 0x0F000F00),
        (Op.OR,   0xFF000000, 0x00FF0000, 0xFFFF0000),
        (Op.SHL,  1, 31,     0x80000000),
        (Op.SHL,  1, 0,      1),
        (Op.SHR,  0x80000000, 31, 1),
        (Op.SHR,  0x80000000, 0,  0x80000000),
        (Op.LT,   5, 10,     1),
        (Op.LT,   10, 5,     0),
        (Op.LT,   5, 5,      0),
        (Op.EQ,   42, 42,    1),
        (Op.EQ,   42, 43,    0),
        (Op.MAX,  42, 7,     42),
        (Op.MAX,  1, MASK32, MASK32),
        (Op.MIN,  42, 7,     7),
        (Op.MIN,  1, MASK32, 1),
    ]

    for opcode, a, b, exp in test_vectors:
        result = await check_single_cycle_result(dut, opcode, a, b, dest=7)
        assert result == exp, f"Op {opcode}: {a} op {b} = {result}, expected {exp}"
        await RisingEdge(dut.clk)

    dut._log.info("test_single_cycle_ops: PASS")


@cocotb.test()
async def test_div_multicycle(dut):
    """Test DIV opcode (multi-cycle via UnsignedDivider)."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    dest = 10
    a, b = 100, 7
    await fire_alu(dut, Op.DIV, a, b, dest)

    # Wait for divider done (33 cycles)
    for cycle in range(40):
        await RisingEdge(dut.clk)
        if int(dut.io_writeReqs_0_valid.value) == 1:
            data = int(dut.io_writeReqs_0_payload_data.value)
            addr = int(dut.io_writeReqs_0_payload_addr.value)
            exp = a // b
            assert data == exp, f"DIV: {data} != {exp}"
            assert addr == dest, f"DIV dest: {addr} != {dest}"
            dut._log.info(f"DIV {a}/{b} = {data} (done at cycle {cycle+1})")
            break
    else:
        raise AssertionError("DIV did not complete")

    dut._log.info("test_div_multicycle: PASS")


@cocotb.test()
async def test_mod_multicycle(dut):
    """Test MOD opcode (multi-cycle, returns remainder)."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    dest = 11
    a, b = 100, 7
    await fire_alu(dut, Op.MOD, a, b, dest)

    for cycle in range(40):
        await RisingEdge(dut.clk)
        if int(dut.io_writeReqs_0_valid.value) == 1:
            data = int(dut.io_writeReqs_0_payload_data.value)
            addr = int(dut.io_writeReqs_0_payload_addr.value)
            exp = a % b
            assert data == exp, f"MOD: {data} != {exp}"
            assert addr == dest, f"MOD dest: {addr} != {dest}"
            dut._log.info(f"MOD {a}%{b} = {data} (done at cycle {cycle+1})")
            break
    else:
        raise AssertionError("MOD did not complete")

    dut._log.info("test_mod_multicycle: PASS")


@cocotb.test()
async def test_cdiv_multicycle(dut):
    """Test CDIV (ceiling division) opcode."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    dest = 12
    a, b = 100, 7
    await fire_alu(dut, Op.CDIV, a, b, dest)

    for cycle in range(40):
        await RisingEdge(dut.clk)
        if int(dut.io_writeReqs_0_valid.value) == 1:
            data = int(dut.io_writeReqs_0_payload_data.value)
            addr = int(dut.io_writeReqs_0_payload_addr.value)
            exp = (a + b - 1) // b
            assert data == exp, f"CDIV: {data} != {exp}"
            assert addr == dest, f"CDIV dest: {addr} != {dest}"
            dut._log.info(f"CDIV ceil({a}/{b}) = {data} (done at cycle {cycle+1})")
            break
    else:
        raise AssertionError("CDIV did not complete")

    dut._log.info("test_cdiv_multicycle: PASS")


@cocotb.test()
async def test_no_write_when_invalid(dut):
    """Verify no write request when valid=0."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    dut.io_valid.value = 0
    dut.io_slots_0_valid.value = 1
    dut.io_slots_0_opcode.value = Op.ADD
    dut.io_operandA_0.value = 100
    dut.io_operandB_0.value = 200

    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)

    valid = int(dut.io_writeReqs_0_valid.value)
    assert valid == 0, "writeReq should not be valid when io_valid=0"

    dut._log.info("test_no_write_when_invalid: PASS")


@cocotb.test()
async def test_random_single_cycle(dut):
    """Random test for single-cycle operations."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    rng = random.Random(123)
    single_ops = [Op.ADD, Op.SUB, Op.MUL, Op.XOR, Op.AND, Op.OR, Op.SHL, Op.SHR, Op.LT, Op.EQ, Op.MAX, Op.MIN]

    for _ in range(100):
        op = rng.choice(single_ops)
        a = rng.randint(0, MASK32)
        b = rng.randint(0, MASK32)
        result = await check_single_cycle_result(dut, op, a, b, dest=20)
        exp = expected_result(op, a, b)
        assert result == exp, f"Op {op}: {a} op {b} = {result} != {exp}"
        await RisingEdge(dut.clk)

    dut._log.info("test_random_single_cycle: PASS (100 cases)")


@cocotb.test()
async def test_fp32_add_and_convert_smoke(dut):
    """Smoke-test serialized FP32 add and conversion latency on AluEngine."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    await fire_alu(dut, Op.FADD, f32_to_bits(1.5), f32_to_bits(2.25), dest=21)
    for cycle in range(3):
        await RisingEdge(dut.clk)
        assert int(dut.io_writeReqs_0_valid.value) == 0, f"FADD completed too early at cycle {cycle + 1}"

    await RisingEdge(dut.clk)
    assert int(dut.io_writeReqs_0_valid.value) == 1, "FADD did not complete at 4-cycle latency"
    assert int(dut.io_writeReqs_0_payload_addr.value) == 21
    assert int(dut.io_writeReqs_0_payload_data.value) == f32_to_bits(3.75)

    await fire_alu(dut, Op.I2F, 7, 0, dest=22)
    for _ in range(3):
        await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert int(dut.io_writeReqs_0_valid.value) == 1, "I2F did not complete at 4-cycle latency"
    assert int(dut.io_writeReqs_0_payload_addr.value) == 22
    assert int(dut.io_writeReqs_0_payload_data.value) == f32_to_bits(7.0)

    dut._log.info("test_fp32_add_and_convert_smoke: PASS")


@cocotb.test()
async def test_fp32_reference_vectors(dut):
    """Check scalar FP32 ops against the golden-model reference."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    binary_cases = [
        (Op.FADD, "fadd", 4, [
            (0x3F800000, 0x40000000),
            (0x00000001, 0x00000001),
            (0x7F800000, 0x3F800000),
            (0x7F800000, 0xFF800000),
            (0x80000000, 0x00000000),
        ]),
        (Op.FSUB, "fsub", 4, [
            (0x40400000, 0x3FC00000),
            (0x00000002, 0x00000001),
            (0x7F800000, 0x7F800000),
            (0xBF800000, 0x3F800000),
        ]),
        (Op.FMUL, "fmul", 5, [
            (0x3FC00000, 0x40200000),
            (0x00000001, 0x3F800000),
            (0x7F800000, 0x00000000),
            (0xBF800000, 0x40000000),
        ]),
        (Op.FMAX, "fmax", 4, [
            (0x80000000, 0x00000000),
            (0x7FC00000, 0x3F800000),
            (0xBF800000, 0x3F000000),
        ]),
        (Op.FMIN, "fmin", 4, [
            (0x80000000, 0x00000000),
            (0x7FC00000, 0x3F800000),
            (0xBF800000, 0x3F000000),
        ]),
    ]

    dest = 40
    for opcode, ref_name, latency, cases in binary_cases:
        for a_bits, b_bits in cases:
            await fire_alu(dut, opcode, a_bits, b_bits, dest=dest)
            data = await wait_fp_write(dut, latency, dest)
            exp = _f32_binop(ref_name, a_bits, b_bits)
            assert data == exp, f"Op {ref_name}: got 0x{data:08x}, expected 0x{exp:08x}"
            await RisingEdge(dut.clk)
            dest += 1

    conv_cases = [
        (Op.I2F, 4, [0, 1, 0xFFFFFFFF, 0x80000000, 0x7FFFFFFF], _i32_to_f32_bits),
        (Op.U2F, 4, [0, 1, 0xFFFFFFFF, 0x80000000, 0x7FFFFFFF], _u32_to_f32_bits),
        (Op.F2I, 4, [0x00000001, 0x3FC00000, 0xBF800000, 0x7F800000, 0x7FC00000], _f32_to_i32_bits),
        (Op.F2U, 4, [0x00000001, 0x3FC00000, 0xBF800000, 0x7F800000, 0x7FC00000], _f32_to_u32_bits),
    ]

    for opcode, latency, values, ref_fn in conv_cases:
        for value in values:
            await fire_alu(dut, opcode, value, 0, dest=dest)
            data = await wait_fp_write(dut, latency, dest)
            exp = ref_fn(value)
            assert data == exp, f"Conv op {opcode}: got 0x{data:08x}, expected 0x{exp:08x}"
            await RisingEdge(dut.clk)
            dest += 1

    rng = random.Random(321)
    for opcode, ref_name, latency in ((Op.FADD, "fadd", 4), (Op.FSUB, "fsub", 4), (Op.FMUL, "fmul", 5)):
        for _ in range(25):
            a_bits = rng.getrandbits(32)
            b_bits = rng.getrandbits(32)
            await fire_alu(dut, opcode, a_bits, b_bits, dest=dest)
            data = await wait_fp_write(dut, latency, dest)
            exp = _f32_binop(ref_name, a_bits, b_bits)
            assert data == exp, f"Random {ref_name}: got 0x{data:08x}, expected 0x{exp:08x}"
            await RisingEdge(dut.clk)
            dest += 1

    dut._log.info("test_fp32_reference_vectors: PASS")
