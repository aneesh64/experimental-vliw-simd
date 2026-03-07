from __future__ import annotations

from ..builder import KernelBuilder
from ..ir import Kernel, U32


def build_threshold_clip_kernel(name: str = "dsl_threshold_clip", *, length: int = 6) -> Kernel:
    """Build a control-flow-heavy scalar kernel that clips values below a threshold to zero."""

    kb = KernelBuilder(name)
    input_buf = kb.arg_dmem_tensor("input", shape=(length,), dtype=U32)
    output_buf = kb.arg_dmem_tensor("output", shape=(length,), dtype=U32)
    threshold = kb.arg_scalar("threshold", default=10)

    input_base = kb.scalar("input_base")
    output_base = kb.scalar("output_base")
    index = kb.scalar("index")
    in_ptr = kb.scalar("in_ptr")
    out_ptr = kb.scalar("out_ptr")
    value = kb.scalar("value")
    zero = kb.scalar("zero")
    below_threshold = kb.scalar("below_threshold")

    kb.address_of(input_base, input_buf)
    kb.address_of(output_base, output_buf)
    kb.const(zero, 0)

    def body(inner_kb: KernelBuilder) -> None:
        inner_kb.add(in_ptr, input_base, index)
        inner_kb.load(value, in_ptr)
        inner_kb.binary("lt", below_threshold, value, threshold)
        inner_kb.add(out_ptr, output_base, index)
        inner_kb.if_else(
            below_threshold,
            prefix=f"clip_{length}",
            then_body=lambda kb_then: kb_then.store(out_ptr, zero),
            else_body=lambda kb_else: kb_else.store(out_ptr, value),
        )

    kb.counted_loop(index, start=0, stop=length, step=1, body=body, prefix=f"clip_loop_{length}")
    kb.halt()
    return kb.build()


def build_coreid_offset_store_kernel(name: str = "dsl_coreid_offset_store", *, slots: int = 1) -> Kernel:
    """Build a small core-aware kernel that stores `coreid()` at `out[coreid]`.

    In the current single-core baseline this writes `0` to `out[0]`, while still
    exercising the core-aware addressing pattern documented in the DSL verification plan.
    """

    if slots <= 0:
        raise ValueError("build_coreid_offset_store_kernel() requires a positive slot count")

    kb = KernelBuilder(name)
    out_buf = kb.arg_dmem_tensor("out", shape=(slots,), dtype=U32)
    out_ptr = kb.scalar("out_ptr")
    core = kb.scalar("core")

    kb.address_of(out_ptr, out_buf)
    kb.coreid(core)
    kb.add(out_ptr, out_ptr, core)
    kb.store(out_ptr, core)
    kb.halt()
    return kb.build()


def build_vector_threshold_mask_kernel(
    name: str = "dsl_vector_threshold_mask",
    *,
    tile_elements: int = 8,
    length: int = 16,
) -> Kernel:
    """Build a looped vector threshold-mask kernel with structured control flow.

    The kernel broadcasts a scalar threshold once, then iterates over vector tiles,
    using `vload`, `vector_map("lt")`, and `vstore` inside a counted loop.
    """

    if tile_elements <= 0:
        raise ValueError("build_vector_threshold_mask_kernel() requires positive tile_elements")
    if length <= 0 or length % tile_elements != 0:
        raise ValueError("build_vector_threshold_mask_kernel() requires length to be a positive multiple of tile_elements")

    tiles = length // tile_elements

    kb = KernelBuilder(name)
    input_buf = kb.arg_dmem_tensor("input", shape=(length,), dtype=U32)
    out_buf = kb.arg_dmem_tensor("out", shape=(length,), dtype=U32)
    threshold = kb.arg_scalar("threshold", default=10)

    input_ptr = kb.scalar("input_ptr")
    out_ptr = kb.scalar("out_ptr")
    tile_index = kb.scalar("tile_index")

    threshold_vec = kb.vector("threshold_vec", length=tile_elements, dtype=U32, scratch_base=320)
    input_vec = kb.vector("input_vec", length=tile_elements, dtype=U32, scratch_base=320 + tile_elements)
    mask_vec = kb.vector("mask_vec", length=tile_elements, dtype=U32, scratch_base=320 + 2 * tile_elements)

    kb.address_of(input_ptr, input_buf)
    kb.address_of(out_ptr, out_buf)
    kb.vector_fill(threshold_vec, threshold, ew=32)

    def body(inner_kb: KernelBuilder) -> None:
        inner_kb.vload(input_vec, input_ptr)
        inner_kb.vector_map("lt", mask_vec, input_vec, threshold_vec, ew=32)
        inner_kb.vstore(out_ptr, mask_vec)

    kb.for_each_tile_1d(
        tile_index,
        tiles=tiles,
        tile_elements=tile_elements,
        pointers=[input_ptr, out_ptr],
        body=body,
        prefix=f"vector_threshold_loop_{length}_{tile_elements}",
    )
    kb.halt()
    return kb.build()


def build_nested_vector_threshold_mask_kernel(
    name: str = "dsl_nested_vector_threshold_mask",
    *,
    rows: int = 2,
    cols: int = 16,
    tile_elements: int = 8,
) -> Kernel:
    """Build a nested-loop vector threshold kernel over a small 2D image."""

    if rows <= 0 or cols <= 0:
        raise ValueError("build_nested_vector_threshold_mask_kernel() requires positive rows and cols")
    if tile_elements <= 0 or cols % tile_elements != 0:
        raise ValueError("build_nested_vector_threshold_mask_kernel() requires cols to be a positive multiple of tile_elements")

    length = rows * cols
    row_tiles = cols // tile_elements

    kb = KernelBuilder(name)
    input_buf = kb.arg_dmem_tensor("input", shape=(length,), dtype=U32)
    out_buf = kb.arg_dmem_tensor("out", shape=(length,), dtype=U32)
    threshold = kb.arg_scalar("threshold", default=10)

    input_base = kb.scalar("input_base")
    out_base = kb.scalar("out_base")
    row_index = kb.scalar("row_index")
    row_stride = kb.scalar("row_stride")
    row_offset = kb.scalar("row_offset")
    row_input_ptr = kb.scalar("row_input_ptr")
    row_out_ptr = kb.scalar("row_out_ptr")
    tile_index = kb.scalar("tile_index")

    threshold_vec = kb.vector("nested_threshold_vec", length=tile_elements, dtype=U32, scratch_base=352)
    input_vec = kb.vector("nested_input_vec", length=tile_elements, dtype=U32, scratch_base=352 + tile_elements)
    mask_vec = kb.vector("nested_mask_vec", length=tile_elements, dtype=U32, scratch_base=352 + 2 * tile_elements)

    kb.address_of(input_base, input_buf)
    kb.address_of(out_base, out_buf)
    kb.const(row_stride, cols)
    kb.vector_fill(threshold_vec, threshold, ew=32)

    def tile_body(inner_kb: KernelBuilder) -> None:
        inner_kb.vload(input_vec, row_input_ptr)
        inner_kb.vector_map("lt", mask_vec, input_vec, threshold_vec, ew=32)
        inner_kb.vstore(row_out_ptr, mask_vec)

    def row_body(inner_kb: KernelBuilder) -> None:
        inner_kb.binary("mul", row_offset, row_index, row_stride)
        inner_kb.add(row_input_ptr, input_base, row_offset)
        inner_kb.add(row_out_ptr, out_base, row_offset)
        inner_kb.for_each_tile_1d(
            tile_index,
            tiles=row_tiles,
            tile_elements=tile_elements,
            pointers=[row_input_ptr, row_out_ptr],
            body=tile_body,
            prefix=f"nested_vector_threshold_tiles_{rows}_{cols}_{tile_elements}",
        )

    kb.counted_loop(
        row_index,
        start=0,
        stop=rows,
        step=1,
        body=row_body,
        prefix=f"nested_vector_threshold_rows_{rows}_{cols}_{tile_elements}",
    )
    kb.halt()
    return kb.build()
