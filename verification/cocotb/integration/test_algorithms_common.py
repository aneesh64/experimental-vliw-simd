"""
Algorithmic kernel integration tests (DSP / ML / CV) with Python golden references.
"""

import json
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))
if str(PROJECT_ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "tools"))
if str(Path(__file__).parent) not in sys.path:
    sys.path.insert(0, str(Path(__file__).parent))

import cocotb
from assembler import Assembler, AssemblerConfig
from scheduler import VliwScheduler, SchedulerConfig
from harness import VliwCoreHarness
from verification.cocotb.config import load_test_config

CFG = load_test_config(project_root=PROJECT_ROOT)

ASM = Assembler(AssemblerConfig(
    n_alu_slots=CFG.n_alu_slots,
    n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots,
    n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots,
    vlen=CFG.vlen,
    scratch_size=CFG.scratch_size,
    imem_depth=CFG.imem_depth,
))

S = VliwScheduler(SchedulerConfig(
    n_alu_slots=CFG.n_alu_slots,
    n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots,
    n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots,
    mem_post_gap=CFG.mem_post_gap,
))


def build_program(ops, verbose=False):
    bundles_dicts = S.schedule(ops, verbose=verbose)
    return ASM.assemble_program(bundles_dicts)


def _u32(x: int) -> int:
    return x & 0xFFFFFFFF


def _pack_subs(values: list[int], ew: int) -> int:
    """Pack sub-element values into a 32-bit word at element width ew."""
    mask = (1 << ew) - 1
    result = 0
    for i, v in enumerate(values):
        result |= (v & mask) << (i * ew)
    return result & 0xFFFFFFFF


def _extract_subs(word: int, ew: int) -> list[int]:
    """Extract all sub-elements from a 32-bit word at element width ew."""
    n = 32 // ew
    mask = (1 << ew) - 1
    return [(word >> (i * ew)) & mask for i in range(n)]


def _to_signed(val: int, bits: int) -> int:
    mask = (1 << bits) - 1
    val = val & mask
    if val >= (1 << (bits - 1)):
        return val - (1 << bits)
    return val


def _from_signed(val: int, bits: int) -> int:
    return val & ((1 << bits) - 1)


def _golden_moving_avg2(samples: list[int]) -> list[int]:
    out = [0] * len(samples)
    for i in range(1, len(samples)):
        out[i] = (samples[i] + samples[i - 1]) >> 1
    return out


def _golden_dense1(x: list[int], w: list[int], bias: int) -> int:
    acc = 0
    for xv, wv in zip(x, w):
        acc = _u32(acc + _u32(xv * wv))
    return _u32(acc + bias)


def _golden_threshold(pixels: list[int], threshold: int) -> list[int]:
    return [1 if p < threshold else 0 for p in pixels]


def _golden_invert_u8(pixels: list[int]) -> list[int]:
    return [255 - (p & 0xFF) for p in pixels]


def _write_pgm(path: Path, width: int, height: int, pixels: list[int]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fp:
        fp.write("P2\n")
        fp.write(f"{width} {height}\n")
        fp.write("255\n")
        for row in range(height):
            base = row * width
            line = " ".join(str(pixels[base + col] & 0xFF) for col in range(width))
            fp.write(line + "\n")


def _write_u32_csv(path: Path, width: int, height: int, words: list[int]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fp:
        fp.write(f"# width={width},height={height}\n")
        for row in range(height):
            base = row * width
            line = ",".join(str(words[base + col] & 0xFFFFFFFF) for col in range(width))
            fp.write(line + "\n")


__all__ = [name for name in globals() if not name.startswith("__")]
