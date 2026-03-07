#!/usr/bin/env python3

import sys
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from assembler import AssemblerConfig
from scheduler import SchedulerConfig
from dsl import HardwareCapabilities, KernelBuilder, U8, compile_kernel


def test_capabilities_round_trip_configs():
    sched = SchedulerConfig(
        n_alu_slots=2,
        n_valu_slots=1,
        n_load_slots=1,
        n_store_slots=1,
        n_flow_slots=1,
        scratch_banks=8,
        data_width=32,
    )
    asm = AssemblerConfig(
        n_alu_slots=2,
        n_valu_slots=1,
        n_load_slots=1,
        n_store_slots=1,
        n_flow_slots=1,
        vlen=8,
        scratch_size=2048,
        imem_depth=4096,
    )

    caps = HardwareCapabilities.from_configs(scheduler_config=sched, assembler_config=asm, n_cores=4)

    assert caps.n_cores == 4
    assert caps.n_alu_slots == 2
    assert caps.bundle_width == asm.bundle_width
    assert caps.to_scheduler_config().n_alu_slots == 2
    assert caps.to_assembler_config().scratch_size == 2048


def test_initial_lowering_respects_scratch_capacity():
    kb = KernelBuilder("scratch_overflow")
    ptr = kb.scalar("ptr")
    kb.vector("v0", dtype=U8)
    kb.vector("v1", dtype=U8)
    kb.vector("v2", dtype=U8)
    kb.const(ptr, 0).halt()

    caps = HardwareCapabilities.from_configs(
        assembler_config=AssemblerConfig(scratch_size=16, vlen=8),
    )

    try:
        compile_kernel(kb.build(), caps)
    except ValueError as exc:
        assert "scratch_size" in str(exc)
    else:
        raise AssertionError("Expected scratch overflow to raise ValueError")
