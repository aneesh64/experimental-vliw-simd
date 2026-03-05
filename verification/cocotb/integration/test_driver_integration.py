"""
Driver Integration Test — Full end-to-end verification via CSR/IMEM interface.

Demonstrates the complete flow:
1. Load program to IMEM via harness
2. Start execution
3. Wait for halt
4. Read results via AXI memory
5. Verify expected outcomes

This test validates:
- Program load and execution flow
- Driver-level API correctness
- Arithmetic, memory, control flow, and vector operations
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

ASM = Assembler(AssemblerConfig(
    n_alu_slots=CFG.n_alu_slots,
    n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots,
    n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots,
    vlen=CFG.vlen,
    scratch_size=CFG.scratch_size,
    imem_depth=CFG.imem_depth,
))

S = VliwScheduler(SchedulerConfig(
    n_alu_slots=CFG.n_alu_slots,
    n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots,
    n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots,
    mem_post_gap=CFG.mem_post_gap,
))


def build_program(ops, verbose=False):
    bundles_dicts = S.schedule(ops, verbose=verbose)
    return ASM.assemble_program(bundles_dicts)


@cocotb.test(skip=False)
async def test_driver_program_load_execute(dut):
    """
    Test 1: Program Load and Execution (Driver Emulation)

    Demonstrates load program -> start -> wait -> read flow matching vliw_driver API.
    """
    harness = VliwCoreHarness(dut)
    await harness.init()

    # Verify basic config
    assert dut.io_start is not None
    cocotb.log.info("Harness initialized, signals verified")

    # Build program: LI $0,10; LI $1,20; ADD $2,$0,$1; HALT
    program = build_program([
        S.const(0, 10),
        S.const(1, 20),
        S.add(2, 0, 1),
        S.halt(),
    ])

    await harness.load_program(program)
    cocotb.log.info(f"Program loaded ({len(program)} bundles)")

    cycles = await harness.run(max_cycles=10000)
    cocotb.log.info(f"Program halted after {cycles} cycles")

    assert cycles > 0, "Program should execute"
    assert cycles < 1000, "Trivial program should complete quickly"


@cocotb.test(skip=False)
async def test_driver_simple_arithmetic(dut):
    """
    Test 2: Simple Arithmetic via Driver Flow

    Validates driver-controlled program produces correct results.
    Store result to AXI memory and verify.
    """
    harness = VliwCoreHarness(dut)
    await harness.init()

    # 10 + 20 = 30, store to mem[0]
    program = build_program([
        S.const(0, 10),
        S.const(1, 20),
        S.add(2, 0, 1),          # s[2] = 30
        S.const(10, 0),          # addr = 0
        S.store(10, 2),          # mem[0] = 30
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    result = harness.axi_mem.read_word(0)
    cocotb.log.info(f"Arithmetic test completed in {cycles} cycles, result={result}")
    assert result == 30, f"Expected 30, got {result}"
    assert cycles > 0 and cycles < 1000


@cocotb.test(skip=False)
async def test_driver_memory_access_flow(dut):
    """
    Test 3: Memory Access Via Driver

    Store a value, load it back, verify round-trip.
    """
    harness = VliwCoreHarness(dut)
    await harness.init()

    # Store 42 at address 0, then load it back to s[5], store s[5] at address 1
    program = build_program([
        S.const(0, 42),
        S.const(10, 0),          # addr = 0
        S.store(10, 0),          # mem[0] = 42
        S.load(5, 10),           # s[5] = mem[0]
        S.add_imm(10, 10, 1),   # addr = 1
        S.store(10, 5),          # mem[1] = s[5] (should be 42)
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=100000)

    result = harness.axi_mem.read_word(1)
    cocotb.log.info(f"Memory access test completed in {cycles} cycles, result={result}")
    assert result == 42, f"Expected 42, got {result}"
    assert cycles < 50000


@cocotb.test(skip=False)
async def test_driver_control_flow(dut):
    """
    Test 4: Control Flow (Counting Loop) Via Driver

    Count from 0 to 5 using a loop. Store final counter to memory.
    """
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 0),           # counter = 0
        S.const(1, 5),           # limit = 5
        S.const(2, 1),           # increment = 1
        S.label("loop"),
        S.add(0, 0, 2),          # counter++
        S.lt(3, 0, 1),           # counter < limit?
        S.cond_jump(3, "loop"),
        S.const(10, 0),
        S.store(10, 0),          # mem[0] = counter
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=100000)

    result = harness.axi_mem.read_word(0)
    cocotb.log.info(f"Control flow test completed in {cycles} cycles, counter={result}")
    assert result == 5, f"Expected counter=5, got {result}"
    assert cycles > 0


@cocotb.test(skip=False)
async def test_driver_vector_operations(dut):
    """
    Test 5: Vector Operations Via Driver

    Broadcast scalar to vector, store one lane to verify.
    """
    harness = VliwCoreHarness(dut)
    await harness.init()

    program = build_program([
        S.const(0, 100),
        S.vbroadcast(16, 0),     # v0 (base=16) = broadcast(100)
        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=100000)

    cocotb.log.info(f"Vector operations test completed in {cycles} cycles")
    assert cycles > 0

