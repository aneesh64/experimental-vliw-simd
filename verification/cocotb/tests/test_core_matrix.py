"""
cocotb integration testbench for a matrix-enabled VliwCore.

Coverage here stays intentionally narrow and core-focused:
    1. End-to-end matrix DRAM moves + compute on the matrix-enabled core.
    2. A scalar load-use replay regression on the same matrix-enabled core
         configuration, so fetch-stall behavior is protected even when no matrix
         instruction is active in the failing sequence.
"""

from pathlib import Path
import sys

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly


PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))
INTEGRATION_DIR = PROJECT_ROOT / "verification" / "cocotb" / "integration"
if str(INTEGRATION_DIR) not in sys.path:
    sys.path.insert(0, str(INTEGRATION_DIR))

from tools.assembler import Assembler, AssemblerConfig
from verification.cocotb.integration.harness import VliwCoreHarness
from tools.dsl import encode_fp8_e4m3, encode_fp8_e5m2, golden_matrix_fp8_matmul


ASM = Assembler(AssemblerConfig(n_matrix_slots=1))


def assemble_bundle(**engines):
    return ASM.assemble(engines)


def pack_u8_beat(values: list[int]) -> int:
    data = 0
    for idx, value in enumerate(values):
        data |= (value & 0xFF) << (idx * 8)
    return data


def pack_read_beat(memory_words: dict[int, int], byte_addr: int) -> int:
    base_word = (byte_addr >> 2) & ~0xF
    data = 0
    for word_index in range(16):
        data |= (memory_words.get(base_word + word_index, 0) & 0xFFFFFFFF) << (word_index * 32)
    return data


def write_beat(memory_words: dict[int, int], byte_addr: int, data: int, strb: int):
    base_word = (byte_addr >> 2) & ~0xF
    for byte_index in range(64):
        if not (strb & (1 << byte_index)):
            continue
        word_addr = base_word + (byte_index // 4)
        byte_in_word = byte_index % 4
        byte_value = (data >> (byte_index * 8)) & 0xFF
        current = memory_words.get(word_addr, 0) & 0xFFFFFFFF
        mask = 0xFF << (byte_in_word * 8)
        memory_words[word_addr] = (current & ~mask) | (byte_value << (byte_in_word * 8))


def preload_u8_tile(memory_words: dict[int, int], base_word_addr: int, values: list[int]):
    for index in range(0, len(values), 4):
        word = 0
        for byte_index, value in enumerate(values[index:index + 4]):
            word |= (value & 0xFF) << (byte_index * 8)
        memory_words[base_word_addr + (index // 4)] = word


def read_words(memory_words: dict[int, int], base_word_addr: int, count: int) -> list[int]:
    return [memory_words.get(base_word_addr + index, 0) & 0xFFFFFFFF for index in range(count)]


def unpack_u32_beat(data: int) -> list[int]:
    words = []
    for idx in range(16):
        words.append((data >> (idx * 32)) & 0xFFFFFFFF)
    return words


def expected_matmul(a_tile: list[int], b_tile: list[int]) -> list[int]:
    out = []
    for row in range(8):
        for col in range(8):
            total = 0
            for k in range(8):
                total += a_tile[row * 8 + k] * b_tile[k * 8 + col]
            out.append(total & 0xFFFFFFFF)
    return out


def safe_int(signal) -> int:
    raw = str(signal.value)
    if any(ch in raw.lower() for ch in ("x", "z")):
        return 0
    return int(signal.value)


async def write_imem(dut, addr: int, data: int):
    dut.io_imemWrite_valid.value = 1
    dut.io_imemWrite_payload_addr.value = addr
    dut.io_imemWrite_payload_data.value = data
    await RisingEdge(dut.clk)
    dut.io_imemWrite_valid.value = 0


async def reset(dut, cycles=5):
    dut.reset.value = 1
    dut.io_start.value = 0
    dut.io_imemWrite_valid.value = 0
    dut.io_imemWrite_payload_addr.value = 0
    dut.io_imemWrite_payload_data.value = 0
    dut.io_dmemAxi_b_valid.value = 0
    dut.io_dmemAxi_b_payload_id.value = 0
    dut.io_dmemAxi_b_payload_resp.value = 0
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


async def wait_halted(dut, max_cycles=4000):
    for _ in range(max_cycles):
        await RisingEdge(dut.clk)
        await ReadOnly()
        if int(dut.io_halted.value) == 1:
            return
    raise AssertionError(
        f"Core did not halt within {max_cycles} cycles; "
        f"pc={int(dut.io_pc.value)} running={int(dut.io_running.value)} halted={int(dut.io_halted.value)}"
    )


async def axi_memory_model(dut, memory_words: dict[int, int], read_latency: int = 0):
    pending_read = None
    pending_read_delay = 0
    pending_b = False
    pending_aw = None

    while True:
        dut.io_dmemAxi_aw_ready.value = 1
        dut.io_dmemAxi_w_ready.value = 1
        dut.io_dmemAxi_ar_ready.value = 1
        read_ready = pending_read is not None and pending_read_delay == 0
        dut.io_dmemAxi_r_valid.value = 1 if read_ready else 0
        dut.io_dmemAxi_r_payload_data.value = pack_read_beat(memory_words, pending_read) if read_ready else 0
        dut.io_dmemAxi_r_payload_id.value = 0
        dut.io_dmemAxi_r_payload_resp.value = 0
        dut.io_dmemAxi_r_payload_last.value = 1
        dut.io_dmemAxi_b_valid.value = 1 if pending_b else 0
        dut.io_dmemAxi_b_payload_id.value = 0
        dut.io_dmemAxi_b_payload_resp.value = 0

        await RisingEdge(dut.clk)

        ar_fired = safe_int(dut.io_dmemAxi_ar_valid) and safe_int(dut.io_dmemAxi_ar_ready)
        aw_fired = safe_int(dut.io_dmemAxi_aw_valid) and safe_int(dut.io_dmemAxi_aw_ready)
        w_fired = safe_int(dut.io_dmemAxi_w_valid) and safe_int(dut.io_dmemAxi_w_ready)
        r_fired = read_ready and safe_int(dut.io_dmemAxi_r_ready)
        b_fired = pending_b and safe_int(dut.io_dmemAxi_b_ready)

        if ar_fired:
            pending_read = safe_int(dut.io_dmemAxi_ar_payload_addr)
            pending_read_delay = read_latency
        elif pending_read is not None and pending_read_delay > 0:
            pending_read_delay -= 1
        elif r_fired:
            pending_read = None
            pending_read_delay = 0

        if aw_fired:
            pending_aw = safe_int(dut.io_dmemAxi_aw_payload_addr)

        if w_fired:
            assert pending_aw is not None, "W fired without a pending AW address"
            write_beat(
                memory_words,
                pending_aw,
                safe_int(dut.io_dmemAxi_w_payload_data),
                safe_int(dut.io_dmemAxi_w_payload_strb),
            )
            pending_aw = None
            pending_b = True

        if b_fired:
            pending_b = False


@cocotb.test()
async def test_matrix_program_round_trip(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    a_tile = [((row * 8 + col) + 1) & 0xFF for row in range(8) for col in range(8)]
    b_tile = [1 if row == col else 0 for row in range(8) for col in range(8)]
    expected = expected_matmul(a_tile, b_tile)

    memory_words: dict[int, int] = {}
    preload_u8_tile(memory_words, 0, a_tile)
    preload_u8_tile(memory_words, 16, b_tile)

    cocotb.start_soon(axi_memory_model(dut, memory_words))
    await reset(dut)

    program = [
        assemble_bundle(matrix=[("mdmvin", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mdmvin", 0, 16, 0, 0, 8, 8, 0b10)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mzero", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mcompute", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mdmvout", 32, 0, 0, 0, 8, 8, 0b1)]),
        assemble_bundle(),
        assemble_bundle(flow=[("halt",)]),
    ]

    for addr, bundle in enumerate(program):
        await write_imem(dut, addr, bundle)

    await RisingEdge(dut.clk)
    await start_core(dut)
    await wait_halted(dut, max_cycles=10000)

    assert read_words(memory_words, 32, 64) == expected, "Matrix core program wrote unexpected results"


@cocotb.test()
async def test_matrix_enabled_core_replays_first_load_use_dependent_bundle(dut):
    """Matrix-enabled core must preserve the first dependent bundle after load-use stall release.

    With software-managed hazard avoidance, a WAIT_FOR_LOAD barrier is inserted
    between the load and its consumer to stall until the load completes.
    """
    harness = VliwCoreHarness(dut, axi_latency=8)
    harness.axi_mem.preload(600, [9])
    await harness.init()

    program = ASM.assemble_program([
        {},
        {"load": [("const", 0, 600)]},
        {},
        {},
        {"load": [("load", 1, 0)]},
        {"load": [("wait_for_load", 1)]},
        {"alu": [("add", 2, 1, 1)]},
        {"load": [("const", 10, 1400)]},
        {},
        {},
        {"store": [("store", 10, 2)]},
        {"flow": [("halt",)]},
    ])

    await harness.load_program(program)
    await harness.run(max_cycles=4000)

    assert harness.axi_mem.read_word(1400) == 18, (
        f"First dependent bundle expected 18, got {harness.axi_mem.read_word(1400)}"
    )


@cocotb.test()
async def test_matrix_fp8_e4m3_program_round_trip(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    lhs = encode_fp8_e4m3([((row - col) / 4.0) for row in range(8) for col in range(8)])
    rhs = encode_fp8_e4m3([
        1.0 if row == col else (((row + col) % 5) - 2.0) / 8.0
        for row in range(8)
        for col in range(8)
    ])
    expected = golden_matrix_fp8_matmul(lhs, rhs, fmt="fp8_e4m3")

    memory_words: dict[int, int] = {}
    preload_u8_tile(memory_words, 0, lhs)
    preload_u8_tile(memory_words, 16, rhs)

    cocotb.start_soon(axi_memory_model(dut, memory_words))
    await reset(dut)

    program = [
        assemble_bundle(matrix=[("mdmvin", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mdmvin", 0, 16, 0, 0, 8, 8, 0b10)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mzero", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mcompute_fp8_e4m3", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mdmvout", 32, 0, 0, 0, 8, 8, 0b1)]),
        assemble_bundle(),
        assemble_bundle(flow=[("halt",)]),
    ]

    for addr, bundle in enumerate(program):
        await write_imem(dut, addr, bundle)

    await RisingEdge(dut.clk)
    await start_core(dut)
    await wait_halted(dut, max_cycles=10000)

    assert read_words(memory_words, 32, 64) == expected, "FP8 E4M3 matrix program wrote unexpected results"


@cocotb.test()
async def test_matrix_fp8_e5m2_accumulate_program_round_trip(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    lhs0 = encode_fp8_e5m2([((row + 1.0) / 8.0) for row in range(8) for _ in range(8)])
    rhs0 = encode_fp8_e5m2([((col + 1.0) / 16.0) for _ in range(8) for col in range(8)])
    lhs1 = encode_fp8_e5m2([((row * 2.0) - col + 1.0) / 16.0 for row in range(8) for col in range(8)])
    rhs1 = encode_fp8_e5m2([((row + col + 1.0) / 32.0) for row in range(8) for col in range(8)])
    expected_first = golden_matrix_fp8_matmul(lhs0, rhs0, fmt="fp8_e5m2")
    expected = golden_matrix_fp8_matmul(lhs1, rhs1, fmt="fp8_e5m2", accum_seed_bits=expected_first)

    memory_words: dict[int, int] = {}
    preload_u8_tile(memory_words, 0, lhs0)
    preload_u8_tile(memory_words, 16, rhs0)
    preload_u8_tile(memory_words, 32, lhs1)
    preload_u8_tile(memory_words, 48, rhs1)

    cocotb.start_soon(axi_memory_model(dut, memory_words))
    await reset(dut)

    program = [
        assemble_bundle(matrix=[("mdmvin", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mdmvin", 0, 16, 0, 0, 8, 8, 0b10)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mzero", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mcompute_fp8_e5m2", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mdmvout", 64, 0, 0, 0, 8, 8, 0b1)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mdmvin", 0, 32, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mdmvin", 0, 48, 0, 0, 8, 8, 0b10)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mcompute_fp8_e5m2_acc", 0, 0, 0, 0, 8, 8, 0)]),
        assemble_bundle(),
        assemble_bundle(matrix=[("mdmvout", 64, 0, 0, 0, 8, 8, 0b1)]),
        assemble_bundle(),
        assemble_bundle(flow=[("halt",)]),
    ]

    for addr, bundle in enumerate(program):
        await write_imem(dut, addr, bundle)

    await RisingEdge(dut.clk)
    await start_core(dut)
    await wait_halted(dut, max_cycles=20000)

    assert read_words(memory_words, 64, 64) == expected, "FP8 E5M2 accumulate matrix program wrote unexpected results"
