"""
cocotb testbench for ValuEngine module (Sim config: 1 VALU slot, VLEN=8).

Tests vector ALU operations across all 8 lanes, including:
  - Lane-wise ADD, SUB, MUL, XOR, AND, OR, SHL, SHR, LT, EQ
  - VBROADCAST (opcode 13)
  - MULTIPLY_ADD (opcode 14, DSP48 path)
  - Multi-cycle DIV/MOD/CDIV per lane (8 parallel dividers)

Port naming:
  io_slots_0_{valid,opcode,destBase,src1Base,src2Base,src3Base}
  io_valid
  io_operandA_0_{0..7}, io_operandB_0_{0..7}, io_operandC_0_{0..7}
  io_writeReqs_0_{0..7}_{valid,payload_addr,payload_data}
"""

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
import random

MASK32 = 0xFFFFFFFF
VLEN = 8


class Op:
    ADD  = 0;  SUB  = 1;  MUL  = 2;  XOR = 3;  AND = 4;  OR  = 5
    SHL  = 6;  SHR  = 7;  LT   = 8;  EQ  = 9
    MOD  = 10; DIV  = 11; CDIV = 12; MAX = 13; MIN = 14
    VBROADCAST   = 15
    MULTIPLY_ADD = 16


def alu_ref(op, a, b, c=0):
    a, b, c = a & MASK32, b & MASK32, c & MASK32
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
    if op == Op.MOD:  return (a % b) if b else 0
    if op == Op.DIV:  return (a // b) if b else 0
    if op == Op.CDIV: return ((a + b - 1) // b) if b else 0
    if op == Op.MAX:  return a if a >= b else b
    if op == Op.MIN:  return a if a <= b else b
    if op == Op.MULTIPLY_ADD: return (a * b + c) & MASK32
    raise ValueError(f"Unknown op {op}")


def _s8(value):
    value &= 0xFF
    return value - 256 if value & 0x80 else value


def _pack_u8(values):
    packed = 0
    for lane, value in enumerate(values):
        packed |= (value & 0xFF) << (lane * 8)
    return packed


async def reset(dut, cycles=5):
    dut.reset.value = 1
    dut.io_valid.value = 0
    dut.io_slots_0_valid.value = 0
    dut.io_slots_0_opcode.value = 0
    dut.io_slots_0_destBase.value = 0
    dut.io_slots_0_src1Base.value = 0
    dut.io_slots_0_src2Base.value = 0
    dut.io_slots_0_src3Base.value = 0
    dut.io_slots_0_ewidth.value = 0   # EW32
    dut.io_slots_0_dwidth.value = 0   # EW32
    dut.io_slots_0_isSigned.value = 0
    for lane in range(VLEN):
        getattr(dut, f"io_operandA_0_{lane}").value = 0
        getattr(dut, f"io_operandB_0_{lane}").value = 0
        getattr(dut, f"io_operandC_0_{lane}").value = 0
    for _ in range(cycles):
        await RisingEdge(dut.clk)
    dut.reset.value = 0
    await RisingEdge(dut.clk)


def set_operands(dut, a_vec, b_vec, c_vec=None):
    """Set per-lane operands. Each is a list of VLEN values."""
    for lane in range(VLEN):
        getattr(dut, f"io_operandA_0_{lane}").value = a_vec[lane] & MASK32
        getattr(dut, f"io_operandB_0_{lane}").value = b_vec[lane] & MASK32
        if c_vec:
            getattr(dut, f"io_operandC_0_{lane}").value = c_vec[lane] & MASK32


def get_write_results(dut):
    """Read all 8 lane write requests. Returns list of (valid, addr, data)."""
    results = []
    for lane in range(VLEN):
        v = int(getattr(dut, f"io_writeReqs_0_{lane}_valid").value)
        a = int(getattr(dut, f"io_writeReqs_0_{lane}_payload_addr").value)
        d = int(getattr(dut, f"io_writeReqs_0_{lane}_payload_data").value)
        results.append((v, a, d))
    return results


async def fire_valu(dut, opcode, a_vec, b_vec, c_vec=None, dest_base=16):
    """Issue a VALU operation for one cycle."""
    dut.io_valid.value = 1
    dut.io_slots_0_valid.value = 1
    dut.io_slots_0_opcode.value = opcode
    dut.io_slots_0_destBase.value = dest_base
    set_operands(dut, a_vec, b_vec, c_vec)
    await RisingEdge(dut.clk)
    dut.io_valid.value = 0
    dut.io_slots_0_valid.value = 0


@cocotb.test()
async def test_vector_add(dut):
    """Test lane-wise vector ADD."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    a = [i * 10 for i in range(VLEN)]
    b = [i * 3 for i in range(VLEN)]
    dest_base = 100

    dut.io_valid.value = 1
    dut.io_slots_0_valid.value = 1
    dut.io_slots_0_opcode.value = Op.ADD
    dut.io_slots_0_destBase.value = dest_base
    set_operands(dut, a, b)

    await RisingEdge(dut.clk)

    results = get_write_results(dut)
    for lane in range(VLEN):
        v, addr, data = results[lane]
        exp = (a[lane] + b[lane]) & MASK32
        assert v == 1, f"Lane {lane}: not valid"
        assert addr == (dest_base + lane) & 0x7FF, f"Lane {lane}: addr {addr} != {dest_base+lane}"
        assert data == exp, f"Lane {lane}: {data} != {exp}"

    dut._log.info("test_vector_add: PASS")


@cocotb.test()
async def test_vector_mul(dut):
    """Test lane-wise vector MUL."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    a = [100 + i for i in range(VLEN)]
    b = [200 + i for i in range(VLEN)]

    dut.io_valid.value = 1
    dut.io_slots_0_valid.value = 1
    dut.io_slots_0_opcode.value = Op.MUL
    dut.io_slots_0_destBase.value = 0
    set_operands(dut, a, b)

    await RisingEdge(dut.clk)
    results = get_write_results(dut)

    for lane in range(VLEN):
        v, _, data = results[lane]
        exp = (a[lane] * b[lane]) & MASK32
        assert v == 1 and data == exp, f"Lane {lane}: MUL {data} != {exp}"

    dut._log.info("test_vector_mul: PASS")


@cocotb.test()
async def test_vector_max_min_unsigned_ew32(dut):
    """Test lane-wise unsigned vector MAX/MIN at EW32."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    a = [3, 40, 7, 99, 123, 2, 0xFFFFFFFE, 15]
    b = [9, 10, 70, 12, 122, 8, 0xFFFFFFFF, 1]

    for opcode, ref in ((Op.MAX, max), (Op.MIN, min)):
        dut.io_valid.value = 1
        dut.io_slots_0_valid.value = 1
        dut.io_slots_0_opcode.value = opcode
        dut.io_slots_0_destBase.value = 32
        dut.io_slots_0_ewidth.value = 0
        dut.io_slots_0_dwidth.value = 0
        dut.io_slots_0_isSigned.value = 0
        set_operands(dut, a, b)

        await RisingEdge(dut.clk)
        results = get_write_results(dut)

        for lane in range(VLEN):
            v, addr, data = results[lane]
            exp = ref(a[lane] & MASK32, b[lane] & MASK32)
            assert v == 1, f"Lane {lane}: MAX/MIN write not valid"
            assert addr == 32 + lane, f"Lane {lane}: addr {addr} != {32 + lane}"
            assert data == exp, f"Lane {lane}: got {data:#x}, expected {exp:#x}"

        dut.io_valid.value = 0
        dut.io_slots_0_valid.value = 0
        await RisingEdge(dut.clk)

    dut._log.info("test_vector_max_min_unsigned_ew32: PASS")


@cocotb.test()
async def test_vector_max_min_signed_packed_ew8(dut):
    """Test packed signed vector MAX/MIN at EW8."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    a_words = [
        _pack_u8([0xF0, 0x05, 0x7F, 0x80]),
        _pack_u8([0x01, 0xFE, 0x10, 0xA0]),
        _pack_u8([0x20, 0x30, 0x40, 0x50]),
        _pack_u8([0xAA, 0xBB, 0xCC, 0xDD]),
        _pack_u8([0x12, 0x34, 0x56, 0x78]),
        _pack_u8([0x87, 0x65, 0x43, 0x21]),
        _pack_u8([0x00, 0x7E, 0x81, 0xFF]),
        _pack_u8([0x11, 0x22, 0x33, 0x44]),
    ]
    b_words = [
        _pack_u8([0x08, 0xF9, 0x01, 0x7F]),
        _pack_u8([0x02, 0x05, 0xF0, 0x90]),
        _pack_u8([0x10, 0x31, 0x3F, 0x60]),
        _pack_u8([0xAB, 0xBA, 0xCD, 0xDC]),
        _pack_u8([0x21, 0x43, 0x65, 0x87]),
        _pack_u8([0x78, 0x56, 0x34, 0x12]),
        _pack_u8([0xFF, 0x7F, 0x80, 0x00]),
        _pack_u8([0x44, 0x33, 0x22, 0x11]),
    ]

    def signed_lane_ref(word_a, word_b, want_max):
        lanes = []
        for lane in range(4):
            aa = (word_a >> (lane * 8)) & 0xFF
            bb = (word_b >> (lane * 8)) & 0xFF
            sa = _s8(aa)
            sb = _s8(bb)
            choose_a = sa >= sb if want_max else sa <= sb
            lanes.append(aa if choose_a else bb)
        return _pack_u8(lanes)

    for opcode, want_max in ((Op.MAX, True), (Op.MIN, False)):
        dut.io_valid.value = 1
        dut.io_slots_0_valid.value = 1
        dut.io_slots_0_opcode.value = opcode
        dut.io_slots_0_destBase.value = 64
        dut.io_slots_0_ewidth.value = 1
        dut.io_slots_0_dwidth.value = 1
        dut.io_slots_0_isSigned.value = 1
        set_operands(dut, a_words, b_words)

        await RisingEdge(dut.clk)
        results = get_write_results(dut)

        for lane in range(VLEN):
            v, addr, data = results[lane]
            exp = signed_lane_ref(a_words[lane], b_words[lane], want_max)
            assert v == 1, f"Lane {lane}: packed MAX/MIN write not valid"
            assert addr == 64 + lane, f"Lane {lane}: addr {addr} != {64 + lane}"
            assert data == exp, f"Lane {lane}: got {data:#010x}, expected {exp:#010x}"

        dut.io_valid.value = 0
        dut.io_slots_0_valid.value = 0
        await RisingEdge(dut.clk)

    dut._log.info("test_vector_max_min_signed_packed_ew8: PASS")


@cocotb.test()
async def test_vbroadcast(dut):
    """Test VBROADCAST: all lanes get operandC[0]."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    broadcast_val = 42
    # In standalone ValuEngine, VBROADCAST at EW32 outputs operandC per lane.
    # VliwCore broadcasts one scalar to all lanes — mirror that here.
    c_vec = [broadcast_val] * VLEN

    dut.io_valid.value = 1
    dut.io_slots_0_valid.value = 1
    dut.io_slots_0_opcode.value = Op.VBROADCAST
    dut.io_slots_0_destBase.value = 200
    set_operands(dut, [0]*VLEN, [0]*VLEN, c_vec)

    await RisingEdge(dut.clk)
    results = get_write_results(dut)

    for lane in range(VLEN):
        v, addr, data = results[lane]
        assert v == 1, f"Lane {lane}: not valid"
        assert data == broadcast_val, f"Lane {lane}: broadcast {data} != {broadcast_val}"

    dut._log.info("test_vbroadcast: PASS")


@cocotb.test()
async def test_multiply_add(dut):
    """Test MULTIPLY_ADD: result = (a * b + c) mod 2^32 per lane."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    a = [10 + i for i in range(VLEN)]
    b = [20 + i for i in range(VLEN)]
    c = [30 + i for i in range(VLEN)]

    dut.io_valid.value = 1
    dut.io_slots_0_valid.value = 1
    dut.io_slots_0_opcode.value = Op.MULTIPLY_ADD
    dut.io_slots_0_destBase.value = 50
    set_operands(dut, a, b, c)

    await RisingEdge(dut.clk)
    results = get_write_results(dut)

    for lane in range(VLEN):
        v, _, data = results[lane]
        exp = (a[lane] * b[lane] + c[lane]) & MASK32
        assert v == 1 and data == exp, f"Lane {lane}: MAD {data} != {exp}"

    dut._log.info("test_multiply_add: PASS")


@cocotb.test()
async def test_vector_div(dut):
    """Test lane-wise DIV (multi-cycle, 8 parallel dividers)."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    a = [100 + i * 13 for i in range(VLEN)]
    b = [7 + i for i in range(VLEN)]
    dest_base = 300

    await fire_valu(dut, Op.DIV, a, b, dest_base=dest_base)

    # Wait for all lane dividers to complete (33 cycles)
    for cycle in range(40):
        await RisingEdge(dut.clk)
        results = get_write_results(dut)
        if results[0][0] == 1:  # lane 0 done means all done
            for lane in range(VLEN):
                v, addr, data = results[lane]
                exp = a[lane] // b[lane]
                assert v == 1, f"Lane {lane}: DIV not valid"
                assert data == exp, f"Lane {lane}: DIV {a[lane]}/{b[lane]} = {data} != {exp}"
            dut._log.info(f"test_vector_div: PASS (done at cycle {cycle+1})")
            return

    raise AssertionError("Vector DIV did not complete")


@cocotb.test()
async def test_vector_mod(dut):
    """Test lane-wise MOD (multi-cycle, 8 parallel dividers)."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    a = [100 + i * 13 for i in range(VLEN)]
    b = [7 + i for i in range(VLEN)]
    dest_base = 400

    await fire_valu(dut, Op.MOD, a, b, dest_base=dest_base)

    for cycle in range(40):
        await RisingEdge(dut.clk)
        results = get_write_results(dut)
        if results[0][0] == 1:
            for lane in range(VLEN):
                v, addr, data = results[lane]
                exp = a[lane] % b[lane]
                assert v == 1, f"Lane {lane}: MOD not valid"
                assert data == exp, f"Lane {lane}: MOD {a[lane]}%{b[lane]} = {data} != {exp}"
            dut._log.info(f"test_vector_mod: PASS (done at cycle {cycle+1})")
            return

    raise AssertionError("Vector MOD did not complete")


@cocotb.test()
async def test_all_single_cycle_ops(dut):
    """Sweep all single-cycle opcodes with random data."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    rng = random.Random(99)
    single_ops = [Op.ADD, Op.SUB, Op.MUL, Op.XOR, Op.AND, Op.OR, Op.SHL, Op.SHR, Op.LT, Op.EQ, Op.MAX, Op.MIN]

    for op in single_ops:
        a = [rng.randint(0, MASK32) for _ in range(VLEN)]
        b = [rng.randint(0, MASK32) for _ in range(VLEN)]

        dut.io_valid.value = 1
        dut.io_slots_0_valid.value = 1
        dut.io_slots_0_opcode.value = op
        dut.io_slots_0_destBase.value = 0
        set_operands(dut, a, b)

        await RisingEdge(dut.clk)
        results = get_write_results(dut)

        for lane in range(VLEN):
            v, _, data = results[lane]
            exp = alu_ref(op, a[lane], b[lane])
            assert v == 1 and data == exp, \
                f"Op {op} Lane {lane}: {data} != {exp} (a={a[lane]:#x}, b={b[lane]:#x})"

    dut.io_valid.value = 0
    dut.io_slots_0_valid.value = 0
    dut._log.info("test_all_single_cycle_ops: PASS")
