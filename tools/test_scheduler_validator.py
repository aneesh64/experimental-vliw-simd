#!/usr/bin/env python3
"""
Unit tests for scheduler_validator.py

Tests the validators catch the right errors and allow valid schedules.
"""

import sys
from pathlib import Path

# Add parent to path so we can import scheduler_validator
TOOLS_DIR = Path(__file__).parent
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from scheduler_validator import ScheduleValidator


def make_op(op_type, dest=None, sources=None):
    """Helper to create an operation dict."""
    op = {"type": op_type}
    if dest is not None:
        op["dest_register"] = dest
    if sources:
        op["source_registers"] = sources
    else:
        op["source_registers"] = []
    return op


def make_bundle(*ops):
    """Helper to create a bundle dict."""
    return {"ops": list(ops)}


def test_valid_schedule():
    """A valid schedule with proper spacing should pass."""
    bundles = [
        make_bundle(make_op("const", dest=0)),  # Bundle 0: write s[0]
        make_bundle(make_op("const", dest=1)),  # Bundle 1: bubble
        make_bundle(make_op("const", dest=2)),  # Bundle 2: bubble
        make_bundle(make_op("add", dest=3, sources=[0])),  # Bundle 3: read s[0] (safe)
    ]
    config = {"LOAD_RESULT_LATENCY": 20, "max_ops_per_slot": 1}

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()

    assert passed, f"Valid schedule failed: {errors}"
    assert len(errors) == 0
    print("✓ test_valid_schedule PASSED")


def test_load_use_hazard():
    """Load followed immediately by use should be caught."""
    bundles = [
        make_bundle(make_op("load", dest=5)),  # Bundle 0: LOAD s[5]
        make_bundle(make_op("add", dest=6, sources=[5])),  # Bundle 1: use s[5] - TOO SOON!
    ]
    config = {"LOAD_RESULT_LATENCY": 20}

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()

    assert not passed, "Load-use hazard not detected!"
    assert any("load-use" in e.lower() for e in errors), f"Wrong error type: {errors}"
    print("✓ test_load_use_hazard PASSED")


def test_load_use_safe_spacing():
    """Load with proper latency spacing should pass."""
    # LOAD_RESULT_LATENCY = 20, so earliest consumer is at gap > 20 (i.e., bundle 21+)
    bundles = [
        make_bundle(make_op("load", dest=5)),  # Bundle 0: LOAD s[5]
    ]
    # Bundles 1-20: gap=1 to gap=20, still too early
    for i in range(1, 21):
        bundles.append(make_bundle(make_op("const", dest=99)))

    # Bundle 21: gap=21, NOW it's safe to use s[5]
    bundles.append(make_bundle(make_op("add", dest=7, sources=[5])))

    config = {"LOAD_RESULT_LATENCY": 20}

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()

    assert passed, f"Safe schedule rejected: {errors}"
    print("✓ test_load_use_safe_spacing PASSED")


def test_bram_write_read_conflict():
    """Write in bundle N, read in bundle N+1 should fail."""
    bundles = [
        make_bundle(make_op("const", dest=0)),  # Bundle 0: write s[0]
        make_bundle(make_op("add", dest=1, sources=[0])),  # Bundle 1: read s[0] - CONFLICT!
    ]
    config = {}

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()

    assert not passed, "BRAM conflict not detected!"
    assert any("bram" in e.lower() and "write-read" in e.lower() for e in errors), f"Wrong error: {errors}"
    print("✓ test_bram_write_read_conflict PASSED")


def test_bram_write_read_safe_gap():
    """Write in N, read in N+2 should pass (2-cycle gap)."""
    bundles = [
        make_bundle(make_op("const", dest=0)),  # Bundle 0: write s[0]
        make_bundle(make_op("const", dest=1)),  # Bundle 1: bubble
        make_bundle(make_op("add", dest=2, sources=[0])),  # Bundle 2: read s[0] - SAFE
    ]
    config = {}

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()

    assert passed, f"Safe BRAM schedule rejected: {errors}"
    print("✓ test_bram_write_read_safe_gap PASSED")


def test_multiple_stores_per_bundle():
    """Multiple stores in one bundle should fail."""
    bundles = [
        make_bundle(make_op("const", dest=0), make_op("const", dest=1)),  # Setup
        make_bundle(
            make_op("store", dest=None, sources=[0]),
            make_op("store", dest=None, sources=[1]),  # Two stores - ERROR!
        ),
    ]
    config = {}

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()

    assert not passed, "Multiple stores not detected!"
    assert any("store" in e.lower() and "multiple" in e.lower() for e in errors), f"Wrong error: {errors}"
    print("✓ test_multiple_stores_per_bundle PASSED")


def test_single_store_per_bundle():
    """Single store per bundle should pass."""
    bundles = [
        make_bundle(make_op("const", dest=0)),  # Bundle 0: write s[0]
        make_bundle(make_op("const", dest=1)),  # Bundle 1: bubble gap
        make_bundle(make_op("store", dest=None, sources=[0])),  # Bundle 2: read s[0] (safe at gap=2)
        make_bundle(make_op("const", dest=2)),  # Bundle 3: write s[2]
        make_bundle(make_op("const", dest=3)),  # Bundle 4: bubble gap
        make_bundle(make_op("store", dest=None, sources=[2])),  # Bundle 5: read s[2] (safe at gap=2)
    ]
    config = {}

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()

    assert passed, f"Valid stores rejected: {errors}"
    print("✓ test_single_store_per_bundle PASSED")


def test_combined_hazards():
    """Multiple hazards in one schedule should catch all."""
    bundles = [
        make_bundle(make_op("load", dest=0)),  # Bundle 0: LOAD s[0]
        make_bundle(make_op("add", dest=1, sources=[0])),  # Bundle 1: use s[0] - load-use too soon
        make_bundle(
            make_op("const", dest=2, sources=[]),
            make_op("store", dest=None, sources=[2]),  # Two store-like ops might be multi-issue issue
            make_op("store", dest=None, sources=[2]),  # Multiple stores - ERROR!
        ),  # Bundle 2: multiple stores
    ]
    config = {"LOAD_RESULT_LATENCY": 20}

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()

    assert not passed, "No errors detected!"
    # Should catch: load-use hazard + multiple stores
    assert len(errors) >= 2, f"Expected at least 2 errors, got {len(errors)}: {errors}"
    print("✓ test_combined_hazards PASSED")


def test_empty_schedule():
    """Empty schedule is valid."""
    bundles = []
    config = {}

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()

    assert passed, f"Empty schedule failed: {errors}"
    print("✓ test_empty_schedule PASSED")


def run_all_tests():
    """Run all validation tests."""
    print("Running scheduler_validator tests...\n")

    tests = [
        test_valid_schedule,
        test_load_use_hazard,
        test_load_use_safe_spacing,
        test_bram_write_read_conflict,
        test_bram_write_read_safe_gap,
        test_multiple_stores_per_bundle,
        test_single_store_per_bundle,
        test_combined_hazards,
        test_empty_schedule,
    ]

    passed = 0
    failed = 0

    for test_func in tests:
        try:
            test_func()
            passed += 1
        except AssertionError as e:
            print(f"✗ {test_func.__name__} FAILED: {e}\n")
            failed += 1
        except Exception as e:
            print(f"✗ {test_func.__name__} ERROR: {e}\n")
            failed += 1

    print(f"\n{'='*70}")
    print(f"Test Results: {passed} passed, {failed} failed")
    print(f"{'='*70}")

    return failed == 0


if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)
