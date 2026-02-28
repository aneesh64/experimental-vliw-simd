# VLIW SIMD Co-Processor — Python Toolchain Reference

> Documents the assembler and scheduler in `tools/`.
> Companion to `docs/ARCHITECTURE.md` for holistic hardware/software optimization.

---

## Table of Contents

1. [Toolchain Overview](#1-toolchain-overview)
2. [Assembler (`assembler.py`)](#2-assembler)
3. [Scheduler (`scheduler.py`)](#3-scheduler)
4. [End-to-End Compilation Flow](#4-end-to-end-compilation-flow)
5. [Instruction Dictionary Format](#5-instruction-dictionary-format)
6. [Opcode Reference](#6-opcode-reference)
7. [Scheduler Timing Model](#7-scheduler-timing-model)
8. [Bank Conflict Model](#8-bank-conflict-model)
9. [Worked Examples](#9-worked-examples)
10. [Limitations & Optimization Opportunities](#10-limitations--optimization-opportunities)

---

## 1. Toolchain Overview

```
  High-level program          Scheduled bundles          Binary bundle words
  (list of Op/Label)   ────►  (instruction dicts)  ────►  (list of int)
       │                           │                           │
  VliwScheduler.schedule()    Assembler.assemble_program()    .to_word_list()
       │                           │                           │
  scheduler.py                assembler.py                  → AXI writes to IMEM
```

**Two-stage compilation:**

1. **Scheduler** — Takes a sequence of high-level operations (`Op` / `Label`), resolves data dependencies, avoids hazards, packs into VLIW bundles, and emits instruction dictionaries.
2. **Assembler** — Takes instruction dictionaries and encodes them into binary bit patterns matching the RTL `DecodeUnit` layout.

Both tools are Python 3 modules designed for import. They also have self-test `__main__` blocks.

---

## 2. Assembler

**File:** `tools/assembler.py`

### Purpose

Converts instruction dictionaries (one per bundle) into binary bit patterns that exactly match the RTL encoding in `DecodeUnit.scala` and `SlotBundles.scala`.

### Configuration

```python
from assembler import Assembler, AssemblerConfig

cfg = AssemblerConfig(
    n_alu_slots   = 1,     # Must match VliwSocConfig.nAluSlots
    n_valu_slots  = 1,     # Must match VliwSocConfig.nValuSlots
    n_load_slots  = 1,     # Must match VliwSocConfig.nLoadSlots
    n_store_slots = 1,     # Must match VliwSocConfig.nStoreSlots
    n_flow_slots  = 1,     # Always 1 (architectural limit)
    vlen          = 8,     # Must match VliwSocConfig.vlen
    scratch_size  = 1536,  # Must match VliwSocConfig.scratchSize
    imem_depth    = 1024,  # Must match VliwSocConfig.imemDepth
)

asm = Assembler(cfg)
```

### Derived Properties

| Property | Formula | Default |
|----------|---------|---------|
| `scratch_addr_width` | `ceil(log2(scratch_size))` | 11 bits |
| `imem_addr_width` | `ceil(log2(imem_depth))` | 10 bits |
| `bundle_width` | Sum of all slot widths, padded to 64-bit boundary | 256 bits |
| `bundle_bytes` | `bundle_width / 8` | 32 bytes |

### API

#### `assemble(instruction: dict) → int`

Encode a single instruction dictionary into an integer bit pattern.

```python
bundle_int = asm.assemble({
    "alu":  [("+", 10, 20, 30)],
    "load": [("const", 5, 42)],
    "flow": [("halt",)],
})
```

#### `assemble_program(instructions: list[dict]) → list[int]`

Encode a complete program (list of instruction dicts) into binary bundles.

```python
program = [
    {"load": [("const", 0, 100)]},
    {"load": [("const", 1, 200)]},
    {"alu": [("+", 2, 0, 1)]},
    {"flow": [("halt",)]},
]
binaries = asm.assemble_program(program)
```

#### `to_bytes(bundle: int) → bytes`

Convert bundle integer to little-endian bytes.

#### `to_word_list(bundle: int, word_width=32) → list[int]`

Split a bundle into 32-bit words for AXI write transactions.

```python
words = asm.to_word_list(bundle_int)
# → [0xABCD1234, 0x5678EFAB, ...] (bundle_width / 32 words)
```

#### `program_to_mem_init(instructions, word_width=32) → list[int]`

Flatten an entire program to a list of 32-bit words for memory initialization.

### Slot Encoders (Low-Level)

Each slot type has a standalone encoder function:

| Function | Slot Width | Parameters |
|----------|-----------|------------|
| `encode_alu_slot(op, dest, src1, src2)` | 40 bits | ALU opcode string, scratch addresses |
| `encode_valu_slot(op, dest_base, src1_base, src2_base, src3_base)` | 56 bits | VALU opcode, base addresses |
| `encode_load_slot(op, dest, addr_reg, offset, immediate)` | 48 bits | Load opcode, scratch/immediate |
| `encode_store_slot(op, addr_reg, src_reg)` | 28 bits | Store opcode, scratch addresses |
| `encode_flow_slot(op, dest, operand_a, operand_b, immediate)` | 48 bits | Flow opcode, operands |

All have corresponding `encode_*_nop()` functions that return `0`.

### Disassembler (Partial)

```python
from assembler import disassemble_bundle, disassemble_alu_slot

decoded = disassemble_bundle(bundle_int)
# → {"alu": [("add", 10, 20, 30)], "valu": [], "load": [], "store": [], "flow": []}
```

Currently only ALU slots are fully disassembled. VALU, Load, Store, and Flow disassembly stubs exist but are not implemented.

---

## 3. Scheduler

**File:** `tools/scheduler.py`

### Purpose

Automatically resolves data dependencies, avoids pipeline hazards, respects hardware resource limits, and packs operations into VLIW bundles. The output is a list of instruction dictionaries ready for the assembler.

### Configuration

```python
from scheduler import VliwScheduler, SchedulerConfig

cfg = SchedulerConfig(
    n_alu_slots   = 1,
    n_valu_slots  = 1,
    n_load_slots  = 1,
    n_store_slots = 1,
    n_flow_slots  = 1,
    scratch_banks = 8,       # For bank-conflict detection
    data_width    = 32,
    div_latency   = 33,      # dataWidth + 1
    mem_post_gap  = 2,       # Conservative guard after memory ops
)

s = VliwScheduler(cfg)
```

### Timing Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `NORMAL_LATENCY` | 2 | Bundles between producer and consumer (RAW) |
| `VALU_SRC3_LATENCY` | 3 | For VBROADCAST, MULTIPLY_ADD (extra pipeline stage) |
| `DIV_LATENCY` | 35 | Issue to readable: 33 busy + 2 scratch readback |
| `DIV_BUSY_CYCLES` | 33 | Divider occupied cycles |
| `JUMP_BUBBLE` | 3 | Dead slots after taken branch (3-cycle delay) |
| `DEFAULT_MEM_POST_GAP` | 2 | NOP bundles after memory ops |

### Operation Constructors

The scheduler provides convenience methods that return `Op` objects:

#### Load Operations

| Method | Signature | Description |
|--------|-----------|-------------|
| `const(dest, value)` | `→ Op` | Load immediate into scratch[dest] |
| `load(dest, addr_reg)` | `→ Op` | Scalar load from memory |
| `load_offset(dest, addr_reg, offset)` | `→ Op` | Load with offset |
| `vload(dest_base, addr_reg, vlen=8)` | `→ Op` | Vector burst load (VLEN words) |

#### Store Operations

| Method | Signature | Description |
|--------|-----------|-------------|
| `store(addr_reg, src_reg)` | `→ Op` | Scalar store to memory |
| `vstore(addr_reg, src_base, vlen=8)` | `→ Op` | Vector burst store |

#### ALU Operations

| Method | Signature | Latency |
|--------|-----------|---------|
| `add(dest, src1, src2)` | `→ Op` | 2 bundles |
| `sub(dest, src1, src2)` | `→ Op` | 2 bundles |
| `mul(dest, src1, src2)` | `→ Op` | 2 bundles |
| `xor(dest, src1, src2)` | `→ Op` | 2 bundles |
| `and_op(dest, src1, src2)` | `→ Op` | 2 bundles |
| `or_op(dest, src1, src2)` | `→ Op` | 2 bundles |
| `shl(dest, src1, src2)` | `→ Op` | 2 bundles |
| `shr(dest, src1, src2)` | `→ Op` | 2 bundles |
| `lt(dest, src1, src2)` | `→ Op` | 2 bundles |
| `eq(dest, src1, src2)` | `→ Op` | 2 bundles |
| `div(dest, src1, src2)` | `→ Op` | **35 bundles** |
| `mod(dest, src1, src2)` | `→ Op` | **35 bundles** |
| `cdiv(dest, src1, src2)` | `→ Op` | **35 bundles** |

#### VALU Operations

| Method | Signature | Latency |
|--------|-----------|---------|
| `valu_op(op, dest_base, src1_base, src2_base, vlen=8)` | `→ Op` | 2 bundles |
| `vbroadcast(dest_base, src_scalar, vlen=8)` | `→ Op` | **3 bundles** |
| `multiply_add(dest_base, a_base, b_base, c_base, vlen=8)` | `→ Op` | **3 bundles** |

#### Flow Operations

| Method | Signature | Notes |
|--------|-----------|-------|
| `halt()` | `→ Op` | Stops execution |
| `jump(target_label)` | `→ Op` | Unconditional jump to label |
| `jump_addr(target_pc)` | `→ Op` | Unconditional jump to absolute PC |
| `cond_jump(cond_reg, target_label)` | `→ Op` | Jump if scratch[cond] ≠ 0 |
| `cond_jump_addr(cond_reg, target_pc)` | `→ Op` | Conditional to absolute PC |
| `cond_jump_rel(cond_reg, offset)` | `→ Op` | Conditional relative jump |
| `jump_indirect(addr_reg)` | `→ Op` | Jump to scratch[addr] |
| `select(dest, cond, src_a, src_b)` | `→ Op` | Ternary select |
| `vselect(dest, cond, src_a, src_b)` | `→ Op` | Vector ternary select |
| `add_imm(dest, src, imm)` | `→ Op` | Add sign-ext immediate |
| `coreid(dest)` | `→ Op` | Read hardware core ID |

#### Labels

```python
s.label("loop_start")  # Returns a Label pseudo-op
```

### Scheduling API

#### `schedule(operations, verbose=False) → list[dict]`

Main entry point. Takes a list of `Op` and `Label` objects and returns instruction dictionaries.

```python
s = VliwScheduler()
bundles = s.schedule([
    s.const(0, 100),
    s.const(1, 200),
    s.add(2, 0, 1),     # Scheduler auto-inserts NOP for RAW hazard
    s.store(10, 2),
    s.halt(),
], verbose=True)
# bundles → list of instruction dicts for Assembler
```

#### `program(ops) → list[dict]`

Shorthand for `schedule(ops, verbose=False)`.

### Op Data Structure

```python
@dataclass
class Op:
    engine: str           # "alu", "valu", "load", "store", "flow"
    op: str               # Opcode name (matches assembler tables)
    dests: List[int]      # Scratch registers written
    srcs: List[int]       # Scratch registers read
    params: Dict          # Extra params for assembler encoding
    latency: int          # Cycles until result is readable
    is_div: bool          # Uses hardware divider
    is_jump: bool         # Branch instruction (post-bubble)
    is_halt: bool         # HALT instruction
    label: Optional[str]  # Position label
    jump_target: Optional[str]  # Label-based target
    _scheduled_cycle: int # Filled by scheduler
```

### Scheduling Algorithm

The scheduler works in these phases:

1. **Split into basic blocks** — at labels and jumps
2. **Per-block scheduling:**
   - Maintain `reg_ready[reg]` = earliest cycle register can be read
   - Maintain `div_busy[slot]` = cycle until divider on that slot frees
   - For each op in program order, compute earliest placement cycle considering:
     - Source register readiness (RAW dependencies)
     - Engine slot availability
     - Division exclusion zones
     - HALT isolation (must be alone)
     - FLOW + memory mutual exclusion
     - WAW conflict avoidance
     - Bank conflict detection (TDP dual-port model)
     - Write-bank conflict detection
   - Place op at earliest valid cycle, update tracking state
3. **Resolve jump targets** — patch label references to absolute PCs
4. **Emit bundles** — convert cycle→ops map to linear instruction list with NOP padding

---

## 4. End-to-End Compilation Flow

### Minimal Example

```python
from scheduler import VliwScheduler
from assembler import Assembler

# 1. Write the program using scheduler ops
s = VliwScheduler()
ops = [
    s.const(0, 100),       # s[0] = 100
    s.const(1, 200),       # s[1] = 200
    s.add(2, 0, 1),        # s[2] = s[0] + s[1] = 300
    s.halt(),
]

# 2. Schedule into VLIW bundles (auto inserts NOPs)
bundles = s.schedule(ops, verbose=True)

# 3. Assemble into binary
asm = Assembler()
binary = asm.assemble_program(bundles)

# 4. Convert to 32-bit words for AXI loading
for pc, bundle_int in enumerate(binary):
    words = asm.to_word_list(bundle_int)
    # Write words[0..N-1] to IMEM at address PC via AXI
```

### With Loops

```python
s = VliwScheduler()
ops = [
    s.const(0, 0),         # sum = 0
    s.const(1, 1),         # increment
    s.const(2, 0),         # counter
    s.const(3, 10),        # limit
    s.label("loop"),
    s.add(0, 0, 1),        # sum += 1
    s.add(2, 2, 1),        # counter += 1
    s.lt(4, 2, 3),         # counter < limit?
    s.cond_jump(4, "loop"),
    s.halt(),
]
bundles = s.schedule(ops, verbose=True)
```

### Multi-Slot Configuration

```python
from scheduler import VliwScheduler, SchedulerConfig
from assembler import Assembler, AssemblerConfig

hw_cfg = SchedulerConfig(
    n_alu_slots   = 2,
    n_valu_slots  = 1,
    n_load_slots  = 2,
    n_store_slots = 2,
)

asm_cfg = AssemblerConfig(
    n_alu_slots   = 2,
    n_valu_slots  = 1,
    n_load_slots  = 2,
    n_store_slots = 2,
)

s = VliwScheduler(hw_cfg)
asm = Assembler(asm_cfg)

# Two independent CONSTs can now be packed in the same bundle (2 load slots)
ops = [
    s.const(0, 100),
    s.const(1, 200),   # Packed into same bundle as const(0)
    s.add(2, 0, 1),
    s.halt(),
]
bundles = s.schedule(ops)
binary = asm.assemble_program(bundles)
```

---

## 5. Instruction Dictionary Format

Each instruction is a Python dict mapping engine names to lists of slot tuples:

```python
{
    "alu":   [(opcode, dest, src1, src2), ...],
    "valu":  [(opcode, dest_base, src1_base, src2_base), ...],   # or special forms
    "load":  [(opcode, ...), ...],
    "store": [(opcode, addr_reg, src_reg), ...],
    "flow":  [(opcode, ...), ...],
}
```

Empty or missing engine keys are filled with NOPs.

### Slot Tuple Formats by Engine

#### ALU

```python
(opcode_str, dest, src1, src2)
# Example: ("+", 10, 20, 30)  →  s[10] = s[20] + s[30]
```

#### VALU

```python
# Lane-wise:
(opcode_str, dest_base, src1_base, src2_base)
# Example: ("+", 100, 108, 116)  →  s[100+i] = s[108+i] + s[116+i] for i=0..7

# VBROADCAST:
("vbroadcast", dest_base, scalar_src)
# Example: ("vbroadcast", 100, 50)  →  s[100+i] = s[50] for i=0..7

# MULTIPLY_ADD:
("multiply_add", dest_base, a_base, b_base, c_base)
# Example: ("multiply_add", 100, 108, 116, 124)  →  s[100+i] = s[108+i]*s[116+i] + s[124+i]
```

#### Load

```python
# CONST:
("const", dest, value)
# Example: ("const", 5, 42)  →  s[5] = 42

# LOAD:
("load", dest, addr_reg)
# Example: ("load", 10, 5)  →  s[10] = mem[s[5]]

# LOAD_OFFSET:
("load_offset", dest, addr_reg, offset)
# Example: ("load_offset", 10, 5, 3)  →  s[10+3] = mem[s[5]+3]

# VLOAD:
("vload", dest, addr_reg)
# Example: ("vload", 100, 5)  →  s[100..107] = mem[s[5]..s[5]+7] (burst)
```

#### Store

```python
# STORE:
("store", addr_reg, src_reg)
# Example: ("store", 5, 10)  →  mem[s[5]] = s[10]

# VSTORE:
("vstore", addr_reg, src_base)
# Example: ("vstore", 5, 100)  →  mem[s[5]..+7] = s[100..107] (burst)
```

#### Flow

```python
("halt",)
("jump", target_pc)
("cond_jump", cond_reg, target_pc)
("cond_jump_rel", cond_reg, offset)
("jump_indirect", addr_reg)
("select", dest, cond, src_a, src_b)
("vselect", dest, cond, src_a, src_b)
("add_imm", dest, src, imm)
("coreid", dest)
```

---

## 6. Opcode Reference

### ALU Opcode Table

| String Keys | Value | Operation |
|------------|-------|-----------|
| `"+"`, `"add"` | 0 | Addition |
| `"-"`, `"sub"` | 1 | Subtraction |
| `"*"`, `"mul"` | 2 | Multiplication (lower 32 bits) |
| `"^"`, `"xor"` | 3 | Bitwise XOR |
| `"&"`, `"and"` | 4 | Bitwise AND |
| `"\|"`, `"or"` | 5 | Bitwise OR |
| `"<<"`, `"shl"` | 6 | Shift left |
| `">>"`, `"shr"` | 7 | Shift right (logical) |
| `"<"`, `"lt"` | 8 | Unsigned less-than (→ 0 or 1) |
| `"=="`, `"eq"` | 9 | Equality (→ 0 or 1) |
| `"%"`, `"mod"` | 10 | Unsigned modulo (33 cycles) |
| `"//"`, `"div"` | 11 | Unsigned division (33 cycles) |
| `"cdiv"` | 12 | Ceiling division (33 cycles) |

### VALU Extra Opcodes

| String Key | Value | Operation |
|-----------|-------|-----------|
| `"vbroadcast"` | 13 | Replicate scalar to all vector lanes |
| `"multiply_add"` | 14 | Fused multiply-add (a*b+c) per lane |

### Load Opcodes

| String Key | Value |
|-----------|-------|
| `"nop"` | 0 |
| `"load"` | 1 |
| `"load_offset"` | 2 |
| `"vload"` | 3 |
| `"const"` | 4 |

### Store Opcodes

| String Key | Value |
|-----------|-------|
| `"nop"` | 0 |
| `"store"` | 1 |
| `"vstore"` | 2 |

### Flow Opcodes

| String Key | Value |
|-----------|-------|
| `"nop"` | 0 |
| `"select"` | 1 |
| `"vselect"` | 2 |
| `"add_imm"` | 3 |
| `"halt"` | 4 |
| `"cond_jump"` | 5 |
| `"cond_jump_rel"` | 6 |
| `"jump"` | 7 |
| `"jump_indirect"` | 8 |
| `"coreid"` | 9 |

---

## 7. Scheduler Timing Model

### RAW Dependency Tracking

The scheduler maintains `reg_ready: dict[int, int]` mapping each scratch register to the earliest cycle it can be read.

When an op with `dests=[d]` and `latency=L` is placed at cycle `C`:
```
reg_ready[d] = C + L
```

A consumer reading register `d` cannot be placed before cycle `reg_ready[d]`.

### Division Tracking

The scheduler maintains `div_busy: dict[int, int]` mapping ALU slot index to the cycle the divider finishes.

When a DIV/MOD/CDIV is placed at cycle `C` on ALU slot `S`:
```
div_busy[S] = C + DIV_BUSY_CYCLES   (33)
```

Constraints:
- No other division on slot `S` until `cycle >= div_busy[S]`
- No non-div write-producing op on slot `S` at `cycle == div_busy[S]` (done conflict)

### Memory Post-Gap

After a bundle containing a non-CONST memory op, the scheduler advances `current_cycle` by `1 + mem_post_gap` (default: 3 total cycles). This is a conservative guard — the actual stall duration depends on AXI timing, and the pipeline handles it via hardware stall.

### Jump Handling

After a jump op at cycle `C`:
```
current_cycle = C + 1 + JUMP_BUBBLE = C + 4
```
Three NOP bundles are emitted to fill the 3-cycle branch delay slot
(matching the IF→Decode→EX pipeline depth).

### Loop-Carried Dependency Verification

For backward jumps (target_pc ≤ jump_pc), the scheduler checks:
```
wrap_gap = (jump_pc - write_cycle) + JUMP_BUBBLE + (read_cycle - target_pc) + 1
```
If `wrap_gap < NORMAL_LATENCY`, a warning is printed. The scheduler does NOT automatically fix loop-carried hazards — the user must manually unroll or insert padding.

---

## 8. Bank Conflict Model

### TDP Capacity Per Bank Per Cycle

The scratch memory has 8 banks. Each bank has:
- **Port A:** 1 read
- **Port B:** 1 read OR 1 write (not both)

Maximum 2 reads per bank per cycle (Port A + Port B). If Port B is writing, only 1 read (Port A).

### Scheduler Bank Check

For each candidate placement, the scheduler:

1. Computes which banks each scalar read port accesses: `bank = reg_addr % 8`
2. Counts total reads per bank across all ops in the candidate cycle
3. Rejects if any bank exceeds capacity:
   - `> 2 reads/bank` → rejected (TDP capacity exceeded)
   - `> 1 read/bank when bank has a write` → rejected (Port B busy with write)
4. Also checks write-bank conflicts: `> 1 write to same bank` → rejected

### Port Assignment (Mirrors Hardware)

The `_compute_read_ports()` function maps ops to hardware port indices matching VliwCore.scala:

| Port Range | Engine |
|------------|--------|
| `0 .. 2*nAlu-1` | ALU src1/src2 |
| `2*nAlu .. +nLoad-1` | Load addrReg (CONST suppressed) |
| `+nLoad .. +2*nStore-1` | Store addrReg/srcReg |
| `.. +3` | Flow operandA/B/immediate |
| `.. +nValu` | VALU src3 (vbroadcast scalar) |

---

## 9. Worked Examples

### Example 1: Simple Constant + Add

```python
s = VliwScheduler()
ops = [
    s.const(0, 100),    # Bundle 0: CONST → s[0]=100
    s.const(1, 200),    # Bundle 1: CONST → s[1]=200 (can't pack with above — 1 load slot)
    s.add(2, 0, 1),     # Bundle 3: ADD s[2]=s[0]+s[1] (2-bundle RAW gap after const(1))
    s.halt(),            # Bundle 4: HALT (alone — HALT isolation)
]
bundles = s.schedule(ops)
```

Schedule output:
```
[0] {"load": [("const", 0, 100)]}
[1] {"load": [("const", 1, 200)]}
[2] {}                                  ← NOP (RAW gap)
[3] {"alu": [("add", 2, 0, 1)]}
[4] {"flow": [("halt",)]}
```

### Example 2: Dual-Issue (Independent Engines)

With default config (1 slot per engine), a CONST and COREID can share a bundle:

```python
ops = [
    s.const(0, 10),     # Load engine
    s.coreid(5),        # Flow engine — independent, different engine
]
# Both land in bundle 0: {"load": [("const", 0, 10)], "flow": [("coreid", 5)]}
```

### Example 3: Fibonacci Loop

```python
s = VliwScheduler()
ops = [
    s.const(0, 0),          # fib_prev
    s.const(1, 1),          # fib_curr
    s.const(2, 2),          # counter
    s.const(3, 10),         # limit
    s.const(4, 1),          # increment
    s.const(30, 0),         # zero (for moves)
    s.label("fib_loop"),
    s.add(5, 0, 1),         # temp = prev + curr
    s.add(0, 1, 30),        # prev = curr
    s.add(1, 5, 30),        # curr = temp
    s.add(2, 2, 4),         # counter++
    s.lt(6, 2, 3),          # counter < limit?
    s.cond_jump(6, "fib_loop"),
    s.const(10, 0),
    s.store(10, 1),         # mem[0] = fib_curr
    s.halt(),
]
bundles = s.schedule(ops, verbose=True)
```

The scheduler:
- Packs first two CONSTs into sequential bundles (1 load slot)
- Inserts RAW gap between last CONST and first ADD
- Chains ADD→ADD→ADD→LT in sequence with RAW gaps
- Resolves `"fib_loop"` label to the correct PC
- Inserts bubble after `cond_jump`
- Isolates `halt` in its own bundle

### Example 4: Vector Operations

```python
s = VliwScheduler()
ops = [
    s.const(0, 0),                          # base address = 0
    s.vload(100, 0),                         # Load 8 words from mem[0..7] → s[100..107]
    s.vbroadcast(108, 50),                   # Broadcast s[50] → s[108..115]
    s.valu_op("+", 116, 100, 108),           # s[116+i] = s[100+i] + s[108+i]
    s.const(1, 0),                           # store address
    s.vstore(1, 116),                        # Store s[116..123] → mem[0..7]
    s.halt(),
]
bundles = s.schedule(ops, verbose=True)
```

Note: VALU bundles block all scalar reads. The scheduler enforces this by checking the V1–V6 constraints implicitly through the bank conflict model + mutual exclusion rules.

---

## 10. Limitations & Optimization Opportunities

### Scheduler Limitations

| ID | Issue | Impact | Fix |
|----|-------|--------|-----|
| S1 | No instruction reordering across basic blocks | Missed packing opportunities | Implement global scheduling |
| S2 | No software pipelining | Loop iterations not overlapped | Add modulo scheduling pass |
| S3 | Loop-carried hazards only warned, not fixed | User must manually pad | Auto-insert prologue/epilogue NOPs |
| S4 | `mem_post_gap` is conservative (fixed 2 NOPs) | Unnecessary NOPs when AXI is fast | Model actual AXI latency per path |
| S5 | VALU mutual exclusion is implicit | May reject valid packings | Explicitly model VALU port ownership |
| S6 | No register allocation/spilling | User must manually assign scratch addresses | Add register allocator |
| S7 | Single-pass greedy scheduling | Sub-optimal packing | Implement list scheduling with priority |
| S8 | `NORMAL_LATENCY=2` is conservative | Could be 1 with write bypass enabled | Coordinate with HW bypass enable |

### Assembler Limitations

| ID | Issue | Impact | Fix |
|----|-------|--------|-----|
| A1 | Disassembler only handles ALU | Can't round-trip verify all slot types | Implement full disassembly |
| A2 | No validation of register address ranges | Out-of-range addresses silently truncated | Add bounds checking |
| A3 | CONST immediate overlaps other fields in encoding | Potential bit collision if addrReg fields not zeroed | Document/enforce exclusive layout |
| A4 | `trace_write` and `pause` encoded as NOPs | No RTL support | Implement in RTL or remove from assembler |

### Co-Optimization Opportunities (HW + SW)

| ID | Change | HW Side | SW Side | Benefit |
|----|--------|---------|---------|---------|
| CO1 | Enable write bypass | Wire bypass in BankedScratchMemory | Set `NORMAL_LATENCY=1` | ~30% fewer NOP bundles |
| CO2 | Non-blocking loads | Add load queue in MemoryEngine | Remove `mem_post_gap` | Overlap load with compute |
| CO3 | Multi-slot memory | Allow parallel AXI transactions | Schedule multiple loads/stores per bundle | Better memory throughput |
| CO4 | VALU + scalar coexistence | Fine-grained bank arbitration | Relax VALU exclusion in scheduler | Pack scalar ops with VALU |
| CO5 | Wider VLEN (16/32) | Scale banks, read groups | Update vload/vstore VLEN parameter | Higher throughput |
| CO6 | Loop prologue/epilogue gen | No change | Scheduler auto-pads loop-carried deps | Correctness guarantee |
| CO7 | VSELECT wiring | Wire vector operand paths in VliwCore | Enable vselect in scheduler | Functional VSELECT |
