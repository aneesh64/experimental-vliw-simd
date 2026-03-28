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
import struct
from verification.cocotb.golden_model import _f32_binop, _i32_to_f32_bits, _f32_to_i32_bits

MASK32 = 0xFFFFFFFF
VLEN = 8


class Op:
    ADD  = 0;  SUB  = 1;  MUL  = 2;  XOR = 3;  AND = 4;  OR  = 5
    SHL  = 6;  SHR  = 7;  LT   = 8;  EQ  = 9
    MOD  = 10; DIV  = 11; CDIV = 12; MAX = 13; MIN = 14
    FADD = 18; FSUB = 19; FMUL = 20; FMAX = 21; FMIN = 22
    I2F = 23; F2I = 24; U2F = 25; F2U = 26
    VBROADCAST   = 15
    MULTIPLY_ADD = 16


def f32_to_bits(value: float) -> int:
    return struct.unpack("<I", struct.pack("<f", float(value)))[0]


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


async def wait_vector_fp_write(dut, latency, dest_base):
    for cycle in range(latency - 1):
        await RisingEdge(dut.clk)
        results = get_write_results(dut)
        assert all(valid == 0 for valid, _, _ in results), f"Vector FP32 op completed too early at cycle {cycle + 1}"

    await RisingEdge(dut.clk)
    results = get_write_results(dut)
    for lane in range(VLEN):
        valid, addr, _ = results[lane]
        assert valid == 1, f"Lane {lane}: write not valid at latency {latency}"
        assert addr == dest_base + lane, f"Lane {lane}: addr {addr} != {dest_base + lane}"
    return [data for _, _, data in results]


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


@cocotb.test()
async def test_vector_fp32_add_smoke(dut):
    """Smoke-test serialized EW32 vector FP32 add latency and lane outputs."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    a = [f32_to_bits(v) for v in (1.0, 2.0, 3.5, 4.5, 5.0, 6.25, 7.5, 8.0)]
    b = [f32_to_bits(v) for v in (0.5, 1.5, 2.5, 3.0, 4.0, 5.75, 6.5, 7.0)]
    exp = [f32_to_bits(v) for v in (1.5, 3.5, 6.0, 7.5, 9.0, 12.0, 14.0, 15.0)]

    await fire_valu(dut, Op.FADD, a, b, dest_base=500)
    for cycle in range(3):
        await RisingEdge(dut.clk)
        results = get_write_results(dut)
        assert all(valid == 0 for valid, _, _ in results), f"Vector FADD completed too early at cycle {cycle + 1}"

    await RisingEdge(dut.clk)
    results = get_write_results(dut)
    for lane in range(VLEN):
        valid, addr, data = results[lane]
        assert valid == 1, f"Lane {lane}: FP32 write not valid"
        assert addr == 500 + lane, f"Lane {lane}: addr {addr} != {500 + lane}"
        assert data == exp[lane], f"Lane {lane}: got 0x{data:08x}, expected 0x{exp[lane]:08x}"

    dut._log.info("test_vector_fp32_add_smoke: PASS")


@cocotb.test()
async def test_vector_fp32_reference_ops(dut):
    """Check vector FP32 ops against the golden-model reference."""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())
    await reset(dut)

    dest_base = 560
    op_cases = [
        (
            Op.FADD,
            "fadd",
            4,
            [0x3F800000, 0x00000001, 0x7F800000, 0x80000000, 0xBF800000, 0x7FC00000, 0x00400000, 0x7F7FFFFF],
            [0x40000000, 0x00000001, 0xFF800000, 0x00000000, 0x3F800000, 0x3F800000, 0x00400000, 0x00800000],
        ),
        (
            Op.FMUL,
            "fmul",
            5,
            [0x3FC00000, 0x00000001, 0x7F800000, 0xBF800000, 0x3F000000, 0x7FC00000, 0x00400000, 0x7F7FFFFF],
            [0x40200000, 0x3F800000, 0x00000000, 0x40000000, 0x3F000000, 0x3F800000, 0x00400000, 0x00800000],
        ),
    ]

    for opcode, ref_name, latency, a_vec, b_vec in op_cases:
        await fire_valu(dut, opcode, a_vec, b_vec, dest_base=dest_base)
        data_vec = await wait_vector_fp_write(dut, latency, dest_base)
        for lane in range(VLEN):
            exp = _f32_binop(ref_name, a_vec[lane], b_vec[lane])
            assert data_vec[lane] == exp, f"Lane {lane} {ref_name}: got 0x{data_vec[lane]:08x}, expected 0x{exp:08x}"
        await RisingEdge(dut.clk)
        dest_base += VLEN

    a_vec = [0, 1, 0xFFFFFFFF, 0x80000000, 0x7FFFFFFF, 123456789, 0x00010000, 0x00FFFFFF]
    zeros = [0] * VLEN
    await fire_valu(dut, Op.I2F, a_vec, zeros, dest_base=dest_base)
    data_vec = await wait_vector_fp_write(dut, 4, dest_base)
    for lane in range(VLEN):
        exp = _i32_to_f32_bits(a_vec[lane])
        assert data_vec[lane] == exp, f"Lane {lane} i2f: got 0x{data_vec[lane]:08x}, expected 0x{exp:08x}"
    await RisingEdge(dut.clk)
    dest_base += VLEN

    a_vec = [0x00000001, 0x3FC00000, 0xBF800000, 0x7F800000, 0x7FC00000, 0x00400000, 0x7F7FFFFF, 0xCF000000]
    await fire_valu(dut, Op.F2I, a_vec, zeros, dest_base=dest_base)
    data_vec = await wait_vector_fp_write(dut, 4, dest_base)
    for lane in range(VLEN):
        exp = _f32_to_i32_bits(a_vec[lane])
        assert data_vec[lane] == exp, f"Lane {lane} f2i: got 0x{data_vec[lane]:08x}, expected 0x{exp:08x}"
    await RisingEdge(dut.clk)

    dut._log.info("test_vector_fp32_reference_ops: PASS")
