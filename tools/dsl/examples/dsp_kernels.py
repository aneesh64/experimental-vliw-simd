from __future__ import annotations

from ..builder import KernelBuilder
from ..ir import Kernel, U32
from ..layout import tile_1d


def build_fused_dsp_gain_monitor_kernel(
    name: str = "dsl_fused_dsp_gain_monitor",
    *,
    tiles: int = 2,
    tile_elements: int = 8,
    tile_stride_elements: int = 16,
) -> Kernel:
    """Build a fused DSP-style kernel without software pipelining.

    Each tile performs a DSP-style gain transform and, in the same pass,
    emits scalar sideband monitor values plus task bookkeeping metadata.
    This demonstrates fused compute plus monitoring tasks in one kernel.
    """

    if tiles <= 0:
        raise ValueError("build_fused_dsp_gain_monitor_kernel() requires at least one tile")
    if tile_elements <= 0:
        raise ValueError("build_fused_dsp_gain_monitor_kernel() requires positive tile_elements")
    if tile_stride_elements < tile_elements:
        raise ValueError("build_fused_dsp_gain_monitor_kernel() requires tile_stride_elements >= tile_elements")

    total = (tiles - 1) * tile_stride_elements + tile_elements

    kb = KernelBuilder(name)
    samples = kb.arg_dmem_tensor("samples", shape=(total,), dtype=U32)
    out = kb.arg_dmem_tensor("out", shape=(total,), dtype=U32)
    probe = kb.arg_dmem_tensor("probe", shape=(2 * tiles,), dtype=U32)
    meta = kb.arg_dmem_tensor("meta", shape=(1,), dtype=U32)
    gain = kb.arg_scalar("gain", default=2)
    tiles_done = kb.scalar("tiles_done")
    one = kb.scalar("one")
    meta_ptr = kb.scalar("meta_ptr")

    gain_vec = kb.vector("gain_vec", length=tile_elements, dtype=U32, scratch_base=320)
    sample_vec = kb.vector("sample_vec", length=tile_elements, dtype=U32, scratch_base=320 + tile_elements)
    scaled_vec = kb.vector("scaled_vec", length=tile_elements, dtype=U32, scratch_base=320 + 2 * tile_elements)

    kb.vector_fill(gain_vec, gain, ew=32)
    kb.const(tiles_done, 0)
    kb.const(one, 1)

    for tile in range(tiles):
        start = tile * tile_stride_elements
        kb.vload_view(sample_vec, tile_1d(samples, length=tile_elements, start=start), addr_name=f"samples_ptr_{tile}")
        kb.vector_map("mul", scaled_vec, sample_vec, gain_vec, ew=32)
        kb.add(tiles_done, tiles_done, one)
        kb.vstore_view(tile_1d(out, length=tile_elements, start=start), scaled_vec, addr_name=f"out_ptr_{tile}")
        kb.store_view(
            tile_1d(probe, length=1, start=2 * tile),
            kb.lane(scaled_vec, 0, name=f"tile_{tile}_first_lane"),
            addr_name=f"probe_first_ptr_{tile}",
        )
        kb.store_view(
            tile_1d(probe, length=1, start=2 * tile + 1),
            kb.lane(scaled_vec, tile_elements - 1, name=f"tile_{tile}_last_lane"),
            addr_name=f"probe_last_ptr_{tile}",
        )

    kb.address_of(meta_ptr, meta)
    kb.store(meta_ptr, tiles_done)
    kb.halt()
    return kb.build()


def build_pipelined_fused_dsp_gain_monitor_kernel(
    name: str = "dsl_pipelined_fused_dsp_gain_monitor",
    *,
    tiles: int = 2,
    tile_elements: int = 8,
    tile_stride_elements: int = 16,
    unroll: int = 1,
) -> Kernel:
    """Build a fused DSP kernel with overlapped load/compute/store stages.

    Parallelism demonstrated by this kernel:
        - data parallelism: lane-wise vector multiply over the input tile
    - instruction parallelism: VALU work co-issues with scalar/store work when possible
    - task parallelism: software-pipelined tiles overlap the load of the next tile
      with the compute and output/monitor stores of the current tile
    """

    if tiles <= 0:
        raise ValueError("build_pipelined_fused_dsp_gain_monitor_kernel() requires at least one tile")
    if tile_elements <= 0:
        raise ValueError("build_pipelined_fused_dsp_gain_monitor_kernel() requires positive tile_elements")
    if tile_stride_elements < tile_elements:
        raise ValueError(
            "build_pipelined_fused_dsp_gain_monitor_kernel() requires tile_stride_elements >= tile_elements"
        )
    if unroll <= 0:
        raise ValueError("build_pipelined_fused_dsp_gain_monitor_kernel() requires a positive unroll factor")

    total = (tiles - 1) * tile_stride_elements + tile_elements
    stage_width = 2 * unroll

    kb = KernelBuilder(name)
    samples = kb.arg_dmem_tensor("samples", shape=(total,), dtype=U32)
    out = kb.arg_dmem_tensor("out", shape=(total,), dtype=U32)
    probe = kb.arg_dmem_tensor("probe", shape=(2 * tiles,), dtype=U32)
    meta = kb.arg_dmem_tensor("meta", shape=(1,), dtype=U32)
    gain = kb.arg_scalar("gain", default=2)
    tiles_done = kb.scalar("tiles_done")
    one = kb.scalar("one")
    meta_ptr = kb.scalar("meta_ptr")

    gain_vec = kb.vector("gain_vec", length=tile_elements, dtype=U32, scratch_base=320)
    stage_base = 320 + tile_elements
    sample_stages = [
        kb.vector(
            f"dsp_samples_{idx}",
            length=tile_elements,
            dtype=U32,
            scratch_base=stage_base + idx * tile_elements,
        )
        for idx in range(stage_width)
    ]
    scaled_base = stage_base + stage_width * tile_elements
    scaled_stages = [
        kb.vector(
            f"dsp_scaled_{idx}",
            length=tile_elements,
            dtype=U32,
            scratch_base=scaled_base + idx * tile_elements,
        )
        for idx in range(stage_width)
    ]
    kb.vector_fill(gain_vec, gain, ew=32)
    kb.const(tiles_done, 0)
    kb.const(one, 1)

    def emit_load(tile_index: int, group: int, offset: int) -> None:
        stage = group * unroll + offset
        start = tile_index * tile_stride_elements
        kb.vload_view(
            sample_stages[stage],
            tile_1d(samples, length=tile_elements, start=start),
            addr_name=f"dsp_samples_ptr_{tile_index}_{stage}",
        )

    def emit_compute_store(tile_index: int, group: int, offset: int) -> None:
        stage = group * unroll + offset
        start = tile_index * tile_stride_elements
        kb.vector_map("mul", scaled_stages[stage], sample_stages[stage], gain_vec, ew=32)
        kb.add(tiles_done, tiles_done, one)
        kb.vstore_view(
            tile_1d(out, length=tile_elements, start=start),
            scaled_stages[stage],
            addr_name=f"dsp_out_ptr_{tile_index}_{stage}",
        )
        kb.store_view(
            tile_1d(probe, length=1, start=2 * tile_index),
            kb.lane(scaled_stages[stage], 0, name=f"dsp_probe_first_{tile_index}"),
            addr_name=f"dsp_probe_first_ptr_{tile_index}",
        )
        kb.store_view(
            tile_1d(probe, length=1, start=2 * tile_index + 1),
            kb.lane(scaled_stages[stage], tile_elements - 1, name=f"dsp_probe_last_{tile_index}"),
            addr_name=f"dsp_probe_last_ptr_{tile_index}",
        )

    current_batch = list(range(min(unroll, tiles)))
    current_group = 0
    for offset, tile_index in enumerate(current_batch):
        emit_load(tile_index, current_group, offset)

    next_tile = len(current_batch)
    while next_tile < tiles:
        next_group = 1 - current_group
        next_batch = list(range(next_tile, min(next_tile + unroll, tiles)))
        steps = max(len(current_batch), len(next_batch))
        for offset in range(steps):
            if offset < len(next_batch):
                emit_load(next_batch[offset], next_group, offset)
            if offset < len(current_batch):
                emit_compute_store(current_batch[offset], current_group, offset)
        current_batch = next_batch
        current_group = next_group
        next_tile += len(next_batch)

    for offset, tile_index in enumerate(current_batch):
        emit_compute_store(tile_index, current_group, offset)

    kb.address_of(meta_ptr, meta)
    kb.store(meta_ptr, tiles_done)
    kb.halt()
    return kb.build()


def build_fused_dsp_dual_output_kernel(
    name: str = "dsl_fused_dsp_dual_output",
    *,
    tiles: int = 2,
    tile_elements: int = 8,
    tile_stride_elements: int = 16,
) -> Kernel:
    """Build a fused DSP kernel with two vector outputs from one input stream.

    Per tile, the kernel emits:
    - `gain_out = samples * gain`
    - `bias_out = samples + bias`
    - scalar sideband probes from the gain and bias outputs
    - scalar metadata counting completed tiles
    """

    if tiles <= 0:
        raise ValueError("build_fused_dsp_dual_output_kernel() requires at least one tile")
    if tile_elements <= 0:
        raise ValueError("build_fused_dsp_dual_output_kernel() requires positive tile_elements")
    if tile_stride_elements < tile_elements:
        raise ValueError("build_fused_dsp_dual_output_kernel() requires tile_stride_elements >= tile_elements")

    total = (tiles - 1) * tile_stride_elements + tile_elements

    kb = KernelBuilder(name)
    samples = kb.arg_dmem_tensor("samples", shape=(total,), dtype=U32)
    gain_out = kb.arg_dmem_tensor("gain_out", shape=(total,), dtype=U32)
    bias_out = kb.arg_dmem_tensor("bias_out", shape=(total,), dtype=U32)
    probe = kb.arg_dmem_tensor("probe", shape=(2 * tiles,), dtype=U32)
    meta = kb.arg_dmem_tensor("meta", shape=(1,), dtype=U32)
    gain = kb.arg_scalar("gain", default=2)
    bias = kb.arg_scalar("bias", default=3)
    tiles_done = kb.scalar("tiles_done")
    one = kb.scalar("one")
    meta_ptr = kb.scalar("meta_ptr")

    gain_vec = kb.vector("dual_gain_vec", length=tile_elements, dtype=U32, scratch_base=320)
    bias_vec = kb.vector("dual_bias_vec", length=tile_elements, dtype=U32, scratch_base=320 + tile_elements)
    gain_sample_vec = kb.vector("dual_gain_sample_vec", length=tile_elements, dtype=U32, scratch_base=320 + 2 * tile_elements)
    bias_sample_vec = kb.vector("dual_bias_sample_vec", length=tile_elements, dtype=U32, scratch_base=320 + 3 * tile_elements)
    gain_out_vec = kb.vector("dual_gain_out_vec", length=tile_elements, dtype=U32, scratch_base=320 + 4 * tile_elements)
    bias_out_vec = kb.vector("dual_bias_out_vec", length=tile_elements, dtype=U32, scratch_base=320 + 5 * tile_elements)

    kb.vector_fill(gain_vec, gain, ew=32)
    kb.vector_fill(bias_vec, bias, ew=32)
    kb.const(tiles_done, 0)
    kb.const(one, 1)

    for tile in range(tiles):
        start = tile * tile_stride_elements
        kb.vload_view(gain_sample_vec, tile_1d(samples, length=tile_elements, start=start), addr_name=f"dual_gain_samples_ptr_{tile}")
        kb.vload_view(bias_sample_vec, tile_1d(samples, length=tile_elements, start=start), addr_name=f"dual_bias_samples_ptr_{tile}")
        kb.vector_map("mul", gain_out_vec, gain_sample_vec, gain_vec, ew=32)
        kb.vector_map("add", bias_out_vec, bias_sample_vec, bias_vec, ew=32)
        kb.add(tiles_done, tiles_done, one)
        kb.vstore_view(tile_1d(gain_out, length=tile_elements, start=start), gain_out_vec, addr_name=f"dual_gain_out_ptr_{tile}")
        kb.vstore_view(tile_1d(bias_out, length=tile_elements, start=start), bias_out_vec, addr_name=f"dual_bias_out_ptr_{tile}")
        kb.store_view(
            tile_1d(probe, length=1, start=2 * tile),
            kb.lane(gain_out_vec, 0, name=f"dual_probe_gain_first_{tile}"),
            addr_name=f"dual_probe_gain_ptr_{tile}",
        )
        kb.store_view(
            tile_1d(probe, length=1, start=2 * tile + 1),
            kb.lane(bias_out_vec, tile_elements - 1, name=f"dual_probe_bias_last_{tile}"),
            addr_name=f"dual_probe_bias_ptr_{tile}",
        )

    kb.address_of(meta_ptr, meta)
    kb.store(meta_ptr, tiles_done)
    kb.halt()
    return kb.build()


def build_pipelined_fused_dsp_dual_output_kernel(
    name: str = "dsl_pipelined_fused_dsp_dual_output",
    *,
    tiles: int = 2,
    tile_elements: int = 8,
    tile_stride_elements: int = 16,
    unroll: int = 1,
) -> Kernel:
    """Build a software-pipelined fused DSP kernel with two vector outputs.

    This is a conservative RTL-safe dual-output example that demonstrates:
    - data parallelism across vector lanes
    - instruction parallelism across VALU/ALU/LOAD/STORE slots
    - task parallelism by overlapping the next tile's load with the current tile's
      dual-output compute and sideband stores
    """

    if tiles <= 0:
        raise ValueError("build_pipelined_fused_dsp_dual_output_kernel() requires at least one tile")
    if tile_elements <= 0:
        raise ValueError("build_pipelined_fused_dsp_dual_output_kernel() requires positive tile_elements")
    if tile_stride_elements < tile_elements:
        raise ValueError("build_pipelined_fused_dsp_dual_output_kernel() requires tile_stride_elements >= tile_elements")
    if unroll <= 0:
        raise ValueError("build_pipelined_fused_dsp_dual_output_kernel() requires a positive unroll factor")

    total = (tiles - 1) * tile_stride_elements + tile_elements
    stage_width = 2 * unroll

    kb = KernelBuilder(name)
    samples = kb.arg_dmem_tensor("samples", shape=(total,), dtype=U32)
    gain_out = kb.arg_dmem_tensor("gain_out", shape=(total,), dtype=U32)
    bias_out = kb.arg_dmem_tensor("bias_out", shape=(total,), dtype=U32)
    probe = kb.arg_dmem_tensor("probe", shape=(2 * tiles,), dtype=U32)
    meta = kb.arg_dmem_tensor("meta", shape=(1,), dtype=U32)
    gain = kb.arg_scalar("gain", default=2)
    bias = kb.arg_scalar("bias", default=3)
    tiles_done = kb.scalar("tiles_done")
    one = kb.scalar("one")
    meta_ptr = kb.scalar("meta_ptr")

    gain_vec = kb.vector("dual_gain_vec", length=tile_elements, dtype=U32, scratch_base=320)
    bias_vec = kb.vector("dual_bias_vec", length=tile_elements, dtype=U32, scratch_base=320 + tile_elements)
    stage_base = 320 + 2 * tile_elements
    gain_sample_stages = [
        kb.vector(
            f"dual_gain_samples_{idx}",
            length=tile_elements,
            dtype=U32,
            scratch_base=stage_base + idx * tile_elements,
        )
        for idx in range(stage_width)
    ]
    bias_sample_base = stage_base + stage_width * tile_elements
    bias_sample_stages = [
        kb.vector(
            f"dual_bias_samples_{idx}",
            length=tile_elements,
            dtype=U32,
            scratch_base=bias_sample_base + idx * tile_elements,
        )
        for idx in range(stage_width)
    ]
    gain_stage_base = bias_sample_base + stage_width * tile_elements
    gain_out_stages = [
        kb.vector(
            f"dual_gain_out_{idx}",
            length=tile_elements,
            dtype=U32,
            scratch_base=gain_stage_base + idx * tile_elements,
        )
        for idx in range(stage_width)
    ]
    bias_stage_base = gain_stage_base + stage_width * tile_elements
    bias_out_stages = [
        kb.vector(
            f"dual_bias_out_{idx}",
            length=tile_elements,
            dtype=U32,
            scratch_base=bias_stage_base + idx * tile_elements,
        )
        for idx in range(stage_width)
    ]

    kb.vector_fill(gain_vec, gain, ew=32)
    kb.vector_fill(bias_vec, bias, ew=32)
    kb.const(tiles_done, 0)
    kb.const(one, 1)

    def emit_load(tile_index: int, group: int, offset: int) -> None:
        stage = group * unroll + offset
        start = tile_index * tile_stride_elements
        kb.vload_view(
            gain_sample_stages[stage],
            tile_1d(samples, length=tile_elements, start=start),
            addr_name=f"dual_gain_samples_ptr_{tile_index}_{stage}",
        )
        kb.vload_view(
            bias_sample_stages[stage],
            tile_1d(samples, length=tile_elements, start=start),
            addr_name=f"dual_bias_samples_ptr_{tile_index}_{stage}",
        )

    def emit_compute_store(tile_index: int, group: int, offset: int) -> None:
        stage = group * unroll + offset
        start = tile_index * tile_stride_elements
        kb.vector_map("mul", gain_out_stages[stage], gain_sample_stages[stage], gain_vec, ew=32)
        kb.vector_map("add", bias_out_stages[stage], bias_sample_stages[stage], bias_vec, ew=32)
        kb.add(tiles_done, tiles_done, one)
        kb.vstore_view(
            tile_1d(gain_out, length=tile_elements, start=start),
            gain_out_stages[stage],
            addr_name=f"dual_gain_out_ptr_{tile_index}_{stage}",
        )
        kb.vstore_view(
            tile_1d(bias_out, length=tile_elements, start=start),
            bias_out_stages[stage],
            addr_name=f"dual_bias_out_ptr_{tile_index}_{stage}",
        )
        kb.store_view(
            tile_1d(probe, length=1, start=2 * tile_index),
            kb.lane(gain_out_stages[stage], 0, name=f"dual_probe_gain_first_{tile_index}"),
            addr_name=f"dual_probe_gain_ptr_{tile_index}",
        )
        kb.store_view(
            tile_1d(probe, length=1, start=2 * tile_index + 1),
            kb.lane(bias_out_stages[stage], tile_elements - 1, name=f"dual_probe_bias_last_{tile_index}"),
            addr_name=f"dual_probe_bias_ptr_{tile_index}",
        )

    current_batch = list(range(min(unroll, tiles)))
    current_group = 0
    for offset, tile_index in enumerate(current_batch):
        emit_load(tile_index, current_group, offset)

    next_tile = len(current_batch)
    while next_tile < tiles:
        next_group = 1 - current_group
        next_batch = list(range(next_tile, min(next_tile + unroll, tiles)))
        steps = max(len(current_batch), len(next_batch))
        for offset in range(steps):
            if offset < len(next_batch):
                emit_load(next_batch[offset], next_group, offset)
            if offset < len(current_batch):
                emit_compute_store(current_batch[offset], current_group, offset)
        current_batch = next_batch
        current_group = next_group
        next_tile += len(next_batch)

    for offset, tile_index in enumerate(current_batch):
        emit_compute_store(tile_index, current_group, offset)

    kb.address_of(meta_ptr, meta)
    kb.store(meta_ptr, tiles_done)
    kb.halt()
    return kb.build()


def build_fused_dsp_affine_monitor_kernel(
    name: str = "dsl_fused_dsp_affine_monitor",
    **kwargs,
) -> Kernel:
    """Backward-compatible alias for `build_fused_dsp_gain_monitor_kernel()`."""

    return build_fused_dsp_gain_monitor_kernel(name=name, **kwargs)


def build_pipelined_fused_dsp_affine_monitor_kernel(
    name: str = "dsl_pipelined_fused_dsp_affine_monitor",
    **kwargs,
) -> Kernel:
    """Backward-compatible alias for `build_pipelined_fused_dsp_gain_monitor_kernel()`."""

    return build_pipelined_fused_dsp_gain_monitor_kernel(name=name, **kwargs)