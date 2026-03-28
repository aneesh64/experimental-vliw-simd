#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


TOOLS_DIR = Path(__file__).resolve().parent
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from assembler import Assembler, AssemblerConfig
from dsl import (
    HardwareCapabilities,
    build_turboquant_binarize_32x32_kernel,
    build_turboquant_score_32x32_kernel,
    compile_kernel,
    golden_turboquant_compress_32x32,
    golden_turboquant_scores_32x32,
    pack_matrix_matmul_32x32_u32_tiles,
    pack_matrix_matmul_32x32_u8_tiles,
    unpack_matrix_matmul_32x32_u32_tiles,
)
from scheduler import SchedulerConfig


def build_demo_inputs(size: int = 32) -> tuple[list[int], list[int]]:
    keys = [(((row * 5) - (col * 3) + 7) % 9) - 4 for row in range(size) for col in range(size)]
    queries = [(((row * 2) + (col * 5) + 1) % 9) - 4 for row in range(size) for col in range(size)]
    return keys, queries


def _u32_words_to_le_bytes(words: list[int]) -> bytes:
    payload = bytearray()
    for word in words:
        payload.extend(int(word & 0xFFFFFFFF).to_bytes(4, byteorder="little", signed=False))
    return bytes(payload)


def _write_u32_hex_lines(path: Path, words: list[int]) -> None:
    path.write_text("\n".join(f"0x{word & 0xFFFFFFFF:08X}" for word in words) + "\n", encoding="ascii")


def _write_bundle_hex_lines(path: Path, bundles: list[int], bundle_bits: int) -> None:
    hex_digits = bundle_bits // 4
    path.write_text("\n".join(f"0x{int(bundle) & ((1 << bundle_bits) - 1):0{hex_digits}X}" for bundle in bundles) + "\n", encoding="ascii")


def compile_demo_kernel():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_turboquant_score_32x32_kernel(),
        caps,
        assemble=True,
        bindings={
            "coarse_keys_tiles": 0,
            "coarse_queries_tiles": 256,
            "residual_keys_tiles": 512,
            "residual_queries_tiles": 768,
            "out_tiles": 1024,
        },
    )
    return caps, result


def compile_binarize_kernel():
    """Compile the binarize kernel that reads scores from Kernel 1 output and packs sign bits."""
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
    return caps, result


def build_demo_summary() -> dict:
    keys_row_major, queries_row_major = build_demo_inputs()
    golden = golden_turboquant_scores_32x32(keys_row_major, queries_row_major)
    coarse_keys_tiles = golden["coarse_keys_tiles"]
    coarse_queries_tiles = golden["coarse_queries_tiles"]
    residual_keys_tiles = golden["residual_keys_tiles"]
    residual_queries_tiles = golden["residual_queries_tiles"]
    expected_tiles = golden["score_tiles"]

    caps, result = compile_demo_kernel()
    manifest = result.to_manifest()

    unpacked_expected = unpack_matrix_matmul_32x32_u32_tiles(expected_tiles)
    if unpacked_expected != golden["scores"]:
        raise AssertionError("TurboQuant packed output tiles did not round-trip back to the expected score matrix")

    return {
        "kernel_name": result.kernel.name,
        "required_bindings": list(result.required_bindings),
        "resolved_bindings": dict(result.resolved_bindings),
        "bundle_count": len(result.scheduled_bundles),
        "binary_bundle_count": len(result.binary_bundles or []),
        "matrix_slot_usage": manifest.slot_usage["matrix"],
        "coarse_keys_preview": coarse_keys_tiles[:32],
        "coarse_queries_preview": coarse_queries_tiles[:32],
        "residual_keys_preview": residual_keys_tiles[:32],
        "residual_queries_preview": residual_queries_tiles[:32],
        "expected_out_preview": expected_tiles[:32],
        "expected_out_row_major": golden["scores"][:16],
        "bundle_preview": [int(bundle) for bundle in (result.binary_bundles or [])[:4]],
    }


def emit_demo_artifacts(output_dir: Path) -> dict:
    keys_row_major, queries_row_major = build_demo_inputs()
    golden = golden_turboquant_scores_32x32(keys_row_major, queries_row_major)
    coarse_keys_tiles = golden["coarse_keys_tiles"]
    coarse_queries_tiles = golden["coarse_queries_tiles"]
    residual_keys_tiles = golden["residual_keys_tiles"]
    residual_queries_tiles = golden["residual_queries_tiles"]
    expected_out_tiles = golden["score_tiles"]

    caps, result = compile_demo_kernel()
    asm = Assembler(caps.to_assembler_config())
    binary_bundles = result.binary_bundles or []
    imem_words: list[int] = []
    for bundle in binary_bundles:
        imem_words.extend(asm.to_word_list(int(bundle), 32))

    output_dir.mkdir(parents=True, exist_ok=True)
    metadata = {
        "kernel_name": result.kernel.name,
        "bindings": dict(result.resolved_bindings),
        "bundle_count": len(result.scheduled_bundles),
        "bundle_word_count": len(imem_words),
        "bundle_words_per_bundle": asm.cfg.bundle_width // 32,
        "bundle_bit_width": asm.cfg.bundle_width,
        "coarse_keys_u8_count": len(coarse_keys_tiles),
        "coarse_queries_u8_count": len(coarse_queries_tiles),
        "residual_keys_u8_count": len(residual_keys_tiles),
        "residual_queries_u8_count": len(residual_queries_tiles),
        "expected_out_tiles_u32_count": len(expected_out_tiles),
        "expected_out_row_major_u32_count": len(golden["scores"]),
        "encoding": "fixed 8x8 Walsh-Hadamard rotation + 4-bit coarse quantizer + 1-bit residual sign",
    }

    (output_dir / "turboquant_32x32_metadata.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="ascii")
    _write_bundle_hex_lines(output_dir / "turboquant_32x32_instruction_bundles.txt", binary_bundles, asm.cfg.bundle_width)
    _write_u32_hex_lines(output_dir / "turboquant_32x32_imem_words.txt", imem_words)
    (output_dir / "turboquant_32x32_coarse_keys_tiles_i8.bin").write_bytes(bytes(coarse_keys_tiles))
    (output_dir / "turboquant_32x32_coarse_queries_tiles_i8.bin").write_bytes(bytes(coarse_queries_tiles))
    (output_dir / "turboquant_32x32_residual_keys_tiles_i8.bin").write_bytes(bytes(residual_keys_tiles))
    (output_dir / "turboquant_32x32_residual_queries_tiles_i8.bin").write_bytes(bytes(residual_queries_tiles))
    (output_dir / "turboquant_32x32_expected_out_tiles_u32_le.bin").write_bytes(_u32_words_to_le_bytes(expected_out_tiles))
    (output_dir / "turboquant_32x32_expected_out_row_major_u32_le.bin").write_bytes(_u32_words_to_le_bytes(golden["scores"]))

    return {
        "output_dir": str(output_dir),
        "metadata": metadata,
        "imem_preview": imem_words[:16],
    }


def build_compress_summary() -> dict:
    """Build the end-to-end compression summary: project → binarize → pack."""
    keys_row_major, queries_row_major = build_demo_inputs()
    golden = golden_turboquant_compress_32x32(keys_row_major, queries_row_major)

    _, project_result = compile_demo_kernel()
    binarize_caps, binarize_result = compile_binarize_kernel()

    return {
        "pipeline": "turboquant_compress_32x32",
        "kernel_1_name": project_result.kernel.name,
        "kernel_1_bundles": len(project_result.scheduled_bundles),
        "kernel_1_bindings": dict(project_result.resolved_bindings),
        "kernel_2_name": binarize_result.kernel.name,
        "kernel_2_bundles": len(binarize_result.scheduled_bundles),
        "kernel_2_bindings": dict(binarize_result.resolved_bindings),
        "input_bits": golden["input_bits"],
        "output_bits": golden["output_bits"],
        "compression_ratio": golden["compression_ratio"],
        "compressed_preview": [f"0x{w:08X}" for w in golden["compressed"][:8]],
        "scores_preview": golden["scores"][:8],
    }


def emit_compress_artifacts(output_dir: Path) -> dict:
    """Emit all artifacts needed by the C driver for end-to-end compression."""
    keys_row_major, queries_row_major = build_demo_inputs()
    golden = golden_turboquant_compress_32x32(keys_row_major, queries_row_major)

    # Compile both kernels
    project_caps, project_result = compile_demo_kernel()
    binarize_caps, binarize_result = compile_binarize_kernel()

    project_asm = Assembler(project_caps.to_assembler_config())
    binarize_asm = Assembler(binarize_caps.to_assembler_config())

    project_bundles = project_result.binary_bundles or []
    binarize_bundles = binarize_result.binary_bundles or []

    project_imem: list[int] = []
    for bundle in project_bundles:
        project_imem.extend(project_asm.to_word_list(int(bundle), 32))

    binarize_imem: list[int] = []
    for bundle in binarize_bundles:
        binarize_imem.extend(binarize_asm.to_word_list(int(bundle), 32))

    output_dir.mkdir(parents=True, exist_ok=True)

    # Kernel 1 artifacts (projection)
    _write_u32_hex_lines(output_dir / "turboquant_compress_k1_imem_words.txt", project_imem)
    _write_bundle_hex_lines(
        output_dir / "turboquant_compress_k1_bundles.txt",
        project_bundles, project_asm.cfg.bundle_width,
    )

    # Kernel 2 artifacts (binarize)
    _write_u32_hex_lines(output_dir / "turboquant_compress_k2_imem_words.txt", binarize_imem)
    _write_bundle_hex_lines(
        output_dir / "turboquant_compress_k2_bundles.txt",
        binarize_bundles, binarize_asm.cfg.bundle_width,
    )

    # Input data
    (output_dir / "turboquant_compress_coarse_keys_i8.bin").write_bytes(bytes(golden["coarse_keys_tiles"]))
    (output_dir / "turboquant_compress_coarse_queries_i8.bin").write_bytes(bytes(golden["coarse_queries_tiles"]))
    (output_dir / "turboquant_compress_residual_keys_i8.bin").write_bytes(bytes(golden["residual_keys_tiles"]))
    (output_dir / "turboquant_compress_residual_queries_i8.bin").write_bytes(bytes(golden["residual_queries_tiles"]))

    # Expected outputs
    (output_dir / "turboquant_compress_expected_scores_u32_le.bin").write_bytes(
        _u32_words_to_le_bytes(golden["scores"])
    )
    (output_dir / "turboquant_compress_expected_compressed_u32_le.bin").write_bytes(
        _u32_words_to_le_bytes(golden["compressed"])
    )

    metadata = {
        "pipeline": "turboquant_compress_32x32",
        "kernel_1": {
            "name": project_result.kernel.name,
            "bindings": dict(project_result.resolved_bindings),
            "bundle_count": len(project_result.scheduled_bundles),
            "imem_word_count": len(project_imem),
            "bundle_bit_width": project_asm.cfg.bundle_width,
        },
        "kernel_2": {
            "name": binarize_result.kernel.name,
            "bindings": dict(binarize_result.resolved_bindings),
            "bundle_count": len(binarize_result.scheduled_bundles),
            "imem_word_count": len(binarize_imem),
            "bundle_bit_width": binarize_asm.cfg.bundle_width,
        },
        "compression": {
            "input_bits": golden["input_bits"],
            "output_bits": golden["output_bits"],
            "ratio": golden["compression_ratio"],
            "input_description": "32x32 I8 matrix (8192 bits)",
            "output_description": "32 packed U32 binary codes (1024 bits)",
        },
    }
    (output_dir / "turboquant_compress_metadata.json").write_text(
        json.dumps(metadata, indent=2) + "\n", encoding="ascii"
    )

    return {
        "output_dir": str(output_dir),
        "metadata": metadata,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Compile and prepare a minimal TurboQuant-style 32x32 score kernel demo.")
    parser.add_argument("--json", action="store_true", help="Print the demo summary as JSON.")
    parser.add_argument("--emit-dir", type=Path, help="Write driver-facing IMEM and DMEM artifact files to this directory.")
    parser.add_argument("--compress", action="store_true", help="Show the full compression pipeline (project + binarize + pack).")
    args = parser.parse_args()

    if args.compress:
        compress_summary = build_compress_summary()
        artifact_summary = None
        if args.emit_dir is not None:
            artifact_summary = emit_compress_artifacts(args.emit_dir)

        if args.json:
            payload = {"compress_summary": compress_summary}
            if artifact_summary is not None:
                payload["artifacts"] = artifact_summary
            print(json.dumps(payload, indent=2))
            return 0

        print("=== TurboQuant Compression Pipeline ===\n")
        print(f"Kernel 1 (Matrix Engine): {compress_summary['kernel_1_name']}")
        print(f"  Bundles: {compress_summary['kernel_1_bundles']}")
        print(f"  Bindings: {compress_summary['kernel_1_bindings']}")
        print(f"\nKernel 2 (Vector + Scalar): {compress_summary['kernel_2_name']}")
        print(f"  Bundles: {compress_summary['kernel_2_bundles']}")
        print(f"  Bindings: {compress_summary['kernel_2_bindings']}")
        print(f"\n--- Compression Summary ---")
        print(f"  Input:  32x32 I8 matrix         = {compress_summary['input_bits']:>5} bits")
        print(f"  Output: 32 packed U32 codes      = {compress_summary['output_bits']:>5} bits")
        print(f"  Compression ratio:                 {compress_summary['compression_ratio']:.1f}x")
        print(f"\n  Compressed codes (first 8 rows): {compress_summary['compressed_preview']}")
        print(f"  Score preview (first 8):           {compress_summary['scores_preview']}")
        if artifact_summary is not None:
            print(f"\n  Artifacts written to: {artifact_summary['output_dir']}")
        return 0

    summary = build_demo_summary()
    artifact_summary = None
    if args.emit_dir is not None:
        artifact_summary = emit_demo_artifacts(args.emit_dir)

    if args.json:
        payload = {"summary": summary}
        if artifact_summary is not None:
            payload["artifacts"] = artifact_summary
        print(json.dumps(payload, indent=2))
        return 0

    print(f"Kernel: {summary['kernel_name']}")
    print(f"Bindings: {summary['resolved_bindings']}")
    print(f"Bundles: {summary['bundle_count']} scheduled, {summary['binary_bundle_count']} binary")
    print(f"Matrix slot usage: {summary['matrix_slot_usage']}")
    print(f"Coarse key preview: {summary['coarse_keys_preview'][:8]}")
    print(f"Coarse query preview: {summary['coarse_queries_preview'][:8]}")
    print(f"Residual key preview: {summary['residual_keys_preview'][:8]}")
    print(f"Residual query preview: {summary['residual_queries_preview'][:8]}")
    print(f"Expected output preview: {summary['expected_out_preview'][:8]}")
    print(f"Expected row-major preview: {summary['expected_out_row_major'][:8]}")
    print(f"Binary bundle preview: {summary['bundle_preview']}")
    if artifact_summary is not None:
        print(f"Artifact directory: {artifact_summary['output_dir']}")
        print(f"IMEM word preview: {artifact_summary['imem_preview'][:8]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())