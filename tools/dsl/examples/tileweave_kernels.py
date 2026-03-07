from __future__ import annotations

from ..ir import Kernel, U32
from ..tileweave import TileWeaveKernelBuilder


def build_tileweave_gain_kernel(
    name: str = "dsl_tileweave_gain",
    *,
    tiles: int = 2,
    block_size: int = 8,
    tile_stride_elements: int = 16,
    length: int | None = None,
    hardware_vector_len: int | None = None,
) -> Kernel:
    """Build a compact Triton-inspired single-output gain kernel."""

    total = length if length is not None else (tiles - 1) * tile_stride_elements + block_size
    tw = TileWeaveKernelBuilder(
        name,
        length=total,
        block_size=block_size,
        tile_stride_elements=tile_stride_elements,
        dtype=U32,
        hardware_vector_len=hardware_vector_len,
    )

    samples = tw.tensor("samples")
    gain_out = tw.tensor("gain_out")
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, block_size)
    x = tw.load(samples, pid, offsets)
    tw.store(gain_out, pid, offsets, x * tw.splat(gain))
    return tw.build()


def build_tileweave_dual_output_kernel(
    name: str = "dsl_tileweave_dual_output",
    *,
    tiles: int = 2,
    block_size: int = 8,
    tile_stride_elements: int = 16,
    length: int | None = None,
    hardware_vector_len: int | None = None,
) -> Kernel:
    """Build a Triton-inspired dual-output kernel on top of the current DSL.

    Programming style mirrors a restricted Triton-like block kernel:
    - `program_id(0)` identifies the active block
    - `arange(0, BLOCK)` selects the contiguous lanes in that block
    - `load()` fetches one block
    - `store()` writes vector results derived from expression trees
    """

    total = length if length is not None else (tiles - 1) * tile_stride_elements + block_size
    tw = TileWeaveKernelBuilder(
        name,
        length=total,
        block_size=block_size,
        tile_stride_elements=tile_stride_elements,
        dtype=U32,
        hardware_vector_len=hardware_vector_len,
    )

    samples = tw.tensor("samples")
    gain_out = tw.tensor("gain_out")
    bias_out = tw.tensor("bias_out")
    gain = tw.scalar("gain", default=2)
    bias = tw.scalar("bias", default=3)

    pid = tw.program_id(0)
    offsets = tw.arange(0, block_size)
    x = tw.load(samples, pid, offsets)
    tw.store(gain_out, pid, offsets, x * tw.splat(gain))
    tw.store(bias_out, pid, offsets, x + tw.splat(bias))
    return tw.build()


def build_tileweave_masked_gain_load_kernel(
    name: str = "dsl_tileweave_masked_gain_load",
    *,
    block_size: int = 8,
    valid_elements: int = 5,
    other: int = 0,
    hardware_vector_len: int | None = None,
) -> Kernel:
    """Build a Triton-inspired kernel that masks the load side and fills OOB lanes."""

    tw = TileWeaveKernelBuilder(
        name,
        length=block_size,
        block_size=block_size,
        tile_stride_elements=block_size,
        dtype=U32,
        hardware_vector_len=hardware_vector_len,
    )

    samples = tw.tensor("samples")
    out = tw.tensor("out")
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, block_size)
    mask = tw.mask_prefix(valid_elements)
    x = tw.load(samples, pid, offsets, mask=mask, other=other)
    tw.store(out, pid, offsets, x * tw.splat(gain))
    return tw.build()


def build_tileweave_masked_gain_store_kernel(
    name: str = "dsl_tileweave_masked_gain_store",
    *,
    block_size: int = 8,
    valid_elements: int = 5,
    hardware_vector_len: int | None = None,
) -> Kernel:
    """Build a Triton-inspired kernel that masks the store side."""

    tw = TileWeaveKernelBuilder(
        name,
        length=block_size,
        block_size=block_size,
        tile_stride_elements=block_size,
        dtype=U32,
        hardware_vector_len=hardware_vector_len,
    )

    samples = tw.tensor("samples")
    out = tw.tensor("out")
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, block_size)
    mask = tw.mask_prefix(valid_elements)
    x = tw.load(samples, pid, offsets)
    tw.store(out, pid, offsets, x * tw.splat(gain), mask=mask)
    return tw.build()


def build_tileweave_column_gain_kernel(
    name: str = "dsl_tileweave_column_gain",
    *,
    rows: int = 8,
    cols: int = 8,
    hardware_vector_len: int | None = None,
) -> Kernel:
    """Build a Triton-inspired strided column kernel over a row-major matrix.

    This is a first step toward DCT-style column passes: one logical block reads a
    full column using a strided block range and writes the scaled column back.
    """

    if rows <= 0 or cols <= 0:
        raise ValueError("build_tileweave_column_gain_kernel() requires positive rows and cols")

    total = rows * cols
    tw = TileWeaveKernelBuilder(
        name,
        length=rows,
        block_size=rows,
        tile_stride_elements=rows,
        dtype=U32,
        hardware_vector_len=hardware_vector_len,
    )

    matrix = tw.tensor("matrix", length=total)
    out = tw.tensor("out", length=total)
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, rows * cols, step=cols)
    column = tw.load(matrix, pid, offsets)
    tw.store(out, pid, offsets, column * tw.splat(gain))
    return tw.build()


def build_tileweave_matrix_gain_kernel(
    name: str = "dsl_tileweave_matrix_gain",
    *,
    rows: int = 8,
    cols: int = 8,
    hardware_vector_len: int | None = None,
) -> Kernel:
    """Build a Triton-inspired row-major matrix gain kernel over all columns.

    Each logical program processes one matrix column using affine strided offsets,
    while the launch itself advances by one element so consecutive programs walk
    across columns of the same row-major matrix.
    """

    if rows <= 0 or cols <= 0:
        raise ValueError("build_tileweave_matrix_gain_kernel() requires positive rows and cols")

    total = rows * cols
    tw = TileWeaveKernelBuilder(
        name,
        length=rows,
        block_size=rows,
        tile_stride_elements=1,
        program_count=cols,
        dtype=U32,
        hardware_vector_len=hardware_vector_len,
    )

    matrix = tw.tensor("matrix", length=total)
    out = tw.tensor("out", length=total)
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, rows * cols, step=cols)
    column = tw.load(matrix, pid, offsets)
    tw.store(out, pid, offsets, column * tw.splat(gain))
    return tw.build()
