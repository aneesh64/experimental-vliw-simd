from __future__ import annotations

from dataclasses import dataclass, field
from typing import Dict, Optional, Tuple

from .capabilities import HardwareCapabilities
from .manifest import GraphManifest
from .ir import Kernel
from .lowering import DslLowerer, LoweringResult


@dataclass(frozen=True)
class LaunchSpec:
    mode: str = "single"
    core_ids: Tuple[int, ...] = ()

    @classmethod
    def single(cls, core_id: int = 0) -> "LaunchSpec":
        return cls(mode="single", core_ids=(core_id,))

    @classmethod
    def replicated(cls, core_ids: Tuple[int, ...] = ()) -> "LaunchSpec":
        return cls(mode="replicated", core_ids=core_ids)

    @classmethod
    def explicit(cls, *core_ids: int) -> "LaunchSpec":
        return cls(mode="explicit", core_ids=tuple(core_ids))


@dataclass(frozen=True)
class GraphNode:
    name: str
    kernel: Kernel
    launch: LaunchSpec = field(default_factory=LaunchSpec.single)
    bindings: Dict[str, int] = field(default_factory=dict)
    metadata: Dict[str, object] = field(default_factory=dict)


@dataclass(frozen=True)
class GraphEdge:
    src: str
    dst: str
    via: Optional[Tuple[str, str]] = None


@dataclass
class KernelGraph:
    name: str
    nodes: Dict[str, GraphNode] = field(default_factory=dict)
    edges: list[GraphEdge] = field(default_factory=list)

    def add_kernel(
        self,
        name: str,
        kernel: Kernel,
        *,
        launch: Optional[LaunchSpec] = None,
        bindings: Optional[Dict[str, int]] = None,
        metadata: Optional[Dict[str, object]] = None,
    ) -> GraphNode:
        if name in self.nodes:
            raise ValueError(f"Graph node '{name}' is already defined")
        node = GraphNode(
            name=name,
            kernel=kernel,
            launch=launch or LaunchSpec.single(),
            bindings=bindings or {},
            metadata=metadata or {},
        )
        self.nodes[name] = node
        return node

    def add_dependency(self, src: str, dst: str, *, via: Optional[Tuple[str, str]] = None) -> GraphEdge:
        if src not in self.nodes:
            raise KeyError(f"Unknown source node '{src}'")
        if dst not in self.nodes:
            raise KeyError(f"Unknown destination node '{dst}'")
        edge = GraphEdge(src=src, dst=dst, via=via)
        self.edges.append(edge)
        return edge


@dataclass(frozen=True)
class CompiledKernelGraph:
    graph: KernelGraph
    capabilities: HardwareCapabilities
    launches: Dict[str, LaunchSpec]
    compiled_nodes: Dict[str, LoweringResult]
    edges: Tuple[GraphEdge, ...]

    def to_manifest(self) -> GraphManifest:
        return GraphManifest(
            graph_name=self.graph.name,
            nodes={name: result.to_manifest() for name, result in self.compiled_nodes.items()},
            launches={name: launch.core_ids for name, launch in self.launches.items()},
            edges=tuple((edge.src, edge.dst, edge.via) for edge in self.edges),
        )


class GraphCompiler:
    def __init__(self, capabilities: HardwareCapabilities):
        self.capabilities = capabilities
        self.lowerer = DslLowerer(capabilities)

    def compile(self, graph: KernelGraph, *, assemble: bool = True) -> CompiledKernelGraph:
        launches: Dict[str, LaunchSpec] = {}
        compiled_nodes: Dict[str, LoweringResult] = {}
        for name, node in graph.nodes.items():
            resolved_launch = self._resolve_launch(node.launch)
            launches[name] = resolved_launch
            compiled_nodes[name] = self.lowerer.lower(node.kernel, assemble=assemble, bindings=node.bindings)
        return CompiledKernelGraph(
            graph=graph,
            capabilities=self.capabilities,
            launches=launches,
            compiled_nodes=compiled_nodes,
            edges=tuple(graph.edges),
        )

    def _resolve_launch(self, launch: LaunchSpec) -> LaunchSpec:
        if launch.mode == "single":
            core_ids = launch.core_ids or (0,)
        elif launch.mode == "replicated":
            core_ids = launch.core_ids or tuple(range(self.capabilities.n_cores))
        elif launch.mode == "explicit":
            if not launch.core_ids:
                raise ValueError("Explicit launch requires at least one core id")
            core_ids = launch.core_ids
        else:
            raise ValueError(f"Unknown launch mode '{launch.mode}'")

        for core_id in core_ids:
            if core_id < 0 or core_id >= self.capabilities.n_cores:
                raise ValueError(
                    f"Launch references core {core_id}, but target only exposes {self.capabilities.n_cores} cores"
                )
        return LaunchSpec(mode=launch.mode, core_ids=tuple(core_ids))
