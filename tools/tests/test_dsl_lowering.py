#!/usr/bin/env python3

import sys
from pathlib import Path
from typing import cast

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from assembler import AssemblerConfig
from scheduler import SchedulerConfig
from dsl import HardwareCapabilities, KernelBuilder, TileWeaveKernelBuilder, U8, U16, U32, compile_kernel
from scheduler import Op


def _real_ops(result) -> list[Op]:
    return [cast(Op, op) for op in result.operations if isinstance(op, Op)]


def test_vector_add_kernel_lowers_to_scheduler_and_binary():
    kb = KernelBuilder("vec_add_u8")
    a_ptr = kb.scalar("a_ptr", dtype=U32)
    b_ptr = kb.scalar("b_ptr", dtype=U32)
    out_ptr = kb.scalar("out_ptr", dtype=U32)
    va = kb.vector("va", dtype=U8)
    vb = kb.vector("vb", dtype=U8)
    vc = kb.vector("vc", dtype=U8)

    kb.const(a_ptr, 0)
    kb.const(b_ptr, 16)
    kb.const(out_ptr, 32)
    kb.vload(va, a_ptr)
    kb.vload(vb, b_ptr)
    kb.vector_binary("add", vc, va, vb, ew=8)
    kb.vstore(out_ptr, vc)
    kb.halt()

    caps = HardwareCapabilities.from_configs(assembler_config=AssemblerConfig(vlen=8, scratch_size=256))
    result = compile_kernel(kb.build(), caps)
    ops = _real_ops(result)

    assert result.scratch_map["va"] % caps.vector_alignment_words == 0
    assert any(op.engine == "valu" and op.op == "add" for op in ops)
    assert len(result.scheduled_bundles) > 0
    assert result.binary_bundles is not None and len(result.binary_bundles) == len(result.scheduled_bundles)


def test_coreid_and_add_imm_lowering():
    kb = KernelBuilder("core_offset")
    core = kb.scalar("core")
    base = kb.scalar("base")
    kb.coreid(core)
    kb.const(base, 100)
    kb.add_imm(base, base, 8)
    kb.halt()

    caps = HardwareCapabilities.from_configs()
    result = compile_kernel(kb.build(), caps, assemble=False)
    ops = _real_ops(result)

    assert any(op.engine == "flow" and op.op == "coreid" for op in ops)
    assert any(op.engine == "flow" and op.op == "add_imm" for op in ops)
    assert result.binary_bundles is None


def test_scalar_and_vector_max_min_lowering():
    kb = KernelBuilder("max_min_ops")
    s_a = kb.scalar("s_a")
    s_b = kb.scalar("s_b")
    s_max = kb.scalar("s_max")
    s_min = kb.scalar("s_min")
    v_a = kb.vector("v_a", dtype=U8)
    v_b = kb.vector("v_b", dtype=U8)
    v_max = kb.vector("v_max", dtype=U8)
    v_min = kb.vector("v_min", dtype=U8)

    kb.max(s_max, s_a, s_b)
    kb.min(s_min, s_a, s_b)
    kb.vector_max(v_max, v_a, v_b, ew=8, signed=1)
    kb.vector_min(v_min, v_a, v_b, ew=8, signed=1)
    kb.halt()

    caps = HardwareCapabilities.from_configs(assembler_config=AssemblerConfig(vlen=8, scratch_size=256))
    result = compile_kernel(kb.build(), caps)
    ops = _real_ops(result)

    scalar_ops = [op for op in ops if op.engine == "alu"]
    vector_ops = [op for op in ops if op.engine == "valu"]

    assert [op.op for op in scalar_ops] == ["max", "min"]
    assert [op.op for op in vector_ops] == ["max", "min"]
    assert all(op.params["ew"] == 8 for op in vector_ops)
    assert all(op.params["signed"] == 1 for op in vector_ops)
    assert result.binary_bundles is not None and len(result.binary_bundles) == len(result.scheduled_bundles)


def test_argument_prologue_and_symbolic_dmem_binding():
    kb = KernelBuilder("bound_vec_load")
    scale = kb.arg_scalar("scale")
    input_buf = kb.arg_dmem_tensor("input", shape=(8,), dtype=U8)
    ptr = kb.scalar("ptr")
    vec = kb.vector("vec", dtype=U8)

    kb.address_of(ptr, input_buf, offset_words=4)
    kb.vload(vec, ptr)
    kb.vbroadcast(vec, scale, ew=8)
    kb.halt()

    caps = HardwareCapabilities.from_configs(assembler_config=AssemblerConfig(vlen=8, scratch_size=256))
    result = compile_kernel(kb.build(), caps, assemble=False, bindings={"scale": 3, "input": 64})
    ops = _real_ops(result)

    assert result.required_bindings == ("scale", "input")
    assert result.resolved_bindings["scale"] == 3
    assert result.resolved_bindings["input"] == 64
    assert ops[0].engine == "load" and ops[0].op == "const"
    assert ops[1].engine == "load" and ops[1].op == "const"


def test_matrix_matmul_lowers_to_matrix_sequence_and_manifest_usage():
    kb = KernelBuilder("matrix_matmul")
    lhs = kb.arg_dmem_tensor("lhs", shape=(8, 8), dtype=U8)
    rhs = kb.arg_dmem_tensor("rhs", shape=(8, 8), dtype=U8)
    out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

    kb.matmul(lhs, rhs, out)
    kb.halt()

    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1, scratch_size=256),
    )
    result = compile_kernel(kb.build(), caps, bindings={"lhs": 0, "rhs": 16, "out": 32})
    ops = _real_ops(result)
    manifest = result.to_manifest()

    matrix_ops = [op for op in ops if op.engine == "matrix"]
    assert [op.op for op in matrix_ops] == ["mdmvin", "mdmvin", "mzero", "mcompute", "mdmvout"]
    assert matrix_ops[0].params["src_a"] == 0
    assert matrix_ops[1].params["dest"] == 0
    assert matrix_ops[-1].params["dest"] == 32
    assert manifest.slot_usage["matrix"] == 5
    assert result.binary_bundles is not None and len(result.binary_bundles) == len(result.scheduled_bundles)


def test_matrix_accumulate_lowers_without_zeroing():
    kb = KernelBuilder("matrix_matmul_acc")
    lhs = kb.arg_dmem_tensor("lhs", shape=(8, 8), dtype=U8)
    rhs = kb.arg_dmem_tensor("rhs", shape=(8, 8), dtype=U8)
    out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

    kb.matmul(lhs, rhs, out, accumulate=True)
    kb.halt()

    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(kb.build(), caps, assemble=False, bindings={"lhs": 0, "rhs": 16, "out": 32})
    ops = _real_ops(result)

    matrix_ops = [op for op in ops if op.engine == "matrix"]
    assert [op.op for op in matrix_ops] == ["mdmvin", "mdmvin", "mcompute_acc", "mdmvout"]


def test_dmem_alias_resolves_relative_to_base_binding():
    kb = KernelBuilder("matrix_alias_binding")
    tiles = kb.arg_dmem_tensor("tiles", shape=(16, 8, 8), dtype=U8)
    tile = kb.dmem_alias("tile_5", tiles, shape=(8, 8), offset_words=5 * 16, dtype=U8)
    out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

    kb.matmul(tile, tile, out)
    kb.halt()

    caps = HardwareCapabilities.from_configs(
        scheduler_config=SchedulerConfig(n_matrix_slots=1),
        assembler_config=AssemblerConfig(n_matrix_slots=1),
    )
    result = compile_kernel(kb.build(), caps, assemble=False, bindings={"tiles": 128, "out": 512})
    ops = _real_ops(result)

    matrix_ops = [op for op in ops if op.engine == "matrix"]
    assert result.required_bindings == ("tiles", "out")
    assert matrix_ops[0].params["src_a"] == 208
    assert matrix_ops[1].params["src_a"] == 208


def test_tiled_32x32_matrix_matmul_lowers_to_expected_matrix_sequence_count():
    from dsl import build_matrix_matmul_32x32_tiled_kernel

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
    ops = _real_ops(result)

    matrix_ops = [op for op in ops if op.engine == "matrix"]
    assert result.required_bindings == ("lhs_tiles", "rhs_tiles", "out_tiles")
    assert len(matrix_ops) == 272
    assert [op.op for op in matrix_ops[:9]] == [
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
    assert matrix_ops[0].params["src_a"] == 0
    assert matrix_ops[1].params["src_a"] == 256
    assert matrix_ops[4].params["dest"] == 1024
    assert matrix_ops[-1].params["dest"] == 1984


def test_matrix_matmul_requires_matrix_target_capability():
    kb = KernelBuilder("matrix_matmul_requires_matrix")
    lhs = kb.arg_dmem_tensor("lhs", shape=(8, 8), dtype=U8)
    rhs = kb.arg_dmem_tensor("rhs", shape=(8, 8), dtype=U8)
    out = kb.arg_dmem_tensor("out", shape=(8, 8), dtype=U32)

    kb.matmul(lhs, rhs, out)
    kb.halt()

    try:
        compile_kernel(kb.build(), HardwareCapabilities.from_configs(), assemble=False, bindings={"lhs": 0, "rhs": 16, "out": 32})
    except ValueError as exc:
        assert "no matrix slots" in str(exc)
    else:
        raise AssertionError("Expected matrix DSL lowering to fail on targets without matrix slots")


def test_missing_required_binding_fails():
    kb = KernelBuilder("missing_binding")
    kb.arg_dmem_tensor("input", shape=(8,), dtype=U8)
    ptr = kb.scalar("ptr")
    kb.address_of(ptr, "input").halt()

    caps = HardwareCapabilities.from_configs()

    try:
        compile_kernel(kb.build(), caps, assemble=False)
    except ValueError as exc:
        assert "requires binding" in str(exc)
    else:
        raise AssertionError("Expected missing binding to raise ValueError")


def test_tileweave_u16_large_block_preserves_element_width_and_chunks():
    tw = TileWeaveKernelBuilder(
        "tileweave_u16_large",
        length=16,
        block_size=16,
        tile_stride_elements=16,
        dtype=U16,
    )
    samples = tw.tensor("samples", dtype=U16)
    out = tw.tensor("out", dtype=U16)
    gain = tw.scalar("gain", dtype=U16, default=3)

    pid = tw.program_id(0)
    offsets = tw.arange(0, 16)
    x = tw.load(samples, pid, offsets)
    tw.store(out, pid, offsets, x * tw.splat(gain))

    result = compile_kernel(
        tw.build(),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"samples": 512, "out": 640, "gain": 3},
    )
    ops = _real_ops(result)

    mul_ops = [op for op in ops if op.engine == "valu" and op.op == "mul"]
    vbroadcast_ops = [op for op in ops if op.engine == "valu" and op.op == "vbroadcast"]
    vload_ops = [op for op in ops if op.engine == "load" and op.op == "vload"]
    vstore_ops = [op for op in ops if op.engine == "store" and op.op == "vstore"]

    assert len(mul_ops) == 2
    assert len(vload_ops) == 2
    assert len(vstore_ops) == 2
    assert len(vbroadcast_ops) == 1
    assert all(op.params["ew"] == 16 for op in mul_ops + vbroadcast_ops)


def test_tileweave_explicit_program_count_supports_overlapping_affine_launches():
    tw = TileWeaveKernelBuilder(
        "tileweave_affine_launch",
        length=8,
        block_size=8,
        tile_stride_elements=1,
        program_count=8,
        dtype=U32,
    )
    matrix = tw.tensor("matrix", length=64)
    out = tw.tensor("out", length=64)
    gain = tw.scalar("gain", default=2)

    pid = tw.program_id(0)
    offsets = tw.arange(0, 64, step=8)
    x = tw.load(matrix, pid, offsets)
    tw.store(out, pid, offsets, x * tw.splat(gain))

    result = compile_kernel(
        tw.build(),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"matrix": 768, "out": 896, "gain": 2},
    )
    ops = _real_ops(result)

    add_imm_ops = [op for op in ops if op.engine == "flow" and op.op == "add_imm"]
    load_ops = [op for op in ops if op.engine == "load" and op.op == "load"]
    store_ops = [op for op in ops if op.engine == "store" and op.op == "store"]

    assert len(load_ops) >= 8
    assert len(store_ops) >= 8
    assert any(op.params.get("imm") == 1 for op in add_imm_ops)
