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
    build_matrix_matmul_32x32_tiled_kernel,
    compile_kernel,
    pack_matrix_matmul_32x32_u32_tiles,
    pack_matrix_matmul_32x32_u8_tiles,
    unpack_matrix_matmul_32x32_u32_tiles,
)
from scheduler import SchedulerConfig


def build_demo_inputs(size: int = 32) -> tuple[list[int], list[int]]:
    lhs = [((row * 11 + col * 5 + 7) % 32) for row in range(size) for col in range(size)]
    rhs = [((row * 13 + col * 3 + 1) % 32) for row in range(size) for col in range(size)]
    return lhs, rhs


def golden_square_matmul(lhs: list[int], rhs: list[int], *, size: int = 32) -> list[int]:
    out: list[int] = []
    for row in range(size):
        for col in range(size):
            total = 0
            for depth in range(size):
                total += lhs[row * size + depth] * rhs[depth * size + col]
            out.append(total & 0xFFFFFFFF)
    return out


def _u32_words_to_le_bytes(words: list[int]) -> bytes:
    payload = bytearray()
    for word in words:
        payload.extend(int(word & 0xFFFFFFFF).to_bytes(4, byteorder="little", signed=False))
    return bytes(payload)


def _write_u32_hex_lines(path: Path, words: list[int]) -> None:
    path.write_text("\n".join(f"0x{word & 0xFFFFFFFF:08X}" for word in words) + "\n", encoding="ascii")


def compile_demo_kernel():
    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(
        build_matrix_matmul_32x32_tiled_kernel(),
        caps,
        assemble=True,
        bindings={"lhs_tiles": 0, "rhs_tiles": 256, "out_tiles": 512},
    )
    return caps, result


def build_demo_summary() -> dict:
    lhs_row_major, rhs_row_major = build_demo_inputs()
    expected_row_major = golden_square_matmul(lhs_row_major, rhs_row_major)
    lhs_tiles = pack_matrix_matmul_32x32_u8_tiles(lhs_row_major)
    rhs_tiles = pack_matrix_matmul_32x32_u8_tiles(rhs_row_major)
    expected_tiles = pack_matrix_matmul_32x32_u32_tiles(expected_row_major)

    caps, result = compile_demo_kernel()
    manifest = result.to_manifest()

    unpacked_expected = unpack_matrix_matmul_32x32_u32_tiles(expected_tiles)
    if unpacked_expected != expected_row_major:
        raise AssertionError("Packed output tiles did not round-trip back to the expected row-major matrix")

    return {
        "kernel_name": result.kernel.name,
        "required_bindings": list(result.required_bindings),
        "resolved_bindings": dict(result.resolved_bindings),
        "bundle_count": len(result.scheduled_bundles),
        "binary_bundle_count": len(result.binary_bundles or []),
        "matrix_slot_usage": manifest.slot_usage["matrix"],
        "lhs_tile_words": lhs_tiles[:32],
        "rhs_tile_words": rhs_tiles[:32],
        "expected_out_tile_words": expected_tiles[:32],
        "expected_out_row_major": expected_row_major[:16],
        "bundle_preview": [int(bundle) for bundle in (result.binary_bundles or [])[:4]],
    }


def emit_demo_artifacts(output_dir: Path) -> dict:
    lhs_row_major, rhs_row_major = build_demo_inputs()
    expected_row_major = golden_square_matmul(lhs_row_major, rhs_row_major)
    lhs_tiles = pack_matrix_matmul_32x32_u8_tiles(lhs_row_major)
    rhs_tiles = pack_matrix_matmul_32x32_u8_tiles(rhs_row_major)
    expected_out_tiles = pack_matrix_matmul_32x32_u32_tiles(expected_row_major)
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
        "lhs_tiles_u8_count": len(lhs_tiles),
        "rhs_tiles_u8_count": len(rhs_tiles),
        "expected_out_tiles_u32_count": len(expected_out_tiles),
        "expected_out_row_major_u32_count": len(expected_row_major),
    }

    (output_dir / "matrix_matmul_32x32_metadata.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="ascii")
    _write_u32_hex_lines(output_dir / "matrix_matmul_32x32_imem_words.txt", imem_words)
    (output_dir / "matrix_matmul_32x32_lhs_tiles_u8.bin").write_bytes(bytes(lhs_tiles))
    (output_dir / "matrix_matmul_32x32_rhs_tiles_u8.bin").write_bytes(bytes(rhs_tiles))
    (output_dir / "matrix_matmul_32x32_expected_out_tiles_u32_le.bin").write_bytes(_u32_words_to_le_bytes(expected_out_tiles))
    (output_dir / "matrix_matmul_32x32_expected_out_row_major_u32_le.bin").write_bytes(_u32_words_to_le_bytes(expected_row_major))

    return {
        "output_dir": str(output_dir),
        "metadata": metadata,
        "imem_preview": imem_words[:16],
    }


def main() -> int:
    parser = argparse.ArgumentParser(description="Compile and prepare the tiled 32x32 matrix matmul demo inputs.")
    parser.add_argument("--json", action="store_true", help="Print the demo summary as JSON.")
    parser.add_argument("--emit-dir", type=Path, help="Write driver-facing IMEM and DMEM artifact files to this directory.")
    args = parser.parse_args()

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
    print(f"Packed lhs preview: {summary['lhs_tile_words'][:8]}")
    print(f"Packed rhs preview: {summary['rhs_tile_words'][:8]}")
    print(f"Expected packed out preview: {summary['expected_out_tile_words'][:8]}")
    print(f"Expected row-major out preview: {summary['expected_out_row_major'][:8]}")
    print(f"Binary bundle preview: {summary['bundle_preview']}")
    if artifact_summary is not None:
        print(f"Artifact directory: {artifact_summary['output_dir']}")
        print(f"IMEM word preview: {artifact_summary['imem_preview'][:8]}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())