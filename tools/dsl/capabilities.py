from __future__ import annotations

from dataclasses import dataclass, field
from typing import FrozenSet, Optional

from assembler import AssemblerConfig
from scheduler import SchedulerConfig


@dataclass(frozen=True)
class KnownHardwareLimitations:
    """Compiler-visible hardware limitations and policy knobs."""

    single_pending_load: bool = True
    vector_axi_alignment_words: int = 16
    vector_axi_safe_span_words: int = 8
    widening_fma_requires_split: bool = True
    multi_alu_writeback_stable: bool = False


@dataclass(frozen=True)
class HardwareCapabilities:
    """Target description consumed by the DSL frontend and lowering pipeline."""

    n_cores: int = 1
    n_alu_slots: int = 1
    n_valu_slots: int = 1
    n_load_slots: int = 1
    n_store_slots: int = 1
    n_flow_slots: int = 1
    vlen: int = 8
    data_width: int = 32
    scratch_size: int = 1536
    scratch_banks: int = 8
    imem_depth: int = 1024
    bundle_width: int = 256
    supported_scalar_ops: FrozenSet[str] = field(
        default_factory=lambda: frozenset({"add", "sub", "mul", "xor", "and", "or", "shl", "shr", "lt", "eq", "div", "mod", "cdiv"})
    )
    supported_vector_ops: FrozenSet[str] = field(
        default_factory=lambda: frozenset({"add", "sub", "mul", "xor", "and", "or", "shl", "shr", "lt", "eq", "vbroadcast", "multiply_add", "vcast"})
    )
    supported_load_ops: FrozenSet[str] = field(
        default_factory=lambda: frozenset({"const", "load", "load_offset", "vload"})
    )
    supported_store_ops: FrozenSet[str] = field(
        default_factory=lambda: frozenset({"store", "vstore"})
    )
    supported_flow_ops: FrozenSet[str] = field(
        default_factory=lambda: frozenset({"halt", "jump", "cond_jump", "cond_jump_rel", "jump_indirect", "select", "vselect", "add_imm", "coreid"})
    )
    supported_element_widths: FrozenSet[int] = field(
        default_factory=lambda: frozenset({4, 8, 16, 32, 64})
    )
    limitations: KnownHardwareLimitations = field(default_factory=KnownHardwareLimitations)

    @classmethod
    def from_configs(
        cls,
        scheduler_config: Optional[SchedulerConfig] = None,
        assembler_config: Optional[AssemblerConfig] = None,
        *,
        n_cores: int = 1,
        scratch_size: Optional[int] = None,
        scratch_banks: Optional[int] = None,
        data_width: Optional[int] = None,
    ) -> "HardwareCapabilities":
        sched = scheduler_config or SchedulerConfig()
        asm = assembler_config or AssemblerConfig(
            n_alu_slots=sched.n_alu_slots,
            n_valu_slots=sched.n_valu_slots,
            n_load_slots=sched.n_load_slots,
            n_store_slots=sched.n_store_slots,
            n_flow_slots=sched.n_flow_slots,
            scratch_size=scratch_size or 1536,
            imem_depth=1024,
        )
        return cls(
            n_cores=n_cores,
            n_alu_slots=asm.n_alu_slots,
            n_valu_slots=asm.n_valu_slots,
            n_load_slots=asm.n_load_slots,
            n_store_slots=asm.n_store_slots,
            n_flow_slots=asm.n_flow_slots,
            vlen=asm.vlen,
            data_width=data_width or sched.data_width,
            scratch_size=scratch_size or asm.scratch_size,
            scratch_banks=scratch_banks or sched.scratch_banks,
            imem_depth=asm.imem_depth,
            bundle_width=asm.bundle_width,
            limitations=KnownHardwareLimitations(
                single_pending_load=True,
                vector_axi_alignment_words=16,
                vector_axi_safe_span_words=max(0, 16 - asm.vlen),
                widening_fma_requires_split=True,
                multi_alu_writeback_stable=asm.n_alu_slots <= 1,
            ),
        )

    def to_scheduler_config(self) -> SchedulerConfig:
        return SchedulerConfig(
            n_alu_slots=self.n_alu_slots,
            n_valu_slots=self.n_valu_slots,
            n_load_slots=self.n_load_slots,
            n_store_slots=self.n_store_slots,
            n_flow_slots=self.n_flow_slots,
            scratch_banks=self.scratch_banks,
            data_width=self.data_width,
        )

    def to_assembler_config(self) -> AssemblerConfig:
        return AssemblerConfig(
            n_alu_slots=self.n_alu_slots,
            n_valu_slots=self.n_valu_slots,
            n_load_slots=self.n_load_slots,
            n_store_slots=self.n_store_slots,
            n_flow_slots=self.n_flow_slots,
            vlen=self.vlen,
            scratch_size=self.scratch_size,
            imem_depth=self.imem_depth,
        )

    def require_vector_op(self, op: str) -> None:
        if self.n_valu_slots < 1:
            raise ValueError(f"Target exposes no VALU slots; cannot lower vector op '{op}'")
        if op not in self.supported_vector_ops:
            raise ValueError(f"Vector op '{op}' is not supported by the target capability profile")

    def require_scalar_op(self, op: str) -> None:
        if self.n_alu_slots < 1:
            raise ValueError(f"Target exposes no ALU slots; cannot lower scalar op '{op}'")
        if op not in self.supported_scalar_ops:
            raise ValueError(f"Scalar op '{op}' is not supported by the target capability profile")

    def require_element_width(self, width: int) -> None:
        if width not in self.supported_element_widths:
            raise ValueError(f"Element width {width} is not supported by the target capability profile")

    @property
    def vector_alignment_words(self) -> int:
        return max(self.vlen, self.scratch_banks)
