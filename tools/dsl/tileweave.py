from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, Optional

from .builder import KernelBuilder
from .capabilities import HardwareCapabilities
from .ir import Buffer, DType, Kernel, U32


@dataclass(frozen=True)
class ProgramId:
    axis: int = 0


@dataclass(frozen=True)
class BlockRange:
    start: int
    stop: int
    step: int = 1


@dataclass(frozen=True)
class TensorHandle:
    buffer: Buffer


@dataclass(frozen=True)
class ScalarHandle:
    buffer: Buffer


@dataclass(frozen=True)
class PrefixMask:
    valid_elements: int


@dataclass(frozen=True)
class BlockValue:
    builder: "TileWeaveKernelBuilder"
    kind: str
    name: str
    dtype: DType = U32
    tensor: Optional[TensorHandle] = None
    scalar: Optional[ScalarHandle] = None
    lhs: Optional["BlockValue"] = None
    rhs: Optional["BlockValue"] = None
    op: Optional[str] = None
    mask: Optional[PrefixMask] = None
    other: int = 0
    offsets: Optional[BlockRange] = None

    def __add__(self, other: "BlockValue") -> "BlockValue":
        return self.builder.binary("add", self, other)

    def __mul__(self, other: "BlockValue") -> "BlockValue":
        return self.builder.binary("mul", self, other)

    def __sub__(self, other: "BlockValue") -> "BlockValue":
        return self.builder.binary("sub", self, other)


@dataclass(frozen=True)
class StoreSpec:
    tensor: TensorHandle
    value: BlockValue
    mask: Optional[PrefixMask] = None
    offsets: Optional[BlockRange] = None


class TileWeaveKernelBuilder:
    """A compact Triton-inspired façade on top of `KernelBuilder`.

    Current supported subset:
    - 1D block programs
    - `program_id(axis=0)`
    - `arange(0, BLOCK)` and affine `arange(..., step=...)`
    - block `load()` / `store()`
    - `splat()` of scalar arguments
    - elementwise `add`, `sub`, `mul`

    TileWeave keeps the frontend intentionally narrow while providing a higher-
    level block-kernel authoring style similar to Triton.
    """

    def __init__(
        self,
        name: str,
        *,
        length: int,
        block_size: int,
        tile_stride_elements: Optional[int] = None,
        program_count: Optional[int] = None,
        dtype: DType = U32,
        scratch_base_start: int = 320,
        hardware_vector_len: Optional[int] = None,
    ):
        if length <= 0:
            raise ValueError("TileWeaveKernelBuilder requires a positive length")
        if block_size <= 0:
            raise ValueError("TileWeaveKernelBuilder requires a positive block_size")
        stride = tile_stride_elements if tile_stride_elements is not None else block_size
        if stride <= 0:
            raise ValueError("TileWeaveKernelBuilder requires a positive tile_stride_elements")
        if program_count is not None and program_count <= 0:
            raise ValueError("TileWeaveKernelBuilder requires a positive program_count")

        self._kb = KernelBuilder(name)
        self.length = length
        self.block_size = block_size
        self.tile_stride_elements = stride
        self.program_count = program_count
        self.dtype = dtype
        self._scratch_base = scratch_base_start
        self.hardware_vector_len = hardware_vector_len or HardwareCapabilities.from_configs().vlen
        self._value_counter = 0
        self._tensor_pointers: Dict[str, Buffer] = {}
        self._offset_pointers: Dict[str, Buffer] = {}
        self._physical_vectors: Dict[str, Buffer] = {}
        self._load_tensors: Dict[str, TensorHandle] = {}
        self._stores: list[StoreSpec] = []

    def tensor(self, name: str, *, dtype: Optional[DType] = None, length: Optional[int] = None) -> TensorHandle:
        return TensorHandle(self._kb.arg_dmem_tensor(name, shape=(length or self.length,), dtype=dtype or self.dtype))

    def scalar(self, name: str, *, dtype: Optional[DType] = None, default: Optional[int] = None) -> ScalarHandle:
        return ScalarHandle(self._kb.arg_scalar(name, dtype=dtype or self.dtype, default=default))

    @staticmethod
    def program_id(axis: int = 0) -> ProgramId:
        if axis != 0:
            raise ValueError("TileWeaveKernelBuilder currently supports only program_id(axis=0)")
        return ProgramId(axis=axis)

    def arange(self, start: int, stop: int, *, step: int = 1) -> BlockRange:
        if start != 0 or step <= 0:
            raise ValueError("TileWeaveKernelBuilder currently supports arange() with start=0 and positive step")
        lanes = len(range(start, stop, step))
        if lanes != self.block_size:
            raise ValueError("TileWeaveKernelBuilder arange() must describe exactly block_size logical elements")
        return BlockRange(start=start, stop=stop, step=step)

    def mask_prefix(self, valid_elements: int) -> PrefixMask:
        if valid_elements < 0 or valid_elements > self.block_size:
            raise ValueError("TileWeaveKernelBuilder mask_prefix() requires 0 <= valid_elements <= block_size")
        return PrefixMask(valid_elements=valid_elements)

    def load(
        self,
        tensor: TensorHandle,
        pid: ProgramId,
        offsets: BlockRange,
        *,
        mask: Optional[PrefixMask] = None,
        other: int = 0,
        name: Optional[str] = None,
    ) -> BlockValue:
        self._validate_block_access(pid, offsets)
        self._load_tensors[tensor.buffer.name] = tensor
        return BlockValue(
            self,
            kind="load",
            name=name or self._next_value_name("load"),
            dtype=tensor.buffer.dtype,
            tensor=tensor,
            mask=mask,
            other=other,
            offsets=offsets,
        )

    def splat(self, scalar: ScalarHandle, *, name: Optional[str] = None) -> BlockValue:
        return BlockValue(self, kind="splat", name=name or self._next_value_name("splat"), dtype=scalar.buffer.dtype, scalar=scalar)

    def binary(self, op: str, lhs: BlockValue, rhs: BlockValue, *, name: Optional[str] = None) -> BlockValue:
        if lhs.builder is not self or rhs.builder is not self:
            raise ValueError("Block values must belong to the same TileWeaveKernelBuilder")
        return BlockValue(
            self,
            kind="binary",
            name=name or self._next_value_name(op),
            dtype=lhs.dtype,
            lhs=lhs,
            rhs=rhs,
            op=op,
        )

    def store(
        self,
        tensor: TensorHandle,
        pid: ProgramId,
        offsets: BlockRange,
        value: BlockValue,
        *,
        mask: Optional[PrefixMask] = None,
    ) -> None:
        self._validate_block_access(pid, offsets)
        if value.builder is not self:
            raise ValueError("Stored block value must belong to the same TileWeaveKernelBuilder")
        self._stores.append(StoreSpec(tensor=tensor, value=value, mask=mask, offsets=offsets))

    def build(self) -> Kernel:
        if not self._stores:
            raise ValueError("TileWeaveKernelBuilder requires at least one store() before build()")
        if self.hardware_vector_len <= 0:
            raise ValueError("TileWeaveKernelBuilder requires a positive hardware_vector_len")

        ptrs = [self._ensure_tensor_pointer(tensor) for tensor in self._load_tensors.values()]
        ptrs.extend(self._ensure_tensor_pointer(store.tensor) for store in self._stores)
        unique_ptrs: list[Buffer] = []
        seen: set[str] = set()
        for ptr in ptrs:
            if ptr.name not in seen:
                unique_ptrs.append(ptr)
                seen.add(ptr.name)

        tile_index = self._kb.scalar("program_id_0")
        if self.program_count is None:
            full_tiles = 0
            if self.length >= self.block_size:
                full_tiles = 1 + (self.length - self.block_size) // self.tile_stride_elements
            tail_start = full_tiles * self.tile_stride_elements
            tail_elements = max(0, self.length - tail_start)
        else:
            full_tiles = self.program_count
            tail_elements = 0
        vector_chunks = self.block_size // self.hardware_vector_len
        block_tail = self.block_size % self.hardware_vector_len

        for tensor in self._load_tensors.values():
            self._kb.address_of(self._ensure_tensor_pointer(tensor), tensor.buffer)
        for store in self._stores:
            self._kb.address_of(self._ensure_tensor_pointer(store.tensor), store.tensor.buffer)

        def reserve_physical_vectors(value: BlockValue) -> None:
            if value.kind == "load":
                self._ensure_physical_vector(value.name, dtype=value.dtype)
                return
            if value.kind == "splat":
                self._ensure_physical_vector(value.name, dtype=value.dtype)
                return
            if value.kind == "binary":
                if value.lhs is None or value.rhs is None:
                    raise ValueError("Binary block values require lhs and rhs")
                reserve_physical_vectors(value.lhs)
                reserve_physical_vectors(value.rhs)
                self._ensure_physical_vector(value.name, dtype=value.dtype)
                return
            raise ValueError(f"Unsupported block value kind '{value.kind}'")

        for store in self._stores:
            reserve_physical_vectors(store.value)

        expr_cache: Dict[tuple[str, int], Buffer] = {}
        invariant_cache: Dict[str, Buffer] = {}

        def ew_for(value: BlockValue) -> int:
            return value.dtype.bits

        def valid_for(mask: Optional[PrefixMask], offset: int, width: int) -> int:
            if mask is None:
                return width
            return max(0, min(width, mask.valid_elements - offset))

        scalar_expr_buffers: Dict[str, Buffer] = {}

        def immediate_scalar(name: str, value: int, *, dtype: DType) -> Buffer:
            existing = scalar_expr_buffers.get(name)
            if existing is not None:
                return existing
            buf = self._kb.scalar(name, dtype=dtype)
            scalar_expr_buffers[name] = buf
            self._kb.const(buf, value)
            return buf

        def pointer_with_offset(tensor: TensorHandle, offset: int) -> Buffer:
            base = self._ensure_tensor_pointer(tensor)
            if offset == 0:
                return base
            temp = self._ensure_offset_pointer(tensor)
            self._kb.add_imm(temp, base, offset)
            return temp

        def step_for_offsets(offsets: Optional[BlockRange]) -> int:
            return 1 if offsets is None else offsets.step

        def requires_scalar_path(value: BlockValue) -> bool:
            if value.kind == "load":
                return step_for_offsets(value.offsets) != 1
            if value.kind == "binary":
                if value.lhs is None or value.rhs is None:
                    raise ValueError("Binary block values require lhs and rhs")
                return requires_scalar_path(value.lhs) or requires_scalar_path(value.rhs)
            return False

        def materialize(value: BlockValue, chunk_offset: int) -> Buffer:
            cached = expr_cache.get((value.name, chunk_offset))
            if cached is not None and value.kind != "load":
                return cached

            if value.kind == "load":
                if value.tensor is None:
                    raise ValueError("Load block values require a source tensor")
                vec = self._ensure_physical_vector(value.name, dtype=value.dtype)
                stride = step_for_offsets(value.offsets)
                chunk_valid = valid_for(value.mask, chunk_offset, self.hardware_vector_len)
                if stride == 1 and chunk_valid >= self.hardware_vector_len:
                    self._kb.vload(vec, pointer_with_offset(value.tensor, chunk_offset))
                else:
                    fill_scalar = immediate_scalar(f"{value.name}_fill", value.other, dtype=value.dtype)
                    self._kb.vector_fill(vec, fill_scalar, ew=ew_for(value))
                    for lane in range(chunk_valid):
                        lane_buf = self._kb.lane(vec, lane, name=f"{value.name}_lane_{lane}")
                        self._kb.load(lane_buf, pointer_with_offset(value.tensor, chunk_offset + lane * stride))
            elif value.kind == "splat":
                if value.scalar is None:
                    raise ValueError("Splat block values require a source scalar")
                vec = invariant_cache.get(value.name)
                if vec is None:
                    vec = self._ensure_physical_vector(value.name, dtype=value.dtype)
                    self._kb.vector_fill(vec, value.scalar.buffer, ew=ew_for(value))
                    invariant_cache[value.name] = vec
            elif value.kind == "binary":
                if value.lhs is None or value.rhs is None or value.op is None:
                    raise ValueError("Binary block values require lhs, rhs, and op")
                lhs = materialize(value.lhs, chunk_offset)
                rhs = materialize(value.rhs, chunk_offset)
                vec = self._ensure_physical_vector(value.name, dtype=value.dtype)
                self._kb.vector_map(value.op, vec, lhs, rhs, ew=ew_for(value))
            else:
                raise ValueError(f"Unsupported block value kind '{value.kind}'")

            if value.kind != "load":
                expr_cache[(value.name, chunk_offset)] = vec
            return vec

        def hoist_invariants(value: BlockValue) -> None:
            if value.kind == "load":
                return
            if value.kind == "binary":
                if value.lhs is None or value.rhs is None:
                    raise ValueError("Binary block values require lhs and rhs")
                hoist_invariants(value.lhs)
                hoist_invariants(value.rhs)
                return
            materialize(value, 0)

        if full_tiles > 0:
            for store in self._stores:
                hoist_invariants(store.value)

        def scalar_buffer(value: BlockValue) -> Buffer:
            existing = scalar_expr_buffers.get(value.name)
            if existing is not None:
                return existing

            if value.kind == "splat":
                if value.scalar is None:
                    raise ValueError("Splat block values require a source scalar")
                scalar_expr_buffers[value.name] = value.scalar.buffer
                return value.scalar.buffer

            buf = self._kb.scalar(f"{value.name}_scalar", dtype=value.dtype)
            scalar_expr_buffers[value.name] = buf
            return buf

        def emit_scalar_value(value: BlockValue, offset: int, emitted: set[str]) -> Buffer:
            if value.kind == "splat":
                if value.scalar is None:
                    raise ValueError("Splat block values require a source scalar")
                return value.scalar.buffer

            dest = scalar_buffer(value)
            if value.name in emitted:
                return dest

            if value.kind == "load":
                if value.tensor is None:
                    raise ValueError("Load block values require a source tensor")
                if value.mask is not None and offset >= value.mask.valid_elements:
                    fill_scalar = immediate_scalar(f"{value.name}_fill", value.other, dtype=value.dtype)
                    self._kb.const(dest, 0)
                    self._kb.add(dest, fill_scalar, dest)
                else:
                    stride = step_for_offsets(value.offsets)
                    self._kb.load(dest, pointer_with_offset(value.tensor, offset * stride))
            elif value.kind == "binary":
                if value.lhs is None or value.rhs is None or value.op is None:
                    raise ValueError("Binary block values require lhs, rhs, and op")
                lhs = emit_scalar_value(value.lhs, offset, emitted)
                rhs = emit_scalar_value(value.rhs, offset, emitted)
                self._kb.binary(value.op, dest, lhs, rhs)
            else:
                raise ValueError(f"Unsupported block value kind '{value.kind}'")

            emitted.add(value.name)
            return dest

        def loop_body(inner_kb: KernelBuilder) -> None:
            del inner_kb
            for store in self._stores:
                stride = step_for_offsets(store.offsets)
                if stride != 1 or requires_scalar_path(store.value):
                    for lane_offset in range(self.block_size):
                        if store.mask is not None and lane_offset >= store.mask.valid_elements:
                            continue
                        emitted: set[str] = set()
                        value_scalar = emit_scalar_value(store.value, lane_offset, emitted)
                        self._kb.store(pointer_with_offset(store.tensor, lane_offset * stride), value_scalar)
                    continue

                for chunk_index in range(vector_chunks):
                    offset = chunk_index * self.hardware_vector_len
                    value_vec = materialize(store.value, offset)
                    chunk_valid = valid_for(store.mask, offset, self.hardware_vector_len)
                    if stride == 1 and chunk_valid >= self.hardware_vector_len:
                        self._kb.vstore(pointer_with_offset(store.tensor, offset), value_vec)
                    else:
                        for lane in range(chunk_valid):
                            lane_buf = self._kb.lane(value_vec, lane, name=f"{value_vec.name}_store_lane_{lane}")
                            self._kb.store(pointer_with_offset(store.tensor, offset + lane * stride), lane_buf)

                if block_tail > 0:
                    tail_offset = vector_chunks * self.hardware_vector_len
                    for lane_offset in range(tail_offset, self.block_size):
                        if store.mask is not None and lane_offset >= store.mask.valid_elements:
                            continue
                        emitted: set[str] = set()
                        value_scalar = emit_scalar_value(store.value, lane_offset, emitted)
                        self._kb.store(pointer_with_offset(store.tensor, lane_offset * stride), value_scalar)

        if full_tiles > 0:
            self._kb.for_each_tile_1d(
                tile_index,
                tiles=full_tiles,
                tile_elements=self.tile_stride_elements,
                pointers=unique_ptrs,
                body=loop_body,
                prefix=f"{self._kb.build().name}_programs",
            )

        if tail_elements > 0:
            tail_index = self._kb.scalar("program_id_0_tail")

            def tail_body(inner_kb: KernelBuilder) -> None:
                del inner_kb
                emitted: set[str] = set()
                for store in self._stores:
                    if store.mask is not None and store.mask.valid_elements <= 0:
                        continue
                    value_scalar = emit_scalar_value(store.value, 0, emitted)
                    self._kb.store(self._ensure_tensor_pointer(store.tensor), value_scalar)
                for pointer in unique_ptrs:
                    self._kb.add_imm(pointer, pointer, 1)

            self._kb.counted_loop(
                tail_index,
                start=0,
                stop=tail_elements,
                step=1,
                body=tail_body,
                prefix=f"{self._kb.build().name}_tail_programs",
            )
        self._kb.halt()
        return self._kb.build()

    def _validate_block_access(self, pid: ProgramId, offsets: BlockRange) -> None:
        if pid.axis != 0:
            raise ValueError("TileWeaveKernelBuilder currently supports only program_id(axis=0)")
        if offsets.start != 0 or offsets.step <= 0 or len(range(offsets.start, offsets.stop, offsets.step)) != self.block_size:
            raise ValueError("TileWeaveKernelBuilder currently requires offsets that describe exactly block_size logical elements")

    def _ensure_tensor_pointer(self, tensor: TensorHandle) -> Buffer:
        existing = self._tensor_pointers.get(tensor.buffer.name)
        if existing is not None:
            return existing
        ptr = self._kb.scalar(f"{tensor.buffer.name}_ptr")
        self._tensor_pointers[tensor.buffer.name] = ptr
        return ptr

    def _ensure_offset_pointer(self, tensor: TensorHandle) -> Buffer:
        existing = self._offset_pointers.get(tensor.buffer.name)
        if existing is not None:
            return existing
        ptr = self._kb.scalar(f"{tensor.buffer.name}_ptr_offset")
        self._offset_pointers[tensor.buffer.name] = ptr
        return ptr

    def _ensure_physical_vector(self, name: str, *, dtype: DType) -> Buffer:
        existing = self._physical_vectors.get(name)
        if existing is not None:
            return existing
        buf = self._alloc_vector(name, dtype=dtype)
        self._physical_vectors[name] = buf
        return buf

    def _alloc_vector(self, name: str, *, dtype: DType) -> Buffer:
        buf = self._kb.vector(name, length=self.hardware_vector_len, dtype=dtype, scratch_base=self._scratch_base)
        self._scratch_base += self.hardware_vector_len
        return buf

    def _next_value_name(self, prefix: str) -> str:
        name = f"{prefix}_{self._value_counter}"
        self._value_counter += 1
        return name

    @staticmethod
    def _alloc_name_or_buffer(buffer: Buffer) -> Buffer:
        return buffer
