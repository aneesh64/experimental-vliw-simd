from __future__ import annotations

from ..builder import KernelBuilder
from ..ir import Kernel, U32
from ..layout import tile_1d


def build_tiled_vector_add_kernel(
    name: str = "dsl_tiled_vector_add",
    *,
    tiles: int = 4,
    tile_elements: int = 8,
    tile_stride_elements: int = 16,
) -> Kernel:
    """Build a simple tiled vector-add kernel without software pipelining."""

    kb = KernelBuilder(name)
    total = (tiles - 1) * tile_stride_elements + tile_elements
    lhs = kb.arg_dmem_tensor("lhs", shape=(total,), dtype=U32)
    rhs = kb.arg_dmem_tensor("rhs", shape=(total,), dtype=U32)
    out = kb.arg_dmem_tensor("out", shape=(total,), dtype=U32)
    lhs_vec = kb.vector("lhs_vec", length=tile_elements, dtype=U32, scratch_base=320)
    rhs_vec = kb.vector("rhs_vec", length=tile_elements, dtype=U32, scratch_base=328)
    out_vec = kb.vector("out_vec", length=tile_elements, dtype=U32, scratch_base=336)

    for tile in range(tiles):
        start = tile * tile_stride_elements
        kb.vload_view(lhs_vec, tile_1d(lhs, length=tile_elements, start=start), addr_name=f"lhs_ptr_{tile}")
        kb.vload_view(rhs_vec, tile_1d(rhs, length=tile_elements, start=start), addr_name=f"rhs_ptr_{tile}")
        kb.vector_map("add", out_vec, lhs_vec, rhs_vec, ew=32)
        kb.vstore_view(tile_1d(out, length=tile_elements, start=start), out_vec, addr_name=f"out_ptr_{tile}")
    kb.halt()
    return kb.build()


def build_pipelined_tiled_vector_add_kernel(
    name: str = "dsl_pipelined_tiled_vector_add",
    *,
    tiles: int = 4,
    tile_elements: int = 8,
    tile_stride_elements: int = 16,
    unroll: int = 1,
) -> Kernel:
    """Build a tiled vector-add kernel using callback-based software pipelining helpers."""

    kb = KernelBuilder(name)
    total = (tiles - 1) * tile_stride_elements + tile_elements
    lhs = kb.arg_dmem_tensor("lhs", shape=(total,), dtype=U32)
    rhs = kb.arg_dmem_tensor("rhs", shape=(total,), dtype=U32)
    out = kb.arg_dmem_tensor("out", shape=(total,), dtype=U32)

    kb.software_pipeline_binary(
        lhs,
        rhs,
        out,
        tiles=tiles,
        tile_elements=tile_elements,
        tile_stride_elements=tile_stride_elements,
        unroll=unroll,
        name_prefix="tiled_add",
        compute=lambda inner_kb, lhs_stage, rhs_stage, out_stage: inner_kb.vector_map(
            "add",
            out_stage,
            lhs_stage,
            rhs_stage,
            ew=32,
        ),
    )
    kb.halt()
    return kb.build()


def build_pipelined_tiled_vector_mul_kernel(
    name: str = "dsl_pipelined_tiled_vector_mul",
    *,
    tiles: int = 2,
    tile_elements: int = 8,
    tile_stride_elements: int = 16,
    unroll: int = 1,
) -> Kernel:
    """Build a tiled vector-mul kernel using callback-based software pipelining helpers."""

    kb = KernelBuilder(name)
    total = (tiles - 1) * tile_stride_elements + tile_elements
    lhs = kb.arg_dmem_tensor("lhs", shape=(total,), dtype=U32)
    rhs = kb.arg_dmem_tensor("rhs", shape=(total,), dtype=U32)
    out = kb.arg_dmem_tensor("out", shape=(total,), dtype=U32)

    kb.software_pipeline_binary(
        lhs,
        rhs,
        out,
        tiles=tiles,
        tile_elements=tile_elements,
        tile_stride_elements=tile_stride_elements,
        unroll=unroll,
        name_prefix="tiled_mul",
        compute=lambda inner_kb, lhs_stage, rhs_stage, out_stage: inner_kb.vector_map(
            "mul",
            out_stage,
            lhs_stage,
            rhs_stage,
            ew=32,
        ),
    )
    kb.halt()
    return kb.build()
