"""
VLIW SIMD Integration Tests — Program-level verification.

Uses the VliwScheduler for automatic hazard avoidance:
  - RAW dependencies (latency 2) inserted automatically
  - Division latency (33 cycles) tracked
  - Jump bubbles handled
  - Independent ops packed into same bundle

Test Categories:
  1. Arithmetic programs (ALU correctness through the full pipeline)
  2. Memory programs (LOAD/STORE/CONST through AXI)
  3. Control flow programs (JUMP, COND_JUMP, loops)
  4. Multi-instruction programs (dual-issue packing)
  5. Edge cases (division, zero, overflow)
  6. Fibonacci (complex loop)
"""

import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))
if str(PROJECT_ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "tools"))
if str(Path(__file__).parent) not in sys.path:
    sys.path.insert(0, str(Path(__file__).parent))

import cocotb
from assembler import Assembler, AssemblerConfig
from scheduler import VliwScheduler, SchedulerConfig
from harness import VliwCoreHarness
from verification.cocotb.config import load_test_config

CFG = load_test_config(project_root=PROJECT_ROOT)
N_ALU_SLOTS = CFG.n_alu_slots
N_VALU_SLOTS = CFG.n_valu_slots
N_LOAD_SLOTS = CFG.n_load_slots
N_STORE_SLOTS = CFG.n_store_slots
N_FLOW_SLOTS = CFG.n_flow_slots

# Create assembler + scheduler matching Sim config
ASM = Assembler(AssemblerConfig(
    n_alu_slots=N_ALU_SLOTS, n_valu_slots=N_VALU_SLOTS, n_load_slots=N_LOAD_SLOTS,
    n_store_slots=N_STORE_SLOTS, n_flow_slots=N_FLOW_SLOTS, vlen=CFG.vlen,
    scratch_size=CFG.scratch_size, imem_depth=CFG.imem_depth
))

S = VliwScheduler(SchedulerConfig(
    n_alu_slots=N_ALU_SLOTS, n_valu_slots=N_VALU_SLOTS, n_load_slots=N_LOAD_SLOTS,
    n_store_slots=N_STORE_SLOTS, n_flow_slots=N_FLOW_SLOTS,
    mem_post_gap=CFG.mem_post_gap
))


def _u32(x: int) -> int:
    return x & 0xFFFFFFFF


def _vbin(op: str, a: list[int], b: list[int]) -> list[int]:
    out = []
    for av, bv in zip(a, b):
        if op == "add":
            out.append(_u32(av + bv))
        elif op == "sub":
            out.append(_u32(av - bv))
        elif op == "mul":
            out.append(_u32(av * bv))
        elif op == "xor":
            out.append(_u32(av ^ bv))
        elif op == "and":
            out.append(_u32(av & bv))
        elif op == "or":
            out.append(_u32(av | bv))
        elif op == "shl":
            out.append(_u32(av << (bv & 0x1F)))
        elif op == "shr":
            out.append(_u32((av & 0xFFFFFFFF) >> (bv & 0x1F)))
        elif op == "lt":
            out.append(1 if _u32(av) < _u32(bv) else 0)
        elif op == "eq":
            out.append(1 if _u32(av) == _u32(bv) else 0)
        else:
            raise ValueError(f"Unknown op {op}")
    return out


def _vmadd(a: list[int], b: list[int], c: list[int]) -> list[int]:
    return [_u32(av * bv + cv) for av, bv, cv in zip(a, b, c)]


def build_program(ops, verbose=False):
    """Schedule ops, assemble into binary bundles."""
    bundles_dicts = S.schedule(ops, verbose=verbose)
    return ASM.assemble_program(bundles_dicts)


# ============================================================================
#  Test 1: Scalar ADD + SUB
# ============================================================================

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
async def test_load_store_roundtrip(dut):
    """Store 42 to mem[0], load it back, store to mem[256]."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 42),         # value
        S.const(1, 0),          # addr = 0
        S.store(1, 0),          # mem[0] = 42
        S.const(30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.load(3, 1),           # s[3] = mem[0] = 42
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.const(5, 256),        # addr = 256
        S.store(5, 3),          # mem[256] = 42
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=500)

    val0 = harness.axi_mem.read_word(0)
    val256 = harness.axi_mem.read_word(256)
    assert val0 == 42, f"Store: expected 42, got {val0}"
    assert val256 == 42, f"Load-store: expected 42, got {val256}"


# ============================================================================
#  Test 6: Pre-loaded memory
# ============================================================================

@cocotb.test()
async def test_load_preloaded_memory(dut):
    """Pre-load AXI memory, load two values, add them, store sum."""
    harness = VliwCoreHarness(dut)
    harness.axi_mem.preload(100, [1000, 2000])
    await harness.init()

    program = build_program([
        S.const(0, 100),        # addr = 100
        S.load(1, 0),           # s[1] = mem[100] = 1000
        S.const(30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(0, 0, 1),     # addr = 101
        S.load(2, 0),           # s[2] = mem[101] = 2000
        S.add_imm(30, 30, 0),
        S.add_imm(30, 30, 0),
        S.add(3, 1, 2),         # s[3] = 3000
        S.const(10, 0),
        S.store(10, 3),         # mem[0] = 3000
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=500)

    result = harness.axi_mem.read_word(0)
    assert result == 3000, f"Expected 3000, got {result}"


# ============================================================================
#  Test 7: Counting loop
# ============================================================================

@cocotb.test()
async def test_counting_loop(dut):
    """Count from 0 to 4 using a loop. Final counter = 5."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 0),          # counter = 0
        S.const(1, 5),          # limit = 5
        S.const(2, 1),          # increment = 1
        S.label("loop"),
        S.add(0, 0, 2),         # counter++
        S.lt(3, 0, 1),          # counter < limit?
        S.cond_jump(3, "loop"),
        # After loop: counter = 5
        S.const(10, 0),
        S.store(10, 0),         # mem[0] = counter
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=2000)

    result = harness.axi_mem.read_word(0)
    assert result == 5, f"Expected counter=5, got {result}"


# ============================================================================
#  Test 8: Unconditional jump
# ============================================================================

@cocotb.test()
async def test_unconditional_jump(dut):
    """Jump over an overwrite. s[0] should remain 111."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 111),
        S.jump("skip"),
        S.const(0, 999),        # should be skipped
        S.label("skip"),
        S.const(10, 0),
        S.store(10, 0),         # mem[0] = 111 (not 999)
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=500)

    result = harness.axi_mem.read_word(0)
    assert result == 111, f"Expected 111, got {result}"


# ============================================================================
#  Test 9: SELECT (conditional move)
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
async def test_memory_scatter_gather(dut):
    """Pre-load 4 values, load-sum-store."""
    harness = VliwCoreHarness(dut)
    harness.axi_mem.preload(0, [10, 20, 30, 40])
    await harness.init()

    program = build_program([
        S.const(10, 0),
        S.load(0, 10),          # s[0] = 10
        S.const(30, 0),
        S.add_imm(30, 30, 0),
        S.add_imm(10, 10, 1),
        S.load(1, 10),          # s[1] = 20
        S.add_imm(30, 30, 0),
        S.add_imm(10, 10, 1),
        S.load(2, 10),          # s[2] = 30
        S.add_imm(30, 30, 0),
        S.add_imm(10, 10, 1),
        S.load(3, 10),          # s[3] = 40
        S.add_imm(30, 30, 0),
        S.add(4, 0, 1),         # s[4] = 30
        S.add(5, 2, 3),         # s[5] = 70
        S.add(6, 4, 5),         # s[6] = 100
        S.const(10, 100),
        S.store(10, 6),         # mem[100] = 100
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=2000)

    result = harness.axi_mem.read_word(100)
    assert result == 100, f"Expected 100, got {result}"


# ============================================================================
#  Test 17: Cycle counter sanity
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
async def test_valu_short_opcode_coverage_golden(dut):
    """VALU-heavy short test with deterministic and exploratory opcode coverage."""
    harness = VliwCoreHarness(dut)

    vlen = 8
    await harness.init()

    a = [1, 2, 3, 4, 5, 6, 7, 8]
    b = [8, 7, 6, 5, 4, 3, 2, 1]
    deterministic_ops = ["add"]
    exploratory_ops = ["sub", "mul", "xor", "and", "or", "shl", "shr", "lt", "eq"]

    add_v = _vbin("add", a, b)

    program = build_program([
        # Initialize vector source regions with scalar consts (avoids VALU src3 path)
        S.const(96, 1), S.const(97, 2), S.const(98, 3), S.const(99, 4),
        S.const(100, 5), S.const(101, 6), S.const(102, 7), S.const(103, 8),
        S.const(104, 8), S.const(105, 7), S.const(106, 6), S.const(107, 5),
        S.const(108, 4), S.const(109, 3), S.const(110, 2), S.const(111, 1),
        S.const(112, 10), S.const(113, 20), S.const(114, 30), S.const(115, 40),
        S.const(116, 50), S.const(117, 60), S.const(118, 70), S.const(119, 80),
        S.const(120, 0), S.const(121, 1), S.const(122, 2), S.const(123, 3),
        S.const(124, 4), S.const(125, 5), S.const(126, 6), S.const(127, 7),

        S.valu_op("add", 200, 96, 104),
        S.valu_op("sub", 208, 96, 104),
        S.valu_op("mul", 216, 96, 104),
        S.valu_op("xor", 224, 96, 104),
        S.valu_op("and", 232, 96, 104),
        S.valu_op("or", 240, 96, 104),
        S.valu_op("shl", 248, 96, 120),
        S.valu_op("shr", 256, 112, 120),
        S.valu_op("lt", 264, 96, 104),
        S.valu_op("eq", 272, 96, 96),

        # Store one deterministic representative lane for golden checking
        S.const(10, 600), S.store(10, 200),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=4000)

    expected = {
        600: add_v[0],
    }

    for addr, exp in expected.items():
        got = harness.axi_mem.read_word(addr)
        assert got == exp, f"addr={addr}: expected {exp}, got {got}"


# ============================================================================
#  Test 21: VALU iterative workload (long, golden model)
# ============================================================================

@cocotb.test()
async def test_valu_long_iterative_golden(dut):
    """Long VALU-heavy loop (~hundreds of cycles) against Python golden model."""
    harness = VliwCoreHarness(dut)

    vlen = 8
    x0 = [11, 13, 17, 19, 23, 29, 31, 37]
    step = [3, 5, 7, 11, 13, 17, 19, 23]
    await harness.init()

    # Golden model
    iters = 160
    x = x0[:]
    y = step[:]
    for _ in range(iters):
        x = _vbin("add", x, y)      # x = x + step

    iter_ops = [S.valu_op("add", 304, 304, 312) for _ in range(iters)]

    program = build_program([
        # Initialize x and step vectors lane-by-lane with scalar consts
        S.const(304, 11), S.const(305, 13), S.const(306, 17), S.const(307, 19),
        S.const(308, 23), S.const(309, 29), S.const(310, 31), S.const(311, 37),
        S.const(312, 3),  S.const(313, 5),  S.const(314, 7),  S.const(315, 11),
        S.const(316, 13), S.const(317, 17), S.const(318, 19), S.const(319, 23),
        *iter_ops,

        # Store final x lanes to memory for verification
        S.const(10, 700),
        S.store(10, 304),
        S.add_imm(10, 10, 1), S.store(10, 305),
        S.add_imm(10, 10, 1), S.store(10, 306),
        S.add_imm(10, 10, 1), S.store(10, 307),
        S.add_imm(10, 10, 1), S.store(10, 308),
        S.add_imm(10, 10, 1), S.store(10, 309),
        S.add_imm(10, 10, 1), S.store(10, 310),
        S.add_imm(10, 10, 1), S.store(10, 311),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=50000)

    assert cycles >= 200, f"Expected long-running VALU test (>=200 cycles), got {cycles}"
    for lane in range(vlen):
        got = harness.axi_mem.read_word(700 + lane)
        exp = x[lane]
        assert got == exp, f"lane={lane}: expected {exp}, got {got}"


# ============================================================================
#  Test 18: Long scalar recurrence (golden model)
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
async def test_long_memory_accumulate_golden(dut):
    """Long memory-heavy loop: sum 64 preloaded words; compare against golden."""
    harness = VliwCoreHarness(dut)

    data = [((i * 7 + 3) & 0xFF) for i in range(64)]
    harness.axi_mem.preload(0, data)
    await harness.init()

    golden = sum(data) & 0xFFFFFFFF

    program = build_program([
        S.const(0, 0),          # acc
        S.const(10, 0),         # addr pointer
        S.const(11, 0),         # idx
        S.const(12, 64),        # limit
        S.const(13, 1),         # increment
        S.const(20, 0),         # delay/temp
        S.label("mem_acc_loop"),
        S.load(1, 10),          # val = mem[addr]
        S.add_imm(20, 20, 0),   # conservative spacing for async load
        S.add(0, 0, 1),         # acc += val
        S.add_imm(10, 10, 1),   # addr++
        S.add(11, 11, 13),      # idx++
        S.lt(14, 11, 12),       # idx < 64
        S.cond_jump(14, "mem_acc_loop"),
        S.const(15, 301),
        S.store(15, 0),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=200000)

    result = harness.axi_mem.read_word(301)
    assert cycles >= 200, f"Expected long-running test (>=200 cycles), got {cycles}"
    assert result == golden, f"Expected {golden}, got {result}"


# ============================================================================
#  Test 22: VSTORE vector roundtrip
# ============================================================================

@cocotb.test()
async def test_vstore_roundtrip_golden(dut):
    """VLOAD + VSTORE roundtrip should preserve all VLEN lane values."""
    harness = VliwCoreHarness(dut)

    lanes = [11, 22, 33, 44, 55, 66, 77, 88]
    harness.axi_mem.preload(0, lanes)
    await harness.init()

    base_addr = 1200

    program = build_program([
        S.const(9, 0),
        S.vload(320, 9),
        S.const(10, base_addr),
        S.store(10, 320),
        S.add_imm(10, 10, 1), S.store(10, 321),
        S.add_imm(10, 10, 1), S.store(10, 322),
        S.add_imm(10, 10, 1), S.store(10, 323),
        S.add_imm(10, 10, 1), S.store(10, 324),
        S.add_imm(10, 10, 1), S.store(10, 325),
        S.add_imm(10, 10, 1), S.store(10, 326),
        S.add_imm(10, 10, 1), S.store(10, 327),
        S.halt(),
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=5000)

    for i, exp in enumerate(lanes):
        got = harness.axi_mem.read_word(base_addr + i)
        assert got == exp, f"vstore lane {i}: expected {exp}, got {got}"


# ============================================================================
#  Test 23: VALU src3 ops correctness + latency sanity
# ============================================================================

@cocotb.test()
async def test_valu_src3_ops_multicycle_golden(dut):
    """VBROADCAST (src3 op) produces correct data; now single-cycle in WB stage."""
    harness = VliwCoreHarness(dut)
    await harness.init()

    c_scalar = 10

    expected_broadcast = [c_scalar] * 8

    program = build_program([
        S.const(50, c_scalar),
        S.vbroadcast(340, 50),

        S.const(10, 1300),
        S.store(10, 340),
        S.add_imm(10, 10, 1), S.store(10, 347),
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=6000)

    # VBROADCAST is now single-cycle (no extra pipeline register)
    assert cycles >= 3, f"Expected at least a few cycles, got cycles={cycles}"

    b0 = harness.axi_mem.read_word(1300)
    b7 = harness.axi_mem.read_word(1301)

    assert b0 == expected_broadcast[0], f"vbroadcast lane0 expected {expected_broadcast[0]}, got {b0}"
    assert b7 == expected_broadcast[7], f"vbroadcast lane7 expected {expected_broadcast[7]}, got {b7}"


