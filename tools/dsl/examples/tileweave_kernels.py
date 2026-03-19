from __future__ import annotations

from typing import Sequence

from ..builder import KernelBuilder
from ..ir import Kernel, U8, U32
from ..layout import tile_1d
from ..tileweave import TileWeaveKernelBuilder


def _s8(value: int) -> int:
    value &= 0xFF
    return value - 256 if value & 0x80 else value


def _u32(value: int) -> int:
    return value & 0xFFFFFFFF


_MATRIX_TILE_ELEMENTS = 64
_MATRIX_INPUT_TILE_WORDS = 16
_MATRIX_OUTPUT_TILE_WORDS = 64


def golden_tileweave_matrix_residual_affine(
    lhs: Sequence[int],
    rhs: Sequence[int],
    residual: Sequence[int],
    *,
    gain: int = 2,
    bias: int = 3,
) -> tuple[list[int], list[int], list[int]]:
    lhs_values = [int(value) & 0xFF for value in lhs]
    rhs_values = [int(value) & 0xFF for value in rhs]
    residual_values = [_u32(int(value)) for value in residual]
    if len(lhs_values) != 64 or len(rhs_values) != 64:
        raise ValueError("golden_tileweave_matrix_residual_affine() requires 8x8 lhs and rhs tiles")
    if len(residual_values) != 64:
        raise ValueError("golden_tileweave_matrix_residual_affine() requires a 64-element residual tile")

    matrix_out: list[int] = []
    for row in range(8):
        for col in range(8):
            total = 0
            for k in range(8):
                total += _s8(lhs_values[row * 8 + k]) * _s8(rhs_values[k * 8 + col])
            matrix_out.append(_u32(total))

    affine_out = [_u32((_u32(mat + res) * _u32(gain)) + _u32(bias)) for mat, res in zip(matrix_out, residual_values)]
    diff_out = [_u32(aff - mat) for aff, mat in zip(affine_out, matrix_out)]
    return matrix_out, affine_out, diff_out


def golden_multi_matrix_residual_affine(
    lhs_tiles: Sequence[int],
    rhs_tiles: Sequence[int],
    residual: Sequence[int],
    *,
    runs: int = 2,
    gain: int = 2,
    bias: int = 3,
) -> tuple[list[int], list[int], list[int], list[int], int]:
    lhs_values = [int(value) & 0xFF for value in lhs_tiles]
    rhs_values = [int(value) & 0xFF for value in rhs_tiles]
    residual_values = [_u32(int(value)) for value in residual]
    required_elements = runs * _MATRIX_TILE_ELEMENTS
    if len(lhs_values) != required_elements or len(rhs_values) != required_elements:
        raise ValueError("golden_multi_matrix_residual_affine() requires runs * 64 lhs/rhs elements")
    if len(residual_values) != required_elements:
        raise ValueError("golden_multi_matrix_residual_affine() requires runs * 64 residual elements")

    matrix_out: list[int] = []
    affine_out: list[int] = []
    diff_out: list[int] = []
    probe: list[int] = []

    for run in range(runs):
        start = run * _MATRIX_TILE_ELEMENTS
        end = start + _MATRIX_TILE_ELEMENTS
        matrix_tile, affine_tile, diff_tile = golden_tileweave_matrix_residual_affine(
            lhs_values[start:end],
            rhs_values[start:end],
            residual_values[start:end],
            gain=gain,
            bias=bias,
        )
        matrix_out.extend(matrix_tile)
        affine_out.extend(affine_tile)
        diff_out.extend(diff_tile)
        probe.extend([affine_tile[0], diff_tile[-1]])

    return matrix_out, affine_out, diff_out, probe, runs * (_MATRIX_TILE_ELEMENTS // 8)


def _build_multi_matrix_residual_affine_kernel(
    *,
    name: str,
    runs: int,
    chunk_elements: int,
    unroll: int,
    pipelined: bool,
) -> Kernel:
    if runs <= 0:
        raise ValueError("matrix residual-affine examples require at least one run")
    if chunk_elements <= 0 or (_MATRIX_TILE_ELEMENTS % chunk_elements) != 0:
        raise ValueError("matrix residual-affine examples require chunk_elements to divide 64")
    if unroll <= 0:
        raise ValueError("matrix residual-affine examples require a positive unroll factor")

    total_elements = runs * _MATRIX_TILE_ELEMENTS
    chunks_per_run = _MATRIX_TILE_ELEMENTS // chunk_elements
    total_chunks = runs * chunks_per_run
    buffer_count = total_chunks if pipelined else 1

    kb = KernelBuilder(name)
    lhs_tiles = kb.arg_dmem_tensor("lhs_tiles", shape=(runs, 8, 8), dtype=U8)
    rhs_tiles = kb.arg_dmem_tensor("rhs_tiles", shape=(runs, 8, 8), dtype=U8)
    residual = kb.arg_dmem_tensor("residual", shape=(total_elements,), dtype=U32)
    matrix_out = kb.arg_dmem_tensor("matrix_out", shape=(runs, 8, 8), dtype=U32)
    affine_out = kb.arg_dmem_tensor("affine_out", shape=(runs, 8, 8), dtype=U32)
    probe = kb.arg_dmem_tensor("probe", shape=(2 * runs,), dtype=U32)
    meta = kb.arg_dmem_tensor("meta", shape=(1,), dtype=U32)
    gain = kb.arg_scalar("gain", default=2)
    bias = kb.arg_scalar("bias", default=3)

    matrix_flat = kb.dmem_alias("matrix_out_flat_all", matrix_out, shape=(total_elements,), dtype=U32)
    affine_flat = kb.dmem_alias("affine_out_flat_all", affine_out, shape=(total_elements,), dtype=U32)
    lhs_aliases = [
        kb.dmem_alias(
            f"lhs_tile_{run}",
            lhs_tiles,
            shape=(8, 8),
            offset_words=run * _MATRIX_INPUT_TILE_WORDS,
            dtype=U8,
        )
        for run in range(runs)
    ]
    rhs_aliases = [
        kb.dmem_alias(
            f"rhs_tile_{run}",
            rhs_tiles,
            shape=(8, 8),
            offset_words=run * _MATRIX_INPUT_TILE_WORDS,
            dtype=U8,
        )
        for run in range(runs)
    ]
    affine_tile_aliases = [
        kb.dmem_alias(
            f"matrix_tile_{run}",
            matrix_out,
            shape=(8, 8),
            offset_words=run * _MATRIX_OUTPUT_TILE_WORDS,
            dtype=U32,
        )
        for run in range(runs)
    ]

    for lhs_tile, rhs_tile, affine_tile in zip(lhs_aliases, rhs_aliases, affine_tile_aliases):
        kb.matmul(lhs_tile, rhs_tile, affine_tile)

    gain_vec = kb.vector(f"{name}_gain_vec", length=chunk_elements, dtype=U32, scratch_base=320)
    bias_vec = kb.vector(f"{name}_bias_vec", length=chunk_elements, dtype=U32, scratch_base=320 + chunk_elements)

    if pipelined:
        stage_base = 320 + 2 * chunk_elements
        mat_stages = [
            kb.vector(
                f"{name}_pipe_mat_{idx}",
                length=chunk_elements,
                dtype=U32,
                scratch_base=stage_base + idx * chunk_elements,
            )
            for idx in range(2)
        ]
        residual_base = stage_base + 2 * chunk_elements
        residual_stages = [
            kb.vector(
                f"{name}_pipe_residual_{idx}",
                length=chunk_elements,
                dtype=U32,
                scratch_base=residual_base + idx * chunk_elements,
            )
            for idx in range(2)
        ]
        affine_base = residual_base + 2 * chunk_elements
        affine_stages = [
            kb.vector(
                f"{name}_pipe_affine_{idx}",
                length=chunk_elements,
                dtype=U32,
                scratch_base=affine_base + idx * chunk_elements,
            )
            for idx in range(2)
        ]
        scalar_base = affine_base + 2 * chunk_elements
        chunks_done = kb.scalar(f"{name}_chunks_done", scratch_base=scalar_base)
        meta_ptr = kb.scalar(f"{name}_meta_ptr", scratch_base=scalar_base + 1)
        matrix_ptr = kb.scalar(f"{name}_matrix_ptr", scratch_base=scalar_base + 2)
        residual_ptr = kb.scalar(f"{name}_residual_ptr", scratch_base=scalar_base + 3)
        affine_ptr = kb.scalar(f"{name}_affine_ptr", scratch_base=scalar_base + 4)

        kb.vector_fill(gain_vec, gain, ew=32)
        kb.vector_fill(bias_vec, bias, ew=32)
        kb.address_of(matrix_ptr, matrix_flat)
        kb.address_of(residual_ptr, residual)
        kb.address_of(affine_ptr, affine_flat)
        kb.const(chunks_done, total_chunks)

        def emit_affine_compute_store(chunk_index: int, stage: int) -> None:
            run_index = chunk_index // chunks_per_run
            run_chunk = chunk_index % chunks_per_run
            kb.vector_map("add", affine_stages[stage], mat_stages[stage], residual_stages[stage], ew=32)
            kb.vector_map("mul", affine_stages[stage], affine_stages[stage], gain_vec, ew=32)
            kb.vector_map("add", affine_stages[stage], affine_stages[stage], bias_vec, ew=32)
            kb.vstore(affine_ptr, affine_stages[stage])
            if run_chunk == 0:
                kb.store_view(
                    tile_1d(probe, length=1, start=2 * run_index),
                    kb.lane(affine_stages[stage], 0, name=f"{name}_pipe_probe_first_{chunk_index}"),
                    addr_name=f"{name}_pipe_probe_first_ptr_{chunk_index}",
                )
            if run_chunk == (chunks_per_run - 1):
                kb.store_view(
                    tile_1d(probe, length=1, start=2 * run_index + 1),
                    kb.lane(
                        affine_stages[stage],
                        chunk_elements - 1,
                        name=f"{name}_pipe_probe_last_{chunk_index}",
                    ),
                    addr_name=f"{name}_pipe_probe_last_ptr_{chunk_index}",
                )
            kb.add_imm(affine_ptr, affine_ptr, chunk_elements)

        kb.vload(mat_stages[0], matrix_ptr)
        kb.vload(residual_stages[0], residual_ptr)
        if total_chunks > 1:
            emit_affine_compute_store(0, 0)
            kb.add_imm(matrix_ptr, matrix_ptr, chunk_elements)
            kb.add_imm(residual_ptr, residual_ptr, chunk_elements)

            for chunk_index in range(1, total_chunks):
                stage = chunk_index & 1
                kb.vload(mat_stages[stage], matrix_ptr)
                kb.vload(residual_stages[stage], residual_ptr)
                emit_affine_compute_store(chunk_index, stage)
                if chunk_index != (total_chunks - 1):
                    kb.add_imm(matrix_ptr, matrix_ptr, chunk_elements)
                    kb.add_imm(residual_ptr, residual_ptr, chunk_elements)
        else:
            emit_affine_compute_store(0, 0)

        kb.address_of(meta_ptr, meta)
        kb.store(meta_ptr, chunks_done)
        kb.halt()
        return kb.build()

    stage_base = 320 + 2 * chunk_elements
    mat_stages = [
        kb.vector(
            f"{name}_mat_{idx}",
            length=chunk_elements,
            dtype=U32,
            scratch_base=stage_base + idx * chunk_elements,
        )
        for idx in range(buffer_count)
    ]
    residual_base = stage_base + buffer_count * chunk_elements
    residual_stages = [
        kb.vector(
            f"{name}_residual_{idx}",
            length=chunk_elements,
            dtype=U32,
            scratch_base=residual_base + idx * chunk_elements,
        )
        for idx in range(buffer_count)
    ]
    sum_base = residual_base + buffer_count * chunk_elements
    sum_stages = [
        kb.vector(
            f"{name}_sum_{idx}",
            length=chunk_elements,
            dtype=U32,
            scratch_base=sum_base + idx * chunk_elements,
        )
        for idx in range(buffer_count)
    ]
    mul_base = sum_base + buffer_count * chunk_elements
    mul_stages = [
        kb.vector(
            f"{name}_mul_{idx}",
            length=chunk_elements,
            dtype=U32,
            scratch_base=mul_base + idx * chunk_elements,
        )
        for idx in range(buffer_count)
    ]
    affine_base = mul_base + buffer_count * chunk_elements
    affine_stages = [
        kb.vector(
            f"{name}_affine_{idx}",
            length=chunk_elements,
            dtype=U32,
            scratch_base=affine_base + idx * chunk_elements,
        )
        for idx in range(buffer_count)
    ]
    scalar_base = affine_base + buffer_count * chunk_elements
    chunks_done = kb.scalar(f"{name}_chunks_done", scratch_base=scalar_base)
    meta_ptr = kb.scalar(f"{name}_meta_ptr", scratch_base=scalar_base + 1)
    one = kb.scalar(f"{name}_one", scratch_base=scalar_base + 2)

    kb.vector_fill(gain_vec, gain, ew=32)
    kb.vector_fill(bias_vec, bias, ew=32)
    kb.const(chunks_done, 0)
    kb.const(one, 1)

    def emit_affine_load(chunk_index: int) -> None:
        stage = chunk_index if pipelined else 0
        start = chunk_index * chunk_elements
        kb.vload_view(
            mat_stages[stage],
            tile_1d(matrix_flat, length=chunk_elements, start=start),
            addr_name=f"{name}_mat_ptr_{chunk_index}_{stage}",
        )
        kb.vload_view(
            residual_stages[stage],
            tile_1d(residual, length=chunk_elements, start=start),
            addr_name=f"{name}_residual_ptr_{chunk_index}_{stage}",
        )

    def emit_affine_compute_store(chunk_index: int) -> None:
        stage = chunk_index if pipelined else 0
        start = chunk_index * chunk_elements
        run_index = chunk_index // chunks_per_run
        run_chunk = chunk_index % chunks_per_run
        kb.vector_map("add", sum_stages[stage], mat_stages[stage], residual_stages[stage], ew=32)
        kb.vector_map("mul", mul_stages[stage], sum_stages[stage], gain_vec, ew=32)
        kb.vector_map("add", affine_stages[stage], mul_stages[stage], bias_vec, ew=32)
        kb.add(chunks_done, chunks_done, one)
        kb.vstore_view(
            tile_1d(affine_flat, length=chunk_elements, start=start),
            affine_stages[stage],
            addr_name=f"{name}_affine_ptr_{chunk_index}_{stage}",
        )
        if run_chunk == 0:
            kb.store_view(
                tile_1d(probe, length=1, start=2 * run_index),
                kb.lane(affine_stages[stage], 0, name=f"{name}_probe_affine_first_{chunk_index}"),
                addr_name=f"{name}_probe_affine_ptr_{chunk_index}",
            )
        if run_chunk == (chunks_per_run - 1):
            kb.store_view(
                tile_1d(probe, length=1, start=2 * run_index + 1),
                kb.lane(affine_stages[stage], chunk_elements - 1, name=f"{name}_probe_affine_last_{chunk_index}"),
                addr_name=f"{name}_probe_affine_last_ptr_{chunk_index}",
            )

    def run_chunk_pipeline(emit_load_fn, emit_compute_store_fn) -> None:
        if pipelined:
            current_batch = list(range(min(unroll, total_chunks)))
            for chunk_index in current_batch:
                emit_load_fn(chunk_index)

            next_chunk = len(current_batch)
            while next_chunk < total_chunks:
                for chunk_index in current_batch:
                    emit_compute_store_fn(chunk_index)

                next_batch = list(range(next_chunk, min(next_chunk + unroll, total_chunks)))
                for chunk_index in next_batch:
                    emit_load_fn(chunk_index)
                current_batch = next_batch
                next_chunk += len(next_batch)

            for chunk_index in current_batch:
                emit_compute_store_fn(chunk_index)
        else:
            for chunk_index in range(total_chunks):
                emit_load_fn(chunk_index)
                emit_compute_store_fn(chunk_index)

    run_chunk_pipeline(emit_affine_load, emit_affine_compute_store)

    kb.address_of(meta_ptr, meta)
    kb.store(meta_ptr, chunks_done)
    kb.halt()
    return kb.build()


def build_multi_matrix_residual_affine_kernel(
    name: str = "dsl_multi_matrix_residual_affine",
    *,
    runs: int = 2,
    chunk_elements: int = 8,
) -> Kernel:
    return _build_multi_matrix_residual_affine_kernel(
        name=name,
        runs=runs,
        chunk_elements=chunk_elements,
        unroll=1,
        pipelined=False,
    )


def build_pipelined_multi_matrix_residual_affine_kernel(
    name: str = "dsl_pipelined_multi_matrix_residual_affine",
    *,
    runs: int = 2,
    chunk_elements: int = 8,
    unroll: int = 2,
) -> Kernel:
    return _build_multi_matrix_residual_affine_kernel(
        name=name,
        runs=runs,
        chunk_elements=chunk_elements,
        unroll=unroll,
        pipelined=True,
    )


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


def build_tileweave_matrix_residual_affine_kernel(
    name: str = "dsl_tileweave_matrix_residual_affine",
    *,
    block_size: int = 8,
    tile_stride_elements: int = 8,
    hardware_vector_len: int | None = None,
) -> Kernel:
    """Build a fused matrix-plus-TileWeave epilogue kernel.

    Pipeline shape:
    - matrix engine computes one 8x8 signed-int8 matmul tile into `affine_out`
    - TileWeave block programs load that tile back as a flat U32 view
    - fused epilogue computes `(matmul + residual) * gain + bias`
    - writes final affine output in-place and emits a secondary diff output

    The main epilogue stays beat-aligned for vector traffic. A scalar postlude
    then derives a compact monitor value from the fused outputs so the generated
    program still exercises matrix, VALU, scalar ALU, load/store, and flow
    engines together.
    """

    tw = TileWeaveKernelBuilder(
        name,
        length=64,
        block_size=block_size,
        tile_stride_elements=tile_stride_elements,
        dtype=U32,
        hardware_vector_len=hardware_vector_len,
    )

    lhs = tw.tensor_2d("lhs", rows=8, cols=8, dtype=U8)
    rhs = tw.tensor_2d("rhs", rows=8, cols=8, dtype=U8)
    residual = tw.tensor("residual", dtype=U32, length=64)
    affine_out_matrix = tw.tensor_2d("affine_out", rows=8, cols=8, dtype=U32)
    affine_out = tw.dmem_alias("affine_out_flat", affine_out_matrix, shape=(64,), dtype=U32)
    diff_out = tw.tensor("diff_out", dtype=U32, length=64)
    monitor = tw.tensor("monitor", dtype=U32, length=1)
    gain = tw.scalar("gain", default=2)
    bias = tw.scalar("bias", default=3)

    tw.matmul(lhs, rhs, affine_out_matrix)

    pid = tw.program_id(0)
    offsets = tw.arange(0, block_size)
    mat = tw.load(affine_out, pid, offsets)
    res = tw.load(residual, pid, offsets)
    fused = (mat + res) * tw.splat(gain) + tw.splat(bias)
    delta = fused - mat
    tw.store(diff_out, pid, offsets, delta)
    tw.store(affine_out, pid, offsets, fused)

    def postlude(kb):
        affine_ptr = kb.scalar("matrix_affine_monitor_ptr")
        diff_ptr = kb.scalar("matrix_diff_monitor_ptr")
        monitor_ptr = kb.scalar("matrix_monitor_ptr")
        first_affine = kb.scalar("matrix_first_affine")
        last_diff = kb.scalar("matrix_last_diff")
        summary = kb.scalar("matrix_summary")

        kb.address_of(affine_ptr, affine_out_matrix.buffer, offset_words=0)
        kb.address_of(diff_ptr, diff_out.buffer, offset_words=63)
        kb.address_of(monitor_ptr, monitor.buffer)
        kb.load(first_affine, affine_ptr)
        kb.load(last_diff, diff_ptr)
        kb.add(summary, first_affine, last_diff)
        kb.store(monitor_ptr, summary)

    return tw.build(postlude=postlude)
