from test_integration_common import *


def _assemble_direct(bundles):
    return ASM.assemble_program(bundles)

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
async def test_vector_load_compute_store_pipeline(dut):
    """
    Full vector pipeline: VLOAD two vectors from memory, perform VALU add
    and VALU mul, then store results back with scalar stores (lane by lane).

    Exercises the complete data path:
      Memory → Vector registers → VALU compute → Scalar readback → AXI store

    Golden model computed in Python.
    """
    harness = VliwCoreHarness(dut)

    vlen = 8
    vec_a = [100, 200, 300, 400, 500, 600, 700, 800]
    vec_b = [1, 2, 3, 4, 5, 6, 7, 8]

    # Pre-load vectors into AXI memory at known addresses
    # vec_a at word address 0, vec_b at word address 8
    harness.axi_mem.preload(0, vec_a)
    harness.axi_mem.preload(8, vec_b)
    await harness.init()

    # Golden model
    golden_add = _vbin("add", vec_a, vec_b)   # [101,202,303,404,505,606,707,808]
    golden_mul = _vbin("mul", vec_a, vec_b)    # [100,400,900,1600,2500,3600,4900,6400]

    # Register allocation:
    #   Vector bank 96..103  = vec_a  (loaded via vload)
    #   Vector bank 104..111 = vec_b  (loaded via vload)
    #   Vector bank 112..119 = add result
    #   Vector bank 120..127 = mul result

    program = build_program([
        # VLOAD vec_a from mem[0]
        S.const(9, 0),           # addr = 0
        S.vload(96, 9),          # s[96..103] = mem[0..7]

        # VLOAD vec_b from mem[8]
        S.const(9, 8),           # addr = 8
        S.vload(104, 9),         # s[104..111] = mem[8..15]

        # VALU add: result in s[112..119]
        S.valu_op("add", 112, 96, 104),

        # VALU mul: result in s[120..127]
        S.valu_op("mul", 120, 96, 104),

        # VSTORE add results to mem[2000..2007]
        S.const(10, 2000),
        S.vstore(10, 112),       # burst store 8 lanes

        # VSTORE mul results to mem[3000..3007]
        S.const(10, 3000),
        S.vstore(10, 120),       # burst store 8 lanes

        S.halt(),
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=10000)

    # Verify add results
    for lane in range(vlen):
        got = harness.axi_mem.read_word(2000 + lane)
        exp = golden_add[lane]
        assert got == exp, (
            f"VALU add lane {lane}: expected {exp}, got {got}"
        )

    # Verify mul results
    for lane in range(vlen):
        got = harness.axi_mem.read_word(3000 + lane)
        exp = golden_mul[lane]
        assert got == exp, (
            f"VALU mul lane {lane}: expected {exp}, got {got}"
        )


# ============================================================================
#  Targeted load-use hazard tests (test-first for hardware stall feature)
# ============================================================================

@cocotb.test()
async def test_scalar_load_use_immediate_dependency_stalls(dut):
    """Immediate scalar load-use dependency with forced read latency."""
    harness = VliwCoreHarness(dut, axi_latency=8)
    harness.axi_mem.preload(100, [21])
    await harness.init()

    program = _assemble_direct([
        {},
        {"load": [("const", 0, 100)]},
        {},
        {},
        {"load": [("load", 1, 0)]},
        {"alu": [("add", 2, 1, 1)]},
        {"load": [("const", 10, 1000)]},
        {},
        {},
        {"store": [("store", 10, 2)]},
        {"flow": [("halt",)]},
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=4000)

    got = harness.axi_mem.read_word(1000)
    assert got == 42, f"Expected doubled loaded value 42, got {got}"


@cocotb.test()
async def test_vector_vload_use_immediate_dependency_stalls(dut):
    """Immediate vector vload-use dependency with forced read latency.

    VLOAD → VALU (same-cycle dependency) → VSTORE must stall the pipeline
    until the VLOAD data is committed.  The VSTORE AXI address must be
    beat-aligned for the vector width (addr % 16 <= 8 for VLEN=8 with a
    512-bit / 16-word AXI bus) to avoid lane-wrapping within a single beat.
    """
    harness = VliwCoreHarness(dut, axi_latency=9)
    src = [1, 2, 3, 4, 5, 6, 7, 8]
    harness.axi_mem.preload(0, src)   # offset=0 → positions 0-7 in beat
    await harness.init()

    # Use beat-aligned VSTORE address: 2000 % 16 == 0
    program = _assemble_direct([
        {},
        {"load": [("const", 0, 0)]},
        {},
        {},
        {"load": [("vload", 320, 0)]},
        {"valu": [("add", 328, 320, 320)]},
        {"load": [("const", 10, 2000)]},
        {},
        {},
        {"store": [("vstore", 10, 328)]},
        {"flow": [("halt",)]},
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=6000)

    expected = [v * 2 for v in src]
    results = [harness.axi_mem.read_word(2000 + lane) for lane in range(8)]
    dut._log.info(f"[diag] vload-use vector results: {results}")
    dut._log.info(f"[diag] vload-use vector expected: {expected}")
    for lane, exp in enumerate(expected):
        got = results[lane]
        assert got == exp, f"lane {lane}: expected {exp}, got {got}"


@cocotb.test()
async def test_load_use_independent_before_dependent_progress(dut):
    """Independent bundle after load should progress; later dependent bundle must be correct."""
    harness = VliwCoreHarness(dut, axi_latency=10)
    harness.axi_mem.preload(300, [5])
    await harness.init()

    program = _assemble_direct([
        {},
        {"load": [("const", 0, 300)]},
        {"load": [("const", 20, 100)]},
        {},
        {},
        {"load": [("load", 1, 0)]},
        {"flow": [("add_imm", 20, 20, 7)]},
        {"alu": [("add", 2, 1, 1)]},
        {"load": [("const", 10, 1300)]},
        {},
        {},
        {"store": [("store", 10, 20)]},
        {"flow": [("add_imm", 10, 10, 1)]},
        {"store": [("store", 10, 2)]},
        {"flow": [("halt",)]},
    ])

    await harness.load_program(program)
    cycles = await harness.run(max_cycles=6000)

    independent = harness.axi_mem.read_word(1300)
    dependent = harness.axi_mem.read_word(1301)
    assert independent == 107, f"Independent op expected 107, got {independent}"
    assert dependent == 10, f"Dependent load-use op expected 10, got {dependent}"
    assert cycles < 3000, f"Unexpected excessive stalling: cycles={cycles}"


@cocotb.test()
async def test_load_use_randomized_axi_latency_robustness(dut):
    """Stress immediate load-use dependencies under randomized per-transaction AXI read latency."""
    harness = VliwCoreHarness(dut, axi_latency_mode="stress", axi_latency_n=20)
    harness.axi_mem.preload(400, [3])
    harness.axi_mem.preload(401, [7])
    harness.axi_mem.preload(500, [2, 4, 6, 8, 10, 12, 14, 16])
    await harness.init()

    program = _assemble_direct([
        {},
        {"load": [("const", 0, 400)]},
        {},
        {},
        {"load": [("load", 1, 0)]},
        {"alu": [("add", 2, 1, 1)]},

        {"flow": [("add_imm", 0, 0, 1)]},
        {"load": [("load", 3, 0)]},
        {"alu": [("add", 4, 3, 3)]},

        {"load": [("const", 5, 500)]},
        {},
        {},
        {"load": [("vload", 320, 5)]},
        {"valu": [("add", 328, 320, 320)]},

        {"load": [("const", 10, 2000)]},
        {},
        {},
        {"store": [("store", 10, 2)]},
        {"flow": [("add_imm", 10, 10, 1)]},
        {"store": [("store", 10, 4)]},
        {"flow": [("add_imm", 10, 10, 1)]},
        {"store": [("vstore", 10, 328)]},
        {"flow": [("halt",)]},
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=12000)

    assert harness.axi_mem.read_word(2000) == 6, "Scalar hazard #1 mismatch"
    assert harness.axi_mem.read_word(2001) == 14, "Scalar hazard #2 mismatch"
    expected_vec = [4, 8, 12, 16, 20, 24, 28, 32]
    for lane, exp in enumerate(expected_vec):
        got = harness.axi_mem.read_word(2002 + lane)
        assert got == exp, f"Random stress vector lane {lane}: expected {exp}, got {got}"

    assert harness.axi_mem.read_txn_count >= 3, "Expected multiple AXI read transactions"
    assert len(set(harness.axi_mem.read_latencies)) > 1, (
        f"Expected varied read latencies, got {harness.axi_mem.read_latencies}"
    )


@cocotb.test()
async def test_store_fifo_full_stall_under_write_backpressure(dut):
    """Force AXI write backpressure, fill store FIFO, and verify correct stall/recovery behavior."""
    harness = VliwCoreHarness(
        dut,
        axi_write_aw_delay=120,
        axi_write_w_delay=120,
        axi_write_b_delay=120,
    )
    await harness.init()

    # Build direct bundles so stores are issued back-to-back (no scheduler spacing).
    # This intentionally drives store request pressure above FIFO depth (default 4).
    store_count = 5
    bundles = [
        {},
        {"load": [("const", 10, 1600)]},
        {"load": [("const", 0, 0x5A)]},
    ]
    for _ in range(store_count):
        bundles.append({"store": [("store", 10, 0)]})
    bundles.append({"flow": [("halt",)]})

    program = _assemble_direct(bundles)
    await harness.load_program(program)

    # Large drain to allow delayed write responses to commit after halt.
    cycles = await harness.run(max_cycles=20000, drain_cycles=1200)

    got = harness.axi_mem.read_word(1600)
    assert got == 0x5A, f"Expected final stored value 0x5A, got {got:#x}"
    assert harness.axi_mem.write_txn_count >= 4, (
        "Expected at least 4 committed store transactions under backpressure "
        f"(FIFO saturation path), got {harness.axi_mem.write_txn_count}"
    )
    assert cycles > 200, f"Expected visible backpressure-induced stalling, got only {cycles} cycles"
