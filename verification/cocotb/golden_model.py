"""
Golden model for VLIW SIMD co-processor verification.

Provides a cycle-accurate Python model that mirrors the RTL behavior:
  - Instruction fetch with 2-stage pipeline latency
  - Banked scratch memory with BRAM-like timing
  - All engine operations (ALU, VALU, Load, Store, Flow)
  - Multi-width packed sub-element VALU operations
  - Write buffering (all reads see old state)

Can be used standalone or driven by cocotb testbenches for comparison.
"""

from __future__ import annotations
from typing import Dict, List, Optional
import copy

MOD32 = 2**32

# Element width encoding → (bit_width, subs_per_lane)
EWIDTH_INFO = {
    0: (32, 1),   # EW32
    1: (8,  4),   # EW8
    2: (16, 2),   # EW16
    3: (4,  8),   # EW4
    4: (64, 1),   # EW64 (lane pairing)
}

# Element width values (integers) → encoding
EWIDTH_MAP = {32: 0, 8: 1, 16: 2, 4: 3, 64: 4}


def _to_signed(val: int, bits: int) -> int:
    """Convert unsigned value to signed (two's complement)."""
    mask = (1 << bits) - 1
    val = val & mask
    if val >= (1 << (bits - 1)):
        return val - (1 << bits)
    return val


def _from_signed(val: int, bits: int) -> int:
    """Convert signed value to unsigned representation."""
    mask = (1 << bits) - 1
    return val & mask


def _extract_sub(word: int, ew: int, idx: int) -> int:
    """Extract sub-element idx from a 32-bit packed word at element width ew."""
    mask = (1 << ew) - 1
    return (word >> (idx * ew)) & mask


def _pack_subs(subs: list, ew: int) -> int:
    """Pack a list of sub-element values into a 32-bit word."""
    result = 0
    for i, s in enumerate(subs):
        result |= ((s & ((1 << ew) - 1)) << (i * ew))
    return result & 0xFFFFFFFF


def _packed_alu_op(op: str, a_word: int, b_word: int, ew: int, n: int,
                    signed: bool = False) -> int:
    """Perform a packed sub-element ALU operation on two 32-bit words."""
    mask = (1 << ew) - 1
    subs = []
    for k in range(n):
        sa = _extract_sub(a_word, ew, k)
        sb = _extract_sub(b_word, ew, k)
        if op in ("+", "add"):
            r = (sa + sb) & mask
        elif op in ("-", "sub"):
            r = (sa - sb) & mask
        elif op in ("*", "mul"):
            if signed:
                sa_s = _to_signed(sa, ew)
                sb_s = _to_signed(sb, ew)
                r = _from_signed(sa_s * sb_s, ew)
            else:
                r = (sa * sb) & mask
        elif op in ("^", "xor"):
            r = sa ^ sb
        elif op in ("&", "and"):
            r = sa & sb
        elif op in ("|", "or"):
            r = sa | sb
        elif op in ("<<", "shl"):
            sh_mask = ew - 1  # e.g., 7 for 8-bit
            r = (sa << (sb & sh_mask)) & mask
        elif op in (">>", "shr"):
            sh_mask = ew - 1
            shamt = sb & sh_mask
            if signed:
                sa_s = _to_signed(sa, ew)
                r = _from_signed(sa_s >> shamt, ew)
            else:
                r = sa >> shamt
        elif op in ("<", "lt"):
            if signed:
                r = 1 if _to_signed(sa, ew) < _to_signed(sb, ew) else 0
            else:
                r = 1 if sa < sb else 0
        elif op in ("==", "eq"):
            r = 1 if sa == sb else 0
        else:
            raise ValueError(f"Unknown packed op: {op}")
        subs.append(r & mask)
    return _pack_subs(subs, ew)


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
        # Also accept long-form names
        aliases = {"add": "+", "sub": "-", "mul": "*", "xor": "^",
                   "and": "&", "or": "|", "shl": "<<", "shr": ">>",
                   "lt": "<", "eq": "==", "mod": "%", "div": "//"}
        canon = aliases.get(op, op)
        return ops[canon]()

    def _alu_op_64(self, op: str, a: int, b: int, signed: bool = False) -> int:
        """Execute a 64-bit ALU operation. Returns 64-bit unsigned result."""
        MOD64 = 2**64
        a = a % MOD64
        b = b % MOD64
        aliases = {"add": "+", "sub": "-", "mul": "*", "xor": "^",
                   "and": "&", "or": "|", "shl": "<<", "shr": ">>",
                   "lt": "<", "eq": "=="}
        canon = aliases.get(op, op)
        if canon == "+":
            return (a + b) % MOD64
        elif canon == "-":
            return (a - b) % MOD64
        elif canon == "^":
            return a ^ b
        elif canon == "&":
            return a & b
        elif canon == "|":
            return a | b
        elif canon == "<<":
            return (a << (b & 63)) % MOD64
        elif canon == ">>":
            if signed:
                a_s = _to_signed(a, 64)
                return _from_signed(a_s >> (b & 63), 64)
            return (a >> (b & 63)) % MOD64
        elif canon == "<":
            if signed:
                return 1 if _to_signed(a, 64) < _to_signed(b, 64) else 0
            return 1 if a < b else 0
        elif canon == "==":
            return 1 if a == b else 0
        else:
            raise ValueError(f"Unsupported 64-bit op: {op}")

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
                ew_code = op_tuple[3] if len(op_tuple) > 3 else 0
                if isinstance(ew_code, int) and ew_code in EWIDTH_MAP.values():
                    ew = EWIDTH_INFO[ew_code][0]
                elif ew_code in EWIDTH_MAP:
                    ew = int(ew_code)
                else:
                    ew = 32
                val = self._read_scratch(src)
                # Broadcast lowest sub-element to all positions in all lanes
                mask = (1 << ew) - 1
                sub_val = val & mask
                if ew < 32:
                    n_subs = 32 // ew
                    packed = _pack_subs([sub_val] * n_subs, ew)
                else:
                    packed = val
                for i in range(self.vlen):
                    self._write_scratch(dest + i, packed)
            elif op == "multiply_add":
                dest = op_tuple[1]
                a_base, b_base, c_base = op_tuple[2], op_tuple[3], op_tuple[4]
                ew_code = op_tuple[5] if len(op_tuple) > 5 else 0
                dw_code = op_tuple[6] if len(op_tuple) > 6 else ew_code
                sgn = bool(op_tuple[7]) if len(op_tuple) > 7 else False
                # Resolve element widths
                ew = EWIDTH_INFO.get(ew_code, (32, 1))[0] if isinstance(ew_code, int) and ew_code < 5 else (int(ew_code) if ew_code in EWIDTH_MAP else 32)
                dw = EWIDTH_INFO.get(dw_code, (32, 1))[0] if isinstance(dw_code, int) and dw_code < 5 else (int(dw_code) if dw_code in EWIDTH_MAP else 32)
                if isinstance(ew_code, int) and ew_code in EWIDTH_MAP.values():
                    pass
                elif ew_code in EWIDTH_MAP:
                    ew = int(ew_code); ew_code = EWIDTH_MAP[ew]
                if isinstance(dw_code, int) and dw_code in EWIDTH_MAP.values():
                    pass
                elif dw_code in EWIDTH_MAP:
                    dw = int(dw_code); dw_code = EWIDTH_MAP[dw]

                if ew == dw or dw_code == ew_code:
                    # Same-width FMA
                    n_subs = 32 // ew if ew < 32 else 1
                    for i in range(self.vlen):
                        a_w = self._read_scratch(a_base + i)
                        b_w = self._read_scratch(b_base + i)
                        c_w = self._read_scratch(c_base + i)
                        if ew == 32:
                            if sgn:
                                sa = _to_signed(a_w, 32)
                                sb = _to_signed(b_w, 32)
                                sc = _to_signed(c_w, 32)
                                r = _from_signed(sa * sb + sc, 32)
                            else:
                                r = (a_w * b_w + c_w) % MOD32
                            self._write_scratch(dest + i, r)
                        else:
                            subs = []
                            mask = (1 << ew) - 1
                            for k in range(n_subs):
                                sa = _extract_sub(a_w, ew, k)
                                sb = _extract_sub(b_w, ew, k)
                                sc = _extract_sub(c_w, ew, k)
                                if sgn:
                                    sa_s = _to_signed(sa, ew)
                                    sb_s = _to_signed(sb, ew)
                                    sc_s = _to_signed(sc, ew)
                                    subs.append(_from_signed(sa_s * sb_s + sc_s, ew))
                                else:
                                    subs.append((sa * sb + sc) & mask)
                            self._write_scratch(dest + i, _pack_subs(subs, ew))
                else:
                    # Widening FMA: ew < dw
                    n_dest = 32 // dw if dw < 32 else 1
                    mask_d = (1 << dw) - 1
                    for i in range(self.vlen):
                        a_w = self._read_scratch(a_base + i)
                        b_w = self._read_scratch(b_base + i)
                        c_w = self._read_scratch(c_base + i)
                        subs = []
                        for k in range(n_dest):
                            sa = _extract_sub(a_w, ew, k)
                            sb = _extract_sub(b_w, ew, k)
                            sc = _extract_sub(c_w, dw, k)
                            if sgn:
                                sa_s = _to_signed(sa, ew)
                                sb_s = _to_signed(sb, ew)
                                sc_s = _to_signed(sc, dw)
                                subs.append(_from_signed(sa_s * sb_s + sc_s, dw))
                            else:
                                subs.append((sa * sb + sc) & mask_d)
                        self._write_scratch(dest + i, _pack_subs(subs, dw) if dw < 32 else subs[0] & 0xFFFFFFFF)
            elif op == "vcast":
                dest, src = op_tuple[1], op_tuple[2]
                ew_val = op_tuple[3] if len(op_tuple) > 3 else 32
                dw_val = op_tuple[4] if len(op_tuple) > 4 else 32
                sgn = bool(op_tuple[5]) if len(op_tuple) > 5 else False
                upper = bool(op_tuple[6]) if len(op_tuple) > 6 else False
                # Resolve ew/dw to bit widths
                if ew_val in EWIDTH_MAP:
                    ew = int(ew_val)
                elif isinstance(ew_val, int) and ew_val < 5:
                    ew = EWIDTH_INFO[ew_val][0]
                else:
                    ew = int(ew_val)
                if dw_val in EWIDTH_MAP:
                    dw = int(dw_val)
                elif isinstance(dw_val, int) and dw_val < 5:
                    dw = EWIDTH_INFO[dw_val][0]
                else:
                    dw = int(dw_val)

                n_src = 32 // ew if ew < 32 else 1
                n_dst = 32 // dw if dw < 32 else 1

                for i in range(self.vlen):
                    a_w = self._read_scratch(src + i)
                    if ew == dw:
                        self._write_scratch(dest + i, a_w)
                    elif ew < dw:
                        # Widening cast
                        offset = n_dst if upper else 0
                        subs = []
                        for k in range(n_dst):
                            idx = k + offset
                            if idx < n_src:
                                sub = _extract_sub(a_w, ew, idx)
                            else:
                                sub = 0
                            if sgn:
                                sub_s = _to_signed(sub, ew)
                                subs.append(_from_signed(sub_s, dw))
                            else:
                                subs.append(sub)  # zero-extend
                        if dw >= 32:
                            self._write_scratch(dest + i, subs[0] & 0xFFFFFFFF)
                        else:
                            self._write_scratch(dest + i, _pack_subs(subs, dw))
                    else:
                        # Narrowing cast
                        subs = []
                        for k in range(n_src):
                            sub = _extract_sub(a_w, ew, k)
                            subs.append(sub & ((1 << dw) - 1))
                        packed_bits = n_src * dw
                        packed = _pack_subs(subs, dw)
                        if upper:
                            packed = (packed << packed_bits) & 0xFFFFFFFF
                        self._write_scratch(dest + i, packed)
            else:
                # Lane-wise ALU op with optional element width
                dest = op_tuple[1]
                src1, src2 = op_tuple[2], op_tuple[3]
                # Parse optional ew, dw, signed args
                ew_val = op_tuple[4] if len(op_tuple) > 4 else 32
                dw_raw = op_tuple[5] if len(op_tuple) > 5 else None
                sgn = False

                # Resolve ew
                if ew_val in EWIDTH_MAP:
                    ew = int(ew_val)
                elif isinstance(ew_val, int) and ew_val < 5:
                    ew = EWIDTH_INFO[ew_val][0]
                else:
                    ew = int(ew_val)

                if dw_raw is not None:
                    if len(op_tuple) > 6:
                        # (op, dest, src1, src2, ew, dw, signed)
                        if dw_raw in EWIDTH_MAP:
                            dw = int(dw_raw)
                        elif isinstance(dw_raw, int) and dw_raw < 5:
                            dw = EWIDTH_INFO[dw_raw][0]
                        else:
                            dw = int(dw_raw)
                        sgn = bool(op_tuple[6])
                    elif op in ("*", "mul") and dw_raw not in (0, 1):
                        # Widening MUL
                        if dw_raw in EWIDTH_MAP:
                            dw = int(dw_raw)
                        elif isinstance(dw_raw, int) and dw_raw < 5:
                            dw = EWIDTH_INFO[dw_raw][0]
                        else:
                            dw = int(dw_raw)
                    else:
                        dw = ew
                        sgn = bool(dw_raw)
                else:
                    dw = ew

                n_subs = 32 // ew if ew < 32 else 1

                if ew == 64:
                    # 64-bit lane pairing
                    for pair in range(self.vlen // 2):
                        lo_lane = pair * 2
                        hi_lane = pair * 2 + 1
                        a_lo = self._read_scratch(src1 + lo_lane)
                        a_hi = self._read_scratch(src1 + hi_lane)
                        b_lo = self._read_scratch(src2 + lo_lane)
                        b_hi = self._read_scratch(src2 + hi_lane)
                        a64 = a_lo | (a_hi << 32)
                        b64 = b_lo | (b_hi << 32)
                        r64 = self._alu_op_64(op, a64, b64, sgn)
                        self._write_scratch(dest + lo_lane, r64 & 0xFFFFFFFF)
                        self._write_scratch(dest + hi_lane, (r64 >> 32) & 0xFFFFFFFF)
                elif ew != dw and op in ("*", "mul"):
                    # Widening MUL
                    n_dest = 32 // dw if dw < 32 else 1
                    mask_d = (1 << dw) - 1
                    for i in range(self.vlen):
                        a_w = self._read_scratch(src1 + i)
                        b_w = self._read_scratch(src2 + i)
                        subs = []
                        for k in range(n_dest):
                            sa = _extract_sub(a_w, ew, k)
                            sb = _extract_sub(b_w, ew, k)
                            if sgn:
                                sa_s = _to_signed(sa, ew)
                                sb_s = _to_signed(sb, ew)
                                subs.append(_from_signed(sa_s * sb_s, dw))
                            else:
                                subs.append((sa * sb) & mask_d)
                        if dw >= 32:
                            self._write_scratch(dest + i, subs[0] & 0xFFFFFFFF)
                        else:
                            self._write_scratch(dest + i, _pack_subs(subs, dw))
                elif ew < 32:
                    # Packed sub-element ALU
                    for i in range(self.vlen):
                        a_w = self._read_scratch(src1 + i)
                        b_w = self._read_scratch(src2 + i)
                        r = _packed_alu_op(op, a_w, b_w, ew, n_subs, sgn)
                        self._write_scratch(dest + i, r)
                else:
                    # Standard 32-bit
                    for i in range(self.vlen):
                        a_w = self._read_scratch(src1 + i)
                        b_w = self._read_scratch(src2 + i)
                        if sgn and op in ("*", "mul"):
                            sa = _to_signed(a_w, 32)
                            sb = _to_signed(b_w, 32)
                            r = _from_signed(sa * sb, 32)
                        elif sgn and op in ("<", "lt"):
                            r = 1 if _to_signed(a_w, 32) < _to_signed(b_w, 32) else 0
                        elif sgn and op in (">>", "shr"):
                            sa = _to_signed(a_w, 32)
                            r = _from_signed(sa >> (b_w & 31), 32)
                        else:
                            r = self._alu_op(op, a_w, b_w)
                        self._write_scratch(dest + i, r)

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
