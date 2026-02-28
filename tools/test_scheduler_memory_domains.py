#!/usr/bin/env python3
"""
Scheduler tests for scalar/vector memory-domain isolation rules.

Covers:
- Default scalar load/store can co-issue with vector instructions
- Scalar memory ops explicitly targeting vector banks do NOT co-issue
"""

from scheduler import SchedulerConfig, VliwScheduler


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


def run_all_tests() -> bool:
    tests = [
        test_default_scalar_mem_can_pack_with_vector,
        test_scalar_load_from_vector_bank_isolated_from_vector_ops,
        test_scalar_store_to_vector_bank_isolated_from_vector_ops,
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
