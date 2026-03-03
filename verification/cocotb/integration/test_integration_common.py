"""
VLIW SIMD Integration Tests — Program-level verification.

Uses the VliwScheduler for automatic hazard avoidance:
  - RAW dependencies (latency 2) inserted automatically
  - Division latency (33 cycles) tracked
  - Jump bubbles handled
  - Independent ops packed into same bundle

Test Categories:
  1. Arithmetic programs (ALU correctness through the full pipeline)
  2. Memory programs (LOAD/STORE/CONST through AXI)
  3. Control flow programs (JUMP, COND_JUMP, loops)
  4. Multi-instruction programs (dual-issue packing)
  5. Edge cases (division, zero, overflow)
  6. Fibonacci (complex loop)
"""

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
N_ALU_SLOTS = CFG.n_alu_slots
N_VALU_SLOTS = CFG.n_valu_slots
N_LOAD_SLOTS = CFG.n_load_slots
N_STORE_SLOTS = CFG.n_store_slots
N_FLOW_SLOTS = CFG.n_flow_slots

# Create assembler + scheduler matching Sim config
ASM = Assembler(AssemblerConfig(
    n_alu_slots=N_ALU_SLOTS, n_valu_slots=N_VALU_SLOTS, n_load_slots=N_LOAD_SLOTS,
    n_store_slots=N_STORE_SLOTS, n_flow_slots=N_FLOW_SLOTS, vlen=CFG.vlen,
    scratch_size=CFG.scratch_size, imem_depth=CFG.imem_depth
))

S = VliwScheduler(SchedulerConfig(
    n_alu_slots=N_ALU_SLOTS, n_valu_slots=N_VALU_SLOTS, n_load_slots=N_LOAD_SLOTS,
    n_store_slots=N_STORE_SLOTS, n_flow_slots=N_FLOW_SLOTS,
    mem_post_gap=CFG.mem_post_gap
))


def _u32(x: int) -> int:
    return x & 0xFFFFFFFF


def _vbin(op: str, a: list[int], b: list[int]) -> list[int]:
    out = []
    for av, bv in zip(a, b):
        if op == "add":
            out.append(_u32(av + bv))
        elif op == "sub":
            out.append(_u32(av - bv))
        elif op == "mul":
            out.append(_u32(av * bv))
        elif op == "xor":
            out.append(_u32(av ^ bv))
        elif op == "and":
            out.append(_u32(av & bv))
        elif op == "or":
            out.append(_u32(av | bv))
        elif op == "shl":
            out.append(_u32(av << (bv & 0x1F)))
        elif op == "shr":
            out.append(_u32((av & 0xFFFFFFFF) >> (bv & 0x1F)))
        elif op == "lt":
            out.append(1 if _u32(av) < _u32(bv) else 0)
        elif op == "eq":
            out.append(1 if _u32(av) == _u32(bv) else 0)
        else:
            raise ValueError(f"Unknown op {op}")
    return out


def _vmadd(a: list[int], b: list[int], c: list[int]) -> list[int]:
    return [_u32(av * bv + cv) for av, bv, cv in zip(a, b, c)]


def build_program(ops, verbose=False):
    """Schedule ops, assemble into binary bundles."""
    bundles_dicts = S.schedule(ops, verbose=verbose)
    return ASM.assemble_program(bundles_dicts)


__all__ = [name for name in globals() if not name.startswith("__")]


# ============================================================================
#  Test 1: Scalar ADD + SUB
# ============================================================================
