from test_integration_common import *

@cocotb.test()
async def test_add_sub(dut):
    """100 + 200 = 300, then 300 - 50 = 250. Verify via AXI store."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 100),
        S.const(1, 200),
        S.add(2, 0, 1),          # s[2] = 300
        S.const(3, 50),
        S.sub(4, 2, 3),          # s[4] = 250
        S.const(10, 0),          # addr = 0
        S.store(10, 2),          # mem[0] = 300
        S.add_imm(10, 10, 1),    # addr = 1
        S.store(10, 4),          # mem[1] = 250
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=500)

    val_300 = harness.axi_mem.read_word(0)
    val_250 = harness.axi_mem.read_word(1)
    assert val_300 == 300, f"Expected 300, got {val_300}"
    assert val_250 == 250, f"Expected 250, got {val_250}"


# ============================================================================
#  Test 2: MUL, AND, OR, XOR
# ============================================================================

@cocotb.test()
async def test_mul_logic(dut):
    """7*6=42, 0xFF & 0x0F=0x0F, 0xFF | 0x0F=0xFF, 0xFF ^ 0x0F=0xF0."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 7),
        S.const(1, 6),
        S.mul(2, 0, 1),          # s[2] = 42
        S.const(3, 0xFF),
        S.const(4, 0x0F),
        S.and_op(5, 3, 4),       # s[5] = 0x0F
        S.or_op(6, 3, 4),        # s[6] = 0xFF
        S.xor(7, 3, 4),          # s[7] = 0xF0
        S.const(20, 0),
        S.store(20, 2),          # mem[0] = 42
        S.add_imm(20, 20, 1),
        S.store(20, 5),          # mem[1] = 0x0F
        S.add_imm(20, 20, 1),
        S.store(20, 6),          # mem[2] = 0xFF
        S.add_imm(20, 20, 1),
        S.store(20, 7),          # mem[3] = 0xF0
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=1000)

    assert harness.axi_mem.read_word(0) == 42, f"MUL: {harness.axi_mem.read_word(0)}"
    assert harness.axi_mem.read_word(1) == 0x0F, f"AND: {harness.axi_mem.read_word(1)}"
    assert harness.axi_mem.read_word(2) == 0xFF, f"OR: {harness.axi_mem.read_word(2)}"
    assert harness.axi_mem.read_word(3) == 0xF0, f"XOR: {harness.axi_mem.read_word(3)}"


# ============================================================================
#  Test 3: SHL, SHR, LT, EQ
# ============================================================================

@cocotb.test()
async def test_shift_compare(dut):
    """1<<4=16, 256>>3=32, 10<20=1, 20<10=0, 10==10=1, 10==20=0."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 1),
        S.const(1, 4),
        S.shl(2, 0, 1),         # s[2] = 16
        S.const(3, 256),
        S.const(4, 3),
        S.shr(5, 3, 4),         # s[5] = 32
        S.const(6, 10),
        S.const(7, 20),
        S.lt(8, 6, 7),          # s[8] = 1
        S.lt(9, 7, 6),          # s[9] = 0
        S.eq(11, 6, 6),         # s[11] = 1
        S.eq(12, 6, 7),         # s[12] = 0
        # Store results
        S.const(20, 0),
        S.store(20, 2),         # mem[0] = 16
        S.add_imm(20, 20, 1),
        S.store(20, 5),         # mem[1] = 32
        S.add_imm(20, 20, 1),
        S.store(20, 8),         # mem[2] = 1
        S.add_imm(20, 20, 1),
        S.store(20, 9),         # mem[3] = 0
        S.add_imm(20, 20, 1),
        S.store(20, 11),        # mem[4] = 1
        S.add_imm(20, 20, 1),
        S.store(20, 12),        # mem[5] = 0
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=1500)

    assert harness.axi_mem.read_word(0) == 16, "SHL"
    assert harness.axi_mem.read_word(1) == 32, "SHR"
    assert harness.axi_mem.read_word(2) == 1, "LT(10,20)"
    assert harness.axi_mem.read_word(3) == 0, "LT(20,10)"
    assert harness.axi_mem.read_word(4) == 1, "EQ(10,10)"
    assert harness.axi_mem.read_word(5) == 0, "EQ(10,20)"


# ============================================================================
#  Test 4: Division + Modulo
# ============================================================================

@cocotb.test()
async def test_division(dut):
    """100 / 7 = 14, 100 % 7 = 2. Scheduler handles 33-cycle latency."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 100),
        S.const(1, 7),
        S.div(2, 0, 1),         # s[2] = 14 (33 cycles)
        S.mod(3, 0, 1),         # s[3] = 2  (33 cycles, after div)
        S.const(20, 0),
        S.store(20, 2),         # mem[0] = 14
        S.add_imm(20, 20, 1),
        S.store(20, 3),         # mem[1] = 2
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=2000)

    assert harness.axi_mem.read_word(0) == 14, f"DIV: {harness.axi_mem.read_word(0)}"
    assert harness.axi_mem.read_word(1) == 2, f"MOD: {harness.axi_mem.read_word(1)}"


# ============================================================================
#  Test 5: LOAD + STORE roundtrip
# ============================================================================

@cocotb.test()
async def test_select(dut):
    """SELECT: cond=1 → 100, cond=0 → 200."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 1),          # cond = true
        S.const(1, 100),        # srcA
        S.const(2, 200),        # srcB
        S.select(3, 0, 1, 2),   # s[3] = 100
        S.const(4, 0),          # cond = false
        S.select(5, 4, 1, 2),   # s[5] = 200
        S.const(10, 0),
        S.store(10, 3),         # mem[0] = 100
        S.add_imm(10, 10, 1),
        S.store(10, 5),         # mem[1] = 200
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=500)

    r1 = harness.axi_mem.read_word(0)
    r2 = harness.axi_mem.read_word(1)
    assert r1 == 100, f"SELECT cond=1: expected 100, got {r1}"
    assert r2 == 200, f"SELECT cond=0: expected 200, got {r2}"


# ============================================================================
#  Test 10: Zero operations
# ============================================================================

@cocotb.test()
async def test_zero_operations(dut):
    """0+42=42, 0*42=0, 42/1=42."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 0),
        S.const(1, 42),
        S.add(2, 0, 1),         # 42
        S.mul(3, 0, 1),         # 0
        S.const(4, 1),
        S.div(5, 1, 4),         # 42
        S.const(10, 0),
        S.store(10, 2),         # mem[0] = 42
        S.add_imm(10, 10, 1),
        S.store(10, 3),         # mem[1] = 0
        S.add_imm(10, 10, 1),
        S.store(10, 5),         # mem[2] = 42
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=2000)

    assert harness.axi_mem.read_word(0) == 42, "0+42"
    assert harness.axi_mem.read_word(1) == 0, "0*42"
    assert harness.axi_mem.read_word(2) == 42, "42/1"


# ============================================================================
#  Test 11: Large value wrap-around
# ============================================================================

@cocotb.test()
async def test_large_values(dut):
    """0x7FFFFFFF + 1 = 0x80000000 (unsigned wrap)."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 0x7FFFFFFF),
        S.const(1, 1),
        S.add(2, 0, 1),
        S.const(10, 0),
        S.store(10, 2),
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=500)

    result = harness.axi_mem.read_word(0)
    assert result == 0x80000000, f"Expected 0x80000000, got {result:#010x}"


# ============================================================================
#  Test 12: ADD_IMM chaining
# ============================================================================

@cocotb.test()
async def test_add_imm_sequence(dut):
    """s[0] = 0 → +10 → +20 → +30 = 60."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 0),
        S.add_imm(0, 0, 10),    # 10
        S.add_imm(0, 0, 20),    # 30
        S.add_imm(0, 0, 30),    # 60
        S.const(10, 0),
        S.store(10, 0),
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=500)

    result = harness.axi_mem.read_word(0)
    assert result == 60, f"Expected 60, got {result}"


# ============================================================================
#  Test 13: CoreID
# ============================================================================

@cocotb.test()
async def test_coreid(dut):
    """CoreID should be 0 for core 0."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.coreid(0),
        S.const(10, 0),
        S.store(10, 0),
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=500)

    result = harness.axi_mem.read_word(0)
    assert result == 0, f"Expected coreId=0, got {result}"


# ============================================================================
#  Test 14: Dual-issue packing
# ============================================================================

@cocotb.test()
async def test_dual_issue(dut):
    """ALU + CONST in same bundle (different engines)."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 10),         # load slot
        S.const(1, 20),         # load slot (next bundle)
        S.add(2, 0, 1),         # ALU: 10+20=30
        S.const(5, 99),         # CONST: can pack with something
        S.const(10, 0),
        S.store(10, 2),         # mem[0] = 30
        S.add_imm(10, 10, 1),
        S.store(10, 5),         # mem[1] = 99
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=500)

    assert harness.axi_mem.read_word(0) == 30, "ADD"
    assert harness.axi_mem.read_word(1) == 99, "CONST"


# ============================================================================
#  Test 15: Fibonacci(10) = 55
# ============================================================================

@cocotb.test()
async def test_fibonacci(dut):
    """Compute Fibonacci(10) using a loop."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    # s[30] = 0 used as "zero register" for moves (add 0)
    program = build_program([
        S.const(0, 0),          # fib_prev = 0
        S.const(1, 1),          # fib_curr = 1
        S.const(2, 1),          # counter = 1 (run 9 iterations to reach fib(10))
        S.const(3, 10),         # limit = 10
        S.const(4, 1),          # increment
        S.const(30, 0),         # zero register
        S.label("fib_loop"),
        S.add(5, 0, 1),         # temp = prev + curr
        S.add(0, 1, 30),        # prev = curr
        S.add(1, 5, 30),        # curr = temp
        S.add(2, 2, 4),         # counter++
        S.lt(6, 2, 3),          # counter < limit?
        S.cond_jump(6, "fib_loop"),
        # Store result
        S.const(10, 0),
        S.store(10, 1),         # mem[0] = fib_curr
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=5000)

    result = harness.axi_mem.read_word(0)
    assert result == 55, f"Expected fib(10)=55, got {result}"


# ============================================================================
#  Test 16: Memory scatter/gather (load 4 values, sum, store)
# ============================================================================

@cocotb.test()
async def test_cycle_count(dut):
    """Verify cycle counter > program length."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([S.halt()])

    await harness.load_program(program)
    await harness.run(max_cycles=100)

    cc = harness.cycle_count
    assert cc > 0, f"cycleCount should be > 0, got {cc}"
    assert cc < 20, f"cycleCount too high for simple HALT: {cc}"


# ============================================================================
#  Test 20: VALU opcode coverage (short, golden model)
# ============================================================================

@cocotb.test()
async def test_long_scalar_recurrence_golden(dut):
    """Long loop (~hundreds of cycles): sum(1..N) with golden model compare."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    n_iters = 220
    limit = n_iters + 1

    # Golden model: sum_{k=1..N} k = N*(N+1)/2
    golden = (n_iters * (n_iters + 1) // 2) & 0xFFFFFFFF

    program = build_program([
        S.const(0, 0),          # sum
        S.const(1, 1),          # i
        S.const(2, limit),      # loop limit (exclusive)
        S.const(3, 1),          # increment
        S.label("sum_loop"),
        S.add(0, 0, 1),         # sum += i
        S.add(1, 1, 3),         # i += 1
        S.lt(4, 1, 2),          # i < limit
        S.cond_jump(4, "sum_loop"),
        S.const(10, 300),
        S.store(10, 0),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=12000)

    result = harness.axi_mem.read_word(300)
    assert cycles >= 200, f"Expected long-running test (>=200 cycles), got {cycles}"
    assert result == golden, f"Expected {golden}, got {result}"


# ============================================================================
#  Test 19: Long memory accumulation (golden model)
# ============================================================================

@cocotb.test()
async def test_multi_op_same_bundle(dut):
    """
    Verify the scheduler packs independent ops from different engines into
    the same VLIW bundle and that all engines execute correctly in parallel.

    Both the ALU add and FLOW add_imm depend on s[1] (the last const),
    so their earliest cycle is identical.  The scheduler must pack them
    into the same bundle (ALU slot + FLOW slot).  We verify both at the
    schedule level (same PC) and functionally (correct AXI output).
    """
    harness = VliwCoreHarness(dut)
    await harness.init()

    # s[0] const at pc=0 (load slot) → ready at cycle 1
    # s[1] const at pc=1 (load slot) → ready at cycle 2
    # Both add(3,0,1) and add_imm(4,1,7) need s[1] → earliest = cycle 2
    # They target different engines (ALU / FLOW) so they CAN co-issue.
    program_ops = [
        S.const(0, 50),          # s[0] = 50  (load engine, pc=0)
        S.const(1, 30),          # s[1] = 30  (load engine, pc=1)

        # --- these two must land in the same bundle (pc=2) ---
        S.add(3, 0, 1),          # ALU:  s[3] = 50+30 = 80
        S.add_imm(4, 1, 7),      # FLOW: s[4] = 30+7  = 37

        # Store results
        S.const(10, 0),
        S.store(10, 3),          # mem[0] = 80
        S.add_imm(10, 10, 1),
        S.store(10, 4),          # mem[1] = 37
        S.halt(),
    ]

    # Verify at the schedule level that packing actually happened
    bundles_dicts = S.schedule(program_ops)
    add_pc = None
    add_imm_pc = None
    for pc, bundle in enumerate(bundles_dicts):
        for op in bundle.get("alu", []):
            if op and op[0] == "add":
                add_pc = pc
        for op in bundle.get("flow", []):
            if op and op[0] == "add_imm":
                if add_imm_pc is None:
                    add_imm_pc = pc

    assert add_pc is not None, "Expected ALU add in schedule"
    assert add_imm_pc is not None, "Expected FLOW add_imm in schedule"
    assert add_pc == add_imm_pc, (
        f"ALU add (pc={add_pc}) and FLOW add_imm (pc={add_imm_pc}) should be "
        f"in the same bundle (multi-engine packing)"
    )

    program = ASM.assemble_program(bundles_dicts)
    await harness.load_program(program)
    cycles = await harness.run(max_cycles=500)

    val_80 = harness.axi_mem.read_word(0)
    val_37 = harness.axi_mem.read_word(1)
    assert val_80 == 80, f"ALU add: expected 80, got {val_80}"
    assert val_37 == 37, f"FLOW add_imm: expected 37, got {val_37}"


# ============================================================================
#  Test 26: Multiple engines working simultaneously across bundles
# ============================================================================

@cocotb.test()
async def test_multi_engine_simultaneous(dut):
    """
    Stress test with ALU, LOAD, STORE, and FLOW engines all active in a
    tight loop.  Each iteration: load a value, compute on it, store the
    result, and use flow for loop control — all engines busy every cycle.

    Sums pre-loaded values mem[0..7], multiplies each by 2, and accumulates.
    Golden: sum(v*2 for v in data).
    """
    harness = VliwCoreHarness(dut)

    data = [10, 20, 30, 40, 50, 60, 70, 80]
    harness.axi_mem.preload(0, data)
    await harness.init()

    golden = sum(v * 2 for v in data) & 0xFFFFFFFF  # 720

    program = build_program([
        S.const(0, 0),           # accumulator
        S.const(5, 0),           # address pointer
        S.const(6, 0),           # loop index
        S.const(7, 8),           # loop limit
        S.const(8, 1),           # increment
        S.const(9, 2),           # multiplier
        S.const(20, 0),          # temp / nop pad

        S.label("engine_loop"),
        # LOAD engine: fetch mem[addr]
        S.load(1, 5),
        S.add_imm(20, 20, 0),   # spacing for load latency
        # ALU engine: val * 2
        S.mul(2, 1, 9),
        # ALU engine: accumulate
        S.add(0, 0, 2),
        # FLOW engine: addr++, idx++, branch
        S.add_imm(5, 5, 1),
        S.add(6, 6, 8),
        S.lt(3, 6, 7),
        S.cond_jump(3, "engine_loop"),

        # Store final accumulator
        S.const(10, 500),
        S.store(10, 0),          # mem[500] = golden
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    result = harness.axi_mem.read_word(500)
    assert result == golden, f"Expected {golden}, got {result}"


# ============================================================================
#  Test 27: Vector load → vector compute → vector store pipeline
# ============================================================================
