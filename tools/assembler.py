#!/usr/bin/env python3
"""
VLIW SIMD Assembler — converts instruction dictionaries into binary bundles.

Matches the RTL encoding in DecodeUnit.scala / SlotBundles.scala.

Bundle layout (LSB-first):
  [ ALU_0 (40b) | ... | VALU_0 (56b) | ... | LOAD_0 (48b) | ... |
    STORE_0 (28b) | ... | FLOW (48b) | PAD to 64-bit boundary ]

Usage:
    from assembler import Assembler
    asm = Assembler()           # default: 1 of each slot
    binary = asm.assemble(instruction_dict)
    program = asm.assemble_program([instr1, instr2, ...])
"""

from __future__ import annotations
from dataclasses import dataclass, field
from typing import Dict, List, Tuple, Union, Optional
import struct
import math

# ============================================================================
#  Opcode Tables — must match SlotBundles.scala
# ============================================================================

ALU_OPCODES = {
    "+":    0, "add":    0,
    "-":    1, "sub":    1,
    "*":    2, "mul":    2,
    "^":    3, "xor":    3,
    "&":    4, "and":    4,
    "|":    5, "or":     5,
    "<<":   6, "shl":    6,
    ">>":   7, "shr":    7,
    "<":    8, "lt":     8,
    "==":   9, "eq":     9,
    "%":   10, "mod":   10,
    "//":  11, "div":   11,
    "cdiv": 12,
}

VALU_EXTRA_OPCODES = {
    "vbroadcast":   13,
    "multiply_add": 14,
}

LOAD_OPCODES = {
    "nop":         0,
    "load":        1,
    "load_offset": 2,
    "vload":       3,
    "const":       4,
}

STORE_OPCODES = {
    "nop":    0,
    "store":  1,
    "vstore": 2,
}

FLOW_OPCODES = {
    "nop":            0,
    "select":         1,
    "vselect":        2,
    "add_imm":        3,
    "halt":           4,
    "cond_jump":      5,
    "cond_jump_rel":  6,
    "jump":           7,
    "jump_indirect":  8,
    "coreid":         9,
}


# ============================================================================
#  Slot Widths — must match VliwSocConfig
# ============================================================================

ALU_SLOT_WIDTH   = 40
VALU_SLOT_WIDTH  = 56
LOAD_SLOT_WIDTH  = 48
STORE_SLOT_WIDTH = 28
FLOW_SLOT_WIDTH  = 48


# ============================================================================
#  Configuration
# ============================================================================

@dataclass
class AssemblerConfig:
    """Mirror of VliwSocConfig parameters needed by the assembler."""
    n_alu_slots:   int = 1
    n_valu_slots:  int = 1
    n_load_slots:  int = 1
    n_store_slots: int = 1
    n_flow_slots:  int = 1
    vlen:          int = 8
    scratch_size:  int = 1536
    imem_depth:    int = 1024

    @property
    def scratch_addr_width(self) -> int:
        return math.ceil(math.log2(self.scratch_size)) if self.scratch_size > 1 else 1

    @property
    def imem_addr_width(self) -> int:
        return math.ceil(math.log2(self.imem_depth)) if self.imem_depth > 1 else 1

    @property
    def bundle_width(self) -> int:
        raw = (self.n_alu_slots * ALU_SLOT_WIDTH +
               self.n_valu_slots * VALU_SLOT_WIDTH +
               self.n_load_slots * LOAD_SLOT_WIDTH +
               self.n_store_slots * STORE_SLOT_WIDTH +
               self.n_flow_slots * FLOW_SLOT_WIDTH)
        return ((raw + 63) // 64) * 64

    @property
    def bundle_bytes(self) -> int:
        return self.bundle_width // 8


# ============================================================================
#  Slot Encoders
# ============================================================================

def _pack_bits(value: int, width: int) -> int:
    """Mask value to width bits (unsigned)."""
    return value & ((1 << width) - 1)


def encode_alu_slot(op: str, dest: int, src1: int, src2: int,
                    addr_w: int = 11) -> int:
    """
    Encode a scalar ALU slot (40 bits).
    [39] valid=1 | [38:35] opcode | [34:24] dest | [23:13] src1 | [12:2] src2 | [1:0] rsvd=0
    """
    opcode = ALU_OPCODES[op]
    bits = 0
    bits |= (1 << 39)                                        # valid
    bits |= (_pack_bits(opcode, 4) << 35)                     # opcode
    bits |= (_pack_bits(dest, 11) << 24)                      # dest
    bits |= (_pack_bits(src1, 11) << 13)                      # src1
    bits |= (_pack_bits(src2, 11) << 2)                       # src2
    return bits


def encode_alu_nop() -> int:
    """Encode an ALU NOP (valid=0)."""
    return 0


def encode_valu_slot(op: str, dest_base: int, src1_base: int,
                     src2_base: int = 0, src3_base: int = 0,
                     addr_w: int = 11) -> int:
    """
    Encode a vector ALU slot (56 bits).
    [55] valid=1 | [54:51] opcode | [50:40] destBase | [39:29] src1Base |
    [28:18] src2Base | [17:7] src3Base | [6:0] rsvd=0
    """
    if op in VALU_EXTRA_OPCODES:
        opcode = VALU_EXTRA_OPCODES[op]
    elif op in ALU_OPCODES:
        opcode = ALU_OPCODES[op]
    else:
        raise ValueError(f"Unknown VALU opcode: {op}")

    bits = 0
    bits |= (1 << 55)
    bits |= (_pack_bits(opcode, 4) << 51)
    bits |= (_pack_bits(dest_base, 11) << 40)
    bits |= (_pack_bits(src1_base, 11) << 29)
    bits |= (_pack_bits(src2_base, 11) << 18)
    bits |= (_pack_bits(src3_base, 11) << 7)
    return bits


def encode_valu_nop() -> int:
    return 0


def encode_load_slot(op: str, dest: int, addr_reg: int = 0,
                     offset: int = 0, immediate: int = 0,
                     addr_w: int = 11) -> int:
    """
    Encode a load slot (48 bits).
    [47] valid=1 | [46:44] opcode | [43:33] dest | [32:22] addrReg |
    [21:19] offset | [18:0] rsvd
    For CONST: immediate packed in bits [31:0]
    """
    opcode = LOAD_OPCODES[op]
    bits = 0
    bits |= (1 << 47)
    bits |= (_pack_bits(opcode, 3) << 44)
    bits |= (_pack_bits(dest, 11) << 33)

    if op == "const":
        # Pack 32-bit immediate in bits [31:0]
        bits |= _pack_bits(immediate, 32)
    else:
        bits |= (_pack_bits(addr_reg, 11) << 22)
        bits |= (_pack_bits(offset, 3) << 19)

    return bits


def encode_load_nop() -> int:
    return 0


def encode_store_slot(op: str, addr_reg: int, src_reg: int = 0,
                      addr_w: int = 11) -> int:
    """
    Encode a store slot (28 bits).
    [27] valid=1 | [26:25] opcode | [24:14] addrReg | [13:3] srcReg | [2:0] rsvd=0
    """
    opcode = STORE_OPCODES[op]
    bits = 0
    bits |= (1 << 27)
    bits |= (_pack_bits(opcode, 2) << 25)
    bits |= (_pack_bits(addr_reg, 11) << 14)
    bits |= (_pack_bits(src_reg, 11) << 3)
    return bits


def encode_store_nop() -> int:
    return 0


def encode_flow_slot(op: str, dest: int = 0, operand_a: int = 0,
                     operand_b: int = 0, immediate: int = 0,
                     addr_w: int = 11, imem_addr_w: int = 10) -> int:
    """
    Encode a flow slot (48 bits).
    [47] valid=1 | [46:43] opcode | [42:32] dest | [31:21] operandA |
    [20:10] operandB | [9:0] immediate
    """
    opcode = FLOW_OPCODES[op]
    bits = 0
    bits |= (1 << 47)
    bits |= (_pack_bits(opcode, 4) << 43)
    bits |= (_pack_bits(dest, 11) << 32)
    bits |= (_pack_bits(operand_a, 11) << 21)
    bits |= (_pack_bits(operand_b, 11) << 10)
    bits |= (_pack_bits(immediate, 10) << 0)
    return bits


def encode_flow_nop() -> int:
    return 0


# ============================================================================
#  Main Assembler
# ============================================================================

class Assembler:
    """
    Assembles instruction dictionaries (problem.py format) into binary bundles.

    Each instruction is a dict mapping engine names to lists of slot tuples:
        {
            "alu":  [("+", 10, 20, 30)],
            "valu": [("vbroadcast", 100, 50)],
            "load": [("const", 5, 0, 0, 42)],
            "store": [],
            "flow": [("halt",)],
        }
    """

    def __init__(self, config: Optional[AssemblerConfig] = None):
        self.cfg = config or AssemblerConfig()

    def _encode_alu_ops(self, ops: List[tuple]) -> List[int]:
        """Encode a list of ALU operations into slot bit patterns."""
        slots = []
        for op_tuple in ops:
            op, dest, src1, src2 = op_tuple[0], op_tuple[1], op_tuple[2], op_tuple[3]
            slots.append(encode_alu_slot(op, dest, src1, src2, self.cfg.scratch_addr_width))
        # Pad with NOPs
        while len(slots) < self.cfg.n_alu_slots:
            slots.append(encode_alu_nop())
        if len(slots) > self.cfg.n_alu_slots:
            raise ValueError(f"Too many ALU ops: {len(slots)} > {self.cfg.n_alu_slots}")
        return slots

    def _encode_valu_ops(self, ops: List[tuple]) -> List[int]:
        """Encode a list of VALU operations into slot bit patterns."""
        slots = []
        for op_tuple in ops:
            op = op_tuple[0]
            if op == "vbroadcast":
                # (vbroadcast, dest, src) — src is scalar, broadcast to dest+0..dest+VLEN-1
                dest, src = op_tuple[1], op_tuple[2]
                slots.append(encode_valu_slot(op, dest, src, 0, src, self.cfg.scratch_addr_width))
            elif op == "multiply_add":
                # (multiply_add, dest, a, b, c)
                dest, a, b, c = op_tuple[1], op_tuple[2], op_tuple[3], op_tuple[4]
                slots.append(encode_valu_slot(op, dest, a, b, c, self.cfg.scratch_addr_width))
            else:
                # Lane-wise ALU operation: (op, dest, src1, src2)
                dest, src1, src2 = op_tuple[1], op_tuple[2], op_tuple[3]
                slots.append(encode_valu_slot(op, dest, src1, src2, 0, self.cfg.scratch_addr_width))
        while len(slots) < self.cfg.n_valu_slots:
            slots.append(encode_valu_nop())
        if len(slots) > self.cfg.n_valu_slots:
            raise ValueError(f"Too many VALU ops: {len(slots)} > {self.cfg.n_valu_slots}")
        return slots

    def _encode_load_ops(self, ops: List[tuple]) -> List[int]:
        """Encode load operations."""
        slots = []
        for op_tuple in ops:
            op = op_tuple[0]
            if op == "load":
                dest, addr = op_tuple[1], op_tuple[2]
                slots.append(encode_load_slot(op, dest, addr, addr_w=self.cfg.scratch_addr_width))
            elif op == "load_offset":
                dest, addr, offset = op_tuple[1], op_tuple[2], op_tuple[3]
                slots.append(encode_load_slot(op, dest, addr, offset=offset,
                                              addr_w=self.cfg.scratch_addr_width))
            elif op == "vload":
                dest, addr = op_tuple[1], op_tuple[2]
                slots.append(encode_load_slot(op, dest, addr, addr_w=self.cfg.scratch_addr_width))
            elif op == "const":
                dest, value = op_tuple[1], op_tuple[2]
                slots.append(encode_load_slot(op, dest, immediate=value & 0xFFFFFFFF,
                                              addr_w=self.cfg.scratch_addr_width))
            else:
                raise ValueError(f"Unknown load opcode: {op}")
        while len(slots) < self.cfg.n_load_slots:
            slots.append(encode_load_nop())
        if len(slots) > self.cfg.n_load_slots:
            raise ValueError(f"Too many load ops: {len(slots)} > {self.cfg.n_load_slots}")
        return slots

    def _encode_store_ops(self, ops: List[tuple]) -> List[int]:
        """Encode store operations."""
        slots = []
        for op_tuple in ops:
            op = op_tuple[0]
            if op in ("store", "vstore"):
                addr, src = op_tuple[1], op_tuple[2]
                slots.append(encode_store_slot(op, addr, src, self.cfg.scratch_addr_width))
            else:
                raise ValueError(f"Unknown store opcode: {op}")
        while len(slots) < self.cfg.n_store_slots:
            slots.append(encode_store_nop())
        if len(slots) > self.cfg.n_store_slots:
            raise ValueError(f"Too many store ops: {len(slots)} > {self.cfg.n_store_slots}")
        return slots

    def _encode_flow_ops(self, ops: List[tuple]) -> List[int]:
        """Encode flow operations."""
        slots = []
        for op_tuple in ops:
            op = op_tuple[0]
            if op == "select":
                dest, cond, a, b = op_tuple[1], op_tuple[2], op_tuple[3], op_tuple[4]
                slots.append(encode_flow_slot(op, dest, cond, a, b,
                                              self.cfg.scratch_addr_width, self.cfg.imem_addr_width))
            elif op == "vselect":
                dest, cond, a, b = op_tuple[1], op_tuple[2], op_tuple[3], op_tuple[4]
                slots.append(encode_flow_slot(op, dest, cond, a, b,
                                              self.cfg.scratch_addr_width, self.cfg.imem_addr_width))
            elif op == "add_imm":
                dest, a, imm = op_tuple[1], op_tuple[2], op_tuple[3]
                slots.append(encode_flow_slot(op, dest, a, immediate=imm,
                                              addr_w=self.cfg.scratch_addr_width,
                                              imem_addr_w=self.cfg.imem_addr_width))
            elif op == "halt":
                slots.append(encode_flow_slot(op, addr_w=self.cfg.scratch_addr_width,
                                              imem_addr_w=self.cfg.imem_addr_width))
            elif op == "cond_jump":
                cond, addr = op_tuple[1], op_tuple[2]
                slots.append(encode_flow_slot(op, operand_a=cond, immediate=addr,
                                              addr_w=self.cfg.scratch_addr_width,
                                              imem_addr_w=self.cfg.imem_addr_width))
            elif op == "cond_jump_rel":
                cond, offset = op_tuple[1], op_tuple[2]
                slots.append(encode_flow_slot(op, operand_a=cond, immediate=offset,
                                              addr_w=self.cfg.scratch_addr_width,
                                              imem_addr_w=self.cfg.imem_addr_width))
            elif op == "jump":
                addr_val = op_tuple[1]
                slots.append(encode_flow_slot(op, immediate=addr_val,
                                              addr_w=self.cfg.scratch_addr_width,
                                              imem_addr_w=self.cfg.imem_addr_width))
            elif op == "jump_indirect":
                addr_val = op_tuple[1]
                slots.append(encode_flow_slot(op, operand_a=addr_val,
                                              addr_w=self.cfg.scratch_addr_width,
                                              imem_addr_w=self.cfg.imem_addr_width))
            elif op == "coreid":
                dest = op_tuple[1]
                slots.append(encode_flow_slot(op, dest=dest,
                                              addr_w=self.cfg.scratch_addr_width,
                                              imem_addr_w=self.cfg.imem_addr_width))
            elif op == "trace_write":
                # Not implemented in RTL v1 - encode as NOP with trace flag
                slots.append(encode_flow_nop())
            elif op == "pause":
                # Not implemented in RTL v1 - encode as NOP
                slots.append(encode_flow_nop())
            else:
                raise ValueError(f"Unknown flow opcode: {op}")
        while len(slots) < self.cfg.n_flow_slots:
            slots.append(encode_flow_nop())
        if len(slots) > self.cfg.n_flow_slots:
            raise ValueError(f"Too many flow ops: {len(slots)} > {self.cfg.n_flow_slots}")
        return slots

    def assemble(self, instruction: Dict[str, List[tuple]]) -> int:
        """
        Assemble one instruction bundle dict into a single integer (bit pattern).

        Args:
            instruction: dict mapping engine name → list of slot tuples

        Returns:
            Integer bit pattern for the full bundle (bundleWidth bits wide)
        """
        alu_ops   = instruction.get("alu", [])
        valu_ops  = instruction.get("valu", [])
        load_ops  = instruction.get("load", [])
        store_ops = instruction.get("store", [])
        flow_ops  = instruction.get("flow", [])

        alu_slots   = self._encode_alu_ops(alu_ops)
        valu_slots  = self._encode_valu_ops(valu_ops)
        load_slots  = self._encode_load_ops(load_ops)
        store_slots = self._encode_store_ops(store_ops)
        flow_slots  = self._encode_flow_ops(flow_ops)

        # Pack: LSB first, same order as DecodeUnit.scala
        bundle = 0
        bit_offset = 0

        for s in alu_slots:
            bundle |= (s << bit_offset)
            bit_offset += ALU_SLOT_WIDTH

        for s in valu_slots:
            bundle |= (s << bit_offset)
            bit_offset += VALU_SLOT_WIDTH

        for s in load_slots:
            bundle |= (s << bit_offset)
            bit_offset += LOAD_SLOT_WIDTH

        for s in store_slots:
            bundle |= (s << bit_offset)
            bit_offset += STORE_SLOT_WIDTH

        for s in flow_slots:
            bundle |= (s << bit_offset)
            bit_offset += FLOW_SLOT_WIDTH

        # Mask to bundle width
        bundle &= (1 << self.cfg.bundle_width) - 1
        return bundle

    def assemble_program(self, instructions: List[Dict[str, List[tuple]]]) -> List[int]:
        """Assemble a complete program (list of instruction dicts) into binary bundles."""
        return [self.assemble(instr) for instr in instructions]

    def to_bytes(self, bundle: int) -> bytes:
        """Convert a bundle integer to little-endian bytes."""
        n_bytes = self.cfg.bundle_bytes
        return bundle.to_bytes(n_bytes, byteorder='little')

    def to_word_list(self, bundle: int, word_width: int = 32) -> List[int]:
        """Split a bundle into 32-bit words (for AXI write transactions)."""
        words = []
        mask = (1 << word_width) - 1
        n_words = self.cfg.bundle_width // word_width
        for i in range(n_words):
            words.append((bundle >> (i * word_width)) & mask)
        return words

    def program_to_mem_init(self, instructions: List[Dict[str, List[tuple]]],
                            word_width: int = 32) -> List[int]:
        """Convert a program to a flat list of 32-bit words for memory initialization."""
        words = []
        for instr in instructions:
            bundle = self.assemble(instr)
            words.extend(self.to_word_list(bundle, word_width))
        return words


# ============================================================================
#  Disassembler (for debug)
# ============================================================================

def disassemble_alu_slot(bits: int) -> Optional[tuple]:
    """Decode a 40-bit ALU slot back to (op, dest, src1, src2) or None if NOP."""
    valid = (bits >> 39) & 1
    if not valid:
        return None
    opcode = (bits >> 35) & 0xF
    dest   = (bits >> 24) & 0x7FF
    src1   = (bits >> 13) & 0x7FF
    src2   = (bits >> 2)  & 0x7FF

    op_name = {v: k for k, v in ALU_OPCODES.items() if len(k) <= 3}.get(opcode, f"alu_{opcode}")
    return (op_name, dest, src1, src2)


def disassemble_bundle(bundle: int, cfg: Optional[AssemblerConfig] = None) -> Dict[str, list]:
    """Disassemble a bundle integer back to instruction dict (partial — ALU only for now)."""
    cfg = cfg or AssemblerConfig()
    result = {"alu": [], "valu": [], "load": [], "store": [], "flow": []}
    bit_offset = 0

    for i in range(cfg.n_alu_slots):
        slot_bits = (bundle >> bit_offset) & ((1 << ALU_SLOT_WIDTH) - 1)
        decoded = disassemble_alu_slot(slot_bits)
        if decoded:
            result["alu"].append(decoded)
        bit_offset += ALU_SLOT_WIDTH

    # VALU, Load, Store, Flow disassembly can be added as needed
    bit_offset += cfg.n_valu_slots * VALU_SLOT_WIDTH
    bit_offset += cfg.n_load_slots * LOAD_SLOT_WIDTH
    bit_offset += cfg.n_store_slots * STORE_SLOT_WIDTH
    bit_offset += cfg.n_flow_slots * FLOW_SLOT_WIDTH

    return result


# ============================================================================
#  CLI / Self-test
# ============================================================================

if __name__ == "__main__":
    asm = Assembler()

    # Test: encode a simple instruction
    instr = {
        "alu":  [("+", 10, 20, 30)],
        "valu": [("vbroadcast", 100, 50)],
        "load": [("const", 5, 42)],
        "store": [],
        "flow": [("halt",)],
    }

    bundle = asm.assemble(instr)
    words = asm.to_word_list(bundle)

    print(f"Bundle width: {asm.cfg.bundle_width} bits")
    print(f"Bundle value: 0x{bundle:0{asm.cfg.bundle_width // 4}X}")
    print(f"Words ({len(words)}): {['0x%08X' % w for w in words]}")

    # Verify round-trip for ALU
    decoded = disassemble_bundle(bundle)
    print(f"Decoded ALU: {decoded['alu']}")

    # Test program
    program = [
        {"load": [("const", 0, 100)], "flow": []},
        {"load": [("const", 1, 200)], "flow": []},
        {"alu": [("+", 2, 0, 1)], "flow": []},
        {"flow": [("halt",)]},
    ]
    binary = asm.assemble_program(program)
    print(f"\nProgram: {len(binary)} bundles")
    for i, b in enumerate(binary):
        print(f"  [{i}] 0x{b:0{asm.cfg.bundle_width // 4}X}")
