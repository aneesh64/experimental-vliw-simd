#!/usr/bin/env python3

import sys
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from dsl import KernelBuilder, U8, U16, U32, compile_kernel, HardwareCapabilities, tile_1d


def test_vector_helper_methods_append_expected_ops():
    kb = KernelBuilder("helper_kernel")
    scalar = kb.arg_scalar("scalar", default=3)
    src = kb.vector("src", dtype=U8, scratch_base=64)
    tmp = kb.vector("tmp", dtype=U8, scratch_base=72)
    dst = kb.vector("dst", dtype=U8, scratch_base=80)

    kb.vector_fill(tmp, scalar, ew=8)
    kb.vector_map("add", dst, src, tmp, ew=8)
    kb.vector_copy(src, dst, ew=8)

    ops = kb.build().ops
    assert ops[0].__class__.__name__ == "VectorBroadcast"
    assert ops[1].__class__.__name__ == "VectorBinary"
    assert ops[2].__class__.__name__ == "VectorCast"


def test_lane_alias_and_store_lane_helpers():
    kb = KernelBuilder("lane_store")
    out = kb.arg_dmem_tensor("out", shape=(1,), dtype=U32)
    out_ptr = kb.scalar("out_ptr")
    vec = kb.vector("vec", dtype=U8, scratch_base=200)

    lane0 = kb.lane(vec, 0)
    lane7 = kb.lane("vec", 7, name="last")
    assert lane0.scratch_base == 200
    assert lane7.scratch_base == 207

    kb.address_of(out_ptr, out)
    kb.store_lane(out_ptr, vec, 0)

    result = compile_kernel(kb.build(), HardwareCapabilities.from_configs(), assemble=False, bindings={"out": 300})
    assert result.scratch_map["vec"] == 200
    assert result.scratch_map["vec_lane_0"] == 200
    assert result.scratch_map["last"] == 207


def test_lane_alias_requires_explicit_scratch_base():
    kb = KernelBuilder("lane_alias_error")
    vec = kb.vector("vec", dtype=U8)
    try:
        kb.lane(vec, 0)
    except ValueError as exc:
        assert "explicit scratch_base" in str(exc)
    else:
        raise AssertionError("Expected lane() to reject vectors without explicit scratch base")


def test_vload_view_and_vstore_view_helpers_append_expected_ops():
    kb = KernelBuilder("view_load_store")
    src = kb.arg_dmem_tensor("src", shape=(8,), dtype=U32)
    dst = kb.arg_dmem_tensor("dst", shape=(8,), dtype=U32)
    vec = kb.vector("vec", dtype=U32, scratch_base=320)

    kb.vload_view(vec, tile_1d(src, length=8), addr_name="src_ptr")
    kb.vstore_view(tile_1d(dst, length=8), vec, addr_name="dst_ptr")

    ops = kb.build().ops
    assert ops[0].__class__.__name__ == "AddressOf"
    assert ops[1].__class__.__name__ == "VectorLoad"
    assert ops[2].__class__.__name__ == "AddressOf"
    assert ops[3].__class__.__name__ == "VectorStore"


def test_vload_view_and_vstore_view_lower_with_symbolic_bindings():
    kb = KernelBuilder("view_load_store_lower")
    src = kb.arg_dmem_tensor("src", shape=(8,), dtype=U32)
    dst = kb.arg_dmem_tensor("dst", shape=(8,), dtype=U32)
    vec = kb.vector("vec", dtype=U32, scratch_base=320)

    kb.vload_view(vec, tile_1d(src, length=8), addr_name="src_ptr")
    kb.vstore_view(tile_1d(dst, length=8), vec, addr_name="dst_ptr")
    kb.halt()

    result = compile_kernel(
        kb.build(),
        HardwareCapabilities.from_configs(),
        assemble=False,
        bindings={"src": 100, "dst": 200},
    )
    assert result.resolved_bindings["src"] == 100
    assert result.resolved_bindings["dst"] == 200
    assert result.scratch_map["vec"] == 320
    assert "src_ptr" in result.scratch_map
    assert "dst_ptr" in result.scratch_map


def test_accumulate_lanes_expands_to_scalar_adds():
    kb = KernelBuilder("accumulate_lanes")
    total = kb.scalar("total", scratch_base=40)
    vec = kb.vector("vec", dtype=U32, scratch_base=200)

    kb.const(total, 0)
    kb.accumulate_lanes(total, vec, lanes=[0, 3, 7], alias_prefix="acc")

    result = compile_kernel(kb.build(), HardwareCapabilities.from_configs(), assemble=False)
    assert result.scratch_map["acc_lane_0"] == 200
    assert result.scratch_map["acc_lane_3"] == 203
    assert result.scratch_map["acc_lane_7"] == 207
    add_ops = [op for op in result.operations if getattr(op, "op", None) == "add"]
    assert len(add_ops) == 3


def test_vector_map_supports_multiwidth_sub_ops():
    kb = KernelBuilder("helper_multiwidth_sub")
    lhs = kb.vector("lhs", dtype=U16, scratch_base=320)
    rhs = kb.vector("rhs", dtype=U16, scratch_base=328)
    out = kb.vector("out", dtype=U16, scratch_base=336)

    kb.vector_map("sub", out, lhs, rhs, ew=16)

    ops = kb.build().ops
    assert len(ops) == 1
    assert ops[0].__class__.__name__ == "VectorBinary"
    assert ops[0].ew == 16
    assert ops[0].op == "sub"


def test_vcast_supports_8_to_16_widening():
    kb = KernelBuilder("helper_vcast_8to16")
    src = kb.vector("src", dtype=U8, scratch_base=320)
    dst = kb.vector("dst", dtype=U16, scratch_base=328)

    kb.vcast(dst, src, ew=8, dw=16, signed=0, upper=0)

    ops = kb.build().ops
    assert len(ops) == 1
    assert ops[0].__class__.__name__ == "VectorCast"
    assert ops[0].ew == 8
    assert ops[0].dw == 16


def test_vector_map_supports_multiwidth_xor_ops():
    kb = KernelBuilder("helper_multiwidth_xor")
    lhs = kb.vector("lhs", dtype=U8, scratch_base=320)
    rhs = kb.vector("rhs", dtype=U8, scratch_base=328)
    out = kb.vector("out", dtype=U8, scratch_base=336)

    kb.vector_map("xor", out, lhs, rhs, ew=8)

    ops = kb.build().ops
    assert len(ops) == 1
    assert ops[0].__class__.__name__ == "VectorBinary"
    assert ops[0].ew == 8
    assert ops[0].op == "xor"


def test_vcast_supports_8_to_32_signed_widening():
    kb = KernelBuilder("helper_vcast_8to32_signed")
    src = kb.vector("src", dtype=U8, scratch_base=320)
    dst = kb.vector("dst", dtype=U32, scratch_base=328)

    kb.vcast(dst, src, ew=8, dw=32, signed=1, upper=0)

    ops = kb.build().ops
    assert len(ops) == 1
    assert ops[0].__class__.__name__ == "VectorCast"
    assert ops[0].ew == 8
    assert ops[0].dw == 32
    assert ops[0].signed == 1
