from __future__ import annotations

from typing import Sequence

from ..builder import KernelBuilder
from ..ir import Kernel, U8, U32


_MATRIX_TILE_SIZE = 8
_TILED_32X32_DIM = 32
_TILES_PER_DIM = _TILED_32X32_DIM // _MATRIX_TILE_SIZE
_INPUT_TILE_WORDS = (_MATRIX_TILE_SIZE * _MATRIX_TILE_SIZE) // 4
_OUTPUT_TILE_WORDS = _MATRIX_TILE_SIZE * _MATRIX_TILE_SIZE


def _require_square_matrix(values: Sequence[int], *, size: int, element_bits: int, role: str) -> list[int]:
    flat = [int(value) for value in values]
    expected = size * size
    if len(flat) != expected:
        raise ValueError(f"{role} must contain exactly {expected} elements for a {size}x{size} matrix")
    mask = (1 << element_bits) - 1
    return [value & mask for value in flat]


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


def build_matrix_matmul_32x32_tiled_kernel() -> Kernel:
    kb = KernelBuilder("matrix_matmul_32x32_tiled")
    lhs_tiles = kb.arg_dmem_tensor("lhs_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=U8)
    rhs_tiles = kb.arg_dmem_tensor("rhs_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=U8)
    out_tiles = kb.arg_dmem_tensor("out_tiles", shape=(_TILES_PER_DIM, _TILES_PER_DIM, 8, 8), dtype=U32)

    def input_tile_offset(tile_row: int, tile_col: int) -> int:
        return (tile_row * _TILES_PER_DIM + tile_col) * _INPUT_TILE_WORDS

    def output_tile_offset(tile_row: int, tile_col: int) -> int:
        return (tile_row * _TILES_PER_DIM + tile_col) * _OUTPUT_TILE_WORDS

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