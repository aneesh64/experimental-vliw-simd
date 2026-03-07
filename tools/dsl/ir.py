from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Dict, List, Optional, Tuple


class MemorySpace(str, Enum):
    DMEM = "dmem"
    SCRATCH_SCALAR = "scratch_scalar"
    SCRATCH_VECTOR = "scratch_vector"


@dataclass(frozen=True)
class DType:
    bits: int
    signed: bool = False

    @property
    def is_vector_legal(self) -> bool:
        return self.bits in (4, 8, 16, 32, 64)


U8 = DType(8, signed=False)
U16 = DType(16, signed=False)
U32 = DType(32, signed=False)
U64 = DType(64, signed=False)
I8 = DType(8, signed=True)
I16 = DType(16, signed=True)
I32 = DType(32, signed=True)
I64 = DType(64, signed=True)


@dataclass(frozen=True)
class Buffer:
    name: str
    shape: Tuple[int, ...]
    dtype: DType
    space: MemorySpace
    alignment_words: int = 1
    scratch_base: Optional[int] = None

    @property
    def elements(self) -> int:
        if not self.shape:
            return 1
        total = 1
        for dim in self.shape:
            if dim <= 0:
                raise ValueError(f"Buffer '{self.name}' has unresolved or invalid shape {self.shape}")
            total *= dim
        return total

    @property
    def is_scalar(self) -> bool:
        return self.elements == 1

    @property
    def is_vector(self) -> bool:
        return self.elements > 1


@dataclass(frozen=True)
class KernelArgument:
    name: str
    kind: str
    dtype: DType
    shape: Tuple[int, ...] = ()
    default: Optional[int] = None


@dataclass(frozen=True)
class KernelOp:
    pass


@dataclass(frozen=True)
class LoadImmediate(KernelOp):
    dest: str
    value: int


@dataclass(frozen=True)
class ScalarLoad(KernelOp):
    dest: str
    addr: str
    memory_domain: str = "scalar"


@dataclass(frozen=True)
class ScalarStore(KernelOp):
    addr: str
    src: str
    memory_domain: str = "scalar"


@dataclass(frozen=True)
class VectorLoad(KernelOp):
    dest: str
    addr: str


@dataclass(frozen=True)
class VectorStore(KernelOp):
    addr: str
    src: str


@dataclass(frozen=True)
class ScalarBinary(KernelOp):
    op: str
    dest: str
    lhs: str
    rhs: str


@dataclass(frozen=True)
class VectorBinary(KernelOp):
    op: str
    dest: str
    lhs: str
    rhs: str
    ew: int
    dw: Optional[int] = None
    signed: int = 0


@dataclass(frozen=True)
class VectorBroadcast(KernelOp):
    dest: str
    src: str
    ew: int = 32


@dataclass(frozen=True)
class VectorCast(KernelOp):
    dest: str
    src: str
    ew: int
    dw: int
    signed: int = 0
    upper: int = 0


@dataclass(frozen=True)
class AddImmediate(KernelOp):
    dest: str
    src: str
    imm: int


@dataclass(frozen=True)
class AddressOf(KernelOp):
    dest: str
    buffer: str
    offset_words: int = 0


@dataclass(frozen=True)
class Label(KernelOp):
    name: str


@dataclass(frozen=True)
class Jump(KernelOp):
    target: str


@dataclass(frozen=True)
class CondJump(KernelOp):
    cond: str
    target: str


@dataclass(frozen=True)
class ReadCoreId(KernelOp):
    dest: str


@dataclass(frozen=True)
class Halt(KernelOp):
    pass


@dataclass
class Kernel:
    name: str
    buffers: Dict[str, Buffer] = field(default_factory=dict)
    arguments: Dict[str, KernelArgument] = field(default_factory=dict)
    ops: List[KernelOp] = field(default_factory=list)
    metadata: Dict[str, Any] = field(default_factory=dict)
