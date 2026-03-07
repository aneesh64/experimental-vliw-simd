#!/usr/bin/env python3

import sys
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from assembler import AssemblerConfig
from dsl import GraphCompiler, HardwareCapabilities, KernelBuilder, KernelGraph, LaunchSpec, U32, compile_kernel, tile_1d


def test_control_flow_label_and_cond_jump_lowering():
    kb = KernelBuilder("count_loop")
    counter = kb.scalar("counter")
    limit = kb.scalar("limit")
    one = kb.scalar("one")
    cond = kb.scalar("cond")

    kb.const(counter, 0)
    kb.const(limit, 4)
    kb.const(one, 1)
    kb.label("loop")
    kb.add(counter, counter, one)
    kb.binary("lt", cond, counter, limit)
    kb.cond_jump(cond, "loop")
    kb.halt()

    result = compile_kernel(kb.build(), HardwareCapabilities.from_configs(), assemble=False)

    assert any(getattr(op, "name", None) == "loop" for op in result.operations)
    flow_slots = [slot for bundle in result.scheduled_bundles for slot in bundle.get("flow", [])]
    assert any(slot[0] == "cond_jump" for slot in flow_slots)


def test_kernel_graph_compiles_and_resolves_launches():
    producer = KernelBuilder("producer")
    p_out = producer.arg_scalar("out", default=7)
    producer.halt()

    consumer = KernelBuilder("consumer")
    c_out = consumer.scalar("out")
    consumer.coreid(c_out).halt()

    graph = KernelGraph("pipeline")
    graph.add_kernel("producer", producer.build(), launch=LaunchSpec.single(0), bindings={"out": 11})
    graph.add_kernel("consumer", consumer.build(), launch=LaunchSpec.replicated())
    graph.add_dependency("producer", "consumer", via=("out", "out"))

    caps = HardwareCapabilities.from_configs(
        assembler_config=AssemblerConfig(vlen=8, scratch_size=128),
        n_cores=2,
    )
    compiled = GraphCompiler(caps).compile(graph, assemble=False)

    assert compiled.launches["producer"].core_ids == (0,)
    assert compiled.launches["consumer"].core_ids == (0, 1)
    assert set(compiled.compiled_nodes.keys()) == {"producer", "consumer"}
    assert compiled.compiled_nodes["producer"].resolved_bindings["out"] == 11
    assert compiled.edges[0].via == ("out", "out")


def test_helper_kernels_compile_inside_graph_with_view_bindings():
    loader = KernelBuilder("loader")
    src = loader.arg_dmem_tensor("src", shape=(8,), dtype=U32)
    tmp = loader.arg_dmem_tensor("tmp", shape=(8,), dtype=U32)
    src_vec = loader.vector("src_vec", dtype=U32, scratch_base=320)

    loader.vload_view(src_vec, tile_1d(src, length=8), addr_name="src_ptr")
    loader.vstore_view(tile_1d(tmp, length=8), src_vec, addr_name="tmp_ptr")
    loader.halt()

    consumer = KernelBuilder("consumer")
    tmp_in = consumer.arg_dmem_tensor("tmp", shape=(8,), dtype=U32)
    out = consumer.arg_dmem_tensor("out", shape=(8,), dtype=U32)
    bias = consumer.arg_scalar("bias", default=3)
    tmp_vec = consumer.vector("tmp_vec", dtype=U32, scratch_base=320)
    bias_vec = consumer.vector("bias_vec", dtype=U32, scratch_base=328)
    out_vec = consumer.vector("out_vec", dtype=U32, scratch_base=336)

    consumer.vload_view(tmp_vec, tile_1d(tmp_in, length=8), addr_name="tmp_in_ptr")
    consumer.vector_fill(bias_vec, bias, ew=32)
    consumer.vector_map("add", out_vec, tmp_vec, bias_vec, ew=32)
    consumer.vstore_view(tile_1d(out, length=8), out_vec, addr_name="out_ptr")
    consumer.halt()

    graph = KernelGraph("view_pipeline")
    graph.add_kernel(
        "loader",
        loader.build(),
        launch=LaunchSpec.single(0),
        bindings={"src": 64, "tmp": 96},
    )
    graph.add_kernel(
        "consumer",
        consumer.build(),
        launch=LaunchSpec.explicit(1),
        bindings={"tmp": 96, "out": 128, "bias": 5},
    )
    graph.add_dependency("loader", "consumer", via=("tmp", "tmp"))

    caps = HardwareCapabilities.from_configs(
        assembler_config=AssemblerConfig(vlen=8, scratch_size=512),
        n_cores=2,
    )
    compiled = GraphCompiler(caps).compile(graph, assemble=False)
    manifest = compiled.to_manifest()

    assert compiled.launches["loader"].core_ids == (0,)
    assert compiled.launches["consumer"].core_ids == (1,)
    assert compiled.compiled_nodes["loader"].resolved_bindings["src"] == 64
    assert compiled.compiled_nodes["consumer"].resolved_bindings["bias"] == 5
    assert manifest.edges[0] == ("loader", "consumer", ("tmp", "tmp"))
