from __future__ import annotations

from typing import Callable, Optional, Sequence

from .layout import TensorView, tile_1d
from .ir import (
    AddressOf,
    AddImmediate,
    Buffer,
    CondJump,
    DType,
    Halt,
    Jump,
    Kernel,
    KernelArgument,
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
    U32,
)


class KernelBuilder:
    """Small but capability-aware builder for the first DSL implementation phase."""

    def __init__(self, name: str):
        self._kernel = Kernel(name=name)
        self._temp_counter = 0

    def scalar(
        self,
        name: str,
        *,
        dtype: DType = U32,
        scratch_base: Optional[int] = None,
    ) -> Buffer:
        buf = Buffer(
            name=name,
            shape=(),
            dtype=dtype,
            space=MemorySpace.SCRATCH_SCALAR,
            alignment_words=1,
            scratch_base=scratch_base,
        )
        return self._register(buf)

    def arg_scalar(
        self,
        name: str,
        *,
        dtype: DType = U32,
        scratch_base: Optional[int] = None,
        default: Optional[int] = None,
    ) -> Buffer:
        buf = self.scalar(name, dtype=dtype, scratch_base=scratch_base)
        self._register_argument(KernelArgument(name=name, kind="scalar", dtype=dtype, default=default))
        return buf

    def vector(
        self,
        name: str,
        *,
        length: int = 8,
        dtype: DType = U32,
        alignment_words: Optional[int] = None,
        scratch_base: Optional[int] = None,
    ) -> Buffer:
        buf = Buffer(
            name=name,
            shape=(length,),
            dtype=dtype,
            space=MemorySpace.SCRATCH_VECTOR,
            alignment_words=alignment_words or length,
            scratch_base=scratch_base,
        )
        return self._register(buf)

    def dmem_tensor(
        self,
        name: str,
        *,
        shape: tuple[int, ...],
        dtype: DType = U32,
    ) -> Buffer:
        buf = Buffer(name=name, shape=shape, dtype=dtype, space=MemorySpace.DMEM)
        return self._register(buf)

    def arg_dmem_tensor(
        self,
        name: str,
        *,
        shape: tuple[int, ...],
        dtype: DType = U32,
    ) -> Buffer:
        buf = self.dmem_tensor(name, shape=shape, dtype=dtype)
        self._register_argument(KernelArgument(name=name, kind="buffer", dtype=dtype, shape=shape))
        return buf

    def const(self, dest: Buffer | str, value: int) -> "KernelBuilder":
        self._kernel.ops.append(LoadImmediate(self._name(dest), value))
        return self

    def load(self, dest: Buffer | str, addr: Buffer | str, *, memory_domain: str = "scalar") -> "KernelBuilder":
        self._kernel.ops.append(ScalarLoad(self._name(dest), self._name(addr), memory_domain=memory_domain))
        return self

    def load_view(
        self,
        dest: Buffer | str,
        view: TensorView,
        *,
        addr: Buffer | str | None = None,
        addr_name: Optional[str] = None,
        memory_domain: str = "scalar",
    ) -> "KernelBuilder":
        ptr = self._ensure_pointer(addr, addr_name=addr_name or f"{self._name(dest)}_ptr")
        self.address_of_view(ptr, view)
        return self.load(dest, ptr, memory_domain=memory_domain)

    def store(self, addr: Buffer | str, src: Buffer | str, *, memory_domain: str = "scalar") -> "KernelBuilder":
        self._kernel.ops.append(ScalarStore(self._name(addr), self._name(src), memory_domain=memory_domain))
        return self

    def store_view(
        self,
        view: TensorView,
        src: Buffer | str,
        *,
        addr: Buffer | str | None = None,
        addr_name: Optional[str] = None,
        memory_domain: str = "scalar",
    ) -> "KernelBuilder":
        ptr = self._ensure_pointer(addr, addr_name=addr_name or f"{self._name(src)}_ptr")
        self.address_of_view(ptr, view)
        return self.store(ptr, src, memory_domain=memory_domain)

    def vload(self, dest: Buffer | str, addr: Buffer | str) -> "KernelBuilder":
        self._kernel.ops.append(VectorLoad(self._name(dest), self._name(addr)))
        return self

    def vload_view(
        self,
        dest: Buffer | str,
        view: TensorView,
        *,
        addr: Buffer | str | None = None,
        addr_name: Optional[str] = None,
    ) -> "KernelBuilder":
        ptr = self._ensure_pointer(addr, addr_name=addr_name or f"{self._name(dest)}_ptr")
        self.address_of_view(ptr, view)
        return self.vload(dest, ptr)

    def vstore(self, addr: Buffer | str, src: Buffer | str) -> "KernelBuilder":
        self._kernel.ops.append(VectorStore(self._name(addr), self._name(src)))
        return self

    def vstore_view(
        self,
        view: TensorView,
        src: Buffer | str,
        *,
        addr: Buffer | str | None = None,
        addr_name: Optional[str] = None,
    ) -> "KernelBuilder":
        ptr = self._ensure_pointer(addr, addr_name=addr_name or f"{self._name(src)}_ptr")
        self.address_of_view(ptr, view)
        return self.vstore(ptr, src)

    def binary(self, op: str, dest: Buffer | str, lhs: Buffer | str, rhs: Buffer | str) -> "KernelBuilder":
        self._kernel.ops.append(ScalarBinary(op, self._name(dest), self._name(lhs), self._name(rhs)))
        return self

    def add(self, dest: Buffer | str, lhs: Buffer | str, rhs: Buffer | str) -> "KernelBuilder":
        return self.binary("add", dest, lhs, rhs)

    def sub(self, dest: Buffer | str, lhs: Buffer | str, rhs: Buffer | str) -> "KernelBuilder":
        return self.binary("sub", dest, lhs, rhs)

    def vector_binary(
        self,
        op: str,
        dest: Buffer | str,
        lhs: Buffer | str,
        rhs: Buffer | str,
        *,
        ew: int,
        dw: Optional[int] = None,
        signed: int = 0,
    ) -> "KernelBuilder":
        self._kernel.ops.append(
            VectorBinary(op, self._name(dest), self._name(lhs), self._name(rhs), ew=ew, dw=dw, signed=signed)
        )
        return self

    def vector_map(
        self,
        op: str,
        dest: Buffer | str,
        lhs: Buffer | str,
        rhs: Buffer | str,
        *,
        ew: int,
        dw: Optional[int] = None,
        signed: int = 0,
    ) -> "KernelBuilder":
        return self.vector_binary(op, dest, lhs, rhs, ew=ew, dw=dw, signed=signed)

    def software_pipeline_binary(
        self,
        lhs: Buffer | str,
        rhs: Buffer | str,
        out: Buffer | str,
        *,
        tiles: int,
        tile_elements: int,
        compute: Callable[["KernelBuilder", Buffer, Buffer, Buffer], None],
        tile_stride_elements: Optional[int] = None,
        unroll: int = 1,
        name_prefix: Optional[str] = None,
        scratch_base_start: int = 320,
    ) -> "KernelBuilder":
        if tiles <= 0:
            raise ValueError("software_pipeline_binary() requires at least one tile")
        if tile_elements <= 0:
            raise ValueError("software_pipeline_binary() requires positive tile_elements")
        if unroll <= 0:
            raise ValueError("software_pipeline_binary() requires a positive unroll factor")

        lhs_buf = self._buffer(lhs)
        rhs_buf = self._buffer(rhs)
        out_buf = self._buffer(out)
        self._require_rank1_dmem(lhs_buf, role="lhs")
        self._require_rank1_dmem(rhs_buf, role="rhs")
        self._require_rank1_dmem(out_buf, role="out")

        stride = tile_stride_elements if tile_stride_elements is not None else tile_elements
        if stride < tile_elements:
            raise ValueError("software_pipeline_binary() requires tile_stride_elements >= tile_elements")

        required_elements = (tiles - 1) * stride + tile_elements
        for role, buf in (("lhs", lhs_buf), ("rhs", rhs_buf), ("out", out_buf)):
            if buf.shape[0] < required_elements:
                raise ValueError(
                    f"software_pipeline_binary() requires {role} buffer '{buf.name}' to have at least {required_elements} elements"
                )

        prefix = name_prefix or self._next_temp_name("pipeline")
        stage_width = 2 * unroll
        lhs_stages = [
            self.vector(
                f"{prefix}_lhs_{idx}",
                length=tile_elements,
                dtype=lhs_buf.dtype,
                scratch_base=scratch_base_start + idx * tile_elements,
            )
            for idx in range(stage_width)
        ]
        rhs_base = scratch_base_start + stage_width * tile_elements
        rhs_stages = [
            self.vector(
                f"{prefix}_rhs_{idx}",
                length=tile_elements,
                dtype=rhs_buf.dtype,
                scratch_base=rhs_base + idx * tile_elements,
            )
            for idx in range(stage_width)
        ]
        out_base = rhs_base + stage_width * tile_elements
        out_stages = [
            self.vector(
                f"{prefix}_out_{idx}",
                length=tile_elements,
                dtype=out_buf.dtype,
                scratch_base=out_base + idx * tile_elements,
            )
            for idx in range(stage_width)
        ]

        def emit_load(tile_index: int, group: int, offset: int) -> None:
            stage = group * unroll + offset
            start = tile_index * stride
            self.vload_view(
                lhs_stages[stage],
                tile_1d(lhs_buf, length=tile_elements, start=start),
                addr_name=f"{prefix}_lhs_ptr_{stage}",
            )
            self.vload_view(
                rhs_stages[stage],
                tile_1d(rhs_buf, length=tile_elements, start=start),
                addr_name=f"{prefix}_rhs_ptr_{stage}",
            )

        def emit_compute_store(tile_index: int, group: int, offset: int) -> None:
            stage = group * unroll + offset
            start = tile_index * stride
            compute(self, lhs_stages[stage], rhs_stages[stage], out_stages[stage])
            self.vstore_view(
                tile_1d(out_buf, length=tile_elements, start=start),
                out_stages[stage],
                addr_name=f"{prefix}_out_ptr_{stage}",
            )

        current_batch = list(range(min(unroll, tiles)))
        current_group = 0
        for offset, tile_index in enumerate(current_batch):
            emit_load(tile_index, current_group, offset)

        next_tile = len(current_batch)
        while next_tile < tiles:
            next_group = 1 - current_group
            next_batch = list(range(next_tile, min(next_tile + unroll, tiles)))
            steps = max(len(current_batch), len(next_batch))
            for offset in range(steps):
                if offset < len(next_batch):
                    emit_load(next_batch[offset], next_group, offset)
                if offset < len(current_batch):
                    emit_compute_store(current_batch[offset], current_group, offset)
            current_batch = next_batch
            current_group = next_group
            next_tile += len(next_batch)

        for offset, tile_index in enumerate(current_batch):
            emit_compute_store(tile_index, current_group, offset)
        return self

    def pipelined_vector_map(
        self,
        op: str,
        lhs: Buffer | str,
        rhs: Buffer | str,
        out: Buffer | str,
        *,
        tiles: int,
        tile_elements: int,
        tile_stride_elements: Optional[int] = None,
        ew: int = 32,
        dw: Optional[int] = None,
        signed: int = 0,
        unroll: int = 1,
        name_prefix: Optional[str] = None,
        scratch_base_start: int = 320,
    ) -> "KernelBuilder":
        return self.software_pipeline_binary(
            lhs,
            rhs,
            out,
            tiles=tiles,
            tile_elements=tile_elements,
            tile_stride_elements=tile_stride_elements,
            unroll=unroll,
            name_prefix=name_prefix or f"pipeline_{op}",
            scratch_base_start=scratch_base_start,
            compute=lambda kb, lhs_stage, rhs_stage, out_stage: kb.vector_map(
                op,
                out_stage,
                lhs_stage,
                rhs_stage,
                ew=ew,
                dw=dw,
                signed=signed,
            ),
        )

    def vbroadcast(self, dest: Buffer | str, src: Buffer | str, *, ew: int = 32) -> "KernelBuilder":
        self._kernel.ops.append(VectorBroadcast(self._name(dest), self._name(src), ew=ew))
        return self

    def vector_fill(self, dest: Buffer | str, src: Buffer | str, *, ew: int = 32) -> "KernelBuilder":
        return self.vbroadcast(dest, src, ew=ew)

    def vcast(
        self,
        dest: Buffer | str,
        src: Buffer | str,
        *,
        ew: int,
        dw: int,
        signed: int = 0,
        upper: int = 0,
    ) -> "KernelBuilder":
        self._kernel.ops.append(VectorCast(self._name(dest), self._name(src), ew=ew, dw=dw, signed=signed, upper=upper))
        return self

    def vector_copy(
        self,
        dest: Buffer | str,
        src: Buffer | str,
        *,
        ew: int = 32,
        dw: Optional[int] = None,
        signed: int = 0,
        upper: int = 0,
    ) -> "KernelBuilder":
        copy_dw = dw if dw is not None else ew
        return self.vcast(dest, src, ew=ew, dw=copy_dw, signed=signed, upper=upper)

    def add_imm(self, dest: Buffer | str, src: Buffer | str, imm: int) -> "KernelBuilder":
        self._kernel.ops.append(AddImmediate(self._name(dest), self._name(src), imm))
        return self

    def address_of(self, dest: Buffer | str, buffer: Buffer | str, *, offset_words: int = 0) -> "KernelBuilder":
        self._kernel.ops.append(AddressOf(self._name(dest), self._name(buffer), offset_words=offset_words))
        return self

    def address_of_view(self, dest: Buffer | str, view: TensorView) -> "KernelBuilder":
        self._kernel.ops.append(AddressOf(self._name(dest), view.buffer.name, offset_words=view.base_offset_words))
        return self

    def lane(self, vector: Buffer | str, lane: int, *, name: Optional[str] = None) -> Buffer:
        vector_buffer = self._buffer(vector)
        if len(vector_buffer.shape) != 1:
            raise ValueError("Lane aliases currently require rank-1 vector buffers")
        if vector_buffer.scratch_base is None:
            raise ValueError(
                f"Vector '{vector_buffer.name}' needs an explicit scratch_base before lane aliases can be created"
            )
        if lane < 0 or lane >= vector_buffer.shape[0]:
            raise ValueError(f"Lane {lane} is out of bounds for vector '{vector_buffer.name}'")

        alias_name = name or f"{vector_buffer.name}_lane_{lane}"
        existing = self._kernel.buffers.get(alias_name)
        if existing is not None:
            return existing

        return self.scalar(
            alias_name,
            dtype=vector_buffer.dtype,
            scratch_base=vector_buffer.scratch_base + lane,
        )

    def store_lane(
        self,
        addr: Buffer | str,
        vector: Buffer | str,
        lane: int,
        *,
        alias_name: Optional[str] = None,
        memory_domain: str = "scalar",
    ) -> "KernelBuilder":
        lane_buffer = self.lane(vector, lane, name=alias_name)
        return self.store(addr, lane_buffer, memory_domain=memory_domain)

    def accumulate_lanes(
        self,
        dest: Buffer | str,
        vector: Buffer | str,
        *,
        lanes: Optional[Sequence[int]] = None,
        alias_prefix: Optional[str] = None,
    ) -> "KernelBuilder":
        vector_buffer = self._buffer(vector)
        if len(vector_buffer.shape) != 1:
            raise ValueError("accumulate_lanes() requires a rank-1 vector buffer")

        lane_ids = list(range(vector_buffer.shape[0])) if lanes is None else list(lanes)
        for lane in lane_ids:
            alias_name = None if alias_prefix is None else f"{alias_prefix}_lane_{lane}"
            lane_buffer = self.lane(vector_buffer, lane, name=alias_name)
            self.add(dest, dest, lane_buffer)
        return self

    def if_else(
        self,
        cond: Buffer | str,
        *,
        then_body: Callable[["KernelBuilder"], None],
        else_body: Optional[Callable[["KernelBuilder"], None]] = None,
        prefix: Optional[str] = None,
    ) -> "KernelBuilder":
        base = prefix or self._next_temp_name("if")
        then_label = f"{base}_then"
        end_label = f"{base}_end"
        self.cond_jump(cond, then_label)
        if else_body is not None:
            else_body(self)
        self.jump(end_label)
        self.label(then_label)
        then_body(self)
        self.label(end_label)
        return self

    def counted_loop(
        self,
        index: Buffer | str,
        *,
        start: int,
        stop: int,
        step: int = 1,
        body: Callable[["KernelBuilder"], None],
        prefix: Optional[str] = None,
    ) -> "KernelBuilder":
        if step <= 0:
            raise ValueError("counted_loop() requires a positive step")
        base = prefix or self._next_temp_name("loop")
        step_buf = self.scalar(f"{base}_step")
        stop_buf = self.scalar(f"{base}_stop")
        cond_buf = self.scalar(f"{base}_cond")
        loop_label = f"{base}_body"

        self.const(index, start)
        self.const(step_buf, step)
        self.const(stop_buf, stop)
        self.label(loop_label)
        body(self)
        self.add(index, index, step_buf)
        self.binary("lt", cond_buf, index, stop_buf)
        self.cond_jump(cond_buf, loop_label)
        return self

    def for_each_tile_1d(
        self,
        index: Buffer | str,
        *,
        tiles: int,
        tile_elements: int,
        pointers: Sequence[Buffer | str],
        body: Callable[["KernelBuilder"], None],
        prefix: Optional[str] = None,
    ) -> "KernelBuilder":
        if tiles <= 0:
            raise ValueError("for_each_tile_1d() requires a positive tile count")
        if tile_elements <= 0:
            raise ValueError("for_each_tile_1d() requires positive tile_elements")

        pointer_buffers = [self._buffer(pointer) for pointer in pointers]

        def loop_body(inner_kb: "KernelBuilder") -> None:
            body(inner_kb)
            for pointer in pointer_buffers:
                inner_kb.add_imm(pointer, pointer, tile_elements)

        return self.counted_loop(
            index,
            start=0,
            stop=tiles,
            step=1,
            body=loop_body,
            prefix=prefix or self._next_temp_name("tile_loop"),
        )

    def label(self, name: str) -> "KernelBuilder":
        self._kernel.ops.append(Label(name))
        return self

    def jump(self, target: str) -> "KernelBuilder":
        self._kernel.ops.append(Jump(target))
        return self

    def cond_jump(self, cond: Buffer | str, target: str) -> "KernelBuilder":
        self._kernel.ops.append(CondJump(self._name(cond), target))
        return self

    def coreid(self, dest: Buffer | str) -> "KernelBuilder":
        self._kernel.ops.append(ReadCoreId(self._name(dest)))
        return self

    def halt(self) -> "KernelBuilder":
        self._kernel.ops.append(Halt())
        return self

    def build(self) -> Kernel:
        return self._kernel

    def _buffer(self, buffer: Buffer | str) -> Buffer:
        if isinstance(buffer, Buffer):
            return buffer
        if buffer not in self._kernel.buffers:
            raise KeyError(f"Unknown buffer '{buffer}'")
        return self._kernel.buffers[buffer]

    @staticmethod
    def _require_rank1_dmem(buffer: Buffer, *, role: str) -> None:
        if buffer.space != MemorySpace.DMEM or len(buffer.shape) != 1:
            raise ValueError(f"pipelined_vector_map() requires rank-1 DMEM buffers; {role} buffer '{buffer.name}' is incompatible")

    def _ensure_pointer(self, buffer: Buffer | str | None, *, addr_name: str) -> Buffer:
        if buffer is not None:
            return self._buffer(buffer)
        existing = self._kernel.buffers.get(addr_name)
        if existing is not None:
            return existing
        return self.scalar(addr_name, dtype=U32)

    def _next_temp_name(self, prefix: str) -> str:
        name = f"{prefix}_{self._temp_counter}"
        self._temp_counter += 1
        return name

    def _register(self, buffer: Buffer) -> Buffer:
        existing = self._kernel.buffers.get(buffer.name)
        if existing is not None:
            raise ValueError(f"Buffer '{buffer.name}' is already defined")
        self._kernel.buffers[buffer.name] = buffer
        return buffer

    def _register_argument(self, argument: KernelArgument) -> None:
        existing = self._kernel.arguments.get(argument.name)
        if existing is not None:
            raise ValueError(f"Kernel argument '{argument.name}' is already defined")
        self._kernel.arguments[argument.name] = argument

    @staticmethod
    def _name(buffer: Buffer | str) -> str:
        return buffer.name if isinstance(buffer, Buffer) else buffer
