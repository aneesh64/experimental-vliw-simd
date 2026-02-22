"""
Golden model for VLIW SIMD co-processor verification.

Provides a cycle-accurate Python model that mirrors the RTL behavior:
  - Instruction fetch with 2-stage pipeline latency
  - Banked scratch memory with BRAM-like timing
  - All engine operations (ALU, VALU, Load, Store, Flow)
  - Write buffering (all reads see old state)

Can be used standalone or driven by cocotb testbenches for comparison.
"""

from __future__ import annotations
from typing import Dict, List, Optional
import copy

MOD32 = 2**32


class GoldenModel:
    """
    Cycle-accurate golden model for a single VLIW core.

    Matches the RTL's 2-stage pipeline semantics:
      Cycle N:   Fetch instruction[PC]           (IF stage)
      Cycle N+1: Execute instruction[PC] with    (EX stage)
                 scratch reads from Cycle N state
    """

    def __init__(self, scratch_size: int = 1536, vlen: int = 8, core_id: int = 0):
        self.scratch_size = scratch_size
        self.vlen = vlen
        self.core_id = core_id

        # State
        self.scratch = [0] * scratch_size
        self.mem = {}           # sparse memory model (addr → value)
        self.pc = 0
        self.halted = False
        self.running = False
        self.cycle_count = 0

        # Program
        self.program: List[Dict] = []

        # Pipeline: in-flight instruction (fetched last cycle)
        self._pipeline_valid = False
        self._pipeline_instr = None
        self._pipeline_pc = 0

        # Write buffer: collected during EX, applied at end of cycle
        self._scratch_writes: Dict[int, int] = {}
        self._mem_writes: Dict[int, int] = {}

    def load_program(self, program: List[Dict]):
        """Load a program (list of instruction dicts)."""
        self.program = program

    def load_memory(self, base_addr: int, data: List[int]):
        """Load data into main memory starting at base_addr."""
        for i, val in enumerate(data):
            self.mem[base_addr + i] = val % MOD32

    def start(self):
        """Start execution."""
        self.pc = 0
        self.halted = False
        self.running = True
        self.cycle_count = 0
        self._pipeline_valid = False

    def step(self) -> bool:
        """
        Execute one clock cycle.

        Returns True if still running, False if halted.
        """
        if self.halted or not self.running:
            return False

        self._scratch_writes = {}
        self._mem_writes = {}

        # ---- EX stage: execute the in-flight instruction ----
        jump_target = None
        do_halt = False

        if self._pipeline_valid:
            instr = self._pipeline_instr
            jump_target, do_halt = self._execute(instr, self._pipeline_pc)

        # ---- IF stage: fetch next instruction ----
        # If jump in EX, invalidate the fetched instruction and redirect PC
        if jump_target is not None:
            self._pipeline_valid = False
            self.pc = jump_target
        elif do_halt:
            self._pipeline_valid = False
            self.halted = True
            self.running = False
        else:
            # Normal fetch: current PC
            if self.pc < len(self.program):
                self._pipeline_instr = self.program[self.pc]
                self._pipeline_valid = True
                self._pipeline_pc = self.pc
                self.pc += 1
            else:
                self._pipeline_valid = False

        # ---- Commit writes ----
        for addr, val in self._scratch_writes.items():
            self.scratch[addr] = val % MOD32
        for addr, val in self._mem_writes.items():
            self.mem[addr] = val % MOD32

        self.cycle_count += 1
        return not self.halted

    def run(self, max_cycles: int = 100000) -> int:
        """Run until halt or max_cycles. Returns cycle count."""
        self.start()
        for _ in range(max_cycles):
            if not self.step():
                break
        return self.cycle_count

    # ---- Internal execution ----

    def _read_scratch(self, addr: int) -> int:
        """Read from scratch (old state — before any writes this cycle)."""
        if 0 <= addr < self.scratch_size:
            return self.scratch[addr]
        return 0

    def _write_scratch(self, addr: int, val: int):
        """Buffer a scratch write."""
        self._scratch_writes[addr] = val % MOD32

    def _read_mem(self, addr: int) -> int:
        """Read from main memory."""
        return self.mem.get(addr, 0)

    def _write_mem(self, addr: int, val: int):
        """Buffer a memory write."""
        self._mem_writes[addr] = val % MOD32

    def _alu_op(self, op: str, a: int, b: int) -> int:
        """Execute a scalar ALU operation."""
        a = a % MOD32
        b = b % MOD32
        ops = {
            "+":    lambda: (a + b) % MOD32,
            "-":    lambda: (a - b) % MOD32,
            "*":    lambda: (a * b) % MOD32,
            "^":    lambda: a ^ b,
            "&":    lambda: a & b,
            "|":    lambda: a | b,
            "<<":   lambda: (a << (b & 31)) % MOD32,
            ">>":   lambda: (a >> (b & 31)) % MOD32,
            "<":    lambda: 1 if a < b else 0,
            "==":   lambda: 1 if a == b else 0,
            "%":    lambda: (a % b) % MOD32 if b != 0 else 0,
            "//":   lambda: (a // b) % MOD32 if b != 0 else 0,
            "cdiv": lambda: ((a + b - 1) // b) % MOD32 if b != 0 else 0,
        }
        return ops[op]()

    def _execute(self, instr: Dict, pc: int):
        """Execute one instruction bundle. Returns (jump_target, do_halt)."""
        jump_target = None
        do_halt = False

        # ALU
        for op_tuple in instr.get("alu", []):
            op, dest, src1, src2 = op_tuple[0], op_tuple[1], op_tuple[2], op_tuple[3]
            a = self._read_scratch(src1)
            b = self._read_scratch(src2)
            self._write_scratch(dest, self._alu_op(op, a, b))

        # VALU
        for op_tuple in instr.get("valu", []):
            op = op_tuple[0]
            if op == "vbroadcast":
                dest, src = op_tuple[1], op_tuple[2]
                val = self._read_scratch(src)
                for i in range(self.vlen):
                    self._write_scratch(dest + i, val)
            elif op == "multiply_add":
                dest, a_base, b_base, c_base = op_tuple[1], op_tuple[2], op_tuple[3], op_tuple[4]
                for i in range(self.vlen):
                    a = self._read_scratch(a_base + i)
                    b = self._read_scratch(b_base + i)
                    c = self._read_scratch(c_base + i)
                    self._write_scratch(dest + i, (a * b + c) % MOD32)
            else:
                dest, src1, src2 = op_tuple[1], op_tuple[2], op_tuple[3]
                for i in range(self.vlen):
                    a = self._read_scratch(src1 + i)
                    b = self._read_scratch(src2 + i)
                    self._write_scratch(dest + i, self._alu_op(op, a, b))

        # Load
        for op_tuple in instr.get("load", []):
            op = op_tuple[0]
            if op == "load":
                dest, addr_reg = op_tuple[1], op_tuple[2]
                addr = self._read_scratch(addr_reg)
                self._write_scratch(dest, self._read_mem(addr))
            elif op == "load_offset":
                dest, addr_reg, offset = op_tuple[1], op_tuple[2], op_tuple[3]
                addr = self._read_scratch(addr_reg + offset)
                self._write_scratch(dest + offset, self._read_mem(addr))
            elif op == "vload":
                dest, addr_reg = op_tuple[1], op_tuple[2]
                base_addr = self._read_scratch(addr_reg)
                for i in range(self.vlen):
                    self._write_scratch(dest + i, self._read_mem(base_addr + i))
            elif op == "const":
                dest, val = op_tuple[1], op_tuple[2]
                self._write_scratch(dest, val % MOD32)

        # Store
        for op_tuple in instr.get("store", []):
            op = op_tuple[0]
            if op == "store":
                addr_reg, src_reg = op_tuple[1], op_tuple[2]
                addr = self._read_scratch(addr_reg)
                self._write_mem(addr, self._read_scratch(src_reg))
            elif op == "vstore":
                addr_reg, src_reg = op_tuple[1], op_tuple[2]
                base_addr = self._read_scratch(addr_reg)
                for i in range(self.vlen):
                    self._write_mem(base_addr + i, self._read_scratch(src_reg + i))

        # Flow
        for op_tuple in instr.get("flow", []):
            op = op_tuple[0]
            if op == "select":
                dest, cond, a, b = op_tuple[1], op_tuple[2], op_tuple[3], op_tuple[4]
                cond_val = self._read_scratch(cond)
                self._write_scratch(dest,
                    self._read_scratch(a) if cond_val != 0 else self._read_scratch(b))
            elif op == "vselect":
                dest, cond, a, b = op_tuple[1], op_tuple[2], op_tuple[3], op_tuple[4]
                for i in range(self.vlen):
                    cond_val = self._read_scratch(cond + i)
                    self._write_scratch(dest + i,
                        self._read_scratch(a + i) if cond_val != 0 else self._read_scratch(b + i))
            elif op == "add_imm":
                dest, a, imm = op_tuple[1], op_tuple[2], op_tuple[3]
                self._write_scratch(dest, (self._read_scratch(a) + imm) % MOD32)
            elif op == "halt":
                do_halt = True
            elif op == "cond_jump":
                cond, addr = op_tuple[1], op_tuple[2]
                if self._read_scratch(cond) != 0:
                    jump_target = addr
            elif op == "cond_jump_rel":
                cond, offset = op_tuple[1], op_tuple[2]
                if self._read_scratch(cond) != 0:
                    jump_target = pc + offset
            elif op == "jump":
                jump_target = op_tuple[1]
            elif op == "jump_indirect":
                jump_target = self._read_scratch(op_tuple[1])
            elif op == "coreid":
                self._write_scratch(op_tuple[1], self.core_id)
            elif op in ("trace_write", "pause"):
                pass  # not modeled in golden

        return jump_target, do_halt
