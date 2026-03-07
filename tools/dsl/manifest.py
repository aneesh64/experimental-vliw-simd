from __future__ import annotations

from dataclasses import asdict, dataclass
from typing import Dict, Optional, Tuple


@dataclass(frozen=True)
class KernelManifest:
    kernel_name: str
    required_bindings: Tuple[str, ...]
    resolved_bindings: Dict[str, int]
    scratch_map: Dict[str, int]
    scratch_size: int
    bundle_count: int
    binary_bundle_count: int
    launch_requirements: Dict[str, int]
    slot_usage: Dict[str, int]

    def to_dict(self) -> Dict[str, object]:
        return asdict(self)


@dataclass(frozen=True)
class GraphManifest:
    graph_name: str
    nodes: Dict[str, KernelManifest]
    launches: Dict[str, Tuple[int, ...]]
    edges: Tuple[Tuple[str, str, Optional[Tuple[str, str]]], ...]

    def to_dict(self) -> Dict[str, object]:
        data = asdict(self)
        data["nodes"] = {name: manifest.to_dict() for name, manifest in self.nodes.items()}
        return data
