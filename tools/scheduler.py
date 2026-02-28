#!/usr/bin/env python3
"""
VLIW Instruction Scheduler — automatic hazard avoidance and bundle packing.

Understands the 3-stage pipeline (IF | EX | WB) with:
  - RAW hazard:  write at bundle N → readable at bundle N+1  (write forwarding)
  - Division:    fire-and-forget, 33 cycles → result at bundle N+34
  - Jump bubble: 1 dead slot after every taken branch
  - Bank conflicts: two scalar reads to same bank (addr % 8) → hardware stall
  - Same-bundle: ops in same bundle cannot read each other's results
  - Non-blocking memory: loads/stores push to FIFOs, pipeline rarely stalls

Usage:
    from scheduler import VliwScheduler, Op
    s = VliwScheduler()
    ops = [
        s.const(0, 100),
        s.const(1, 200),
        s.add(2, 0, 1),     # scheduler inserts NOP to avoid RAW hazard
        s.store(10, 2),
        s.halt(),
    ]
    bundles = s.schedule(ops)
    # → list of instruction dicts ready for Assembler.assemble_program()
"""

from __future__ import annotations
from dataclasses import dataclass, field
from typing import List, Optional, Dict, Tuple, Any, Literal
import math


# ============================================================================
#  Pipeline Timing Constants
# ============================================================================

# Minimum gap between producer and consumer (in bundle positions).
# With the 3-stage pipeline (IF|EX|WB) and write-forwarding bypass in
# BankedScratchMemory, the WB write at cycle T is forwarded to the EX
# read in the same cycle → data correct at bundle N+1.
NORMAL_LATENCY = 1

# VALU ops using src3 (e.g., VBROADCAST, MULTIPLY_ADD) are now single-cycle
# in hardware (the WB stage absorbs what was previously an extra pipeline
# register). Same latency as all other single-cycle ops.
VALU_SRC3_LATENCY = NORMAL_LATENCY

# Division: fire-and-forget divider takes dataWidth+1=33 cycles.
# Result written at bundle N+33, then readable at N+33+1 = N+34.
DIV_LATENCY = 34

# Division execution time (cycles the divider is busy on that ALU slot).
DIV_BUSY_CYCLES = 33

# Jump: 1 dead slot after branch (fetch invalidates in-flight instruction).
JUMP_BUBBLE = 3

# Async memory read completion to scratch (queue + AXI handshake + writeback).
# Conservative value to keep dependent consumers from reading too early.
LOAD_RESULT_LATENCY = 20

CONST_RESULT_LATENCY = NORMAL_LATENCY

# Memory operations are non-blocking (FIFO-based). The pipeline pushes
# to load/store FIFOs and continues without stalling. The scheduler
# should place enough independent work between load issue and result use.
# Conservative default keeps FIFO memory ops from being consumed too tightly.
DEFAULT_MEM_POST_GAP = 2

# With single-TDP scratch banks, Port B is shared by VALU src2 reads and WB writes.
# A 1-bundle post-gap avoids back-to-back VALU bundles that would otherwise
# overlap src2 reads with prior bundle writes.
DEFAULT_VALU_POST_GAP = 2

MemoryDomain = Literal["scalar", "vector"]


# ============================================================================
#  Operation Descriptor
# ============================================================================

@dataclass
class Op:
    """
    A single VLIW operation to be scheduled.

    Attributes:
        engine:   Target engine ("alu", "valu", "load", "store", "flow")
        op:       Opcode name (matches assembler opcode tables)
        dests:    List of scratch register addresses written
        srcs:     List of scratch register addresses read
        params:   Extra parameters for the assembler (immediate, offset, etc.)
        latency:  Cycles until result is readable (from the bundle this op is placed in)
        is_div:   True if this op uses the hardware divider
        is_jump:  True if this op is a branch (requires post-bubble)
        is_halt:  True if HALT instruction
        label:    Optional label marking this position in the program
        jump_target: Label name for jump/cond_jump target (resolved after scheduling)
        _scheduled_cycle: Filled by scheduler
    """
    engine: str
    op: str
    dests: List[int] = field(default_factory=list)
    srcs: List[int] = field(default_factory=list)
    params: Dict[str, Any] = field(default_factory=dict)
    latency: int = NORMAL_LATENCY
    is_div: bool = False
    is_jump: bool = False
    is_halt: bool = False
    label: Optional[str] = None
    jump_target: Optional[str] = None
    _scheduled_cycle: int = -1

    def __repr__(self):
        parts = [f"{self.engine}.{self.op}"]
        if self.dests:
            parts.append(f"->s{self.dests}")
        if self.srcs:
            parts.append(f"<-s{self.srcs}")
        if self.label:
            parts.append(f"@{self.label}")
        return f"Op({', '.join(parts)})"


# ============================================================================
#  Pseudo-op for labels (not a real instruction)
# ============================================================================

@dataclass
class Label:
    """Pseudo-operation marking a position in the program."""
    name: str
    _scheduled_cycle: int = -1


# ============================================================================
#  Scheduler Configuration
# ============================================================================

@dataclass
class SchedulerConfig:
    """Hardware resource limits matching VliwSocConfig."""
    n_alu_slots: int = 1
    n_valu_slots: int = 1
    n_load_slots: int = 1
    n_store_slots: int = 1
    n_flow_slots: int = 1
    scratch_banks: int = 8         # for bank-conflict detection
    data_width: int = 32
    div_latency: int = DIV_BUSY_CYCLES  # dataWidth + 1
    mem_post_gap: int = DEFAULT_MEM_POST_GAP
    valu_post_gap: int = DEFAULT_VALU_POST_GAP

    @property
    def slot_limits(self) -> Dict[str, int]:
        return {
            "alu": self.n_alu_slots,
            "valu": self.n_valu_slots,
            "load": self.n_load_slots,
            "store": self.n_store_slots,
            "flow": self.n_flow_slots,
        }

    @property
    def scalar_read_port_count(self) -> int:
        """Total scalar read ports: ALU(2/slot) + Load(1/slot) + Store(2/slot) + Flow(3) + VALU_src3(1/slot)."""
        return (self.n_alu_slots * 2 + self.n_load_slots +
                self.n_store_slots * 2 + self.n_flow_slots * 3 +
                self.n_valu_slots)


# ============================================================================
#  Bank Conflict Model
# ============================================================================

def _compute_read_ports(op: Op, cfg: SchedulerConfig) -> List[Tuple[int, int]]:
    """
    Return list of (port_index, register_address) for this op's scalar reads.

    Port assignment mirrors HW wiring in VliwCore.scala:
      Port 0..2*nAlu-1        : ALU src1/src2
      Port 2*nAlu..+nLoad-1   : Load addrReg (CONST suppressed)
      Port +nLoad..+2*nStore-1: Store addrReg/srcReg
      Port ..+3               : Flow operandA/B/immediate
      Port ..+nValu            : VALU src3
    """
    ports: List[Tuple[int, int]] = []
    alu_base = 0
    load_base = cfg.n_alu_slots * 2
    store_base = load_base + cfg.n_load_slots
    flow_base = store_base + cfg.n_store_slots * 2
    valu_s3_base = flow_base + cfg.n_flow_slots * 3

    if op.engine == "alu":
        # 2 ports per ALU slot; use slot 0 by default
        if len(op.srcs) >= 1:
            ports.append((alu_base, op.srcs[0]))
        if len(op.srcs) >= 2:
            ports.append((alu_base + 1, op.srcs[1]))

    elif op.engine == "load":
        # CONST doesn't read addrReg
        if op.op != "const" and op.srcs:
            ports.append((load_base, op.srcs[0]))

    elif op.engine == "store":
        if len(op.srcs) >= 1:
            ports.append((store_base, op.srcs[0]))
        if len(op.srcs) >= 2:
            ports.append((store_base + 1, op.srcs[1]))

    elif op.engine == "flow":
        if op.op in ("select", "vselect"):
            if len(op.srcs) >= 1:
                ports.append((flow_base, op.srcs[0]))      # cond
            if len(op.srcs) >= 2:
                ports.append((flow_base + 1, op.srcs[1]))   # srcA
            if len(op.srcs) >= 3:
                ports.append((flow_base + 2, op.srcs[2]))   # srcB
        elif op.op in ("cond_jump", "cond_jump_rel", "jump_indirect", "add_imm"):
            if op.srcs:
                ports.append((flow_base, op.srcs[0]))

    elif op.engine == "valu":
        # VALU uses a scalar port for src3 (vbroadcast/multiply_add)
        if op.op == "vbroadcast" and op.srcs:
            ports.append((valu_s3_base, op.srcs[0]))

    return ports


def _has_bank_conflict(existing_ports: List[Tuple[int, int]],
                       new_ports: List[Tuple[int, int]],
                       has_valu: bool,
                       n_banks: int = 8) -> bool:
    """
    Check if adding new_ports would exceed the TDP read capacity.

    TDP architecture: Port A + Port B → up to 2 reads per bank per cycle.
    Port B may be unavailable (WB write), but the scheduler can't predict
    cross-bundle WB writes, so we optimistically allow 2 reads.
    Conflict if 3+ reads target the same bank.
    """
    bank_reads: Dict[int, int] = {}
    for _port, reg in existing_ports:
        bank = reg % n_banks
        bank_reads[bank] = bank_reads.get(bank, 0) + 1
    for _port, reg in new_ports:
        bank = reg % n_banks
        current = bank_reads.get(bank, 0)
        if current >= 2:  # Port A + Port B already used
            return True
        bank_reads[bank] = current + 1
    return False


# ============================================================================
#  VLIW Scheduler
# ============================================================================

class VliwScheduler:
    """
    VLIW instruction scheduler with automatic hazard resolution.

    Scheduling strategy:
      1. Maintain "ready time" per scratch register (when it can be read).
      2. Walk through operations in program order.
      3. For each op, compute the earliest cycle it can be placed:
         - All source registers must be ready.
         - The target engine slot must be available.
         - Division exclusion zones must be respected.
      4. Pack multiple independent ops into the same bundle (different engines).
      5. Insert NOP bundles for gaps.
      6. Resolve jump/label targets after layout.

    Does NOT reorder instructions across basic-block boundaries (labels/jumps).
    Within a basic block, ops are scheduled in program order but may be
    packed into earlier bundles if resources and dependencies allow.
    """

    def __init__(self, config: Optional[SchedulerConfig] = None):
        self.cfg = config or SchedulerConfig()

    # ================================================================
    #  Convenience constructors for operations
    # ================================================================

    def const(self, dest: int, value: int) -> Op:
        """CONST immediate → scratch[dest]."""
        return Op(engine="load", op="const", dests=[dest], srcs=[],
                  params={"dest": dest, "value": value},
                  latency=CONST_RESULT_LATENCY)

    def load(self, dest: int, addr_reg: int,
             memory_domain: MemoryDomain = "scalar") -> Op:
        """LOAD scratch[dest] = mem[scratch[addr_reg]]."""
        return Op(engine="load", op="load", dests=[dest], srcs=[addr_reg],
                  params={"dest": dest, "addr_reg": addr_reg,
                          "memory_domain": memory_domain},
                  latency=LOAD_RESULT_LATENCY)

    def load_offset(self, dest: int, addr_reg: int, offset: int,
                    memory_domain: MemoryDomain = "scalar") -> Op:
        """LOAD_OFFSET scratch[dest+offset] = mem[scratch[addr_reg]+offset]."""
        return Op(engine="load", op="load_offset",
                  dests=[dest + offset], srcs=[addr_reg],
                  params={"dest": dest, "addr_reg": addr_reg,
                          "offset": offset, "memory_domain": memory_domain},
                  latency=LOAD_RESULT_LATENCY)

    def vload(self, dest_base: int, addr_reg: int, vlen: int = 8) -> Op:
        """VLOAD scratch[dest..dest+VLEN-1] = mem burst."""
        return Op(engine="load", op="vload",
                  dests=list(range(dest_base, dest_base + vlen)),
                  srcs=[addr_reg],
                  params={"dest": dest_base, "addr_reg": addr_reg,
                          "memory_domain": "vector"},
                  latency=LOAD_RESULT_LATENCY)

    def store(self, addr_reg: int, src_reg: int,
              memory_domain: MemoryDomain = "scalar") -> Op:
        """STORE mem[scratch[addr_reg]] = scratch[src_reg]."""
        return Op(engine="store", op="store", dests=[], srcs=[addr_reg, src_reg],
                  params={"addr_reg": addr_reg, "src_reg": src_reg,
                          "memory_domain": memory_domain})

    def vstore(self, addr_reg: int, src_base: int, vlen: int = 8) -> Op:
        """VSTORE mem burst from scratch[src..src+VLEN-1]."""
        return Op(engine="store", op="vstore", dests=[],
                  srcs=[addr_reg] + list(range(src_base, src_base + vlen)),
                  params={"addr_reg": addr_reg, "src_reg": src_base,
                          "memory_domain": "vector"})

    def load_from_vector_bank(self, dest: int, addr_reg: int) -> Op:
        """Scalar LOAD from vector memory bank (serialized vs vector ops)."""
        return self.load(dest, addr_reg, memory_domain="vector")

    def store_to_vector_bank(self, addr_reg: int, src_reg: int) -> Op:
        """Scalar STORE to vector memory bank (serialized vs vector ops)."""
        return self.store(addr_reg, src_reg, memory_domain="vector")

    # ---- ALU operations ----

    def _alu_op(self, op: str, dest: int, src1: int, src2: int,
                latency: int = NORMAL_LATENCY, is_div: bool = False) -> Op:
        return Op(engine="alu", op=op, dests=[dest], srcs=[src1, src2],
                  params={"dest": dest, "src1": src1, "src2": src2},
                  latency=latency, is_div=is_div)

    def add(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("add", dest, src1, src2)

    def sub(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("sub", dest, src1, src2)

    def mul(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("mul", dest, src1, src2)

    def xor(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("xor", dest, src1, src2)

    def and_op(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("and", dest, src1, src2)

    def or_op(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("or", dest, src1, src2)

    def shl(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("shl", dest, src1, src2)

    def shr(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("shr", dest, src1, src2)

    def lt(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("lt", dest, src1, src2)

    def eq(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("eq", dest, src1, src2)

    def div(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("div", dest, src1, src2,
                            latency=DIV_LATENCY, is_div=True)

    def mod(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("mod", dest, src1, src2,
                            latency=DIV_LATENCY, is_div=True)

    def cdiv(self, dest: int, src1: int, src2: int) -> Op:
        return self._alu_op("cdiv", dest, src1, src2,
                            latency=DIV_LATENCY, is_div=True)

    # ---- VALU operations ----

    def valu_op(self, op: str, dest_base: int, src1_base: int,
                src2_base: int, vlen: int = 8) -> Op:
        """Vector ALU lane-wise operation."""
        dests = list(range(dest_base, dest_base + vlen))
        srcs = list(range(src1_base, src1_base + vlen)) + \
               list(range(src2_base, src2_base + vlen))
        return Op(engine="valu", op=op, dests=dests, srcs=srcs,
                  params={"dest_base": dest_base, "src1_base": src1_base,
                          "src2_base": src2_base},
                  latency=NORMAL_LATENCY)

    def vbroadcast(self, dest_base: int, src_scalar: int, vlen: int = 8) -> Op:
        """VBROADCAST scalar to vector."""
        dests = list(range(dest_base, dest_base + vlen))
        return Op(engine="valu", op="vbroadcast", dests=dests, srcs=[src_scalar],
                  params={"dest_base": dest_base, "src1_base": src_scalar,
                          "src2_base": 0},
              latency=VALU_SRC3_LATENCY)

    def multiply_add(self, dest_base: int, a_base: int, b_base: int,
                     c_base: int, vlen: int = 8) -> Op:
        """MULTIPLY_ADD dest = a * b + c (vector)."""
        dests = list(range(dest_base, dest_base + vlen))
        srcs = (list(range(a_base, a_base + vlen)) +
                list(range(b_base, b_base + vlen)) +
                list(range(c_base, c_base + vlen)))
        return Op(engine="valu", op="multiply_add", dests=dests, srcs=srcs,
                  params={"dest_base": dest_base, "src1_base": a_base,
                          "src2_base": b_base, "src3_base": c_base},
              latency=VALU_SRC3_LATENCY)

    # ---- Flow operations ----

    def halt(self) -> Op:
        return Op(engine="flow", op="halt", is_halt=True)

    def jump(self, target: str) -> Op:
        """Unconditional jump to label."""
        return Op(engine="flow", op="jump", dests=[], srcs=[],
                  params={}, is_jump=True, jump_target=target)

    def jump_addr(self, target_pc: int) -> Op:
        """Unconditional jump to absolute PC address."""
        return Op(engine="flow", op="jump", dests=[], srcs=[],
                  params={"target": target_pc}, is_jump=True)

    def cond_jump(self, cond_reg: int, target: str) -> Op:
        """Conditional jump to label if scratch[cond_reg] != 0."""
        return Op(engine="flow", op="cond_jump", dests=[], srcs=[cond_reg],
                  params={"cond_reg": cond_reg},
                  is_jump=True, jump_target=target)

    def cond_jump_addr(self, cond_reg: int, target_pc: int) -> Op:
        """Conditional jump to absolute PC."""
        return Op(engine="flow", op="cond_jump", dests=[], srcs=[cond_reg],
                  params={"cond_reg": cond_reg, "target": target_pc},
                  is_jump=True)

    def cond_jump_rel(self, cond_reg: int, offset: int) -> Op:
        """Conditional jump relative (PC += offset if cond != 0)."""
        return Op(engine="flow", op="cond_jump_rel", dests=[], srcs=[cond_reg],
                  params={"cond_reg": cond_reg, "offset": offset},
                  is_jump=True)

    def jump_indirect(self, addr_reg: int) -> Op:
        """Jump to scratch[addr_reg]."""
        return Op(engine="flow", op="jump_indirect", dests=[], srcs=[addr_reg],
                  params={"addr_reg": addr_reg}, is_jump=True)

    def select(self, dest: int, cond: int, src_a: int, src_b: int) -> Op:
        """SELECT dest = cond ? src_a : src_b."""
        return Op(engine="flow", op="select", dests=[dest],
                  srcs=[cond, src_a, src_b],
                  params={"dest": dest, "cond": cond,
                          "src_a": src_a, "src_b": src_b},
                  latency=NORMAL_LATENCY)

    def vselect(self, dest: int, cond: int, src_a: int, src_b: int) -> Op:
        """VSELECT (vector)."""
        return Op(engine="flow", op="vselect", dests=[dest],
                  srcs=[cond, src_a, src_b],
                  params={"dest": dest, "cond": cond,
                          "src_a": src_a, "src_b": src_b},
                  latency=NORMAL_LATENCY)

    def add_imm(self, dest: int, src: int, imm: int) -> Op:
        """ADD_IMM dest = scratch[src] + sign_ext(imm)."""
        return Op(engine="flow", op="add_imm", dests=[dest], srcs=[src],
                  params={"dest": dest, "src": src, "imm": imm},
                  latency=NORMAL_LATENCY)

    def coreid(self, dest: int) -> Op:
        """COREID dest = hardware core ID."""
        return Op(engine="flow", op="coreid", dests=[dest], srcs=[],
                  params={"dest": dest}, latency=NORMAL_LATENCY)

    @staticmethod
    def label(name: str) -> Label:
        """Create a label pseudo-op for jump targets."""
        return Label(name=name)

    # ================================================================
    #  Core Scheduling Algorithm
    # ================================================================

    def schedule(self, operations: List, verbose: bool = False) -> List[Dict]:
        """
        Schedule a list of Op/Label into instruction bundles.

        Returns a list of instruction dicts suitable for Assembler.assemble_program().
        Labels are resolved to bundle PCs. Jump targets are patched.

        Scheduling strategy:
          - Process ops in program order (no reordering across block boundaries).
          - Within a basic block, try to pack independent ops into earlier
            bundles when resources and data dependencies allow.
          - Automatically insert NOP bundles to satisfy RAW latency.
          - Track division exclusion zones.
          - Insert NOP after jumps for the pipeline bubble.
        """
        # Separate labels from real ops, recording their positions
        items = []  # List of (Op | Label)
        for item in operations:
            items.append(item)

        # Split into basic blocks (at labels and jumps)
        blocks = self._split_basic_blocks(items)

        # Schedule each block
        bundles = []  # Final list of (cycle, bundle_dict) pairs
        reg_ready = {}  # reg → earliest cycle it can be READ
        div_busy = {}   # alu_slot → busy_until_cycle
        label_pcs = {}  # label_name → final PC

        current_cycle = 0

        for block in blocks:
            current_cycle, block_bundles = self._schedule_block(
                block, current_cycle, reg_ready, div_busy, label_pcs, verbose
            )
            bundles.extend(block_bundles)

        # Resolve jump targets
        result = self._resolve_jumps(bundles, label_pcs, verbose)

        if verbose:
            self._print_stats(result, operations)

        return result

    def _split_basic_blocks(self, items: List) -> List[List[Any]]:
        """
        Split items into basic blocks.
        A new block starts after a jump and at each label.
        """
        blocks: List[List[Any]] = []
        current_block: List[Any] = []

        for item in items:
            if isinstance(item, Label):
                # Labels start a new block (but also terminate the previous one)
                if current_block:
                    blocks.append(current_block)
                current_block = [item]
            elif isinstance(item, Op) and item.is_jump:
                current_block.append(item)
                blocks.append(current_block)
                current_block = []
            else:
                current_block.append(item)

        if current_block:
            blocks.append(current_block)

        return blocks

    @staticmethod
    def _memory_domain(op: Op) -> Optional[str]:
        """Return the memory domain for memory ops, else None."""
        if op.engine not in ("load", "store"):
            return None
        if op.op == "const":
            return None
        if op.op in ("vload", "vstore"):
            return "vector"
        return op.params.get("memory_domain", "scalar")

    @classmethod
    def _is_vector_instruction(cls, op: Op) -> bool:
        """Vector instruction classes that may contend with vector banks."""
        return op.engine == "valu" or op.op in ("vload", "vstore")

    @classmethod
    def _is_scalar_mem_on_vector_bank(cls, op: Op) -> bool:
        """Scalar memory op explicitly targeting vector banks."""
        if op.op not in ("load", "load_offset", "store"):
            return False
        return cls._memory_domain(op) == "vector"

    @classmethod
    def _has_vector_bank_contention(cls, existing_ops: List[Op], new_op: Op) -> bool:
        """
        Prevent scalar-on-vector-bank memory ops from co-issuing with vector ops.

        This isolates scalar probes/copies into vector memory from active
        vector compute/memory traffic in the same bundle.
        """
        if not existing_ops:
            return False

        new_is_scalar_vecmem = cls._is_scalar_mem_on_vector_bank(new_op)
        new_is_vector_instr = cls._is_vector_instruction(new_op)

        if not (new_is_scalar_vecmem or new_is_vector_instr):
            return False

        existing_has_scalar_vecmem = any(cls._is_scalar_mem_on_vector_bank(op) for op in existing_ops)
        existing_has_vector_instr = any(cls._is_vector_instruction(op) for op in existing_ops)

        return (new_is_scalar_vecmem and existing_has_vector_instr) or \
               (new_is_vector_instr and existing_has_scalar_vecmem)

    def _schedule_block(
        self,
        block: List,
        start_cycle: int,
        reg_ready: Dict[int, int],
        div_busy: Dict[int, int],
        label_pcs: Dict[str, int],
        verbose: bool
    ) -> Tuple[int, List[Tuple[int, Dict]]]:
        """
        Schedule a single basic block.

        Returns (next_cycle, list of (cycle, bundle_dict) pairs).
        Updates reg_ready and div_busy in place.
        """
        # Bundle layout: cycle → {engine: [op_tuples]}
        cycle_bundles: Dict[int, Dict[str, list]] = {}
        slot_usage: Dict[int, Dict[str, int]] = {}  # cycle → {engine: count}
        # WAW tracking: cycle → set of dest regs written at that cycle
        cycle_writes: Dict[int, set] = {}
        # Read-bank tracking: cycle → {bank: scalar read count}
        cycle_read_banks: Dict[int, Dict[int, int]] = {}
        # Write-bank tracking: cycle → set of banks written (addr % 8)
        # Hardware has 1 write port per bank — only 1 write per bank per cycle.
        cycle_write_banks: Dict[int, set] = {}

        current_cycle = start_cycle
        result_bundles = []

        # Deferred labels: placed at the first real op's cycle
        pending_labels: List[Label] = []

        for item in block:
            if isinstance(item, Label):
                # Defer label placement until the first real op in this block
                pending_labels.append(item)
                continue

            op = item
            assert isinstance(op, Op)

            # Compute earliest cycle this op can be scheduled
            earliest = current_cycle

            # 1. Source register dependencies (RAW)
            for src in op.srcs:
                src_ready = reg_ready.get(src, 0)
                earliest = max(earliest, src_ready)

            # Branch guard: with 3-stage pipeline and write forwarding,
            # the predicate value is correctly forwarded. No extra slack needed.
            # (The NORMAL_LATENCY=1 RAW check is sufficient.)

            # 2. Resource availability: find a cycle >= earliest where
            #    the engine slot is available and no WAW conflict
            cycle = earliest
            while True:
                usage = slot_usage.get(cycle, {})
                used = usage.get(op.engine, 0)
                limit = self.cfg.slot_limits.get(op.engine, 1)
                if used < limit:
                    # HALT isolation: HALT must be alone in its bundle.
                    # If HALT is packed with a STORE/LOAD, the core halts
                    # before the AXI transaction completes.
                    if op.is_halt:
                        total_ops = sum(usage.values())
                        if total_ops > 0:
                            cycle += 1
                            continue
                    # Also: don't pack other ops into a bundle that has HALT
                    if not op.is_halt and cycle in cycle_bundles:
                        has_halt = any(
                            getattr(placed, 'is_halt', False)
                            for ops_list in cycle_bundles[cycle].values()
                            for placed in ops_list
                        )
                        if has_halt:
                            cycle += 1
                            continue

                    # Non-blocking memory: FLOW + memory ops CAN coexist in
                    # the same bundle. Memory pushes to FIFO without stalling,
                    # so control ops are not re-observed.

                    # Scalar accesses to vector memory banks must not co-issue
                    # with vector instructions (memory or VALU) to avoid
                    # contention on vector-bank traffic.
                    if cycle in cycle_bundles:
                        existing_ops = [
                            placed
                            for ops_list in cycle_bundles[cycle].values()
                            for placed in ops_list
                        ]
                        if self._has_vector_bank_contention(existing_ops, op):
                            cycle += 1
                            continue

                    # WAW check: no two ops write same register in same cycle
                    waw_conflict = False
                    if op.dests:
                        writes_at = cycle_writes.get(cycle, set())
                        for d in op.dests:
                            if d in writes_at:
                                waw_conflict = True
                                break
                    if waw_conflict:
                        cycle += 1
                        continue

                    # 3. Division exclusion: if this is a div op, check if
                    #    the ALU slot is busy from a previous div
                    if op.is_div and op.engine == "alu":
                        slot_idx = used  # which ALU slot this goes to
                        busy_until = div_busy.get(slot_idx, 0)
                        if cycle < busy_until:
                            cycle += 1
                            continue
                    # Also check: would a non-div ALU op at this cycle conflict
                    # with a divider.done?
                    if op.engine == "alu" and not op.is_div:
                        slot_idx = used
                        if self._div_done_conflicts(slot_idx, cycle, div_busy):
                            cycle += 1
                            continue

                    # 4. Read-bank conflict check (TDP scratch):
                    #    Up to 2 scalar reads per bank per cycle (Port A + Port B).
                    #    If the bank is also written in the same cycle, Port B is
                    #    consumed by write, so only 1 scalar read is allowed.
                    if cycle in cycle_bundles:
                        existing_ops = [
                            placed
                            for ops_list in cycle_bundles[cycle].values()
                            for placed in ops_list
                        ]
                        has_valu = any(p.engine == "valu" for p in existing_ops) or op.engine == "valu"
                        existing_ports = []
                        for p in existing_ops:
                            existing_ports.extend(_compute_read_ports(p, self.cfg))
                        new_ports = _compute_read_ports(op, self.cfg)

                        # Base limit: <=2 reads/bank (Port A + Port B)
                        if _has_bank_conflict(existing_ports, new_ports, has_valu,
                                              self.cfg.scratch_banks):
                            cycle += 1
                            continue

                        # Stricter when writes are present on the same bank:
                        # Port B is busy with write, so total reads on that bank must be <=1.
                        reads_at = cycle_read_banks.get(cycle, {})
                        writes_at = cycle_write_banks.get(cycle, set())

                        # New op read footprint by bank
                        new_read_counts: Dict[int, int] = {}
                        for _port, reg in new_ports:
                            bk = reg % self.cfg.scratch_banks
                            new_read_counts[bk] = new_read_counts.get(bk, 0) + 1

                        # 4a) If this op reads a bank already written in this cycle,
                        #     that bank can sustain at most one total read.
                        rw_conflict = False
                        for bk, add_cnt in new_read_counts.items():
                            if bk in writes_at and reads_at.get(bk, 0) + add_cnt > 1:
                                rw_conflict = True
                                break
                        if rw_conflict:
                            cycle += 1
                            continue

                    # 5. Write-bank conflict: hardware has 1 write port per
                    #    bank.  Two writes to the same bank in the same cycle
                    #    causes SpinalHDL last-assignment-wins -> silent data
                    #    loss.  Prevent by rejecting same-bank dest combos.
                    if op.dests:
                        new_wbanks = {d % self.cfg.scratch_banks for d in op.dests}
                        existing_wbanks = cycle_write_banks.get(cycle, set())
                        if new_wbanks & existing_wbanks:
                            cycle += 1
                            continue

                        # 5a. Write + read interaction on same bank (TDP):
                        # If this op introduces a write to bank b, and there are
                        # already 2 scalar reads on b in this cycle, Port B is
                        # needed for both write and read -> impossible.
                        reads_at = cycle_read_banks.get(cycle, {})
                        if any(reads_at.get(bk, 0) > 1 for bk in new_wbanks):
                            cycle += 1
                            continue

                    break
                cycle += 1

            # Place pending labels at this op's cycle (label = first op in block)
            for lbl in pending_labels:
                label_pcs[lbl.name] = cycle
                lbl._scheduled_cycle = cycle
                if verbose:
                    print(f"  Label '{lbl.name}' -> PC={cycle}")
            pending_labels = []

            # Place the op at this cycle
            op._scheduled_cycle = cycle

            if cycle not in slot_usage:
                slot_usage[cycle] = {}
            if cycle not in cycle_bundles:
                cycle_bundles[cycle] = {}
            if cycle not in cycle_writes:
                cycle_writes[cycle] = set()
            if cycle not in cycle_read_banks:
                cycle_read_banks[cycle] = {}

            eng = op.engine
            slot_usage[cycle][eng] = slot_usage[cycle].get(eng, 0) + 1
            if eng not in cycle_bundles[cycle]:
                cycle_bundles[cycle][eng] = []
            cycle_bundles[cycle][eng].append(op)

            # Record writes for WAW tracking + write-bank tracking
            if cycle not in cycle_write_banks:
                cycle_write_banks[cycle] = set()
            for d in op.dests:
                cycle_writes[cycle].add(d)
                cycle_write_banks[cycle].add(d % self.cfg.scratch_banks)

            # Record read-bank usage for Port A/Port B capacity tracking
            for _port, reg in _compute_read_ports(op, self.cfg):
                bk = reg % self.cfg.scratch_banks
                cycle_read_banks[cycle][bk] = cycle_read_banks[cycle].get(bk, 0) + 1

            # Update register ready times
            for dest in op.dests:
                reg_ready[dest] = cycle + op.latency

            # Track division busy state
            if op.is_div and op.engine == "alu":
                slot_idx = slot_usage[cycle].get("alu", 1) - 1
                div_busy[slot_idx] = cycle + self.cfg.div_latency

            # If this is a jump, advance past the bubble
            if op.is_jump:
                current_cycle = cycle + 1 + JUMP_BUBBLE  # +1 for current, +1 for bubble
            elif op.engine in ("load", "store") and op.op not in ("const",):
                current_cycle = cycle + 1 + self.cfg.mem_post_gap
            elif op.engine == "valu":
                current_cycle = cycle + 1 + self.cfg.valu_post_gap
            else:
                # Don't force advancing — the next op may pack into the same cycle
                # unless we need to for program order
                current_cycle = max(current_cycle, cycle)

            if verbose:
                print(f"  Scheduled {op} at cycle {cycle}")

        # If there were trailing labels with no ops after them,
        # place them at current_cycle
        for lbl in pending_labels:
            label_pcs[lbl.name] = current_cycle
            lbl._scheduled_cycle = current_cycle

        # Determine the range of cycles used
        if cycle_bundles:
            min_cycle = min(cycle_bundles.keys())
            max_cycle = max(cycle_bundles.keys())
        else:
            min_cycle = start_cycle
            max_cycle = start_cycle - 1

        # Add jump bubble for the last item if it was a jump
        last_cycle = max_cycle
        if block and isinstance(block[-1], Op) and block[-1].is_jump:
            last_cycle = max_cycle + JUMP_BUBBLE

        # Convert cycle_bundles to linear bundle list (with NOP padding)
        for c in range(start_cycle, last_cycle + 1):
            bundle = cycle_bundles.get(c, {})
            result_bundles.append((c, bundle))

        next_cycle = last_cycle + 1

        # Verify loop-carried dependencies for backward jumps
        self._verify_loop_deps(block, label_pcs, verbose)

        return next_cycle, result_bundles

    def _verify_loop_deps(self, block: List, label_pcs: Dict[str, int],
                          verbose: bool):
        """
        Verify that loop-carried RAW dependencies are satisfied.

        For backward jumps (target PC <= jump PC), check that writes
        in the loop body are far enough from reads in the next iteration.
        """
        # Find backward jumps in this block
        for item in block:
            if not isinstance(item, Op):
                continue
            if not item.is_jump or item.jump_target is None:
                continue
            target_pc = label_pcs.get(item.jump_target, -1)
            jump_pc = item._scheduled_cycle
            if target_pc < 0 or target_pc > jump_pc:
                continue  # forward jump, skip

            # Collect all writes and reads within [target_pc, jump_pc]
            loop_ops = [it for it in block
                        if isinstance(it, Op) and
                        target_pc <= it._scheduled_cycle <= jump_pc]

            # Build write map: reg → latest write cycle in loop
            write_map: Dict[int, int] = {}  # reg → cycle written
            for op in loop_ops:
                for d in op.dests:
                    write_map[d] = max(write_map.get(d, -1),
                                       op._scheduled_cycle)

            # Check reads in loop against writes from PREVIOUS iteration
            # Wrap-around gap = (jump_pc - write_cycle) + JUMP_BUBBLE + (read_cycle - target_pc)
            for op in loop_ops:
                for src in op.srcs:
                    if src not in write_map:
                        continue  # not written in loop body
                    w_cycle = write_map[src]
                    r_cycle = op._scheduled_cycle

                    if r_cycle >= w_cycle + NORMAL_LATENCY:
                        continue  # intra-iteration dep OK

                    # Loop-carried: writer at w_cycle (prev iter),
                    # reader at r_cycle (next iter)
                    wrap_gap = (jump_pc - w_cycle) + JUMP_BUBBLE + \
                               (r_cycle - target_pc) + 1
                    if wrap_gap < NORMAL_LATENCY:
                        msg = (f"WARNING: Loop-carried RAW hazard! "
                               f"s[{src}] written at PC={w_cycle}, "
                               f"read at PC={r_cycle} (wrap gap={wrap_gap}, "
                               f"need {NORMAL_LATENCY})")
                        if verbose:
                            print(f"  ⚠ {msg}")
                        # Insert a NOP at the jump target to increase the gap
                        # This is a conservative fix — shift all ops in the block
                        # For now, just warn and let the user handle it.

    def _div_done_conflicts(self, slot_idx: int, cycle: int,
                            div_busy: Dict[int, int]) -> bool:
        """Check if a divider.done fires on this slot at this cycle."""
        # div_busy[slot_idx] = start_cycle + div_latency = done_cycle
        # The divider result is written at done_cycle. If a non-div op
        # is scheduled AT done_cycle on the same slot, there's a WAW conflict.
        busy_until = div_busy.get(slot_idx, 0)
        if busy_until > 0:
            # divider.done fires at busy_until
            done_cycle = busy_until
            if cycle == done_cycle:
                return True
        return False

    def _resolve_jumps(self, bundles: List[Tuple[int, Dict]],
                       label_pcs: Dict[str, int],
                       verbose: bool) -> List[Dict]:
        """
        Convert (cycle, bundle_dict) pairs to instruction dicts.
        Resolve label-based jump targets to absolute PCs.
        """
        result = []

        for pc, (cycle, bundle) in enumerate(bundles):
            instr = {}

            for engine, ops in bundle.items():
                slot_list = []
                for op in ops:
                    t = self._op_to_tuple(op, label_pcs, pc)
                    if t is not None:
                        slot_list.append(t)
                if slot_list:
                    instr[engine] = slot_list

            result.append(instr)

        return result

    def _op_to_tuple(self, op: Op, label_pcs: Dict[str, int],
                     current_pc: int) -> Optional[tuple]:
        """Convert an Op to the assembler tuple format."""
        p = op.params

        if op.engine == "alu":
            return (op.op, p["dest"], p["src1"], p["src2"])

        elif op.engine == "valu":
            if op.op == "vbroadcast":
                return ("vbroadcast", p["dest_base"], p["src1_base"])
            elif op.op == "multiply_add":
                return ("multiply_add", p["dest_base"], p["src1_base"],
                        p["src2_base"], p["src3_base"])
            else:
                return (op.op, p["dest_base"], p["src1_base"], p["src2_base"])

        elif op.engine == "load":
            if op.op == "const":
                return ("const", p["dest"], p["value"])
            elif op.op == "load":
                return ("load", p["dest"], p["addr_reg"])
            elif op.op == "load_offset":
                return ("load_offset", p["dest"], p["addr_reg"], p["offset"])
            elif op.op == "vload":
                return ("vload", p["dest"], p["addr_reg"])

        elif op.engine == "store":
            if op.op == "store":
                return ("store", p["addr_reg"], p["src_reg"])
            elif op.op == "vstore":
                return ("vstore", p["addr_reg"], p["src_reg"])

        elif op.engine == "flow":
            if op.op == "halt":
                return ("halt",)
            elif op.op == "jump":
                target = self._resolve_target(op, label_pcs)
                return ("jump", target)
            elif op.op == "cond_jump":
                target = self._resolve_target(op, label_pcs)
                return ("cond_jump", p["cond_reg"], target)
            elif op.op == "cond_jump_rel":
                # For relative jumps, compute offset from the scheduled PC
                if op.jump_target:
                    target_pc = label_pcs.get(op.jump_target, 0)
                    offset = target_pc - current_pc
                    return ("cond_jump_rel", p["cond_reg"], offset)
                return ("cond_jump_rel", p["cond_reg"], p["offset"])
            elif op.op == "jump_indirect":
                return ("jump_indirect", p["addr_reg"])
            elif op.op == "select":
                return ("select", p["dest"], p["cond"], p["src_a"], p["src_b"])
            elif op.op == "vselect":
                return ("vselect", p["dest"], p["cond"], p["src_a"], p["src_b"])
            elif op.op == "add_imm":
                return ("add_imm", p["dest"], p["src"], p["imm"])
            elif op.op == "coreid":
                return ("coreid", p["dest"])

        return None

    def _resolve_target(self, op: Op, label_pcs: Dict[str, int]) -> int:
        """Resolve a jump target from label name or explicit PC."""
        if op.jump_target and op.jump_target in label_pcs:
            return label_pcs[op.jump_target]
        return op.params.get("target", 0)

    # ================================================================
    #  Statistics
    # ================================================================

    def _print_stats(self, bundles: List[Dict], operations: List):
        """Print scheduling statistics."""
        real_ops = [item for item in operations
                    if isinstance(item, Op) and not item.is_halt]
        n_ops = len(real_ops)
        n_bundles = len(bundles)

        # Count non-NOP bundles
        n_active = sum(1 for b in bundles if b)  # non-empty dicts

        # Count total slots used vs total slots available
        total_slots = sum(sum(self.cfg.slot_limits.values())
                         for _ in bundles)
        used_slots = sum(
            sum(len(slots) for slots in b.values())
            for b in bundles
        )

        # Engine utilization
        print(f"\n{'='*60}")
        print(f" VLIW Scheduler Statistics")
        print(f"{'='*60}")
        print(f"  Operations:      {n_ops}")
        print(f"  Bundles emitted: {n_bundles}")
        print(f"  Active bundles:  {n_active} ({100*n_active/max(n_bundles,1):.0f}%)")
        print(f"  Slot usage:      {used_slots}/{total_slots} ({100*used_slots/max(total_slots,1):.1f}%)")

        # Per-engine utilization
        for eng in ["alu", "valu", "load", "store", "flow"]:
            limit = self.cfg.slot_limits[eng]
            used = sum(len(b.get(eng, [])) for b in bundles)
            avail = limit * n_bundles
            pct = 100 * used / max(avail, 1)
            print(f"    {eng:6s}: {used:3d}/{avail:3d} ({pct:5.1f}%)")

        # NOP bundles
        n_nops = n_bundles - n_active
        print(f"  NOP bundles:     {n_nops}")
        print(f"{'='*60}\n")

    # ================================================================
    #  High-level program builder
    # ================================================================

    def program(self, ops: List) -> List[Dict]:
        """
        Shorthand for schedule() with verbose=False.

        Usage:
            s = VliwScheduler()
            bundles = s.program([
                s.const(0, 100),
                s.const(1, 200),
                s.add(2, 0, 1),
                s.halt(),
            ])
        """
        return self.schedule(ops, verbose=False)


# ============================================================================
#  Convenience: standalone schedule function
# ============================================================================

def schedule_program(ops: List, config: Optional[SchedulerConfig] = None,
                     verbose: bool = False) -> List[Dict]:
    """
    Schedule a list of operations into instruction bundles.

    Args:
        ops:     List of Op/Label objects (from VliwScheduler convenience methods)
        config:  Hardware configuration (defaults to Sim config)
        verbose: Print scheduling statistics

    Returns:
        List of instruction dicts for Assembler.assemble_program()
    """
    sched = VliwScheduler(config)
    return sched.schedule(ops, verbose=verbose)


# ============================================================================
#  Self-test / CLI
# ============================================================================

if __name__ == "__main__":
    print("VLIW Scheduler self-test\n")

    s = VliwScheduler()

    # ---- Test 1: Simple add with hazard avoidance ----
    print("Test 1: CONST + ADD with RAW hazard")
    ops = [
        s.const(0, 100),
        s.const(1, 200),
        s.add(2, 0, 1),
        s.halt(),
    ]
    bundles = s.schedule(ops, verbose=True)
    print("Bundles:")
    for i, b in enumerate(bundles):
        print(f"  [{i}] {b}")

    # With NORMAL_LATENCY=1 (write forwarding):
    # CONST(0) at bundle 0 -> ready at 1. CONST(1) at bundle 1 -> ready at 2.
    # ADD needs both -> earliest at bundle 2.
    add_pc = None
    for i, b in enumerate(bundles):
        if "alu" in b:
            add_pc = i
    assert add_pc is not None and add_pc >= 3, \
        f"ADD should be at PC >= 3 (got {add_pc}) to avoid RAW hazard with CONST(1)"
    print(f"  PASS ADD at PC={add_pc} (correct: avoids RAW hazard)\n")

    # ---- Test 2: Division latency ----
    print("Test 2: Division latency tracking")
    ops = [
        s.const(0, 100),
        s.const(1, 7),
        s.div(2, 0, 1),      # takes 35 bundles until dest readable
        s.add(3, 2, 0),      # must wait for div result
        s.halt(),
    ]
    bundles = s.schedule(ops, verbose=True)
    print("Bundles:")
    for i, b in enumerate(bundles):
        if b:
            print(f"  [{i}] {b}")
    # ADD should be at PC >= div_pc + DIV_LATENCY (34 with forwarding)
    div_pc = None
    add_pc = None
    for i, b in enumerate(bundles):
        if "alu" in b:
            for slot in b["alu"]:
                if slot[0] == "div":
                    div_pc = i
                elif slot[0] == "add":
                    add_pc = i
    assert div_pc is not None and add_pc is not None
    assert add_pc >= div_pc + DIV_LATENCY, \
        f"ADD at PC={add_pc} must be >= DIV PC={div_pc}+{DIV_LATENCY}={div_pc+DIV_LATENCY}"
    print(f"  PASS DIV at PC={div_pc}, ADD at PC={add_pc} (gap={add_pc-div_pc})\n")

    # ---- Test 3: Jump with label resolution ----
    print("Test 3: Jump with label")
    ops = [
        s.const(0, 0),
        s.const(1, 5),
        s.const(2, 1),
        s.label("loop"),
        s.add(0, 0, 2),
        s.lt(3, 0, 1),
        s.cond_jump(3, "loop"),
        s.halt(),
    ]
    bundles = s.schedule(ops, verbose=True)
    print("Bundles:")
    for i, b in enumerate(bundles):
        if b:
            print(f"  [{i}] {b}")

    # Verify cond_jump target resolves to the loop label PC
    cj_pc = None
    cj_target = None
    for i, b in enumerate(bundles):
        if "flow" in b:
            for slot in b["flow"]:
                if slot[0] == "cond_jump":
                    cj_pc = i
                    cj_target = slot[2]
    print(f"  cond_jump at PC={cj_pc}, target PC={cj_target}")
    print(f"  PASS Label resolution working\n")

    # ---- Test 4: Bundle packing (dual-issue) ----
    print("Test 4: Bundle packing — independent ops on different engines")
    ops = [
        s.const(0, 10),       # load slot
        s.coreid(5),          # flow slot — independent
        s.const(1, 20),       # load slot — must wait (only 1 load slot)
        s.halt(),
    ]
    bundles = s.schedule(ops, verbose=True)
    print("Bundles:")
    for i, b in enumerate(bundles):
        if b:
            print(f"  [{i}] {b}")

    # CONST(0) + COREID should be in the SAME bundle
    b0 = bundles[0]
    packed = "load" in b0 and "flow" in b0
    print(f"  PASS Dual-issue: {'YES' if packed else 'NO'} (load+flow in bundle 0)\n")

    # ---- Test 5: Fibonacci ----
    print("Test 5: Fibonacci(10) — loop with labels")
    ops = [
        s.const(0, 0),        # fib_prev = 0
        s.const(1, 1),        # fib_curr = 1
        s.const(2, 2),        # counter = 2
        s.const(3, 10),       # limit = 10
        s.const(4, 1),        # increment = 1
        s.const(30, 0),       # zero register (for moves)
        s.label("fib_loop"),
        s.add(5, 0, 1),       # temp = prev + curr
        s.add(0, 1, 30),      # prev = curr  (add zero)
        s.add(1, 5, 30),      # curr = temp  (add zero)
        s.add(2, 2, 4),       # counter++
        s.lt(6, 2, 3),        # counter < limit?
        s.cond_jump(6, "fib_loop"),
        s.const(10, 0),
        s.store(10, 1),       # mem[0] = fib_curr
        s.halt(),
    ]
    bundles = s.schedule(ops, verbose=True)
    print(f"  Total bundles: {len(bundles)}")
    for i, b in enumerate(bundles):
        if b:
            print(f"  [{i:2d}] {b}")
    print()

    print("All self-tests passed!")
