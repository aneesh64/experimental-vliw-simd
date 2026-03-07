#!/usr/bin/env python3

import sys
from pathlib import Path

TOOLS_DIR = Path(__file__).resolve().parents[1]
if str(TOOLS_DIR) not in sys.path:
    sys.path.insert(0, str(TOOLS_DIR))

from dsl import GraphCompiler, HardwareCapabilities, KernelBuilder, KernelGraph, LaunchSpec, compile_kernel


def test_kernel_manifest_contains_bindings_and_bundles():
    kb = KernelBuilder("manifest_kernel")
    out = kb.arg_dmem_tensor("out", shape=(1,))
    ptr = kb.scalar("ptr")
    value = kb.arg_scalar("value", default=9)
    kb.address_of(ptr, out)
    kb.store(ptr, value)
    kb.halt()

    result = compile_kernel(kb.build(), HardwareCapabilities.from_configs(), assemble=True, bindings={"out": 100, "value": 7})
    manifest = result.to_manifest()

    assert manifest.kernel_name == "manifest_kernel"
    assert manifest.required_bindings == ("out", "value")
    assert manifest.resolved_bindings["out"] == 100
    assert manifest.bundle_count == len(result.scheduled_bundles)
    assert manifest.binary_bundle_count == len(result.binary_bundles or [])
    assert manifest.slot_usage["store"] >= 1


def test_graph_manifest_contains_launches_and_edges():
    producer = KernelBuilder("producer")
    producer.arg_scalar("value", default=1)
    producer.halt()

    consumer = KernelBuilder("consumer")
    consumer.arg_scalar("value", default=2)
    consumer.halt()

    graph = KernelGraph("manifest_graph")
    graph.add_kernel("producer", producer.build(), launch=LaunchSpec.single(0), bindings={"value": 3})
    graph.add_kernel("consumer", consumer.build(), launch=LaunchSpec.replicated(), bindings={"value": 4})
    graph.add_dependency("producer", "consumer", via=("value", "value"))

    caps = HardwareCapabilities.from_configs(n_cores=2)
    compiled = GraphCompiler(caps).compile(graph, assemble=False)
    manifest = compiled.to_manifest()

    assert manifest.graph_name == "manifest_graph"
    assert manifest.launches["producer"] == (0,)
    assert manifest.launches["consumer"] == (0, 1)
    assert manifest.edges[0] == ("producer", "consumer", ("value", "value"))
    assert manifest.nodes["producer"].resolved_bindings["value"] == 3
