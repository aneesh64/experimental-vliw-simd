from __future__ import annotations

from functools import lru_cache
from math import sqrt
import math
import struct
from typing import Sequence

from ..builder import KernelBuilder
from ..ir import I8, Kernel, U8, U32


_MATRIX_TILE_SIZE = 8
_TILED_32X32_DIM = 32
_TILES_PER_DIM = _TILED_32X32_DIM // _MATRIX_TILE_SIZE
_INPUT_TILE_WORDS = (_MATRIX_TILE_SIZE * _MATRIX_TILE_SIZE) // 4
_OUTPUT_TILE_WORDS = _MATRIX_TILE_SIZE * _MATRIX_TILE_SIZE
_TURBOQUANT_QMAX = 7
_HADAMARD_8_SCALE = sqrt(8.0)
_TURBOQUANT_SIGN_FLIPS = (1.0, -1.0, 1.0, 1.0, -1.0, 1.0, -1.0, -1.0)


def _s8(value: int) -> int:
    value &= 0xFF
    return value - 256 if value & 0x80 else value


def _u32(value: int) -> int:
    return value & 0xFFFFFFFF


def _f32_to_bits(value: float) -> int:
    return int.from_bytes(struct.pack("<f", float(value)), byteorder="little", signed=False)


def _bits_to_f32(value: int) -> float:
    return struct.unpack("<f", int(value & 0xFFFFFFFF).to_bytes(4, byteorder="little", signed=False))[0]


def _round_to_f32(value: float) -> float:
    return _bits_to_f32(_f32_to_bits(value))


def _decode_fp8_value(raw: int, fmt: str) -> float:
    raw &= 0xFF
    sign = -1.0 if (raw & 0x80) else 1.0

    if fmt == "fp8_e4m3":
        exp = (raw >> 3) & 0xF
        mant = raw & 0x7
        if exp == 0:
            if mant == 0:
                return math.copysign(0.0, -1.0 if sign < 0 else 1.0)
            return sign * mant * (2.0 ** -9)
        if exp == 0xF and mant == 0x7:
            raise ValueError(f"Unsupported FP8 E4M3 special encoding 0x{raw:02X}")
        return sign * (1.0 + (mant / 8.0)) * (2.0 ** (exp - 7))

    if fmt == "fp8_e5m2":
        exp = (raw >> 2) & 0x1F
        mant = raw & 0x3
        if exp == 0:
            if mant == 0:
                return math.copysign(0.0, -1.0 if sign < 0 else 1.0)
            return sign * mant * (2.0 ** -16)
        if exp == 0x1F:
            raise ValueError(f"Unsupported FP8 E5M2 special encoding 0x{raw:02X}")
        return sign * (1.0 + (mant / 4.0)) * (2.0 ** (exp - 15))

    raise ValueError(f"Unsupported FP8 format '{fmt}'")


@lru_cache(maxsize=None)
def _fp8_candidates(fmt: str) -> tuple[tuple[int, float], ...]:
    candidates: list[tuple[int, float]] = []
    for raw in range(256):
        try:
            value = _decode_fp8_value(raw, fmt)
        except ValueError:
            continue
        candidates.append((raw, value))
    return tuple(candidates)


def _encode_fp8_value(value: float, fmt: str) -> int:
    scalar = float(value)
    if math.isnan(scalar) or math.isinf(scalar):
        raise ValueError(f"Cannot encode non-finite value {value!r} as {fmt}")
    if scalar == 0.0:
        return 0x80 if math.copysign(1.0, scalar) < 0 else 0x00

    best_raw = 0
    best_key: tuple[float, float, int] | None = None
    for raw, candidate in _fp8_candidates(fmt):
        distance = abs(candidate - scalar)
        key = (distance, abs(candidate), raw)
        if best_key is None or key < best_key:
            best_key = key
            best_raw = raw
    return best_raw


def encode_fp8_e4m3(values: Sequence[float]) -> list[int]:
    return [_encode_fp8_value(value, "fp8_e4m3") for value in values]


def encode_fp8_e5m2(values: Sequence[float]) -> list[int]:
    return [_encode_fp8_value(value, "fp8_e5m2") for value in values]


def golden_matrix_fp8_matmul(
    lhs: Sequence[int],
    rhs: Sequence[int],
    *,
    fmt: str,
    accum_seed_bits: Sequence[int] | None = None,
) -> list[int]:
    lhs_values = _require_square_matrix(lhs, size=8, element_bits=8, role=f"{fmt} lhs matrix")
    rhs_values = _require_square_matrix(rhs, size=8, element_bits=8, role=f"{fmt} rhs matrix")
    seed = [0] * 64 if accum_seed_bits is None else _require_square_matrix(
        accum_seed_bits,
        size=8,
        element_bits=32,
        role=f"{fmt} accumulator seed",
    )

    out: list[int] = []
    for row in range(8):
        for col in range(8):
            total = _bits_to_f32(seed[row * 8 + col])
            for k in range(8):
                total = _round_to_f32(
                    total +
                    (_decode_fp8_value(lhs_values[row * 8 + k], fmt) *
                     _decode_fp8_value(rhs_values[k * 8 + col], fmt))
                )
            out.append(_f32_to_bits(total))
    return out


def _hadamard(order: int) -> list[list[int]]:
    if order == 1:
        return [[1]]
    half = _hadamard(order // 2)
    top = [row + row for row in half]
    bottom = [row + [-value for value in row] for row in half]
    return top + bottom


_HADAMARD_8 = _hadamard(_MATRIX_TILE_SIZE)


def _require_square_matrix(values: Sequence[int], *, size: int, element_bits: int, role: str) -> list[int]:
    flat = [int(value) for value in values]
    expected = size * size
    if len(flat) != expected:
        raise ValueError(f"{role} must contain exactly {expected} elements for a {size}x{size} matrix")
    mask = (1 << element_bits) - 1
    return [value & mask for value in flat]


def _require_square_signed_matrix(values: Sequence[int], *, size: int, role: str) -> list[int]:
    flat = [int(value) for value in values]
    expected = size * size
    if len(flat) != expected:
        raise ValueError(f"{role} must contain exactly {expected} elements for a {size}x{size} matrix")
    return flat


def _require_rect_matrix(values: Sequence[int], *, rows: int, cols: int, element_bits: int, role: str) -> list[int]:
    flat = [int(value) for value in values]
    expected = rows * cols
    if len(flat) != expected:
        raise ValueError(f"{role} must contain exactly {expected} elements for a {rows}x{cols} matrix")
    mask = (1 << element_bits) - 1
    return [value & mask for value in flat]


def _transpose_square_matrix(values: Sequence[int], *, size: int, role: str) -> list[int]:
    matrix = [int(value) for value in values]
    expected = size * size
    if len(matrix) != expected:
        raise ValueError(f"{role} must contain exactly {expected} elements for a {size}x{size} matrix")
    return [matrix[col * size + row] for row in range(size) for col in range(size)]


def _pack_rect_matrix_tiles(values: Sequence[int], *, rows: int, cols: int, element_bits: int, role: str) -> list[int]:
    if (rows % _MATRIX_TILE_SIZE) != 0 or (cols % _MATRIX_TILE_SIZE) != 0:
        raise ValueError(f"{role} must use dimensions divisible by {_MATRIX_TILE_SIZE}")
    matrix = _require_rect_matrix(values, rows=rows, cols=cols, element_bits=element_bits, role=role)
    packed: list[int] = []
    for tile_row in range(0, rows, _MATRIX_TILE_SIZE):
        for tile_col in range(0, cols, _MATRIX_TILE_SIZE):
            for row in range(_MATRIX_TILE_SIZE):
                row_base = (tile_row + row) * cols + tile_col
                packed.extend(matrix[row_base: row_base + _MATRIX_TILE_SIZE])
    return packed


def _rotate_turboquant_block(block: Sequence[int]) -> list[float]:
    if len(block) != _MATRIX_TILE_SIZE:
        raise ValueError("TurboQuant block rotation expects exactly 8 values")

    rotated: list[float] = []
    for row_index, hadamard_row in enumerate(_HADAMARD_8):
        total = 0.0
        for coeff, value in zip(hadamard_row, block):
            total += float(coeff * int(value))
        rotated.append((total * _TURBOQUANT_SIGN_FLIPS[row_index]) / _HADAMARD_8_SCALE)
    return rotated


def _encode_turboquant_row(values: Sequence[int]) -> tuple[list[int], list[int]]:
    if len(values) != _TILED_32X32_DIM:
        raise ValueError("TurboQuant row encoding expects exactly 32 values")

    coarse: list[int] = []
    residual_signs: list[int] = []
    for block_index in range(0, _TILED_32X32_DIM, _MATRIX_TILE_SIZE):
        block = values[block_index: block_index + _MATRIX_TILE_SIZE]
        rotated = _rotate_turboquant_block(block)
        for value in rotated:
            quantized = max(-_TURBOQUANT_QMAX, min(_TURBOQUANT_QMAX, int(round(value))))
            coarse.append(quantized & 0xFF)
            residual_signs.append((1 if value - quantized >= 0.0 else -1) & 0xFF)
    return coarse, residual_signs


def _signed_matmul(lhs: Sequence[int], rhs: Sequence[int], *, lhs_rows: int, depth: int, rhs_cols: int) -> list[int]:
    lhs_values = _require_rect_matrix(lhs, rows=lhs_rows, cols=depth, element_bits=8, role="signed lhs matrix")
    rhs_values = _require_rect_matrix(rhs, rows=depth, cols=rhs_cols, element_bits=8, role="signed rhs matrix")
    out: list[int] = []
    for row in range(lhs_rows):
        for col in range(rhs_cols):
            total = 0
            for k in range(depth):
                total += _s8(lhs_values[row * depth + k]) * _s8(rhs_values[k * rhs_cols + col])
            out.append(_u32(total))
    return out


def _pack_matrix_tiles(values: Sequence[int], *, size: int, tile_size: int, element_bits: int, role: str) -> list[int]:
    matrix = _require_square_matrix(values, size=size, element_bits=element_bits, role=role)
    packed: list[int] = []
    for tile_row in range(0, size, tile_size):
        for tile_col in range(0, size, tile_size):
            for row in range(tile_size):
                row_base = (tile_row + row) * size + tile_col
                packed.extend(matrix[row_base: row_base + tile_size])
    return packed


def _unpack_matrix_tiles(values: Sequence[int], *, size: int, tile_size: int, element_bits: int, role: str) -> list[int]:
    packed = _require_square_matrix(values, size=size, element_bits=element_bits, role=role)
    matrix = [0] * (size * size)
    packed_index = 0
    for tile_row in range(0, size, tile_size):
        for tile_col in range(0, size, tile_size):
            for row in range(tile_size):
                row_base = (tile_row + row) * size + tile_col
                for col in range(tile_size):
                    matrix[row_base + col] = packed[packed_index]
                    packed_index += 1
    return matrix


def pack_matrix_matmul_32x32_u8_tiles(values: Sequence[int]) -> list[int]:
    """Pack a row-major 32x32 U8 matrix into the tile-packed layout used by the 8x8 matrix engine example."""
    return _pack_matrix_tiles(values, size=_TILED_32X32_DIM, tile_size=_MATRIX_TILE_SIZE, element_bits=8, role="U8 matrix")


def unpack_matrix_matmul_32x32_u8_tiles(values: Sequence[int]) -> list[int]:
    """Unpack a tile-packed 32x32 U8 matrix back into row-major order."""
    return _unpack_matrix_tiles(values, size=_TILED_32X32_DIM, tile_size=_MATRIX_TILE_SIZE, element_bits=8, role="tile-packed U8 matrix")


def pack_matrix_matmul_32x32_u32_tiles(values: Sequence[int]) -> list[int]:
    """Pack a row-major 32x32 U32 matrix into the tile-packed output layout used by the tiled matmul example."""
    return _pack_matrix_tiles(values, size=_TILED_32X32_DIM, tile_size=_MATRIX_TILE_SIZE, element_bits=32, role="U32 matrix")


def unpack_matrix_matmul_32x32_u32_tiles(values: Sequence[int]) -> list[int]:
    """Unpack a tile-packed 32x32 U32 matrix back into row-major order."""
    return _unpack_matrix_tiles(values, size=_TILED_32X32_DIM, tile_size=_MATRIX_TILE_SIZE, element_bits=32, role="tile-packed U32 matrix")


def encode_turboquant_matrix_32x32(values: Sequence[int]) -> tuple[list[int], list[int]]:
    """Encode a signed 32x32 row-major matrix into TurboQuant-style coarse and residual-sign matrices.

    This is a minimal, hardware-friendly variant inspired by TurboQuant's public
    description: a fixed blockwise randomized rotation, a zero-metadata scalar
    quantizer, and a 1-bit residual correction signal. The outputs are int8
    matrices stored as byte values for direct use by the matrix engine.
    """

    matrix = _require_square_signed_matrix(values, size=_TILED_32X32_DIM, role="TurboQuant input matrix")
    coarse: list[int] = []
    residual_signs: list[int] = []
    for row in range(_TILED_32X32_DIM):
        row_values = matrix[row * _TILED_32X32_DIM: (row + 1) * _TILED_32X32_DIM]
        row_coarse, row_residual_signs = _encode_turboquant_row(row_values)
        coarse.extend(row_coarse)
        residual_signs.extend(row_residual_signs)
    return coarse, residual_signs


def golden_turboquant_scores_32x32(keys: Sequence[int], queries: Sequence[int]) -> dict[str, list[int]]:
    """Return encoded matrices and the approximate 32x32 score matrix for the full-residual TurboQuant path."""

    keys_matrix = _require_square_signed_matrix(keys, size=_TILED_32X32_DIM, role="TurboQuant key matrix")
    queries_matrix = _require_square_signed_matrix(queries, size=_TILED_32X32_DIM, role="TurboQuant query matrix")

    coarse_keys, residual_keys = encode_turboquant_matrix_32x32(keys_matrix)
    coarse_queries, residual_queries = encode_turboquant_matrix_32x32(queries_matrix)
    coarse_queries_t = _transpose_square_matrix(coarse_queries, size=_TILED_32X32_DIM, role="TurboQuant coarse query matrix")
    residual_queries_t = _transpose_square_matrix(residual_queries, size=_TILED_32X32_DIM, role="TurboQuant residual query matrix")

    coarse_scores = _signed_matmul(
        coarse_keys,
        coarse_queries_t,
        lhs_rows=_TILED_32X32_DIM,
        depth=_TILED_32X32_DIM,
        rhs_cols=_TILED_32X32_DIM,
    )
    residual_scores = _signed_matmul(
        residual_keys,
        residual_queries_t,
        lhs_rows=_TILED_32X32_DIM,
        depth=_TILED_32X32_DIM,
        rhs_cols=_TILED_32X32_DIM,
    )
    approx_scores = [_u32(coarse + residual) for coarse, residual in zip(coarse_scores, residual_scores)]

    return {
        "coarse_keys": coarse_keys,
        "coarse_queries_t": coarse_queries_t,
        "residual_keys": residual_keys,
        "residual_queries_t": residual_queries_t,
        "coarse_keys_tiles": pack_matrix_matmul_32x32_u8_tiles(coarse_keys),
        "coarse_queries_tiles": pack_matrix_matmul_32x32_u8_tiles(coarse_queries_t),
        "residual_keys_tiles": pack_matrix_matmul_32x32_u8_tiles(residual_keys),
        "residual_queries_tiles": pack_matrix_matmul_32x32_u8_tiles(residual_queries_t),
        "coarse_scores": coarse_scores,
        "residual_scores": residual_scores,
        "scores": approx_scores,
        "score_tiles": pack_matrix_matmul_32x32_u32_tiles(approx_scores),
    }


def golden_turboquant_scores_32x32_compact(keys: Sequence[int], queries: Sequence[int]) -> dict[str, list[int]]:
    """Return encoded matrices and the approximate 32x32 score matrix for the compact TurboQuant path.

    The compact variant reduces the residual from a full 32×32 matmul to a single
    8-column depth-1 slice (one tile column of keys × one tile row of queries).
    This halves the IMEM footprint compared to the full-residual variant (337 vs 529
    bundles) at the cost of a shallower residual correction.  Useful as a reference
    baseline when comparing scheduling efficiency or accuracy trade-offs.
    """

    keys_matrix = _require_square_signed_matrix(keys, size=_TILED_32X32_DIM, role="TurboQuant key matrix")
    queries_matrix = _require_square_signed_matrix(queries, size=_TILED_32X32_DIM, role="TurboQuant query matrix")

    coarse_keys, residual_keys = encode_turboquant_matrix_32x32(keys_matrix)
    coarse_queries, residual_queries = encode_turboquant_matrix_32x32(queries_matrix)
    coarse_queries_t = _transpose_square_matrix(coarse_queries, size=_TILED_32X32_DIM, role="TurboQuant coarse query matrix")
    residual_queries_t = _transpose_square_matrix(residual_queries, size=_TILED_32X32_DIM, role="TurboQuant residual query matrix")

    coarse_scores = _signed_matmul(
        coarse_keys,
        coarse_queries_t,
        lhs_rows=_TILED_32X32_DIM,
        depth=_TILED_32X32_DIM,
        rhs_cols=_TILED_32X32_DIM,
    )
    # Compact residual: one 8-column key slice × one 8-row query slice (depth-1, tile index 0)
    residual_keys_slice = [
        residual_keys[row * _TILED_32X32_DIM + col]
        for row in range(_TILED_32X32_DIM)
        for col in range(_MATRIX_TILE_SIZE)
    ]
    residual_queries_t_slice = [
        residual_queries_t[row * _TILED_32X32_DIM + col]
        for row in range(_MATRIX_TILE_SIZE)
        for col in range(_TILED_32X32_DIM)
    ]
    residual_scores = _signed_matmul(
        residual_keys_slice,
        residual_queries_t_slice,
        lhs_rows=_TILED_32X32_DIM,
        depth=_MATRIX_TILE_SIZE,
        rhs_cols=_TILED_32X32_DIM,
    )
    approx_scores = [_u32(coarse + residual) for coarse, residual in zip(coarse_scores, residual_scores)]

    return {
        "coarse_keys": coarse_keys,
        "coarse_queries_t": coarse_queries_t,
        "residual_keys_slice": residual_keys_slice,
        "residual_queries_t_slice": residual_queries_t_slice,
        "coarse_keys_tiles": pack_matrix_matmul_32x32_u8_tiles(coarse_keys),
        "coarse_queries_tiles": pack_matrix_matmul_32x32_u8_tiles(coarse_queries_t),
        "residual_keys_slice_tiles": _pack_rect_matrix_tiles(
            residual_keys_slice, rows=_TILED_32X32_DIM, cols=_MATRIX_TILE_SIZE, element_bits=8, role="compact residual key slice"
        ),
        "residual_queries_t_slice_tiles": _pack_rect_matrix_tiles(
            residual_queries_t_slice, rows=_MATRIX_TILE_SIZE, cols=_TILED_32X32_DIM, element_bits=8, role="compact residual query slice"
        ),
        "coarse_scores": coarse_scores,
        "residual_scores": residual_scores,
        "scores": approx_scores,
        "score_tiles": pack_matrix_matmul_32x32_u32_tiles(approx_scores),
    }


def build_turboquant_score_32x32_compact_kernel() -> Kernel:
    """Build the compact TurboQuant score kernel.

    Uses a depth-1 residual path (one 8-column key slice and one 8-row query slice)
    instead of the full 4×4 residual tile matmul.  This reduces IMEM usage to 337
    bundles (vs 529 for the full-residual variant) at the cost of a shallower
    residual correction signal.

    DMEM layout:
        coarse_keys_tiles:       word 0    (256 words, 1024 I8 bytes)
        coarse_queries_tiles:    word 256  (256 words)
        residual_keys_slice:     word 512  ( 64 words,  256 I8 bytes — 32×8)
        residual_queries_t_slice:word 576  ( 64 words,  256 I8 bytes — 8×32)
        out_tiles:               word 640  (1024 words, 4096 U32 bytes)
    """
    kb = KernelBuilder("turboquant_score_32x32_compact")
    coarse_keys_tiles = kb.arg_dmem_tensor("coarse_keys_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=I8)
    coarse_queries_tiles = kb.arg_dmem_tensor("coarse_queries_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=I8)
    # Compact residual: 32×8 key slice (4 tiles × 1 tile) and 8×32 query slice (1 tile × 4 tiles)
    residual_keys_slice = kb.arg_dmem_tensor("residual_keys_slice", shape=(_TILES_PER_DIM, 1, 8, 8), dtype=I8)
    residual_queries_t_slice = kb.arg_dmem_tensor("residual_queries_t_slice", shape=(1, _TILES_PER_DIM, 8, 8), dtype=I8)
    out_tiles = kb.arg_dmem_tensor("out_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=U32)

    def input_tile_offset(tile_row: int, tile_col: int) -> int:
        return (tile_row * _TILES_PER_DIM + tile_col) * _INPUT_TILE_WORDS

    def output_tile_offset(tile_row: int, tile_col: int) -> int:
        return (tile_row * _TILES_PER_DIM + tile_col) * _OUTPUT_TILE_WORDS

    coarse_key_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"compact_coarse_key_{tile_row}_{tile_col}",
            coarse_keys_tiles,
            shape=(8, 8),
            dtype=I8,
            offset_words=input_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }
    coarse_query_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"compact_coarse_query_{tile_row}_{tile_col}",
            coarse_queries_tiles,
            shape=(8, 8),
            dtype=I8,
            offset_words=input_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }
    # Residual key slice: 4 tiles vertically, 1 tile wide → offsets within a 4×1 tile array
    residual_key_slice_aliases = {
        tile_row: kb.dmem_alias(
            f"compact_residual_key_{tile_row}",
            residual_keys_slice,
            shape=(8, 8),
            dtype=I8,
            offset_words=tile_row * _INPUT_TILE_WORDS,
        )
        for tile_row in range(_TILES_PER_DIM)
    }
    # Residual query slice: 1 tile tall, 4 tiles wide → offsets within a 1×4 tile array
    residual_query_slice_aliases = {
        tile_col: kb.dmem_alias(
            f"compact_residual_query_{tile_col}",
            residual_queries_t_slice,
            shape=(8, 8),
            dtype=I8,
            offset_words=tile_col * _INPUT_TILE_WORDS,
        )
        for tile_col in range(_TILES_PER_DIM)
    }
    out_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"compact_turboquant_out_{tile_row}_{tile_col}",
            out_tiles,
            shape=(8, 8),
            dtype=U32,
            offset_words=output_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }

    for tile_row in range(_TILES_PER_DIM):
        for tile_col in range(_TILES_PER_DIM):
            out_tile = out_aliases[(tile_row, tile_col)]
            for tile_k in range(_TILES_PER_DIM):
                kb.matmul(
                    coarse_key_aliases[(tile_row, tile_k)],
                    coarse_query_aliases[(tile_k, tile_col)],
                    out_tile,
                    accumulate=tile_k > 0,
                )
            # Single depth-1 residual accumulation using tile slice index 0
            kb.matmul(
                residual_key_slice_aliases[tile_row],
                residual_query_slice_aliases[tile_col],
                out_tile,
                accumulate=True,
            )

    kb.halt()
    return kb.build()


def build_matrix_matmul_kernel() -> Kernel:
    kb = KernelBuilder("matrix_matmul_8x8")
    lhs = kb.arg_dmem_tensor("lhs", shape=(8, 8), dtype=U8)
    rhs = kb.arg_dmem_tensor("rhs", shape=(8, 8), dtype=U8)
    out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

    kb.matmul(lhs, rhs, out)
    kb.halt()
    return kb.build()


def build_matrix_matmul_accumulate_kernel() -> Kernel:
    kb = KernelBuilder("matrix_matmul_accumulate_8x8")
    lhs0 = kb.arg_dmem_tensor("lhs0", shape=(8, 8), dtype=U8)
    rhs0 = kb.arg_dmem_tensor("rhs0", shape=(8, 8), dtype=U8)
    lhs1 = kb.arg_dmem_tensor("lhs1", shape=(8, 8), dtype=U8)
    rhs1 = kb.arg_dmem_tensor("rhs1", shape=(8, 8), dtype=U8)
    out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

    kb.matmul(lhs0, rhs0, out)
    kb.matmul(lhs1, rhs1, out, accumulate=True)
    kb.halt()
    return kb.build()


def _build_matrix_fp8_matmul_kernel(name: str, fmt: str) -> Kernel:
    kb = KernelBuilder(name)
    lhs = kb.arg_dmem_tensor("lhs", shape=(8, 8), dtype=U8)
    rhs = kb.arg_dmem_tensor("rhs", shape=(8, 8), dtype=U8)
    out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

    kb.matmul(lhs, rhs, out, format=fmt)
    kb.halt()
    return kb.build()


def _build_matrix_fp8_accumulate_kernel(name: str, fmt: str) -> Kernel:
    kb = KernelBuilder(name)
    lhs0 = kb.arg_dmem_tensor("lhs0", shape=(8, 8), dtype=U8)
    rhs0 = kb.arg_dmem_tensor("rhs0", shape=(8, 8), dtype=U8)
    lhs1 = kb.arg_dmem_tensor("lhs1", shape=(8, 8), dtype=U8)
    rhs1 = kb.arg_dmem_tensor("rhs1", shape=(8, 8), dtype=U8)
    out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

    kb.matmul(lhs0, rhs0, out, format=fmt)
    kb.matmul(lhs1, rhs1, out, accumulate=True, format=fmt)
    kb.halt()
    return kb.build()


def build_matrix_fp8_e4m3_matmul_kernel() -> Kernel:
    return _build_matrix_fp8_matmul_kernel("matrix_fp8_e4m3_matmul_8x8", "fp8_e4m3")


def build_matrix_fp8_e4m3_accumulate_kernel() -> Kernel:
    return _build_matrix_fp8_accumulate_kernel("matrix_fp8_e4m3_accumulate_8x8", "fp8_e4m3")


def build_matrix_fp8_e5m2_matmul_kernel() -> Kernel:
    return _build_matrix_fp8_matmul_kernel("matrix_fp8_e5m2_matmul_8x8", "fp8_e5m2")


def build_matrix_fp8_e5m2_accumulate_kernel() -> Kernel:
    return _build_matrix_fp8_accumulate_kernel("matrix_fp8_e5m2_accumulate_8x8", "fp8_e5m2")


def build_matrix_matmul_32x32_tiled_kernel() -> Kernel:
    kb = KernelBuilder("matrix_matmul_32x32_tiled")
    lhs_tiles = kb.arg_dmem_tensor("lhs_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=U8)
    rhs_tiles = kb.arg_dmem_tensor("rhs_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=U8)
    out_tiles = kb.arg_dmem_tensor("out_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=U32)

    def input_tile_offset(tile_row: int, tile_col: int) -> int:
        return (tile_row * _TILES_PER_DIM + tile_col) * _INPUT_TILE_WORDS

    def output_tile_offset(tile_row: int, tile_col: int) -> int:
        return (tile_row * _TILES_PER_DIM + tile_col) * _OUTPUT_TILE_WORDS

    def residual_key_tile_offset(tile_row: int) -> int:
        return tile_row * _INPUT_TILE_WORDS

    def residual_query_tile_offset(tile_col: int) -> int:
        return tile_col * _INPUT_TILE_WORDS

    lhs_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"lhs_{tile_row}_{tile_col}",
            lhs_tiles,
            shape=(8, 8),
            dtype=U8,
            offset_words=input_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }
    rhs_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"rhs_{tile_row}_{tile_col}",
            rhs_tiles,
            shape=(8, 8),
            dtype=U8,
            offset_words=input_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }
    out_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"out_{tile_row}_{tile_col}",
            out_tiles,
            shape=(8, 8),
            dtype=U32,
            offset_words=output_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }

    for tile_row in range(_TILES_PER_DIM):
        for tile_col in range(_TILES_PER_DIM):
            out_tile = out_aliases[(tile_row, tile_col)]
            for tile_k in range(_TILES_PER_DIM):
                lhs_tile = lhs_aliases[(tile_row, tile_k)]
                rhs_tile = rhs_aliases[(tile_k, tile_col)]
                kb.matmul(lhs_tile, rhs_tile, out_tile, accumulate=tile_k > 0)

    kb.halt()
    return kb.build()

def build_turboquant_binarize_32x32_kernel() -> Kernel:
    """Build a sign-extraction + bit-packing kernel that compresses 32x32 U32 scores to 32 packed U32 words.

    Uses the vector engine to extract sign bits (right-shift by 31, XOR with 1)
    and the scalar engine to pack 32 bits per row into a single U32 word.

    Each row of 32 projected scores is compressed to one 32-bit binary code:
    - Non-negative score → hash bit 1
    - Negative score     → hash bit 0
    - Bit position i in the packed word corresponds to column i of that row.

    DMEM layout (addresses resolved via bindings):
        scores:     1024 U32 words (32×32 projected score matrix, row-major)
        compressed:   32 U32 words (one packed binary code per row)
    """
    kb = KernelBuilder("turboquant_binarize_32x32")

    # Input: 32×32 U32 score matrix (row-major, 1024 words)
    scores = kb.arg_dmem_tensor("scores", shape=(1024,), dtype=U32)
    # Output: 32 packed U32 words (one binary code per row)
    compressed = kb.arg_dmem_tensor("compressed", shape=(32,), dtype=U32)

    # Scalar registers
    shift_amount = kb.scalar("shift_amount")
    one = kb.scalar("one")
    packed = kb.scalar("packed")
    score_row_ptr = kb.scalar("score_row_ptr")
    out_ptr = kb.scalar("out_ptr")
    group_ptr = kb.scalar("group_ptr")
    row_index = kb.scalar("row_index")

    # Vector registers
    shift31_vec = kb.vector("shift31_vec", length=8, dtype=U32, scratch_base=320)
    ones_vec = kb.vector("ones_vec", length=8, dtype=U32, scratch_base=328)
    v_in = kb.vector("v_in", length=8, dtype=U32, scratch_base=336)
    v_shifted = kb.vector("v_shifted", length=8, dtype=U32, scratch_base=344)
    v_bits_0 = kb.vector("v_bits_0", length=8, dtype=U32, scratch_base=352)
    v_bits_1 = kb.vector("v_bits_1", length=8, dtype=U32, scratch_base=360)
    v_bits_2 = kb.vector("v_bits_2", length=8, dtype=U32, scratch_base=368)
    v_bits_3 = kb.vector("v_bits_3", length=8, dtype=U32, scratch_base=376)

    # Initialize vector constants
    kb.const(shift_amount, 31)
    kb.const(one, 1)
    kb.vector_fill(shift31_vec, shift_amount, ew=32)
    kb.vector_fill(ones_vec, one, ew=32)

    # Initialize DMEM pointers
    kb.address_of(score_row_ptr, scores)
    kb.address_of(out_ptr, compressed)

    v_bits = [v_bits_0, v_bits_1, v_bits_2, v_bits_3]

    def binarize_row_body(inner_kb: KernelBuilder) -> None:
        # Phase 1 (Vector Engine): Load 4 groups of 8 scores, extract sign bits
        for g in range(4):
            if g == 0:
                inner_kb.vload(v_in, score_row_ptr)
            else:
                inner_kb.add_imm(group_ptr, score_row_ptr, g * 8)
                inner_kb.vload(v_in, group_ptr)
            # Right-shift by 31: extracts sign bit (0=non-negative, 1=negative)
            inner_kb.vector_map("shr", v_shifted, v_in, shift31_vec, ew=32)
            # XOR with 1: flip so non-negative→1, negative→0
            inner_kb.vector_map("xor", v_bits[g], v_shifted, ones_vec, ew=32)

        # Phase 2 (Scalar Engine): Pack 32 sign bits into one U32 word (MSB-first)
        inner_kb.const(packed, 0)
        for bit in range(31, -1, -1):
            inner_kb.binary("shl", packed, packed, one)
            group = bit // 8
            lane_idx = bit % 8
            lane_buf = inner_kb.lane(
                v_bits[group], lane_idx, name=f"bits_{group}_lane_{lane_idx}"
            )
            inner_kb.binary("or", packed, packed, lane_buf)

        # Store packed binary code to output
        inner_kb.store(out_ptr, packed)

        # Advance pointers: next row of 32 scores, next output word
        inner_kb.add_imm(score_row_ptr, score_row_ptr, 32)
        inner_kb.add_imm(out_ptr, out_ptr, 1)

    kb.counted_loop(
        row_index, start=0, stop=32, step=1,
        body=binarize_row_body, prefix="binarize_rows",
    )
    kb.halt()
    return kb.build()


def golden_turboquant_compress_32x32(
    keys: Sequence[int], queries: Sequence[int]
) -> dict[str, list[int] | int | float]:
    """Full TurboQuant compression pipeline: project + binarize + pack.

    Returns everything from the score golden function plus:
        compressed: 32 packed U32 words (one per row, bit i = hash_bit for column i)
        input_bits: total bits in the original I8 input matrix
        output_bits: total bits in the compressed binary codes
        compression_ratio: input_bits / output_bits
    """
    golden = golden_turboquant_scores_32x32(keys, queries)
    scores = golden["scores"]  # 1024 U32 values, row-major

    compressed: list[int] = []
    for row in range(_TILED_32X32_DIM):
        packed = 0
        for col in range(_TILED_32X32_DIM):
            score_u32 = scores[row * _TILED_32X32_DIM + col]
            # Bit 31 is the sign bit in two's complement U32 representation
            sign_bit = (score_u32 >> 31) & 1
            hash_bit = 1 - sign_bit  # non-negative → 1, negative → 0
            packed |= hash_bit << col
        compressed.append(packed)

    input_bits = _TILED_32X32_DIM * _TILED_32X32_DIM * 8  # I8 input matrix
    output_bits = _TILED_32X32_DIM * 32  # 32 packed U32 words

    return {
        **golden,
        "compressed": compressed,
        "input_bits": input_bits,
        "output_bits": output_bits,
        "compression_ratio": input_bits / output_bits,
    }

def build_turboquant_score_32x32_kernel() -> Kernel:
    kb = KernelBuilder("turboquant_score_32x32")
    coarse_keys_tiles = kb.arg_dmem_tensor("coarse_keys_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=I8)
    coarse_queries_tiles = kb.arg_dmem_tensor("coarse_queries_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=I8)
    residual_keys_tiles = kb.arg_dmem_tensor("residual_keys_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=I8)
    residual_queries_tiles = kb.arg_dmem_tensor("residual_queries_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=I8)
    out_tiles = kb.arg_dmem_tensor("out_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=U32)

    def input_tile_offset(tile_row: int, tile_col: int) -> int:
        return (tile_row * _TILES_PER_DIM + tile_col) * _INPUT_TILE_WORDS

    def output_tile_offset(tile_row: int, tile_col: int) -> int:
        return (tile_row * _TILES_PER_DIM + tile_col) * _OUTPUT_TILE_WORDS

    coarse_key_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"coarse_key_{tile_row}_{tile_col}",
            coarse_keys_tiles,
            shape=(8, 8),
            dtype=I8,
            offset_words=input_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }
    coarse_query_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"coarse_query_{tile_row}_{tile_col}",
            coarse_queries_tiles,
            shape=(8, 8),
            dtype=I8,
            offset_words=input_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }
    residual_key_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"residual_key_{tile_row}_{tile_col}",
            residual_keys_tiles,
            shape=(8, 8),
            dtype=I8,
            offset_words=input_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }
    residual_query_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"residual_query_{tile_row}_{tile_col}",
            residual_queries_tiles,
            shape=(8, 8),
            dtype=I8,
            offset_words=input_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }
    out_aliases = {
        (tile_row, tile_col): kb.dmem_alias(
            f"turboquant_out_{tile_row}_{tile_col}",
            out_tiles,
            shape=(8, 8),
            dtype=U32,
            offset_words=output_tile_offset(tile_row, tile_col),
        )
        for tile_row in range(_TILES_PER_DIM)
        for tile_col in range(_TILES_PER_DIM)
    }

    for tile_row in range(_TILES_PER_DIM):
        for tile_col in range(_TILES_PER_DIM):
            out_tile = out_aliases[(tile_row, tile_col)]
            for tile_k in range(_TILES_PER_DIM):
                kb.matmul(
                    coarse_key_aliases[(tile_row, tile_k)],
                    coarse_query_aliases[(tile_k, tile_col)],
                    out_tile,
                    accumulate=tile_k > 0,
                )
            for tile_k in range(_TILES_PER_DIM):
                kb.matmul(
                    residual_key_aliases[(tile_row, tile_k)],
                    residual_query_aliases[(tile_k, tile_col)],
                    out_tile,
                    accumulate=True,
                )

    kb.halt()
    return kb.build()
