#!/usr/bin/env python3
"""
Scheduler tests for scalar/vector memory-domain isolation rules.

Covers:
- Default scalar load/store can co-issue with vector instructions
- Scalar memory ops explicitly targeting vector banks do NOT co-issue
"""

import sys
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from scheduler import (
    FP32_ADD_BUSY_CYCLES,
    FP32_ADD_READ_LATENCY,
    SchedulerConfig,
    VliwScheduler,
)


def _has_engine(bundle: dict, engine: str) -> bool:
    return engine in bundle and len(bundle[engine]) > 0


def _find_first_bundle_with_op(bundles: list[dict], engine: str, opcode: str) -> int:
    for idx, bundle in enumerate(bundles):
        for op in bundle.get(engine, []):
            if op and op[0] == opcode:
                return idx
    return -1


def test_default_scalar_mem_can_pack_with_vector():
    s = VliwScheduler(SchedulerConfig(mem_post_gap=-1, valu_post_gap=-1))
    ops = [
        s.valu_op("vadd", 320, 328, 336, vlen=1),
        s.load(1, 0),  # default memory_domain="scalar"
        s.halt(),
    ]
    bundles = s.schedule(ops)

    assert _has_engine(bundles[0], "valu"), "Expected VALU op in bundle 0"
    assert _has_engine(bundles[0], "load"), "Expected scalar LOAD to co-issue with VALU in bundle 0"


def test_scalar_load_from_vector_bank_isolated_from_vector_ops():
    s = VliwScheduler(SchedulerConfig(mem_post_gap=-1, valu_post_gap=-1))
    ops = [
        s.valu_op("vadd", 320, 328, 336, vlen=1),
        s.load_from_vector_bank(1, 0),
        s.halt(),
    ]
    bundles = s.schedule(ops)

    vadd_pc = _find_first_bundle_with_op(bundles, "valu", "vadd")
    load_pc = _find_first_bundle_with_op(bundles, "load", "load")

    assert vadd_pc >= 0 and load_pc >= 0, "Expected both vadd and load to be scheduled"
    assert load_pc > vadd_pc, (
        "Scalar LOAD targeting vector bank must not co-issue with vector instructions"
    )


def test_scalar_store_to_vector_bank_isolated_from_vector_ops():
    s = VliwScheduler(SchedulerConfig(mem_post_gap=-1, valu_post_gap=-1))
    ops = [
        s.valu_op("vadd", 320, 328, 336, vlen=1),
        s.store_to_vector_bank(0, 0),
        s.halt(),
    ]
    bundles = s.schedule(ops)

    vadd_pc = _find_first_bundle_with_op(bundles, "valu", "vadd")
    store_pc = _find_first_bundle_with_op(bundles, "store", "store")

    assert vadd_pc >= 0 and store_pc >= 0, "Expected both vadd and store to be scheduled"
    assert store_pc > vadd_pc, (
        "Scalar STORE targeting vector bank must not co-issue with vector instructions"
    )


def test_scalar_fp32_pseudoop_spacing_accounts_for_wb_and_busy_cycles():
    s = VliwScheduler(SchedulerConfig(mem_post_gap=0, valu_post_gap=0))
    ops = [
        s.const(0, 2),
        s.const(1, 3),
        s.const(2, 4),
        s.i2f(10, 0),
        s.i2f(11, 1),
        s.i2f(12, 2),
        *s.fmadd(14, 10, 11, 12, temp=13),
        s.f2i(15, 14),
        s.const(20, 0),
        s.store(20, 14),
        s.halt(),
    ]

    bundles = s.schedule(ops)

    fadd_pc = _find_first_bundle_with_op(bundles, "alu", "fadd")
    f2i_pc = _find_first_bundle_with_op(bundles, "alu", "f2i")
    store_pc = _find_first_bundle_with_op(bundles, "store", "store")

    assert fadd_pc >= 0 and f2i_pc >= 0 and store_pc >= 0, "Expected fadd, f2i, and store to be scheduled"
    assert store_pc >= fadd_pc + FP32_ADD_READ_LATENCY, (
        "Scalar STORE should wait for FP32 writeback visibility before reading FMADD output"
    )
    assert f2i_pc >= fadd_pc + FP32_ADD_BUSY_CYCLES + 1, (
        "Scalar FP32 consumer should not re-issue while the serialized FP32 unit is still busy"
    )


def run_all_tests() -> bool:
    tests = [
        test_default_scalar_mem_can_pack_with_vector,
        test_scalar_load_from_vector_bank_isolated_from_vector_ops,
        test_scalar_store_to_vector_bank_isolated_from_vector_ops,
        test_scalar_fp32_pseudoop_spacing_accounts_for_wb_and_busy_cycles,
    ]

    passed = 0
    failed = 0

    for test in tests:
        try:
            test()
            print(f"✓ {test.__name__} PASSED")
            passed += 1
        except AssertionError as exc:
            print(f"✗ {test.__name__} FAILED: {exc}")
            failed += 1
        except Exception as exc:  # pragma: no cover - defensive test harness
            print(f"✗ {test.__name__} ERROR: {exc}")
            failed += 1

    print(f"\nResults: {passed} passed, {failed} failed")
    return failed == 0


if __name__ == "__main__":
    ok = run_all_tests()
    raise SystemExit(0 if ok else 1)
