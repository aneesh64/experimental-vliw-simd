from test_algorithms_common import *

@cocotb.test()
async def test_multiwidth_packed_8bit_add(dut):
    """Multi-width: 8-bit packed ADD — 4 sub-elements per lane, 32 total."""
    harness = VliwCoreHarness(dut)

    # Prepare 8 lanes × 4 packed 8-bit values each
    a_vals = []
    b_vals = []
    for lane in range(8):
        subs_a = [(lane * 4 + k + 1) & 0xFF for k in range(4)]
        subs_b = [(10 + lane * 4 + k) & 0xFF for k in range(4)]
        a_vals.append(_pack_subs(subs_a, 8))
        b_vals.append(_pack_subs(subs_b, 8))

    golden = []
    for lane in range(8):
        subs_a = _extract_subs(a_vals[lane], 8)
        subs_b = _extract_subs(b_vals[lane], 8)
        subs_r = [((a + b) & 0xFF) for a, b in zip(subs_a, subs_b)]
        golden.append(_pack_subs(subs_r, 8))

    # Preload a_vals at addr 0..7, b_vals at addr 8..15
    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_vals)
    await harness.init()

    out_base = 1000

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),           # a vector
        S.const(11, 8),
        S.vload(208, 11),           # b vector
        S.valu_op("add", 216, 200, 208, ew=8),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden[lane], (
            f"8-bit ADD lane {lane}: expected 0x{golden[lane]:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_packed_8bit_add: PASS, cycles={cycles}")


# ============================================================================
#  Test: Packed 16-bit SUB across all 8 lanes (16 elements total)
# ============================================================================

@cocotb.test()
async def test_multiwidth_packed_16bit_sub(dut):
    """Multi-width: 16-bit packed SUB — 2 sub-elements per lane, 16 total."""
    harness = VliwCoreHarness(dut)

    a_vals = []
    b_vals = []
    for lane in range(8):
        subs_a = [(100 + lane * 2 + k) & 0xFFFF for k in range(2)]
        subs_b = [(50 + lane + k) & 0xFFFF for k in range(2)]
        a_vals.append(_pack_subs(subs_a, 16))
        b_vals.append(_pack_subs(subs_b, 16))

    golden = []
    for lane in range(8):
        subs_a = _extract_subs(a_vals[lane], 16)
        subs_b = _extract_subs(b_vals[lane], 16)
        subs_r = [((a - b) & 0xFFFF) for a, b in zip(subs_a, subs_b)]
        golden.append(_pack_subs(subs_r, 16))

    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_vals)
    await harness.init()

    out_base = 1104  # must be 16-word aligned for VSTORE

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.const(11, 8),
        S.vload(208, 11),
        S.valu_op("sub", 216, 200, 208, ew=16),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden[lane], (
            f"16-bit SUB lane {lane}: expected 0x{golden[lane]:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_packed_16bit_sub: PASS, cycles={cycles}")


# ============================================================================
#  Test: Packed 8-bit MUL (unsigned)
# ============================================================================

@cocotb.test()
async def test_multiwidth_packed_8bit_mul(dut):
    """Multi-width: 8-bit packed MUL — result truncated to 8 bits per element."""
    harness = VliwCoreHarness(dut)

    a_vals = []
    b_vals = []
    for lane in range(8):
        subs_a = [(3 + lane + k) & 0xFF for k in range(4)]
        subs_b = [(2 + k) & 0xFF for k in range(4)]
        a_vals.append(_pack_subs(subs_a, 8))
        b_vals.append(_pack_subs(subs_b, 8))

    golden = []
    for lane in range(8):
        subs_a = _extract_subs(a_vals[lane], 8)
        subs_b = _extract_subs(b_vals[lane], 8)
        subs_r = [((a * b) & 0xFF) for a, b in zip(subs_a, subs_b)]
        golden.append(_pack_subs(subs_r, 8))

    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_vals)
    await harness.init()

    out_base = 1200

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.const(11, 8),
        S.vload(208, 11),
        S.valu_op("mul", 216, 200, 208, ew=8),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden[lane], (
            f"8-bit MUL lane {lane}: expected 0x{golden[lane]:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_packed_8bit_mul: PASS, cycles={cycles}")


# ============================================================================
#  Test: Packed 8-bit bitwise (XOR, AND, OR)
# ============================================================================

@cocotb.test()
async def test_multiwidth_packed_8bit_bitwise(dut):
    """Multi-width: 8-bit packed XOR, AND, OR — bitwise ops are width-agnostic."""
    harness = VliwCoreHarness(dut)

    a_vals = [0xAABBCCDD] * 8
    b_vals = [0x0F0F0F0F] * 8

    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_vals)
    await harness.init()

    out_xor = 1296  # must be 16-word aligned for VSTORE
    out_and = 1312
    out_or  = 1328

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.const(11, 8),
        S.vload(208, 11),
        # XOR at 8-bit width
        S.valu_op("xor", 216, 200, 208, ew=8),
        S.const(12, out_xor),
        S.vstore(12, 216),
        # AND at 8-bit width
        S.valu_op("and", 224, 200, 208, ew=8),
        S.const(13, out_and),
        S.vstore(13, 224),
        # OR at 8-bit width
        S.valu_op("or", 232, 200, 208, ew=8),
        S.const(14, out_or),
        S.vstore(14, 232),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    golden_xor = 0xAABBCCDD ^ 0x0F0F0F0F  # 0xA5B4C3D2
    golden_and = 0xAABBCCDD & 0x0F0F0F0F  # 0x0A0B0C0D
    golden_or  = 0xAABBCCDD | 0x0F0F0F0F  # 0xAFBFCFDF

    for lane in range(8):
        got = harness.axi_mem.read_word(out_xor + lane)
        assert got == golden_xor, f"8-bit XOR lane {lane}: expected 0x{golden_xor:08X}, got 0x{got:08X}"
        got = harness.axi_mem.read_word(out_and + lane)
        assert got == golden_and, f"8-bit AND lane {lane}: expected 0x{golden_and:08X}, got 0x{got:08X}"
        got = harness.axi_mem.read_word(out_or + lane)
        assert got == golden_or, f"8-bit OR lane {lane}: expected 0x{golden_or:08X}, got 0x{got:08X}"

    dut._log.info(f"test_multiwidth_packed_8bit_bitwise: PASS, cycles={cycles}")


# ============================================================================
#  Test: Packed 8-bit SHL and SHR
# ============================================================================

@cocotb.test()
async def test_multiwidth_packed_8bit_shift(dut):
    """Multi-width: 8-bit packed SHL and SHR."""
    harness = VliwCoreHarness(dut)

    # Each lane: 4 packed 8-bit values, shift amounts 1,2,3,4
    a_vals = [_pack_subs([0x80, 0x40, 0x20, 0x10], 8)] * 8
    b_shl  = [_pack_subs([1, 2, 3, 4], 8)] * 8
    b_shr  = [_pack_subs([1, 2, 3, 4], 8)] * 8

    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_shl)
    await harness.init()

    out_shl = 1400
    out_shr = 1408

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.const(11, 8),
        S.vload(208, 11),
        S.valu_op("shl", 216, 200, 208, ew=8),
        S.const(12, out_shl),
        S.vstore(12, 216),
        S.valu_op("shr", 224, 200, 208, ew=8),
        S.const(13, out_shr),
        S.vstore(13, 224),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # SHL: 0x80<<1=0x00, 0x40<<2=0x00, 0x20<<3=0x00, 0x10<<4=0x00
    golden_shl = _pack_subs([(0x80 << 1) & 0xFF, (0x40 << 2) & 0xFF,
                              (0x20 << 3) & 0xFF, (0x10 << 4) & 0xFF], 8)
    # SHR: 0x80>>1=0x40, 0x40>>2=0x10, 0x20>>3=0x04, 0x10>>4=0x01
    golden_shr = _pack_subs([0x80 >> 1, 0x40 >> 2, 0x20 >> 3, 0x10 >> 4], 8)

    for lane in range(8):
        got = harness.axi_mem.read_word(out_shl + lane)
        assert got == golden_shl, f"8-bit SHL lane {lane}: expected 0x{golden_shl:08X}, got 0x{got:08X}"
        got = harness.axi_mem.read_word(out_shr + lane)
        assert got == golden_shr, f"8-bit SHR lane {lane}: expected 0x{golden_shr:08X}, got 0x{got:08X}"

    dut._log.info(f"test_multiwidth_packed_8bit_shift: PASS, cycles={cycles}")


# ============================================================================
#  Test: Packed 8-bit LT and EQ
# ============================================================================

@cocotb.test()
async def test_multiwidth_packed_8bit_compare(dut):
    """Multi-width: 8-bit packed LT and EQ."""
    harness = VliwCoreHarness(dut)

    a_vals = [_pack_subs([10, 20, 30, 40], 8)] * 8
    b_vals = [_pack_subs([20, 20, 10, 40], 8)] * 8

    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_vals)
    await harness.init()

    out_lt = 1504  # must be 16-word aligned for VSTORE
    out_eq = 1520

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.const(11, 8),
        S.vload(208, 11),
        S.valu_op("lt", 216, 200, 208, ew=8),
        S.const(12, out_lt),
        S.vstore(12, 216),
        S.valu_op("eq", 224, 200, 208, ew=8),
        S.const(13, out_eq),
        S.vstore(13, 224),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # LT: 10<20=1, 20<20=0, 30<10=0, 40<40=0
    golden_lt = _pack_subs([1, 0, 0, 0], 8)
    # EQ: 10==20=0, 20==20=1, 30==10=0, 40==40=1
    golden_eq = _pack_subs([0, 1, 0, 1], 8)

    for lane in range(8):
        got = harness.axi_mem.read_word(out_lt + lane)
        assert got == golden_lt, f"8-bit LT lane {lane}: expected 0x{golden_lt:08X}, got 0x{got:08X}"
        got = harness.axi_mem.read_word(out_eq + lane)
        assert got == golden_eq, f"8-bit EQ lane {lane}: expected 0x{golden_eq:08X}, got 0x{got:08X}"

    dut._log.info(f"test_multiwidth_packed_8bit_compare: PASS, cycles={cycles}")


# ============================================================================
#  Test: VBROADCAST at 8-bit element width
# ============================================================================

@cocotb.test()
async def test_multiwidth_vbroadcast_8bit(dut):
    """Multi-width: VBROADCAST at 8-bit — lowest byte replicated 4x per lane."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    broadcast_val = 0x42  # we broadcast this 8-bit value

    out_base = 1600

    program = build_program([
        S.const(50, broadcast_val),
        S.vbroadcast(400, 50, ew=8),
        S.const(12, out_base),
        S.vstore(12, 400),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Each lane should have 0x42424242
    golden = _pack_subs([broadcast_val] * 4, 8)
    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden, (
            f"VBROADCAST 8-bit lane {lane}: expected 0x{golden:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_vbroadcast_8bit: PASS, cycles={cycles}")


# ============================================================================
#  Test: VCAST widening 8→16 (unsigned, lower half)
# ============================================================================

@cocotb.test()
async def test_multiwidth_vcast_8to16_lower(dut):
    """Multi-width: VCAST 8→16 unsigned lower — 2 lower 8-bit subs → 2 16-bit subs."""
    harness = VliwCoreHarness(dut)

    # Each lane has [0xAA, 0xBB, 0xCC, 0xDD] packed as 8-bit
    src_vals = [_pack_subs([0xAA, 0xBB, 0xCC, 0xDD], 8)] * 8

    harness.axi_mem.preload(0, src_vals)
    await harness.init()

    out_base = 1700

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.vcast(216, 200, ew=8, dw=16, signed=0, upper=0),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Lower half: take sub[0]=0xAA, sub[1]=0xBB → zero-extend to 16-bit
    golden = _pack_subs([0x00AA, 0x00BB], 16)
    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden, (
            f"VCAST 8→16 lower lane {lane}: expected 0x{golden:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_vcast_8to16_lower: PASS, cycles={cycles}")


# ============================================================================
#  Test: VCAST widening 8→16 (unsigned, upper half)
# ============================================================================

@cocotb.test()
async def test_multiwidth_vcast_8to16_upper(dut):
    """Multi-width: VCAST 8→16 unsigned upper — 2 upper 8-bit subs → 2 16-bit subs."""
    harness = VliwCoreHarness(dut)

    src_vals = [_pack_subs([0xAA, 0xBB, 0xCC, 0xDD], 8)] * 8

    harness.axi_mem.preload(0, src_vals)
    await harness.init()

    out_base = 1800

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.vcast(216, 200, ew=8, dw=16, signed=0, upper=1),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Upper half: take sub[2]=0xCC, sub[3]=0xDD → zero-extend to 16-bit
    golden = _pack_subs([0x00CC, 0x00DD], 16)
    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden, (
            f"VCAST 8→16 upper lane {lane}: expected 0x{golden:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_vcast_8to16_upper: PASS, cycles={cycles}")


# ============================================================================
#  Test: VCAST widening 8→32 (signed)
# ============================================================================

@cocotb.test()
async def test_multiwidth_vcast_8to32_signed(dut):
    """Multi-width: VCAST 8→32 signed — sign-extend lowest 8-bit sub to 32 bits."""
    harness = VliwCoreHarness(dut)

    # 0xF0 = -16 as signed 8-bit
    src_vals = [_pack_subs([0xF0, 0x7F, 0x01, 0x80], 8)] * 8

    harness.axi_mem.preload(0, src_vals)
    await harness.init()

    out_base = 1904  # must be 16-word aligned for VSTORE

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.vcast(216, 200, ew=8, dw=32, signed=1, upper=0),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Lower half for 8→32 cast: sub[0]=0xF0 → sign-extend to 32-bit = 0xFFFFFFF0
    golden = _from_signed(_to_signed(0xF0, 8), 32)
    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden, (
            f"VCAST 8→32 signed lane {lane}: expected 0x{golden:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_vcast_8to32_signed: PASS, cycles={cycles}")


# ============================================================================
#  Test: VCAST narrowing 32→8
# ============================================================================

@cocotb.test()
async def test_multiwidth_vcast_32to8(dut):
    """Multi-width: VCAST 32→8 — truncate 32-bit value to lowest 8 bits."""
    harness = VliwCoreHarness(dut)

    src_vals = [0x12345678] * 8

    harness.axi_mem.preload(0, src_vals)
    await harness.init()

    out_base = 2000

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.vcast(216, 200, ew=32, dw=8, signed=0, upper=0),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Narrowing 32→8: take lower 8 bits = 0x78, pack in lowest sub position
    # nSrc=1 (one 32-bit element), truncated to 8-bit = 0x78
    golden = 0x78  # 1 element truncated, rest zero
    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden, (
            f"VCAST 32→8 lane {lane}: expected 0x{golden:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_vcast_32to8: PASS, cycles={cycles}")


# ============================================================================
#  Test: Widening MUL 8→16
# ============================================================================

@cocotb.test()
async def test_multiwidth_widening_mul_8to16(dut):
    """Multi-width: widening MUL 8→16 — 2 lower 8-bit subs multiplied, 16-bit result."""
    harness = VliwCoreHarness(dut)

    a_vals = [_pack_subs([10, 20, 30, 40], 8)] * 8
    b_vals = [_pack_subs([3, 4, 5, 6], 8)] * 8

    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_vals)
    await harness.init()

    out_base = 2100

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.const(11, 8),
        S.vload(208, 11),
        S.valu_op("mul", 216, 200, 208, ew=8, dw=16),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Widening: 2 dest elements of 16-bit each
    # sub[0]: 10*3=30, sub[1]: 20*4=80
    golden = _pack_subs([30, 80], 16)
    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden, (
            f"Widen MUL 8→16 lane {lane}: expected 0x{golden:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_widening_mul_8to16: PASS, cycles={cycles}")


# ============================================================================
#  Test: Widening MULTIPLY_ADD 8→16
# ============================================================================

@cocotb.test()
async def test_multiwidth_widening_fma_8to16(dut):
    """Multi-width: widening MUL 8→16 + packed ADD — a*b+c via 2-instruction sequence."""
    harness = VliwCoreHarness(dut)

    a_vals = [_pack_subs([10, 20, 30, 40], 8)] * 8
    b_vals = [_pack_subs([3, 4, 5, 6], 8)] * 8
    c_vals = [_pack_subs([100, 200], 16)] * 8  # accumulator at 16-bit width

    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_vals)
    harness.axi_mem.preload(16, c_vals)
    await harness.init()

    out_base = 2200

    # NOTE: widening FMA uses a 2-instruction sequence (widening MUL + packed ADD)
    # because the hardware only has 2 BRAM read ports per bank, and FMA needs 3
    # vector operand reads.  The scalar read for src3 is blocked when VALU is
    # active (blockScalarReads), so multiply_add's accumulator gets stale data.
    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.const(11, 8),
        S.vload(208, 11),
        S.const(14, 16),
        S.vload(240, 14),
        # Step 1: widening MUL 8→16  (only needs src1 + src2)
        S.valu_op("mul", 216, 200, 208, ew=8, dw=16),
        # Step 2: packed 16-bit ADD with accumulator
        S.valu_op("add", 216, 216, 240, ew=16),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Widening MUL + ADD: sub[0]: 10*3+100=130, sub[1]: 20*4+200=280
    golden = _pack_subs([130, 280], 16)
    for lane in range(8):
        got = harness.axi_mem.read_word(out_base + lane)
        assert got == golden, (
            f"Widen FMA 8→16 lane {lane}: expected 0x{golden:08X}, got 0x{got:08X}")

    dut._log.info(f"test_multiwidth_widening_fma_8to16: PASS, cycles={cycles}")


# ============================================================================
#  Test: 64-bit ADD via lane pairing
# ============================================================================

@cocotb.test()
async def test_multiwidth_64bit_add(dut):
    """Multi-width: 64-bit ADD — lane pairs (0+1, 2+3, ...) form 4 64-bit elements."""
    harness = VliwCoreHarness(dut)

    # 4 × 64-bit values: A and B
    # A = [0x00000001_FFFFFFFF, 0, 0x80000000_00000001, 0x00000000_00000001]
    # B = [0x00000000_00000001, 0x00000000_00000002, 0x00000000_FFFFFFFF, 0xFFFFFFFF_FFFFFFFE]
    a_lo = [0xFFFFFFFF, 0x00000000, 0x00000001, 0x00000001]  # even lanes
    a_hi = [0x00000001, 0x00000000, 0x80000000, 0x00000000]  # odd lanes
    b_lo = [0x00000001, 0x00000002, 0xFFFFFFFF, 0xFFFFFFFE]
    b_hi = [0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF]

    # Interleave: lane0=a_lo[0], lane1=a_hi[0], lane2=a_lo[1], ...
    a_vals = []
    b_vals = []
    for i in range(4):
        a_vals.extend([a_lo[i], a_hi[i]])
        b_vals.extend([b_lo[i], b_hi[i]])

    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_vals)
    await harness.init()

    out_base = 2304  # must be 16-word aligned for VSTORE

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.const(11, 8),
        S.vload(208, 11),
        S.valu_op("add", 216, 200, 208, ew=64),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Compute golden 64-bit adds
    for i in range(4):
        a64 = a_lo[i] | (a_hi[i] << 32)
        b64 = b_lo[i] | (b_hi[i] << 32)
        r64 = (a64 + b64) & 0xFFFFFFFFFFFFFFFF
        r_lo = r64 & 0xFFFFFFFF
        r_hi = (r64 >> 32) & 0xFFFFFFFF
        got_lo = harness.axi_mem.read_word(out_base + i * 2)
        got_hi = harness.axi_mem.read_word(out_base + i * 2 + 1)
        assert got_lo == r_lo, (
            f"64-bit ADD pair {i} lo: expected 0x{r_lo:08X}, got 0x{got_lo:08X}")
        assert got_hi == r_hi, (
            f"64-bit ADD pair {i} hi: expected 0x{r_hi:08X}, got 0x{got_hi:08X}")

    dut._log.info(f"test_multiwidth_64bit_add: PASS, cycles={cycles}")


# ============================================================================
#  Test: 64-bit SUB with borrow
# ============================================================================

@cocotb.test()
async def test_multiwidth_64bit_sub(dut):
    """Multi-width: 64-bit SUB — verifies borrow chain between lane pairs."""
    harness = VliwCoreHarness(dut)

    # A = 0x00000001_00000000 (pair 0), B = 0x00000000_00000001 → result = 0x00000000_FFFFFFFF
    a_vals = [0x00000000, 0x00000001, 0, 0, 0, 0, 0, 0]
    b_vals = [0x00000001, 0x00000000, 0, 0, 0, 0, 0, 0]

    harness.axi_mem.preload(0, a_vals)
    harness.axi_mem.preload(8, b_vals)
    await harness.init()

    out_base = 2400

    program = build_program([
        S.const(10, 0),
        S.vload(200, 10),
        S.const(11, 8),
        S.vload(208, 11),
        S.valu_op("sub", 216, 200, 208, ew=64),
        S.const(12, out_base),
        S.vstore(12, 216),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    a64 = 0x00000001_00000000
    b64 = 0x00000000_00000001
    r64 = (a64 - b64) & 0xFFFFFFFFFFFFFFFF
    got_lo = harness.axi_mem.read_word(out_base)
    got_hi = harness.axi_mem.read_word(out_base + 1)
    assert got_lo == (r64 & 0xFFFFFFFF), f"64-bit SUB lo: expected 0x{r64 & 0xFFFFFFFF:08X}, got 0x{got_lo:08X}"
    assert got_hi == ((r64 >> 32) & 0xFFFFFFFF), f"64-bit SUB hi: expected 0x{(r64 >> 32) & 0xFFFFFFFF:08X}, got 0x{got_hi:08X}"

    dut._log.info(f"test_multiwidth_64bit_sub: PASS, cycles={cycles}")


# ============================================================================
#  Test: DSP kernel — 8-bit pixel affine transform using multi-width ops
# ============================================================================
