from __future__ import annotations

import sys
from pathlib import Path

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ReadOnly, RisingEdge

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))
if str(PROJECT_ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "tools"))

from assembler import Assembler, AssemblerConfig
from dsl import (
    HardwareCapabilities,
    build_matrix_fp8_e4m3_accumulate_kernel,
    build_matrix_fp8_e4m3_matmul_kernel,
    build_matrix_fp8_e5m2_accumulate_kernel,
    build_matrix_fp8_e5m2_matmul_kernel,
    build_matrix_matmul_32x32_tiled_kernel,
    build_matrix_matmul_accumulate_kernel,
    build_matrix_matmul_kernel,
    build_turboquant_score_32x32_kernel,
    build_pipelined_multi_matrix_residual_affine_kernel,
    build_tileweave_matrix_residual_affine_kernel,
    golden_multi_matrix_residual_affine,
    golden_turboquant_scores_32x32,
    golden_tileweave_matrix_residual_affine,
    compile_kernel,
    encode_fp8_e4m3,
    encode_fp8_e5m2,
    golden_matrix_fp8_matmul,
    pack_matrix_matmul_32x32_u32_tiles,
    pack_matrix_matmul_32x32_u8_tiles,
    unpack_matrix_matmul_32x32_u32_tiles,
)
from scheduler import SchedulerConfig
from verification.cocotb.config import load_test_config


CFG = load_test_config(project_root=PROJECT_ROOT)
ASM = Assembler(
    AssemblerConfig(
        n_alu_slots=CFG.n_alu_slots,
        n_valu_slots=CFG.n_valu_slots,
        n_load_slots=CFG.n_load_slots,
        n_store_slots=CFG.n_store_slots,
        n_flow_slots=CFG.n_flow_slots,
        n_matrix_slots=CFG.n_matrix_slots,
        vlen=CFG.vlen,
        scratch_size=CFG.scratch_size,
        imem_depth=CFG.imem_depth,
    )
)


def _matrix_caps() -> HardwareCapabilities:
    return HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(
            n_alu_slots=CFG.n_alu_slots,
            n_valu_slots=CFG.n_valu_slots,
            n_load_slots=CFG.n_load_slots,
            n_store_slots=CFG.n_store_slots,
            n_flow_slots=CFG.n_flow_slots,
            n_matrix_slots=CFG.n_matrix_slots,
            mem_post_gap=CFG.mem_post_gap,
        ),
        assembler_config=AssemblerConfig(
            n_alu_slots=CFG.n_alu_slots,
            n_valu_slots=CFG.n_valu_slots,
            n_load_slots=CFG.n_load_slots,
            n_store_slots=CFG.n_store_slots,
            n_flow_slots=CFG.n_flow_slots,
            n_matrix_slots=CFG.n_matrix_slots,
            vlen=CFG.vlen,
            scratch_size=CFG.scratch_size,
            imem_depth=CFG.imem_depth,
        ),
    )


def _expected_matmul(a_tile: list[int], b_tile: list[int]) -> list[int]:
    out = []
    for row in range(8):
        for col in range(8):
            total = 0
            for k in range(8):
                total += a_tile[row * 8 + k] * b_tile[k * 8 + col]
            out.append(total & 0xFFFFFFFF)
    return out


def _expected_square_matmul(lhs: list[int], rhs: list[int], size: int) -> list[int]:
    out = []
    for row in range(size):
        for col in range(size):
            total = 0
            for k in range(size):
                total += lhs[row * size + k] * rhs[k * size + col]
            out.append(total & 0xFFFFFFFF)
    return out


def _encode_signed_u8(values: list[int]) -> list[int]:
    return [int(value) & 0xFF for value in values]


def _tile_pack_matrix(values: list[int], *, size: int, tile_size: int) -> list[int]:
    packed: list[int] = []
    for tile_row in range(0, size, tile_size):
        for tile_col in range(0, size, tile_size):
            for row in range(tile_size):
                for col in range(tile_size):
                    packed.append(values[(tile_row + row) * size + (tile_col + col)])
    return packed


def _pack_u8_words(values: list[int]) -> list[int]:
    words = []
    for index in range(0, len(values), 4):
        word = 0
        for byte_index, value in enumerate(values[index: index + 4]):
            word |= (value & 0xFF) << (byte_index * 8)
        words.append(word)
    return words


def _preload_u8_tile(memory_words: dict[int, int], base_word_addr: int, values: list[int]):
    for word_index, word in enumerate(_pack_u8_words(values)):
        memory_words[base_word_addr + word_index] = word


def _read_words(memory_words: dict[int, int], base_word_addr: int, count: int) -> list[int]:
    return [memory_words.get(base_word_addr + index, 0) & 0xFFFFFFFF for index in range(count)]


def _add_word_tiles(lhs: list[int], rhs: list[int]) -> list[int]:
    return [((left + right) & 0xFFFFFFFF) for left, right in zip(lhs, rhs)]


def _pack_read_beat(memory_words: dict[int, int], byte_addr: int) -> int:
    base_word = (byte_addr >> 2) & ~0xF
    data = 0
    for word_index in range(16):
        data |= (memory_words.get(base_word + word_index, 0) & 0xFFFFFFFF) << (word_index * 32)
    return data


def _write_beat(memory_words: dict[int, int], byte_addr: int, data: int, strb: int):
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


def _bundle(**engines) -> int:
    return ASM.assemble(engines)


def _halt_bundle() -> int:
    return _bundle(flow=[("halt",)])


def _safe_int(signal) -> int:
    raw = str(signal.value)
    if any(ch in raw.lower() for ch in ("x", "z")):
        return 0
    return int(signal.value)


async def _write_imem(dut, addr: int, data: int):
    dut.io_imemWrite_valid.value = 1
    dut.io_imemWrite_payload_addr.value = addr
    dut.io_imemWrite_payload_data.value = data
    await RisingEdge(dut.clk)
    dut.io_imemWrite_valid.value = 0


async def _reset(dut, cycles: int = 5):
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


async def _start_core(dut):
    dut.io_start.value = 1
    await RisingEdge(dut.clk)
    dut.io_start.value = 0


async def _wait_halted(dut, max_cycles: int = 10000, drain_cycles: int = 20):
    for _ in range(max_cycles):
        await RisingEdge(dut.clk)
        await ReadOnly()
        if int(dut.io_halted.value) == 1:
            for _ in range(drain_cycles):
                await RisingEdge(dut.clk)
            return
    raise AssertionError(
        f"Core did not halt within {max_cycles} cycles; pc={int(dut.io_pc.value)} halted={int(dut.io_halted.value)}"
    )


async def _axi_memory_model(dut, memory_words: dict[int, int], read_latency_cycles: int = 0, trace: bool = False):
    pending_read = None
    pending_read_delay = 0
    pending_b = False
    pending_aw = None
    cycle = 0

    while True:
        dut.io_dmemAxi_aw_ready.value = 1
        dut.io_dmemAxi_w_ready.value = 1
        dut.io_dmemAxi_ar_ready.value = 1
        read_ready = pending_read is not None and pending_read_delay == 0
        dut.io_dmemAxi_r_valid.value = 1 if read_ready else 0
        dut.io_dmemAxi_r_payload_data.value = _pack_read_beat(memory_words, pending_read if pending_read is not None else 0) if read_ready else 0
        dut.io_dmemAxi_r_payload_id.value = 0
        dut.io_dmemAxi_r_payload_resp.value = 0
        dut.io_dmemAxi_r_payload_last.value = 1
        dut.io_dmemAxi_b_valid.value = 1 if pending_b else 0
        dut.io_dmemAxi_b_payload_id.value = 0
        dut.io_dmemAxi_b_payload_resp.value = 0

        await RisingEdge(dut.clk)
        cycle += 1

        ar_fired = _safe_int(dut.io_dmemAxi_ar_valid) and _safe_int(dut.io_dmemAxi_ar_ready)
        aw_fired = _safe_int(dut.io_dmemAxi_aw_valid) and _safe_int(dut.io_dmemAxi_aw_ready)
        w_fired = _safe_int(dut.io_dmemAxi_w_valid) and _safe_int(dut.io_dmemAxi_w_ready)
        r_fired = read_ready and _safe_int(dut.io_dmemAxi_r_ready)
        b_fired = pending_b and _safe_int(dut.io_dmemAxi_b_ready)

        if ar_fired:
            addr = _safe_int(dut.io_dmemAxi_ar_payload_addr)
            base_word = (addr >> 2) & ~15
            if trace:
                print(f"  [cyc {cycle:4d}] AR: byte_addr={addr} base_word={base_word} words={list(memory_words.get(base_word+i,0) for i in range(16))}")
            pending_read = addr
            pending_read_delay = read_latency_cycles
        elif pending_read is not None and pending_read_delay > 0:
            pending_read_delay -= 1
        elif r_fired:
            if trace:
                base_word = (pending_read >> 2) & ~15
                rdata_words = [memory_words.get(base_word+i, 0) for i in range(16)]
                print(f"  [cyc {cycle:4d}] R:  byte_addr={pending_read} base_word={base_word} data[0..7]={rdata_words[:8]}")
            pending_read = None
            pending_read_delay = 0

        if aw_fired:
            pending_aw = _safe_int(dut.io_dmemAxi_aw_payload_addr)

        if w_fired:
            assert pending_aw is not None, "W fired without a pending AW address"
            raw_data = _safe_int(dut.io_dmemAxi_w_payload_data)
            raw_strb = _safe_int(dut.io_dmemAxi_w_payload_strb)
            base_word = (pending_aw >> 2) & ~15
            if trace:
                words = [(raw_data >> (i*32)) & 0xFFFFFFFF for i in range(16)]
                # Find which word range is active based on strb
                active_words = [i for i in range(16) if (raw_strb >> (i*4)) & 0xF]
                active_range = f"words[{min(active_words) if active_words else '?'}..{max(active_words) if active_words else '?'}]={[words[i] for i in active_words]}" if active_words else "no active bytes"
                print(f"  [cyc {cycle:4d}] W:  byte_addr={pending_aw} base_word={base_word} {active_range} strb={hex(raw_strb)}")
            _write_beat(
                memory_words,
                pending_aw,
                raw_data,
                raw_strb,
            )
            pending_aw = None
            pending_b = True

        if b_fired:
            pending_b = False


async def _run_dsl_kernel(dut, kernel, bindings: dict[str, int], *, max_cycles: int = 10000):
    result = compile_kernel(
        kernel,
        _matrix_caps(),
        bindings=bindings,
        assemble=True,
    )
    assert result.binary_bundles is not None
    if len(result.binary_bundles) >= CFG.imem_depth:
        raise AssertionError(
            f"DSL kernel assembled to {len(result.binary_bundles)} bundles, exceeding IMEM depth {CFG.imem_depth}"
        )

    for addr, bundle in enumerate(result.binary_bundles):
        await _write_imem(dut, addr, bundle)

    await RisingEdge(dut.clk)
    await _start_core(dut)
    await _wait_halted(dut, max_cycles=max_cycles)
    return result


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_dsl_matrix_matmul_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    a_tile = [((row * 8 + col) + 1) & 0xFF for row in range(8) for col in range(8)]
    b_tile = [1 if row == col else 0 for row in range(8) for col in range(8)]
    expected = _expected_matmul(a_tile, b_tile)

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, a_tile)
    _preload_u8_tile(memory_words, 16, b_tile)

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    await _run_dsl_kernel(dut, build_matrix_matmul_kernel(), {"lhs": 0, "rhs": 16, "out": 32})

    assert _read_words(memory_words, 32, 64) == expected, "DSL matrix matmul kernel wrote unexpected results"


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_dsl_matrix_matmul_accumulate_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    a_tile_0 = [((row * 8 + col) + 1) & 0xFF for row in range(8) for col in range(8)]
    b_tile_0 = [1 if row == col else 0 for row in range(8) for col in range(8)]
    a_tile_1 = [1 for _ in range(64)]
    b_tile_1 = [1 for _ in range(64)]
    expected_first = _expected_matmul(a_tile_0, b_tile_0)
    expected_second = _expected_matmul(a_tile_1, b_tile_1)
    expected = _add_word_tiles(expected_first, expected_second)

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, a_tile_0)
    _preload_u8_tile(memory_words, 16, b_tile_0)
    _preload_u8_tile(memory_words, 32, a_tile_1)
    _preload_u8_tile(memory_words, 48, b_tile_1)

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    await _run_dsl_kernel(
        dut,
        build_matrix_matmul_accumulate_kernel(),
        {"lhs0": 0, "rhs0": 16, "lhs1": 32, "rhs1": 48, "out": 64},
    )

    assert _read_words(memory_words, 64, 64) == expected, "DSL matrix accumulate kernel wrote unexpected results"


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_dsl_matrix_fp8_e4m3_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    lhs = encode_fp8_e4m3([((row - col) / 4.0) for row in range(8) for col in range(8)])
    rhs = encode_fp8_e4m3([
        1.0 if row == col else (((row + col) % 5) - 2.0) / 8.0
        for row in range(8)
        for col in range(8)
    ])
    expected = golden_matrix_fp8_matmul(lhs, rhs, fmt="fp8_e4m3")

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, lhs)
    _preload_u8_tile(memory_words, 16, rhs)

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    await _run_dsl_kernel(dut, build_matrix_fp8_e4m3_matmul_kernel(), {"lhs": 0, "rhs": 16, "out": 32})

    assert _read_words(memory_words, 32, 64) == expected, "DSL FP8 E4M3 matrix matmul kernel wrote unexpected results"


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_dsl_matrix_fp8_e5m2_accumulate_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    lhs0 = encode_fp8_e5m2([((row + 1.0) / 8.0) for row in range(8) for _ in range(8)])
    rhs0 = encode_fp8_e5m2([((col + 1.0) / 16.0) for _ in range(8) for col in range(8)])
    lhs1 = encode_fp8_e5m2([((row * 2.0) - col + 1.0) / 16.0 for row in range(8) for col in range(8)])
    rhs1 = encode_fp8_e5m2([((row + col + 1.0) / 32.0) for row in range(8) for col in range(8)])
    expected_first = golden_matrix_fp8_matmul(lhs0, rhs0, fmt="fp8_e5m2")
    expected = golden_matrix_fp8_matmul(lhs1, rhs1, fmt="fp8_e5m2", accum_seed_bits=expected_first)

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, lhs0)
    _preload_u8_tile(memory_words, 16, rhs0)
    _preload_u8_tile(memory_words, 32, lhs1)
    _preload_u8_tile(memory_words, 48, rhs1)

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    await _run_dsl_kernel(
        dut,
        build_matrix_fp8_e5m2_accumulate_kernel(),
        {"lhs0": 0, "rhs0": 16, "lhs1": 32, "rhs1": 48, "out": 64},
    )

    assert _read_words(memory_words, 64, 64) == expected, "DSL FP8 E5M2 accumulate kernel wrote unexpected results"


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_dsl_matrix_matmul_32x32_tiled_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    lhs = [((row * 5 + col * 3 + 1) % 16) for row in range(32) for col in range(32)]
    rhs = [((row * 7 + col * 2 + 3) % 16) for row in range(32) for col in range(32)]
    expected = _tile_pack_matrix(_expected_square_matmul(lhs, rhs, 32), size=32, tile_size=8)

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, _tile_pack_matrix(lhs, size=32, tile_size=8))
    _preload_u8_tile(memory_words, 256, _tile_pack_matrix(rhs, size=32, tile_size=8))

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    await _run_dsl_kernel(
        dut,
        build_matrix_matmul_32x32_tiled_kernel(),
        {"lhs_tiles": 0, "rhs_tiles": 256, "out_tiles": 512},
        max_cycles=200000,
    )

    assert _read_words(memory_words, 512, 1024) == expected, "DSL tiled 32x32 matrix matmul kernel wrote unexpected results"


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_dsl_matrix_matmul_32x32_tiled_row_major_host_flow_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    lhs_row_major = [((row * 11 + col * 5 + 7) % 32) for row in range(32) for col in range(32)]
    rhs_row_major = [((row * 13 + col * 3 + 1) % 32) for row in range(32) for col in range(32)]
    expected_row_major = _expected_square_matmul(lhs_row_major, rhs_row_major, 32)

    lhs_tiles = pack_matrix_matmul_32x32_u8_tiles(lhs_row_major)
    rhs_tiles = pack_matrix_matmul_32x32_u8_tiles(rhs_row_major)

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, lhs_tiles)
    _preload_u8_tile(memory_words, 256, rhs_tiles)

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    await _run_dsl_kernel(
        dut,
        build_matrix_matmul_32x32_tiled_kernel(),
        {"lhs_tiles": 0, "rhs_tiles": 256, "out_tiles": 512},
        max_cycles=200000,
    )

    out_tiles = _read_words(memory_words, 512, 1024)
    out_row_major = unpack_matrix_matmul_32x32_u32_tiles(out_tiles)

    assert out_row_major == expected_row_major, (
        "DSL tiled 32x32 matrix matmul host flow wrote unexpected row-major results after tile unpack"
    )


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_dsl_turboquant_score_32x32_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    keys_row_major = [(((row * 5) - (col * 3) + 7) % 9) - 4 for row in range(32) for col in range(32)]
    queries_row_major = [(((row * 2) + (col * 5) + 1) % 9) - 4 for row in range(32) for col in range(32)]
    golden = golden_turboquant_scores_32x32(keys_row_major, queries_row_major)

    coarse_keys_tiles = golden["coarse_keys_tiles"]
    coarse_queries_tiles = golden["coarse_queries_tiles"]
    residual_keys_tiles = golden["residual_keys_tiles"]
    residual_queries_tiles = golden["residual_queries_tiles"]
    expected_tiles = golden["score_tiles"]

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, coarse_keys_tiles)
    _preload_u8_tile(memory_words, 256, coarse_queries_tiles)
    _preload_u8_tile(memory_words, 512, residual_keys_tiles)
    _preload_u8_tile(memory_words, 768, residual_queries_tiles)

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    await _run_dsl_kernel(
        dut,
        build_turboquant_score_32x32_kernel(),
        {
            "coarse_keys_tiles": 0,
            "coarse_queries_tiles": 256,
            "residual_keys_tiles": 512,
            "residual_queries_tiles": 768,
            "out_tiles": 1024,
        },
        max_cycles=200000,
    )

    assert _read_words(memory_words, 1024, 1024) == expected_tiles, (
        "DSL TurboQuant-style 32x32 score kernel wrote unexpected tile-packed results"
    )


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_tileweave_matrix_residual_affine_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    lhs_signed = [((row * 3 - col * 2 + 5) % 13) - 6 for row in range(8) for col in range(8)]
    rhs_signed = [((row * 5 + col * 3 + 1) % 15) - 7 for row in range(8) for col in range(8)]
    residual = [((index * 17) + 9) & 0xFFFFFFFF for index in range(64)]
    lhs = _encode_signed_u8(lhs_signed)
    rhs = _encode_signed_u8(rhs_signed)
    _, expected_affine, expected_diff = golden_tileweave_matrix_residual_affine(
        lhs,
        rhs,
        residual,
        gain=2,
        bias=5,
    )
    expected_monitor = ((expected_affine[0] + expected_diff[-1]) & 0xFFFFFFFF)

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, lhs)
    _preload_u8_tile(memory_words, 16, rhs)
    for index, value in enumerate(residual):
        memory_words[64 + index] = value & 0xFFFFFFFF

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    await _run_dsl_kernel(
        dut,
        build_tileweave_matrix_residual_affine_kernel(block_size=8, tile_stride_elements=8),
        {"lhs": 0, "rhs": 16, "residual": 64, "affine_out": 128, "diff_out": 192, "monitor": 256, "gain": 2, "bias": 5},
        max_cycles=120000,
    )

    assert _read_words(memory_words, 128, 64) == expected_affine, "TileWeave matrix residual affine kernel wrote unexpected affine output"
    assert _read_words(memory_words, 192, 64) == expected_diff, "TileWeave matrix residual affine kernel wrote unexpected diff output"
    assert memory_words.get(256, 0) == expected_monitor, "TileWeave matrix residual affine kernel wrote unexpected monitor output"


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_pipelined_multi_matrix_residual_affine_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    runs = 2
    lhs_signed = [
        (((run * 19) + (row * 3) - (col * 2) + 5) % 17) - 8
        for run in range(runs)
        for row in range(8)
        for col in range(8)
    ]
    rhs_signed = [
        (((run * 11) + (row * 5) + (col * 3) + 1) % 15) - 7
        for run in range(runs)
        for row in range(8)
        for col in range(8)
    ]
    residual = [((index * 23) + 13) & 0xFFFFFFFF for index in range(runs * 64)]
    lhs_tiles = _encode_signed_u8(lhs_signed)
    rhs_tiles = _encode_signed_u8(rhs_signed)
    expected_matrix, expected_affine, _, _, expected_meta = golden_multi_matrix_residual_affine(
        lhs_tiles,
        rhs_tiles,
        residual,
        runs=runs,
        gain=2,
        bias=5,
    )
    expected_probe = []
    for run in range(runs):
        start = run * 64
        end = start + 64
        expected_probe.extend([expected_affine[start], expected_affine[end - 1]])

    memory_words: dict[int, int] = {}
    for run in range(runs):
        tile_start = run * 64
        _preload_u8_tile(memory_words, 0 + run * 16, lhs_tiles[tile_start: tile_start + 64])
        _preload_u8_tile(memory_words, 32 + run * 16, rhs_tiles[tile_start: tile_start + 64])
    for index, value in enumerate(residual):
        memory_words[64 + index] = value & 0xFFFFFFFF

    cocotb.start_soon(_axi_memory_model(dut, memory_words, trace=True))
    await _reset(dut)

    await _run_dsl_kernel(
        dut,
        build_pipelined_multi_matrix_residual_affine_kernel(runs=runs, chunk_elements=8, unroll=2),
        {
            "lhs_tiles": 0,
            "rhs_tiles": 32,
            "residual": 64,
            "matrix_out": 192,
            "affine_out": 320,
            "probe": 448,
            "meta": 452,
            "gain": 2,
            "bias": 5,
        },
        max_cycles=200000,
    )

    assert _read_words(memory_words, 192, runs * 64) == expected_matrix, "Pipelined multi-matrix residual affine kernel wrote unexpected matrix output"
    actual_affine = _read_words(memory_words, 320, runs * 64)
    if actual_affine != expected_affine:
        print(f"DEBUG: affine_out actual vs expected for first 24 elements:")
        for i in range(min(24, runs * 64)):
            mark = "<<WRONG" if actual_affine[i] != expected_affine[i] else "ok"
            print(f"  [{i:2d}] actual={actual_affine[i]:10} expected={expected_affine[i]:10}  {mark}")
        # Also print the raw DRAM around affine region
        print(f"DEBUG: DRAM[320..343] = {[memory_words.get(320+i, 0) for i in range(24)]}")
        # Check if affine_ptr in scratch got wrong (but scratch not readable from Python)
        # Check residual DRAM[64..79] to confirm it was not corrupted
        print(f"DEBUG: DRAM[64..79] = {[memory_words.get(64+i, 0) for i in range(16)]}")
    assert actual_affine == expected_affine, "Pipelined multi-matrix residual affine kernel wrote unexpected affine output"
    assert actual_affine == expected_affine, "Pipelined multi-matrix residual affine kernel wrote unexpected affine output"
    assert _read_words(memory_words, 448, runs * 2) == expected_probe, "Pipelined multi-matrix residual affine kernel wrote unexpected probe output"
    assert memory_words.get(452, 0) == expected_meta, "Pipelined multi-matrix residual affine kernel wrote unexpected meta output"


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_matrix_mixed_bundle_coissue_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    a_tile = [((row * 8 + col) + 1) & 0xFF for row in range(8) for col in range(8)]
    b_tile = [1 if row == col else 0 for row in range(8) for col in range(8)]
    expected_matrix = _expected_matmul(a_tile, b_tile)
    vector_a = [1, 2, 3, 4, 5, 6, 7, 8]
    vector_b = [10, 20, 30, 40, 50, 60, 70, 80]

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, a_tile)
    _preload_u8_tile(memory_words, 16, b_tile)

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    bundles = [
        _bundle(load=[("const", 40, 128)]),
        _bundle(load=[("const", 41, 129)]),
        _bundle(load=[("const", 42, 130)]),
        _bundle(load=[("const", 50, 20)]),
        _bundle(load=[("const", 51, 22)]),
    ]
    for offset, value in enumerate(vector_a):
        bundles.append(_bundle(load=[("const", 200 + offset, value)]))
    for offset, value in enumerate(vector_b):
        bundles.append(_bundle(load=[("const", 208 + offset, value)]))
    bundles.extend([
        _bundle(matrix=[("mdmvin", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mdmvin", 0, 16, 0, 0, 8, 8, 0b10)]),
        _bundle(),
        _bundle(alu=[("add", 60, 50, 51)], matrix=[("mzero", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(valu=[("add", 216, 200, 208)], matrix=[("mcompute", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mdmvout", 32, 0, 0, 0, 8, 8, 0b1)]),
        _bundle(),
        _bundle(store=[("store", 40, 60)]),
        _bundle(store=[("store", 41, 216)]),
        _bundle(store=[("store", 42, 223)]),
        _halt_bundle(),
    ])

    for addr, bundle in enumerate(bundles):
        await _write_imem(dut, addr, bundle)

    await RisingEdge(dut.clk)
    await _start_core(dut)
    await _wait_halted(dut)

    assert _read_words(memory_words, 32, 64) == expected_matrix
    assert memory_words.get(128, 0) == 42
    assert memory_words.get(129, 0) == 11
    assert memory_words.get(130, 0) == 88


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_matrix_output_feeds_scalar_pipeline_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    a_tile = [((row * 8 + col) + 1) & 0xFF for row in range(8) for col in range(8)]
    b_tile = [1 if row == col else 0 for row in range(8) for col in range(8)]
    expected_matrix = _expected_matmul(a_tile, b_tile)

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, a_tile)
    _preload_u8_tile(memory_words, 16, b_tile)

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    bundles = [
        _bundle(load=[("const", 80, 32)]),
        _bundle(load=[("const", 81, 200)]),
        _bundle(load=[("const", 82, 5)]),
        _bundle(matrix=[("mdmvin", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mdmvin", 0, 16, 0, 0, 8, 8, 0b10)]),
        _bundle(),
        _bundle(matrix=[("mzero", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mcompute", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mdmvout", 32, 0, 0, 0, 8, 8, 0b1)]),
        _bundle(),
        _bundle(),
        _bundle(load=[("load", 90, 80)]),
        _bundle(load=[("wait_for_load", 90)]),
        _bundle(alu=[("add", 91, 90, 82)]),
        _bundle(),
        _bundle(store=[("store", 81, 91)]),
        _halt_bundle(),
    ]

    for addr, bundle in enumerate(bundles):
        await _write_imem(dut, addr, bundle)

    await RisingEdge(dut.clk)
    await _start_core(dut)
    await _wait_halted(dut)

    assert _read_words(memory_words, 32, 64) == expected_matrix
    assert memory_words.get(200, 0) == ((expected_matrix[0] + 5) & 0xFFFFFFFF)


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_matrix_transfer_only_stalls_following_matrix_bundle(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    a_tile = [((row * 8 + col) + 1) & 0xFF for row in range(8) for col in range(8)]

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, a_tile)

    cocotb.start_soon(_axi_memory_model(dut, memory_words, read_latency_cycles=12))
    await _reset(dut)

    bundles = [
        _bundle(matrix=[("mdmvin", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(load=[("const", 10, 0x11111111)]),
        _bundle(load=[("const", 11, 0x22222222)]),
        _bundle(matrix=[("mzero", 0, 0, 0, 0, 8, 8, 0)]),
        _halt_bundle(),
    ]

    for addr, bundle in enumerate(bundles):
        await _write_imem(dut, addr, bundle)

    await RisingEdge(dut.clk)
    await _start_core(dut)

    saw_transfer_start = False
    const_writes_during_transfer: set[int] = set()
    saw_matrix_start_during_transfer = False
    saw_followup_matrix_start = False

    for _ in range(256):
        await RisingEdge(dut.clk)
        await ReadOnly()

        transfer_busy = _safe_int(dut.mem_io_matrixTransferBusy) == 1
        transfer_start = _safe_int(dut.mem_io_matrixTransferStartPulse) == 1
        followup_matrix_start = _safe_int(dut.matrix_io_startPulse) == 1

        if transfer_start:
            saw_transfer_start = True

        if transfer_busy and _safe_int(dut.wbConstWrites_0_valid) == 1:
            const_writes_during_transfer.add(_safe_int(dut.wbConstWrites_0_payload_addr))

        if transfer_busy and followup_matrix_start:
            saw_matrix_start_during_transfer = True

        if saw_transfer_start and not transfer_busy and followup_matrix_start:
            saw_followup_matrix_start = True
            break

    await _wait_halted(dut)

    assert saw_transfer_start, "Expected the initial MDMVIN to start a matrix transfer"
    assert const_writes_during_transfer == {10, 11}, (
        "Expected both unrelated CONST bundles to retire while the matrix transfer was busy; "
        f"saw writes for {sorted(const_writes_during_transfer)}"
    )
    assert not saw_matrix_start_during_transfer, "Follow-up matrix bundle started before the matrix transfer completed"
    assert saw_followup_matrix_start, "Follow-up matrix bundle never started after the transfer completed"


@cocotb.test(skip=CFG.n_matrix_slots < 1)
async def test_matrix_accumulate_mixed_engine_golden(dut):
    cocotb.start_soon(Clock(dut.clk, CFG.clock_period_ns, unit="ns").start())

    a_tile_0 = [((row * 8 + col) + 1) & 0xFF for row in range(8) for col in range(8)]
    b_tile_0 = [1 if row == col else 0 for row in range(8) for col in range(8)]
    a_tile_1 = [1 for _ in range(64)]
    b_tile_1 = [1 for _ in range(64)]
    expected_first = _expected_matmul(a_tile_0, b_tile_0)
    expected_second = _expected_matmul(a_tile_1, b_tile_1)
    expected_accumulated = _add_word_tiles(expected_first, expected_second)

    memory_words: dict[int, int] = {}
    _preload_u8_tile(memory_words, 0, a_tile_0)
    _preload_u8_tile(memory_words, 16, b_tile_0)
    _preload_u8_tile(memory_words, 32, a_tile_1)
    _preload_u8_tile(memory_words, 48, b_tile_1)

    cocotb.start_soon(_axi_memory_model(dut, memory_words))
    await _reset(dut)

    bundles = [
        _bundle(load=[("const", 80, 64)]),
        _bundle(load=[("const", 81, 192)]),
        _bundle(load=[("const", 82, 193)]),
        _bundle(load=[("const", 83, 7)]),
        _bundle(load=[("const", 84, 300)]),
        _bundle(load=[("const", 85, 33)]),
        _bundle(matrix=[("mdmvin", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mdmvin", 0, 16, 0, 0, 8, 8, 0b10)]),
        _bundle(),
        _bundle(matrix=[("mzero", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mcompute", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mdmvin", 0, 32, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mdmvin", 0, 48, 0, 0, 8, 8, 0b10)]),
        _bundle(),
        _bundle(alu=[("add", 86, 84, 85)], matrix=[("mcompute_acc", 0, 0, 0, 0, 8, 8, 0)]),
        _bundle(),
        _bundle(matrix=[("mdmvout", 64, 0, 0, 0, 8, 8, 0b1)]),
        _bundle(),
        _bundle(),
        _bundle(load=[("load", 90, 80)]),
        _bundle(load=[("wait_for_load", 90)]),
        _bundle(alu=[("add", 91, 90, 83)]),
        _bundle(),
        _bundle(store=[("store", 81, 91)]),
        _bundle(store=[("store", 82, 86)]),
        _halt_bundle(),
    ]

    for addr, bundle in enumerate(bundles):
        await _write_imem(dut, addr, bundle)

    await RisingEdge(dut.clk)
    await _start_core(dut)
    await _wait_halted(dut)

    assert _read_words(memory_words, 64, 64) == expected_accumulated
    assert memory_words.get(192, 0) == ((expected_accumulated[0] + 7) & 0xFFFFFFFF)
    assert memory_words.get(193, 0) == 333
