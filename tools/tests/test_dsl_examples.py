#!/usr/bin/env python3

import sys
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from dsl import (
    HardwareCapabilities,
    build_box_blur_3x3_image_kernel,
    build_box_blur_3x3_kernel,
    build_box_blur_3x3_row_kernel,
    build_coreid_offset_store_kernel,
    build_matrix_fp8_e4m3_accumulate_kernel,
    build_matrix_fp8_e4m3_matmul_kernel,
    build_matrix_fp8_e5m2_accumulate_kernel,
    build_matrix_fp8_e5m2_matmul_kernel,
    build_matrix_matmul_32x32_tiled_kernel,
    build_matrix_matmul_accumulate_kernel,
    build_matrix_matmul_kernel,
    build_turboquant_binarize_32x32_kernel,
    build_turboquant_score_32x32_kernel,
    build_multi_matrix_residual_affine_kernel,
    build_pipelined_multi_matrix_residual_affine_kernel,
    build_tileweave_column_gain_kernel,
    build_tileweave_matrix_gain_kernel,
    build_tileweave_matrix_residual_affine_kernel,
    build_fused_dsp_dual_output_kernel,
    build_fused_dsp_gain_monitor_kernel,
    golden_multi_matrix_residual_affine,
    golden_tileweave_matrix_residual_affine,
    build_nested_vector_threshold_mask_kernel,
    build_pipelined_fused_dsp_dual_output_kernel,
    build_pipelined_fused_dsp_gain_monitor_kernel,
    build_pipelined_tiled_vector_add_kernel,
    build_pipelined_tiled_vector_mul_kernel,
    build_threshold_clip_kernel,
    build_tileweave_gain_kernel,
    build_tileweave_dual_output_kernel,
    build_tileweave_masked_gain_load_kernel,
    build_tileweave_masked_gain_store_kernel,
    encode_fp8_e4m3,
    encode_fp8_e5m2,
    golden_matrix_fp8_matmul,
    golden_turboquant_compress_32x32,
    golden_turboquant_scores_32x32,
    golden_turboquant_scores_32x32_compact,
    build_turboquant_score_32x32_compact_kernel,
    build_vector_threshold_mask_kernel,
    build_tiled_vector_add_kernel,
    compile_kernel,
)
from assembler import AssemblerConfig
from scheduler import SchedulerConfig

from matrix_matmul_32x32_demo import build_demo_summary, emit_demo_artifacts
from turboquant_demo import build_demo_summary as build_turboquant_demo_summary, emit_demo_artifacts as emit_turboquant_demo_artifacts
from turboquant_demo import build_compress_summary as build_turboquant_compress_summary, emit_compress_artifacts as emit_turboquant_compress_artifacts


def test_box_blur_3x3_example_compiles_and_resolves_bindings():
    kernel = build_box_blur_3x3_kernel()
    result = compile_kernel(
        kernel,
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"input": 320, "output": 400},
    )

    assert result.required_bindings == ("input", "output")
    assert result.resolved_bindings["input"] == 320
    assert result.resolved_bindings["output"] == 400
    assert any(getattr(op, "op", None) == "div" for op in result.operations if hasattr(op, "op"))


def test_box_blur_3x3_row_example_compiles_and_contains_loop():
    kernel = build_box_blur_3x3_row_kernel()
    result = compile_kernel(
        kernel,
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"input": 512, "output": 640},
    )

    assert result.required_bindings == ("input", "output")
    assert result.resolved_bindings["input"] == 512
    assert result.resolved_bindings["output"] == 640
    assert any(getattr(op, "name", None) == "row_loop" for op in result.operations)
    assert any(getattr(op, "op", None) == "div" for op in result.operations if hasattr(op, "op"))


def test_box_blur_3x3_image_example_compiles_and_contains_nested_loops():
    kernel = build_box_blur_3x3_image_kernel()
    result = compile_kernel(
        kernel,
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"input": 768, "output": 896},
    )

    assert result.required_bindings == ("input", "output")
    assert result.resolved_bindings["input"] == 768
    assert result.resolved_bindings["output"] == 896
    labels = {getattr(op, "name", None) for op in result.operations}
    assert "image_row_loop" in labels
    assert "image_col_loop" in labels
    assert any(getattr(op, "op", None) == "div" for op in result.operations if hasattr(op, "op"))


def test_pipelined_tiled_vector_add_example_reduces_bundle_count():
    caps = HardwareCapabilities.from_configs()
    naive = compile_kernel(
        build_tiled_vector_add_kernel(),
        caps,
        assemble=False,
        bindings={"lhs": 1024, "rhs": 1056, "out": 1088},
    )
    pipelined = compile_kernel(
        build_pipelined_tiled_vector_add_kernel(unroll=2),
        caps,
        assemble=False,
        bindings={"lhs": 1024, "rhs": 1056, "out": 1088},
    )

    assert len(pipelined.scheduled_bundles) <= len(naive.scheduled_bundles)
    assert pipelined.required_bindings == ("lhs", "rhs", "out")


def test_pipelined_tiled_vector_mul_example_compiles():
    result = compile_kernel(
        build_pipelined_tiled_vector_mul_kernel(),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"lhs": 1200, "rhs": 1264, "out": 1328},
    )

    assert result.required_bindings == ("lhs", "rhs", "out")
    assert any(getattr(op, "op", None) == "mul" for op in result.operations if hasattr(op, "op"))


def test_matrix_matmul_example_compiles_for_matrix_target():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_matrix_matmul_kernel(),
        caps,
        assemble=False,
        bindings={"lhs": 0, "rhs": 16, "out": 32},
    )

    assert result.required_bindings == ("lhs", "rhs", "out")
    matrix_ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op") and getattr(op, "engine", None) == "matrix"]
    assert matrix_ops == ["mdmvin", "mdmvin", "mzero", "mcompute", "mdmvout"]
    assert result.to_manifest().slot_usage["matrix"] == 5


def test_matrix_matmul_accumulate_example_compiles_for_matrix_target():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_matrix_matmul_accumulate_kernel(),
        caps,
        assemble=False,
        bindings={"lhs0": 0, "rhs0": 16, "lhs1": 32, "rhs1": 48, "out": 64},
    )

    assert result.required_bindings == ("lhs0", "rhs0", "lhs1", "rhs1", "out")
    matrix_ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op") and getattr(op, "engine", None) == "matrix"]
    assert matrix_ops == [
        "mdmvin",
        "mdmvin",
        "mzero",
        "mcompute",
        "mdmvout",
        "mdmvin",
        "mdmvin",
        "mcompute_acc",
        "mdmvout",
    ]
    manifest = result.to_manifest()
    assert manifest.slot_usage["matrix"] == 9
    assert len(result.scheduled_bundles) >= 9


def test_matrix_fp8_e4m3_example_compiles_for_matrix_target():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_matrix_fp8_e4m3_matmul_kernel(),
        caps,
        assemble=False,
        bindings={"lhs": 0, "rhs": 16, "out": 32},
    )

    matrix_ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op") and getattr(op, "engine", None) == "matrix"]
    assert result.required_bindings == ("lhs", "rhs", "out")
    assert matrix_ops == ["mdmvin", "mdmvin", "mzero", "mcompute_fp8_e4m3", "mdmvout"]
    assert result.to_manifest().slot_usage["matrix"] == 5


def test_matrix_fp8_e5m2_accumulate_example_compiles_for_matrix_target():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_matrix_fp8_e5m2_accumulate_kernel(),
        caps,
        assemble=False,
        bindings={"lhs0": 0, "rhs0": 16, "lhs1": 32, "rhs1": 48, "out": 64},
    )

    matrix_ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op") and getattr(op, "engine", None) == "matrix"]
    assert result.required_bindings == ("lhs0", "rhs0", "lhs1", "rhs1", "out")
    assert matrix_ops == [
        "mdmvin",
        "mdmvin",
        "mzero",
        "mcompute_fp8_e5m2",
        "mdmvout",
        "mdmvin",
        "mdmvin",
        "mcompute_fp8_e5m2_acc",
        "mdmvout",
    ]


def test_matrix_fp8_golden_helper_returns_fp32_words():
    lhs = encode_fp8_e4m3([((index % 8) - 3.0) / 4.0 for index in range(64)])
    rhs = encode_fp8_e5m2([1.0 if (index % 9) == 0 else ((index % 5) - 2.0) / 8.0 for index in range(64)])
    e4m3_out = golden_matrix_fp8_matmul(lhs, lhs, fmt="fp8_e4m3")
    e5m2_out = golden_matrix_fp8_matmul(rhs, rhs, fmt="fp8_e5m2")

    assert len(lhs) == 64
    assert len(rhs) == 64
    assert len(e4m3_out) == 64
    assert len(e5m2_out) == 64
    assert all(0 <= word <= 0xFFFFFFFF for word in e4m3_out)
    assert all(0 <= word <= 0xFFFFFFFF for word in e5m2_out)


def test_matrix_matmul_32x32_tiled_example_compiles_for_matrix_target():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_matrix_matmul_32x32_tiled_kernel(),
        caps,
        assemble=False,
        bindings={"lhs_tiles": 0, "rhs_tiles": 256, "out_tiles": 1024},
    )

    assert result.required_bindings == ("lhs_tiles", "rhs_tiles", "out_tiles")
    matrix_ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op") and getattr(op, "engine", None) == "matrix"]
    assert matrix_ops.count("mzero") == 16
    assert matrix_ops.count("mcompute") == 16
    assert matrix_ops.count("mcompute_acc") == 48
    assert matrix_ops.count("mdmvout") == 64
    assert result.to_manifest().slot_usage["matrix"] == 272


def test_matrix_matmul_32x32_demo_builds_host_prep_summary():
    summary = build_demo_summary()

    assert summary["kernel_name"] == "matrix_matmul_32x32_tiled"
    assert summary["required_bindings"] == ["lhs_tiles", "rhs_tiles", "out_tiles"]
    assert summary["resolved_bindings"] == {"lhs_tiles": 0, "rhs_tiles": 256, "out_tiles": 512}
    assert summary["bundle_count"] == 273
    assert summary["binary_bundle_count"] == 273
    assert summary["matrix_slot_usage"] == 272
    assert len(summary["lhs_tile_words"]) == 32
    assert len(summary["expected_out_row_major"]) == 16
    assert len(summary["bundle_preview"]) == 4


def test_matrix_matmul_32x32_demo_emits_driver_artifacts(tmp_path):
    artifact_summary = emit_demo_artifacts(tmp_path)

    assert artifact_summary["output_dir"] == str(tmp_path)
    assert artifact_summary["metadata"]["bundle_count"] == 273
    assert artifact_summary["metadata"]["bundle_words_per_bundle"] == 10
    assert (tmp_path / "matrix_matmul_32x32_metadata.json").is_file()
    assert (tmp_path / "matrix_matmul_32x32_imem_words.txt").is_file()
    assert (tmp_path / "matrix_matmul_32x32_lhs_tiles_u8.bin").read_bytes().__len__() == 1024
    assert (tmp_path / "matrix_matmul_32x32_rhs_tiles_u8.bin").read_bytes().__len__() == 1024
    assert (tmp_path / "matrix_matmul_32x32_expected_out_tiles_u32_le.bin").read_bytes().__len__() == 4096
    assert (tmp_path / "matrix_matmul_32x32_expected_out_row_major_u32_le.bin").read_bytes().__len__() == 4096


def test_turboquant_score_example_compiles_for_matrix_target():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_turboquant_score_32x32_kernel(),
        caps,
        assemble=False,
        bindings={
            "coarse_keys_tiles": 0,
            "coarse_queries_tiles": 256,
            "residual_keys_tiles": 512,
            "residual_queries_tiles": 768,
            "out_tiles": 1024,
        },
    )

    assert result.required_bindings == (
        "coarse_keys_tiles",
        "coarse_queries_tiles",
        "residual_keys_tiles",
        "residual_queries_tiles",
        "out_tiles",
    )
    matrix_ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op") and getattr(op, "engine", None) == "matrix"]
    assert matrix_ops.count("mzero") == 16
    assert matrix_ops.count("mcompute") == 16
    assert matrix_ops.count("mcompute_acc") == 112
    assert matrix_ops.count("mdmvout") == 128


def test_turboquant_golden_encoder_outputs_expected_shapes():
    keys = [(((row * 5) - (col * 3) + 7) % 9) - 4 for row in range(32) for col in range(32)]
    queries = [(((row * 2) + (col * 5) + 1) % 9) - 4 for row in range(32) for col in range(32)]

    golden = golden_turboquant_scores_32x32(keys, queries)

    assert len(golden["coarse_keys"]) == 1024
    assert len(golden["coarse_queries_t"]) == 1024
    assert len(golden["residual_keys"]) == 1024
    assert len(golden["residual_queries_t"]) == 1024
    assert len(golden["scores"]) == 1024


def test_turboquant_demo_builds_host_prep_summary():
    summary = build_turboquant_demo_summary()

    assert summary["kernel_name"] == "turboquant_score_32x32"
    assert summary["required_bindings"] == [
        "coarse_keys_tiles",
        "coarse_queries_tiles",
        "residual_keys_tiles",
        "residual_queries_tiles",
        "out_tiles",
    ]
    assert summary["resolved_bindings"] == {
        "coarse_keys_tiles": 0,
        "coarse_queries_tiles": 256,
        "residual_keys_tiles": 512,
        "residual_queries_tiles": 768,
        "out_tiles": 1024,
    }
    assert summary["bundle_count"] == 529
    assert summary["binary_bundle_count"] == summary["bundle_count"]
    assert summary["matrix_slot_usage"] == 528
    assert len(summary["coarse_keys_preview"]) == 32
    assert len(summary["expected_out_row_major"]) == 16
    assert len(summary["bundle_preview"]) == 4


def test_turboquant_demo_emits_driver_artifacts(tmp_path):
    artifact_summary = emit_turboquant_demo_artifacts(tmp_path)

    assert artifact_summary["output_dir"] == str(tmp_path)
    assert artifact_summary["metadata"]["bundle_count"] == 529
    assert artifact_summary["metadata"]["bundle_word_count"] == 5290
    assert artifact_summary["metadata"]["bundle_bit_width"] == 320
    assert artifact_summary["metadata"]["bundle_words_per_bundle"] == 10
    assert (tmp_path / "turboquant_32x32_metadata.json").is_file()
    assert (tmp_path / "turboquant_32x32_instruction_bundles.txt").is_file()
    assert (tmp_path / "turboquant_32x32_imem_words.txt").is_file()
    assert (tmp_path / "turboquant_32x32_coarse_keys_tiles_i8.bin").read_bytes().__len__() == 1024
    assert (tmp_path / "turboquant_32x32_coarse_queries_tiles_i8.bin").read_bytes().__len__() == 1024
    assert (tmp_path / "turboquant_32x32_residual_keys_tiles_i8.bin").read_bytes().__len__() == 1024
    assert (tmp_path / "turboquant_32x32_residual_queries_tiles_i8.bin").read_bytes().__len__() == 1024
    assert (tmp_path / "turboquant_32x32_expected_out_tiles_u32_le.bin").read_bytes().__len__() == 4096
    assert (tmp_path / "turboquant_32x32_expected_out_row_major_u32_le.bin").read_bytes().__len__() == 4096


def test_turboquant_compact_kernel_compiles_for_matrix_target():
    """Compact variant uses depth-1 residual (337 bundles vs 529 for full-residual)."""
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_turboquant_score_32x32_compact_kernel(),
        caps,
        assemble=False,
        bindings={
            "coarse_keys_tiles": 0,
            "coarse_queries_tiles": 256,
            "residual_keys_slice": 512,
            "residual_queries_t_slice": 576,
            "out_tiles": 640,
        },
    )

    assert result.required_bindings == (
        "coarse_keys_tiles",
        "coarse_queries_tiles",
        "residual_keys_slice",
        "residual_queries_t_slice",
        "out_tiles",
    )
    matrix_ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op") and getattr(op, "engine", None) == "matrix"]
    assert matrix_ops.count("mzero") == 16
    assert matrix_ops.count("mcompute") == 16
    # 16 output tiles × (3 coarse acc + 1 residual acc) = 64 accumulate ops
    assert matrix_ops.count("mcompute_acc") == 64
    assert matrix_ops.count("mdmvout") == 80
    assert len(result.scheduled_bundles) == 337


def test_turboquant_compact_golden_encoder_outputs_expected_shapes():
    keys = [(((row * 5) - (col * 3) + 7) % 9) - 4 for row in range(32) for col in range(32)]
    queries = [(((row * 2) + (col * 5) + 1) % 9) - 4 for row in range(32) for col in range(32)]

    golden = golden_turboquant_scores_32x32_compact(keys, queries)

    assert len(golden["coarse_keys"]) == 1024
    assert len(golden["coarse_queries_t"]) == 1024
    assert len(golden["residual_keys_slice"]) == 256         # 32×8
    assert len(golden["residual_queries_t_slice"]) == 256   # 8×32
    assert len(golden["residual_keys_slice_tiles"]) == 256
    assert len(golden["residual_queries_t_slice_tiles"]) == 256
    assert len(golden["scores"]) == 1024


def test_turboquant_full_residual_uses_fewer_imem_bundles_than_double_compact():
    """Demonstrate why the full-residual variant is the default: it uses fewer bundles
    than naively stacking two compact passes, while providing the full 32D residual signal."""
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    full_result = compile_kernel(
        build_turboquant_score_32x32_kernel(),
        caps,
        assemble=False,
        bindings={"coarse_keys_tiles": 0, "coarse_queries_tiles": 256, "residual_keys_tiles": 512, "residual_queries_tiles": 768, "out_tiles": 1024},
    )
    compact_result = compile_kernel(
        build_turboquant_score_32x32_compact_kernel(),
        caps,
        assemble=False,
        bindings={"coarse_keys_tiles": 0, "coarse_queries_tiles": 256, "residual_keys_slice": 512, "residual_queries_t_slice": 576, "out_tiles": 640},
    )

    assert len(full_result.scheduled_bundles) == 529
    assert len(compact_result.scheduled_bundles) == 337
    # Full 32D residual fits comfortably in 1024-bundle IMEM; compact is ~37% smaller
    assert len(full_result.scheduled_bundles) < 1024
    assert len(compact_result.scheduled_bundles) < len(full_result.scheduled_bundles)


def test_fused_dsp_gain_monitor_example_compiles_and_emits_probe_stores():
    result = compile_kernel(
        build_fused_dsp_gain_monitor_kernel(tiles=2, tile_elements=8, tile_stride_elements=16),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 1360, "out": 1424, "probe": 1488, "meta": 1496, "gain": 2},
    )

    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("samples", "out", "probe", "meta", "gain")
    assert ops.count("mul") >= 2
    assert ops.count("add") >= 2
    assert any(slot for bundle in result.scheduled_bundles for slot in bundle.get("store", []))


def test_pipelined_fused_dsp_gain_monitor_example_shows_parallel_schedule():
    caps = HardwareCapabilities.from_configs()
    naive = compile_kernel(
        build_fused_dsp_gain_monitor_kernel(tiles=2, tile_elements=8, tile_stride_elements=16),
        caps,
        assemble=False,
        bindings={"samples": 1520, "out": 1584, "probe": 1648, "meta": 1656, "gain": 2},
    )
    pipelined = compile_kernel(
        build_pipelined_fused_dsp_gain_monitor_kernel(tiles=2, tile_elements=8, tile_stride_elements=16, unroll=1),
        caps,
        assemble=False,
        bindings={"samples": 1520, "out": 1584, "probe": 1648, "meta": 1656, "gain": 2},
    )

    def active_engines(bundle: dict) -> int:
        return sum(1 for engine in ("alu", "valu", "load", "store", "flow") if bundle.get(engine))

    assert pipelined.required_bindings == ("samples", "out", "probe", "meta", "gain")
    assert len(pipelined.scheduled_bundles) <= len(naive.scheduled_bundles)
    assert any(active_engines(bundle) >= 2 for bundle in pipelined.scheduled_bundles)


def test_fused_dsp_dual_output_example_compiles_and_emits_dual_vector_stores():
    result = compile_kernel(
        build_fused_dsp_dual_output_kernel(tiles=2, tile_elements=8, tile_stride_elements=16),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 1680, "gain_out": 1744, "bias_out": 1808, "probe": 1872, "meta": 1880, "gain": 2, "bias": 3},
    )

    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    store_slots = [slot for bundle in result.scheduled_bundles for slot in bundle.get("store", [])]
    assert result.required_bindings == ("samples", "gain_out", "bias_out", "probe", "meta", "gain", "bias")
    assert ops.count("mul") >= 2
    assert ops.count("add") >= 4
    assert len([slot for slot in store_slots if slot and slot[0] == "vstore"]) >= 2


def test_pipelined_fused_dsp_dual_output_example_shows_parallel_schedule():
    caps = HardwareCapabilities.from_configs()
    naive = compile_kernel(
        build_fused_dsp_dual_output_kernel(tiles=2, tile_elements=8, tile_stride_elements=16),
        caps,
        assemble=False,
        bindings={"samples": 1904, "gain_out": 1968, "bias_out": 2032, "probe": 2096, "meta": 2104, "gain": 2, "bias": 3},
    )
    pipelined = compile_kernel(
        build_pipelined_fused_dsp_dual_output_kernel(tiles=2, tile_elements=8, tile_stride_elements=16, unroll=1),
        caps,
        assemble=False,
        bindings={"samples": 1904, "gain_out": 1968, "bias_out": 2032, "probe": 2096, "meta": 2104, "gain": 2, "bias": 3},
    )

    def active_engines(bundle: dict) -> int:
        return sum(1 for engine in ("alu", "valu", "load", "store", "flow") if bundle.get(engine))

    assert pipelined.required_bindings == ("samples", "gain_out", "bias_out", "probe", "meta", "gain", "bias")
    assert len(pipelined.scheduled_bundles) < len(naive.scheduled_bundles)
    assert any(active_engines(bundle) >= 2 for bundle in pipelined.scheduled_bundles)


def test_tileweave_dual_output_example_compiles():
    result = compile_kernel(
        build_tileweave_dual_output_kernel(tiles=2, block_size=8, tile_stride_elements=16),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 2120, "gain_out": 2184, "bias_out": 2248, "gain": 2, "bias": 3},
    )

    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("samples", "gain_out", "bias_out", "gain", "bias")
    assert ops.count("mul") >= 1
    assert ops.count("add") >= 1
    assert any(slot for bundle in result.scheduled_bundles for slot in bundle.get("store", []))


def test_tileweave_gain_example_compiles():
    result = compile_kernel(
        build_tileweave_gain_kernel(tiles=2, block_size=8, tile_stride_elements=16),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 2304, "gain_out": 2368, "gain": 2},
    )

    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("samples", "gain_out", "gain")
    assert ops.count("mul") >= 1
    assert any(slot for bundle in result.scheduled_bundles for slot in bundle.get("store", []))


def test_tileweave_gain_tail_example_compiles():
    result = compile_kernel(
        build_tileweave_gain_kernel(block_size=8, tile_stride_elements=8, length=20),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 2400, "gain_out": 2464, "gain": 2},
    )

    labels = {getattr(op, "name", None) for op in result.operations}
    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("samples", "gain_out", "gain")
    assert "dsl_tileweave_gain_tail_programs_body" in labels
    assert ops.count("mul") >= 1
    assert any(slot for bundle in result.scheduled_bundles for slot in bundle.get("store", []))


def test_tileweave_dual_output_tail_example_compiles():
    result = compile_kernel(
        build_tileweave_dual_output_kernel(block_size=8, tile_stride_elements=8, length=20),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 2528, "gain_out": 2592, "bias_out": 2656, "gain": 2, "bias": 3},
    )

    labels = {getattr(op, "name", None) for op in result.operations}
    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("samples", "gain_out", "bias_out", "gain", "bias")
    assert "dsl_tileweave_dual_output_tail_programs_body" in labels
    assert ops.count("mul") >= 1
    assert ops.count("add") >= 1


def test_tileweave_gain_large_block_auto_chunks_to_hardware_vectors():
    result = compile_kernel(
        build_tileweave_gain_kernel(block_size=64, tile_stride_elements=64, length=64),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 2720, "gain_out": 2816, "gain": 2},
    )

    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("samples", "gain_out", "gain")
    assert ops.count("vload") == 8
    assert ops.count("mul") == 8
    assert ops.count("vstore") == 8


def test_tileweave_gain_fft512_sized_block_compiles_via_auto_chunking():
    result = compile_kernel(
        build_tileweave_gain_kernel(block_size=512, tile_stride_elements=512, length=512),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 3000, "gain_out": 3600, "gain": 2},
    )

    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("samples", "gain_out", "gain")
    assert ops.count("vload") == 64
    assert ops.count("mul") == 64
    assert ops.count("vstore") == 64


def test_tileweave_masked_gain_load_example_compiles():
    result = compile_kernel(
        build_tileweave_masked_gain_load_kernel(block_size=8, valid_elements=5, other=0),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 3904, "out": 3968, "gain": 2},
    )

    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("samples", "out", "gain")
    assert ops.count("load") >= 5
    assert ops.count("mul") >= 1
    assert any(slot for bundle in result.scheduled_bundles for slot in bundle.get("store", []))


def test_tileweave_masked_gain_store_example_compiles():
    result = compile_kernel(
        build_tileweave_masked_gain_store_kernel(block_size=8, valid_elements=5),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 4032, "out": 4096, "gain": 2},
    )

    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("samples", "out", "gain")
    assert ops.count("vload") >= 1
    assert ops.count("store") >= 5
    assert ops.count("mul") >= 1


def test_tileweave_column_gain_example_compiles():
    result = compile_kernel(
        build_tileweave_column_gain_kernel(rows=8, cols=8),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"matrix": 4200, "out": 4300, "gain": 2},
    )

    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("matrix", "out", "gain")
    assert ops.count("load") >= 8
    assert ops.count("store") >= 8
    assert ops.count("mul") >= 1


def test_tileweave_matrix_gain_example_compiles():
    result = compile_kernel(
        build_tileweave_matrix_gain_kernel(rows=8, cols=8),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"matrix": 4400, "out": 4500, "gain": 2},
    )

    labels = {getattr(op, "name", None) for op in result.operations}
    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    assert result.required_bindings == ("matrix", "out", "gain")
    assert "dsl_tileweave_matrix_gain_programs_body" in labels
    assert ops.count("add_imm") >= 2
    assert ops.count("load") >= 8
    assert ops.count("store") >= 8
    assert ops.count("mul") >= 1


def test_tileweave_matrix_residual_affine_golden_helper_matches_reference_shape():
    lhs = [(index * 3 + 1) & 0xFF for index in range(64)]
    rhs = [(index * 5 + 7) & 0xFF for index in range(64)]
    residual = [index * 11 for index in range(64)]

    matrix_out, affine_out, diff_out = golden_tileweave_matrix_residual_affine(
        lhs,
        rhs,
        residual,
        gain=2,
        bias=5,
    )

    assert len(matrix_out) == 64
    assert len(affine_out) == 64
    assert len(diff_out) == 64
    assert diff_out[0] == ((affine_out[0] - matrix_out[0]) & 0xFFFFFFFF)


def test_tileweave_matrix_residual_affine_example_compiles_for_matrix_target():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_tileweave_matrix_residual_affine_kernel(block_size=8, tile_stride_elements=8),
        caps,
        assemble=False,
        bindings={"lhs": 0, "rhs": 16, "residual": 64, "affine_out": 128, "diff_out": 192, "monitor": 256, "gain": 2, "bias": 3},
    )

    labels = {getattr(op, "name", None) for op in result.operations}
    ops = [getattr(op, "op", None) for op in result.operations if hasattr(op, "op")]
    matrix_ops = [
        getattr(op, "op", None)
        for op in result.operations
        if hasattr(op, "op") and getattr(op, "engine", None) == "matrix"
    ]

    assert result.required_bindings == ("lhs", "rhs", "residual", "affine_out", "diff_out", "monitor", "gain", "bias")
    assert "dsl_tileweave_matrix_residual_affine_programs_body" in labels
    assert matrix_ops == ["mdmvin", "mdmvin", "mzero", "mcompute", "mdmvout"]
    assert ops.count("mul") >= 1
    assert ops.count("add") >= 1
    assert ops.count("sub") >= 1
    manifest = result.to_manifest()
    assert manifest.slot_usage["matrix"] == 5
    assert manifest.slot_usage["valu"] >= 3
    assert manifest.slot_usage["alu"] >= 1
    assert manifest.slot_usage["store"] >= 1


def test_multi_matrix_residual_affine_golden_helper_matches_reference_shape():
    runs = 2
    lhs_tiles = [((index * 3) + 1) & 0xFF for index in range(runs * 64)]
    rhs_tiles = [((index * 5) + 7) & 0xFF for index in range(runs * 64)]
    residual = [((index * 11) + 9) & 0xFFFFFFFF for index in range(runs * 64)]

    matrix_out, affine_out, diff_out, probe, meta = golden_multi_matrix_residual_affine(
        lhs_tiles,
        rhs_tiles,
        residual,
        runs=runs,
        gain=2,
        bias=5,
    )

    assert len(matrix_out) == runs * 64
    assert len(affine_out) == runs * 64
    assert len(diff_out) == runs * 64
    assert len(probe) == runs * 2
    assert meta == runs * 8
    assert probe[0] == affine_out[0]
    assert probe[-1] == diff_out[-1]


def test_pipelined_multi_matrix_residual_affine_example_shows_denser_schedule():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    bindings = {
        "lhs_tiles": 0,
        "rhs_tiles": 32,
        "residual": 64,
        "matrix_out": 192,
        "affine_out": 320,
        "probe": 448,
        "meta": 452,
        "gain": 2,
        "bias": 3,
    }
    naive = compile_kernel(
        build_multi_matrix_residual_affine_kernel(runs=2, chunk_elements=8),
        caps,
        assemble=False,
        bindings=bindings,
    )
    pipelined = compile_kernel(
        build_pipelined_multi_matrix_residual_affine_kernel(runs=2, chunk_elements=8, unroll=2),
        caps,
        assemble=False,
        bindings=bindings,
    )

    def active_engines(bundle: dict) -> int:
        return sum(1 for engine in ("matrix", "alu", "valu", "load", "store", "flow") if bundle.get(engine))

    assert pipelined.required_bindings == (
        "lhs_tiles",
        "rhs_tiles",
        "residual",
        "matrix_out",
        "affine_out",
        "probe",
        "meta",
        "gain",
        "bias",
    )
    assert len(pipelined.scheduled_bundles) < len(naive.scheduled_bundles)
    assert any(active_engines(bundle) >= 2 for bundle in pipelined.scheduled_bundles)
    naive_manifest = naive.to_manifest()
    manifest = pipelined.to_manifest()
    assert manifest.slot_usage["matrix"] == 10
    assert manifest.slot_usage["valu"] >= 8
    assert manifest.slot_usage["store"] >= 3
    assert manifest.slot_usage["load"] <= naive_manifest.slot_usage["load"]


def test_threshold_clip_example_contains_loop_and_branching():
    result = compile_kernel(
        build_threshold_clip_kernel(length=6),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"input": 1400, "output": 1500, "threshold": 10},
    )

    labels = {getattr(op, "name", None) for op in result.operations}
    ops = {getattr(op, "op", None) for op in result.operations if hasattr(op, "op")}
    assert any(label == "clip_loop_6_body" for label in labels)
    assert "select" in ops
    assert result.required_bindings == ("input", "output", "threshold")


def test_coreid_offset_store_example_contains_coreid_and_store():
    result = compile_kernel(
        build_coreid_offset_store_kernel(slots=1),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"out": 1550},
    )

    ops = {getattr(op, "op", None) for op in result.operations if hasattr(op, "op")}
    assert "coreid" in ops
    assert "add" in ops
    assert result.required_bindings == ("out",)


def test_vector_threshold_mask_example_contains_vector_ops_and_looping():
    result = compile_kernel(
        build_vector_threshold_mask_kernel(length=16, tile_elements=8),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"input": 1600, "out": 1664, "threshold": 10},
    )

    labels = {getattr(op, "name", None) for op in result.operations}
    ops = {getattr(op, "op", None) for op in result.operations if hasattr(op, "op")}
    assert "vector_threshold_loop_16_8_body" in labels
    assert "lt" in ops
    assert result.required_bindings == ("input", "out", "threshold")


def test_nested_vector_threshold_mask_example_contains_nested_loops():
    result = compile_kernel(
        build_nested_vector_threshold_mask_kernel(rows=2, cols=16, tile_elements=8),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"input": 1728, "out": 1792, "threshold": 16},
    )

    labels = {getattr(op, "name", None) for op in result.operations}
    ops = {getattr(op, "op", None) for op in result.operations if hasattr(op, "op")}
    assert "nested_vector_threshold_rows_2_16_8_body" in labels
    assert "nested_vector_threshold_tiles_2_16_8_body" in labels
    assert "lt" in ops
    assert "mul" in ops
    assert result.required_bindings == ("input", "out", "threshold")


def test_turboquant_binarize_kernel_compiles():
    """The binarize kernel uses vector + scalar engines (no matrix engine)."""
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=0),
        assembler_config=AssemblerConfig(n_matrix_slots=0),
    )
    result = compile_kernel(
        build_turboquant_binarize_32x32_kernel(),
        caps,
        assemble=True,
        bindings={
            "scores": 1024,
            "compressed": 2048,
        },
    )

    assert result.required_bindings == ("scores", "compressed")
    assert result.resolved_bindings == {"scores": 1024, "compressed": 2048}
    # Must have vector ops (shr, xor) and scalar ops (shl, or) in the lowered operations
    ops = {getattr(op, "op", None) for op in result.operations if hasattr(op, "op")}
    assert "shr" in ops, "Expected vector shr for sign-bit extraction"
    assert "xor" in ops, "Expected vector xor for bit-flip"
    assert "shl" in ops, "Expected scalar shl for bit packing"
    assert "or" in ops, "Expected scalar or for bit packing"
    # Loop labels must be present
    labels = {getattr(op, "name", None) for op in result.operations}
    assert "binarize_rows_body" in labels
    # IMEM should fit well within the 1024-bundle limit
    assert len(result.scheduled_bundles) < 1024
    # Binary bundles must be generated
    assert result.binary_bundles is not None
    assert len(result.binary_bundles) == len(result.scheduled_bundles)


def test_turboquant_golden_compress_outputs_expected_shapes():
    keys = [(((row * 5) - (col * 3) + 7) % 9) - 4 for row in range(32) for col in range(32)]
    queries = [(((row * 2) + (col * 5) + 1) % 9) - 4 for row in range(32) for col in range(32)]

    golden = golden_turboquant_compress_32x32(keys, queries)

    # Score matrix is 32x32
    assert len(golden["scores"]) == 1024
    # Compressed output is 32 packed U32 words
    assert len(golden["compressed"]) == 32
    # Compression metrics
    assert golden["input_bits"] == 8192   # 32x32 x 8-bit
    assert golden["output_bits"] == 1024  # 32 x 32-bit
    assert golden["compression_ratio"] == 8.0

    # Each compressed word should have exactly 32 bits of data (may have any pattern)
    for word in golden["compressed"]:
        assert 0 <= word <= 0xFFFFFFFF

    # Verify the compression is consistent with the score signs
    scores = golden["scores"]
    for row in range(32):
        packed = golden["compressed"][row]
        for col in range(32):
            score = scores[row * 32 + col]
            sign_bit = (score >> 31) & 1
            expected_hash = 1 - sign_bit
            actual_hash = (packed >> col) & 1
            assert actual_hash == expected_hash, (
                f"Row {row}, col {col}: score=0x{score:08X}, "
                f"expected hash={expected_hash}, got {actual_hash}"
            )


def test_turboquant_compress_summary_builds():
    summary = build_turboquant_compress_summary()

    assert summary["pipeline"] == "turboquant_compress_32x32"
    assert summary["kernel_1_name"] == "turboquant_score_32x32"
    assert summary["kernel_2_name"] == "turboquant_binarize_32x32"
    assert summary["kernel_1_bundles"] == 529
    assert summary["kernel_2_bundles"] > 0
    assert summary["input_bits"] == 8192
    assert summary["output_bits"] == 1024
    assert summary["compression_ratio"] == 8.0
    assert len(summary["compressed_preview"]) == 8


def test_turboquant_compress_emits_artifacts(tmp_path):
    artifact_summary = emit_turboquant_compress_artifacts(tmp_path)

    meta = artifact_summary["metadata"]
    assert meta["pipeline"] == "turboquant_compress_32x32"
    assert meta["kernel_1"]["bundle_count"] == 529
    assert meta["kernel_2"]["bundle_count"] > 0
    assert meta["compression"]["ratio"] == 8.0

    # Kernel IMEM files
    assert (tmp_path / "turboquant_compress_k1_imem_words.txt").is_file()
    assert (tmp_path / "turboquant_compress_k2_imem_words.txt").is_file()
    assert (tmp_path / "turboquant_compress_k1_bundles.txt").is_file()
    assert (tmp_path / "turboquant_compress_k2_bundles.txt").is_file()

    # Input data files
    assert (tmp_path / "turboquant_compress_coarse_keys_i8.bin").read_bytes().__len__() == 1024
    assert (tmp_path / "turboquant_compress_coarse_queries_i8.bin").read_bytes().__len__() == 1024
    assert (tmp_path / "turboquant_compress_residual_keys_i8.bin").read_bytes().__len__() == 1024
    assert (tmp_path / "turboquant_compress_residual_queries_i8.bin").read_bytes().__len__() == 1024

    # Expected output files
    assert (tmp_path / "turboquant_compress_expected_scores_u32_le.bin").read_bytes().__len__() == 4096
    assert (tmp_path / "turboquant_compress_expected_compressed_u32_le.bin").read_bytes().__len__() == 128

    # Metadata
    assert (tmp_path / "turboquant_compress_metadata.json").is_file()
