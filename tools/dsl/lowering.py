from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List, Optional, cast

from assembler import Assembler
from scheduler import Label as SchedulerLabel, MemoryDomain, Op, VliwScheduler

from .capabilities import HardwareCapabilities
from .manifest import KernelManifest
from .ir import (
    AddressOf,
    AddImmediate,
    Buffer,
    CondJump,
    Halt,
    Jump,
    Kernel,
    Label,
    LoadImmediate,
    MemorySpace,
    ReadCoreId,
    ScalarBinary,
    ScalarLoad,
    ScalarStore,
    VectorBinary,
    VectorBroadcast,
    VectorCast,
    VectorLoad,
    VectorStore,
)


@dataclass(frozen=True)
class LoweringResult:
    kernel: Kernel
    capabilities: HardwareCapabilities
    scratch_map: Dict[str, int]
    required_bindings: tuple[str, ...]
    resolved_bindings: Dict[str, int]
    operations: List[Op | SchedulerLabel]
    scheduled_bundles: List[dict]
    binary_bundles: Optional[List[int]] = None

    def to_manifest(self) -> KernelManifest:
        slot_usage = {
            engine: sum(len(bundle.get(engine, [])) for bundle in self.scheduled_bundles)
            for engine in ("alu", "valu", "load", "store", "flow")
        }
        return KernelManifest(
            kernel_name=self.kernel.name,
            required_bindings=self.required_bindings,
            resolved_bindings=dict(self.resolved_bindings),
            scratch_map=dict(self.scratch_map),
            scratch_size=self.capabilities.scratch_size,
            bundle_count=len(self.scheduled_bundles),
            binary_bundle_count=len(self.binary_bundles) if self.binary_bundles is not None else 0,
            launch_requirements={"max_cores": self.capabilities.n_cores},
            slot_usage=slot_usage,
        )


class ScratchAllocator:
    def __init__(self, capabilities: HardwareCapabilities):
        self.capabilities = capabilities
        self.next_addr = 0

    def allocate_all(self, kernel: Kernel) -> Dict[str, int]:
        scratch_map: Dict[str, int] = {}
        for buffer in kernel.buffers.values():
            if buffer.space == MemorySpace.DMEM:
                continue
            scratch_map[buffer.name] = self._allocate_buffer(buffer)
        return scratch_map

    def _allocate_buffer(self, buffer: Buffer) -> int:
        if buffer.scratch_base is not None:
            base = buffer.scratch_base
        else:
            align = max(1, buffer.alignment_words)
            if buffer.space == MemorySpace.SCRATCH_VECTOR:
                align = max(align, self.capabilities.vector_alignment_words)
            base = self._align_up(self.next_addr, align)

        size = buffer.elements
        end = base + size
        if end > self.capabilities.scratch_size:
            raise ValueError(
                f"Buffer '{buffer.name}' requires scratch range [{base}, {end}), "
                f"but target scratch_size={self.capabilities.scratch_size}"
            )

        if buffer.scratch_base is None:
            self.next_addr = end
        else:
            self.next_addr = max(self.next_addr, end)
        return base

    @staticmethod
    def _align_up(value: int, align: int) -> int:
        return ((value + align - 1) // align) * align


class DslLowerer:
    def __init__(
        self,
        capabilities: HardwareCapabilities,
        *,
        scheduler: Optional[VliwScheduler] = None,
        assembler: Optional[Assembler] = None,
    ):
        self.capabilities = capabilities
        self.scheduler = scheduler or VliwScheduler(capabilities.to_scheduler_config())
        self.assembler = assembler or Assembler(capabilities.to_assembler_config())

    def lower(
        self,
        kernel: Kernel,
        *,
        assemble: bool = True,
        bindings: Optional[Dict[str, int]] = None,
    ) -> LoweringResult:
        scratch_map = ScratchAllocator(self.capabilities).allocate_all(kernel)
        resolved_bindings = self._resolve_bindings(kernel, bindings)
        operations: List[Op | SchedulerLabel] = []
        operations.extend(self._emit_argument_prologue(kernel, scratch_map, resolved_bindings))
        operations.extend(self._lower_op(op, kernel, scratch_map, resolved_bindings) for op in kernel.ops)
        scheduled = self.scheduler.schedule(operations)
        binary = self.assembler.assemble_program(scheduled) if assemble else None
        return LoweringResult(
            kernel=kernel,
            capabilities=self.capabilities,
            scratch_map=scratch_map,
            required_bindings=tuple(kernel.arguments.keys()),
            resolved_bindings=resolved_bindings,
            operations=operations,
            scheduled_bundles=scheduled,
            binary_bundles=binary,
        )

    def _emit_argument_prologue(
        self,
        kernel: Kernel,
        scratch_map: Dict[str, int],
        bindings: Dict[str, int],
    ) -> List[Op]:
        prologue: List[Op] = []
        for argument in kernel.arguments.values():
            if argument.kind != "scalar":
                continue
            prologue.append(self.scheduler.const(self._addr(argument.name, scratch_map), bindings[argument.name]))
        return prologue

    def _resolve_bindings(self, kernel: Kernel, bindings: Optional[Dict[str, int]]) -> Dict[str, int]:
        provided = bindings or {}
        resolved: Dict[str, int] = {}
        for argument in kernel.arguments.values():
            if argument.name in provided:
                resolved[argument.name] = provided[argument.name]
            elif argument.default is not None:
                resolved[argument.name] = argument.default
            else:
                raise ValueError(f"Kernel '{kernel.name}' requires binding for argument '{argument.name}'")
        return resolved

    def _lower_op(
        self,
        op,
        kernel: Kernel,
        scratch_map: Dict[str, int],
        bindings: Dict[str, int],
    ) -> Op | SchedulerLabel:
        if isinstance(op, LoadImmediate):
            dest = self._addr(op.dest, scratch_map)
            return self.scheduler.const(dest, op.value)

        if isinstance(op, AddressOf):
            dest = self._addr(op.dest, scratch_map)
            base = self._resolve_buffer_address(op.buffer, kernel, scratch_map, bindings)
            return self.scheduler.const(dest, base + op.offset_words)

        if isinstance(op, ScalarLoad):
            self._require_scalar_buffer(op.dest, kernel)
            dest = self._addr(op.dest, scratch_map)
            addr = self._addr(op.addr, scratch_map)
            return self.scheduler.load(dest, addr, memory_domain=cast(MemoryDomain, op.memory_domain))

        if isinstance(op, ScalarStore):
            addr = self._addr(op.addr, scratch_map)
            src = self._addr(op.src, scratch_map)
            return self.scheduler.store(addr, src, memory_domain=cast(MemoryDomain, op.memory_domain))

        if isinstance(op, VectorLoad):
            dest_buf = self._buffer(op.dest, kernel)
            self._require_full_target_vector(dest_buf)
            dest = self._addr(op.dest, scratch_map)
            addr = self._addr(op.addr, scratch_map)
            return self.scheduler.vload(dest, addr, vlen=dest_buf.elements)

        if isinstance(op, VectorStore):
            src_buf = self._buffer(op.src, kernel)
            self._require_full_target_vector(src_buf)
            addr = self._addr(op.addr, scratch_map)
            src = self._addr(op.src, scratch_map)
            return self.scheduler.vstore(addr, src, vlen=src_buf.elements)

        if isinstance(op, ScalarBinary):
            self.capabilities.require_scalar_op(op.op)
            dest = self._addr(op.dest, scratch_map)
            lhs = self._addr(op.lhs, scratch_map)
            rhs = self._addr(op.rhs, scratch_map)
            constructor = getattr(self.scheduler, op.op)
            return constructor(dest, lhs, rhs)

        if isinstance(op, VectorBinary):
            self.capabilities.require_vector_op(op.op)
            self.capabilities.require_element_width(op.ew)
            dw = op.dw or op.ew
            self.capabilities.require_element_width(dw)
            dest_buf = self._buffer(op.dest, kernel)
            lhs_buf = self._buffer(op.lhs, kernel)
            rhs_buf = self._buffer(op.rhs, kernel)
            self._require_matching_vector_shapes(dest_buf, lhs_buf, rhs_buf)
            return self.scheduler.valu_op(
                op.op,
                self._addr(op.dest, scratch_map),
                self._addr(op.lhs, scratch_map),
                self._addr(op.rhs, scratch_map),
                vlen=dest_buf.elements,
                ew=op.ew,
                dw=dw,
                signed=op.signed,
            )

        if isinstance(op, VectorBroadcast):
            self.capabilities.require_vector_op("vbroadcast")
            self.capabilities.require_element_width(op.ew)
            dest_buf = self._buffer(op.dest, kernel)
            self._require_full_target_vector(dest_buf)
            return self.scheduler.vbroadcast(
                self._addr(op.dest, scratch_map),
                self._addr(op.src, scratch_map),
                vlen=dest_buf.elements,
                ew=op.ew,
            )

        if isinstance(op, VectorCast):
            self.capabilities.require_vector_op("vcast")
            self.capabilities.require_element_width(op.ew)
            self.capabilities.require_element_width(op.dw)
            dest_buf = self._buffer(op.dest, kernel)
            src_buf = self._buffer(op.src, kernel)
            self._require_matching_vector_shapes(dest_buf, src_buf)
            return self.scheduler.vcast(
                self._addr(op.dest, scratch_map),
                self._addr(op.src, scratch_map),
                ew=op.ew,
                dw=op.dw,
                signed=op.signed,
                upper=op.upper,
                vlen=dest_buf.elements,
            )

        if isinstance(op, AddImmediate):
            return self.scheduler.add_imm(
                self._addr(op.dest, scratch_map),
                self._addr(op.src, scratch_map),
                op.imm,
            )

        if isinstance(op, Label):
            return self.scheduler.label(op.name)

        if isinstance(op, Jump):
            return self.scheduler.jump(op.target)

        if isinstance(op, CondJump):
            return self.scheduler.cond_jump(self._addr(op.cond, scratch_map), op.target)

        if isinstance(op, ReadCoreId):
            return self.scheduler.coreid(self._addr(op.dest, scratch_map))

        if isinstance(op, Halt):
            return self.scheduler.halt()

        raise TypeError(f"Unsupported DSL op for lowering: {type(op).__name__}")

    def _buffer(self, name: str, kernel: Kernel) -> Buffer:
        if name not in kernel.buffers:
            raise KeyError(f"Unknown buffer '{name}' in kernel '{kernel.name}'")
        return kernel.buffers[name]

    def _resolve_buffer_address(
        self,
        name: str,
        kernel: Kernel,
        scratch_map: Dict[str, int],
        bindings: Dict[str, int],
    ) -> int:
        buffer = self._buffer(name, kernel)
        if buffer.space == MemorySpace.DMEM:
            if name not in bindings:
                raise ValueError(f"Kernel '{kernel.name}' requires DMEM binding for buffer '{name}'")
            return bindings[name]
        return self._addr(name, scratch_map)

    def _addr(self, name: str, scratch_map: Dict[str, int]) -> int:
        if name not in scratch_map:
            raise KeyError(f"Buffer '{name}' does not have a scratch allocation")
        return scratch_map[name]

    def _require_scalar_buffer(self, name: str, kernel: Kernel) -> None:
        buf = self._buffer(name, kernel)
        if not buf.is_scalar:
            raise ValueError(f"Buffer '{name}' must be scalar for this operation")

    def _require_full_target_vector(self, buffer: Buffer) -> None:
        if not buffer.is_vector:
            raise ValueError(f"Buffer '{buffer.name}' must be vector-shaped")
        if buffer.elements != self.capabilities.vlen:
            raise ValueError(
                f"Buffer '{buffer.name}' has length {buffer.elements}; initial DSL lowering "
                f"currently requires full target vectors of length {self.capabilities.vlen}"
            )

    def _require_matching_vector_shapes(self, *buffers: Buffer) -> None:
        for buffer in buffers:
            self._require_full_target_vector(buffer)
        lengths = {buffer.elements for buffer in buffers}
        if len(lengths) != 1:
            raise ValueError("All vector operands must have the same logical length")


def compile_kernel(
    kernel: Kernel,
    capabilities: HardwareCapabilities,
    *,
    assemble: bool = True,
    bindings: Optional[Dict[str, int]] = None,
) -> LoweringResult:
    return DslLowerer(capabilities).lower(kernel, assemble=assemble, bindings=bindings)
