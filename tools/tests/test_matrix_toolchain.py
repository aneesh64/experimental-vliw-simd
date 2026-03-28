#!/usr/bin/env python3

import sys
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from assembler import Assembler, AssemblerConfig
from scheduler import SchedulerConfig, VliwScheduler
from dsl import HardwareCapabilities, build_pipelined_multi_matrix_residual_affine_kernel, compile_kernel


def _find_first_bundle_with_op(bundles: list[dict], engine: str, opcode: str) -> int:
    for idx, bundle in enumerate(bundles):
        for op in bundle.get(engine, []):
            if op and op[0] == opcode:
                return idx
    return -1


def test_matrix_scheduler_emits_matrix_bundle():
    sched = VliwScheduler(SchedulerConfig(n_matrix_slots=1, mem_post_gap=-1, valu_post_gap=-1))
    bundles = sched.schedule([
        sched.mcfg(flags=1),
        sched.mpreload(dest=32, src_a=64, src_b=96),
        sched.mcompute(dest=128, src_a=64, src_b=96, src_c=160),
        sched.halt(),
    ])

    mcfg_pc = _find_first_bundle_with_op(bundles, "matrix", "mcfg")
    preload_pc = _find_first_bundle_with_op(bundles, "matrix", "mpreload")
    compute_pc = _find_first_bundle_with_op(bundles, "matrix", "mcompute")

    assert mcfg_pc >= 0
    assert preload_pc >= 0
    assert compute_pc >= 0
    assert compute_pc >= preload_pc


def test_matrix_scheduler_emits_fp8_matrix_bundles():
    sched = VliwScheduler(SchedulerConfig(n_matrix_slots=1, mem_post_gap=-1, valu_post_gap=-1))
    bundles = sched.schedule([
        sched.mcompute_fp8_e4m3(dest=0, src_a=0, src_b=0, src_c=0),
        sched.mcompute_fp8_e5m2_acc(dest=0, src_a=0, src_b=0, src_c=0),
        sched.halt(),
    ])

    assert _find_first_bundle_with_op(bundles, "matrix", "mcompute_fp8_e4m3") >= 0
    assert _find_first_bundle_with_op(bundles, "matrix", "mcompute_fp8_e5m2_acc") >= 0


def test_matrix_compute_can_coissue_with_alu_and_valu():
    sched = VliwScheduler(SchedulerConfig(
        n_matrix_slots=1,
        mem_post_gap=-1,
        valu_post_gap=-1,
        matrix_post_gap=-1,
    ))

    alu_bundles = sched.schedule([
        sched.add(10, 1, 2),
        sched.mzero(dest=0),
        sched.halt(),
    ])
    valu_bundles = sched.schedule([
        sched.valu_op("add", 128, 136, 144),
        sched.mzero(dest=0),
        sched.halt(),
    ])

    assert [op[0] for op in alu_bundles[0].get("alu", [])] == ["add"]
    assert [op[0] for op in alu_bundles[0].get("matrix", [])] == ["mzero"]
    assert [op[0] for op in valu_bundles[0].get("valu", [])] == ["add"]
    assert [op[0] for op in valu_bundles[0].get("matrix", [])] == ["mzero"]


def test_matrix_transfer_does_not_coissue_with_memory_ops():
    sched = VliwScheduler(SchedulerConfig(
        n_matrix_slots=1,
        mem_post_gap=-1,
        valu_post_gap=-1,
        matrix_post_gap=-1,
    ))
    bundles = sched.schedule([
        sched.load(5, 7),
        sched.mdmvin(dest=0, src_a=64),
        sched.store(9, 5),
        sched.halt(),
    ])

    load_pc = _find_first_bundle_with_op(bundles, "load", "load")
    mdmvin_pc = _find_first_bundle_with_op(bundles, "matrix", "mdmvin")
    store_pc = _find_first_bundle_with_op(bundles, "store", "store")

    assert load_pc >= 0
    assert mdmvin_pc >= 0
    assert store_pc >= 0
    assert mdmvin_pc != load_pc
    assert mdmvin_pc != store_pc


def test_matrix_assembler_extends_bundle_width_and_encodes_slot():
    cfg = AssemblerConfig(n_matrix_slots=1)
    asm = Assembler(cfg)

    bundle = asm.assemble({
        "matrix": [("mcompute", 128, 64, 96, 160, 8, 8, 0)],
        "flow": [("halt",)],
    })

    assert cfg.bundle_width >= 320
    assert bundle != 0


def test_matrix_assembler_encodes_fp8_compute_slots():
    cfg = AssemblerConfig(n_matrix_slots=1)
    asm = Assembler(cfg)

    bundle = asm.assemble({
        "matrix": [("mcompute_fp8_e4m3", 128, 64, 96, 0, 8, 8, 0)],
        "flow": [("halt",)],
    })
    bundle_acc = asm.assemble({
        "matrix": [("mcompute_fp8_e5m2_acc", 128, 64, 96, 0, 8, 8, 0)],
        "flow": [("halt",)],
    })

    assert bundle != 0
    assert bundle_acc != 0


def test_matrix_direct_transfer_encodes():
    cfg = AssemblerConfig(n_matrix_slots=1)
    asm = Assembler(cfg)

    bundle = asm.assemble({
        "matrix": [
            ("mdmvin", 32, 256, 0, 0, 8, 8, 0),
        ],
        "flow": [("halt",)],
    })

    assert bundle != 0


def test_matrix_capabilities_round_trip_configs():
    sched_cfg = SchedulerConfig(n_matrix_slots=1)
    asm_cfg = AssemblerConfig(n_matrix_slots=1)
    caps = HardwareCapabilities.from_configs(scheduler_config=sched_cfg, assembler_config=asm_cfg)

    assert caps.n_matrix_slots == 1
    assert caps.to_scheduler_config().n_matrix_slots == 1
    assert caps.to_assembler_config().n_matrix_slots == 1
    caps.require_matrix_op("mcompute")


def test_relaxed_mem_post_gap_reduces_pipelined_matrix_bundle_count():
    bindings = {
        "lhs_tiles": 0,
        "rhs_tiles": 32,
        "residual": 64,
        "matrix_out": 192,
        "affine_out": 320,
        "probe": 448,
        "meta": 452,
        "gain": 2,
        "bias": 5,
    }

    conservative_caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1, mem_post_gap=2),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    relaxed_caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1, mem_post_gap=0),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )

    conservative = compile_kernel(
        build_pipelined_multi_matrix_residual_affine_kernel(runs=2, chunk_elements=8, unroll=2),
        conservative_caps,
        assemble=False,
        bindings=bindings,
    )
    relaxed = compile_kernel(
        build_pipelined_multi_matrix_residual_affine_kernel(runs=2, chunk_elements=8, unroll=2),
        relaxed_caps,
        assemble=False,
        bindings=bindings,
    )

    assert len(relaxed.scheduled_bundles) < len(conservative.scheduled_bundles)
    assert relaxed.to_manifest().slot_usage["load"] == conservative.to_manifest().slot_usage["load"]


def run_all_tests() -> bool:
    tests = [
        test_matrix_scheduler_emits_matrix_bundle,
        test_matrix_compute_can_coissue_with_alu_and_valu,
        test_matrix_transfer_does_not_coissue_with_memory_ops,
        test_matrix_assembler_extends_bundle_width_and_encodes_slot,
        test_matrix_direct_transfer_encodes,
        test_matrix_capabilities_round_trip_configs,
        test_relaxed_mem_post_gap_reduces_pipelined_matrix_bundle_count,
    ]

    passed = 0
    failed = 0

    for test in tests:
      try:
          test()
          print(f"PASS {test.__name__}")
          passed += 1
      except AssertionError as exc:
          print(f"FAIL {test.__name__}: {exc}")
          failed += 1
      except Exception as exc:
          print(f"ERROR {test.__name__}: {exc}")
          failed += 1

    print(f"Results: {passed} passed, {failed} failed")
    return failed == 0


if __name__ == "__main__":
    ok = run_all_tests()
    raise SystemExit(0 if ok else 1)
