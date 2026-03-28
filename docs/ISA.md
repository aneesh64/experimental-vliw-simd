# VLIW SIMD ISA Reference

**Status:** Source-derived reference for the current SpinalHDL implementation  
**Derived from:** `SlotBundles.scala`, `VliwSocConfig.scala`, `DecodeUnit.scala`, `FlowEngine.scala`, `MemoryEngine.scala`, `MatrixEngine.scala`, and `tools/assembler.py`  
**Last Updated:** March 28, 2026 — FP32 scalar/vector extension and pseudo-FMADD lowering

---

## Scope

This document describes the instruction-set architecture as implemented in the current RTL and assembler.

It is the canonical ISA reference for:
- opcode numbers
- slot field layouts
- bundle packing order
- operand conventions visible to software

Where prose in older documents conflicts with this file, the RTL-derived definitions here should be treated as correct.

---

## Architectural Model

The machine is a compiler-scheduled VLIW core. Each instruction memory entry holds one bundle containing zero or more engine slots.

- Scalar and vector operands are addressed through scratch-memory word addresses, not a separate named GPR/VR ISA encoding.
- A bundle may contain at most one operation per configured slot.
- Slot counts are configurable. The ISA field formats are fixed, but overall bundle width depends on configuration.
- Bundle packing is LSB-first in this order:

```text
[ ALU slots | VALU slots | LOAD slots | STORE slots | MATRIX slots | FLOW slot | padding ]
```

`DecodeUnit.scala` slices fields in exactly that order.

---

## Encoding Widths

`SlotEncodingWidths` defines the opcode widths:

| Class | Bits |
|------|------|
| ALU opcode | 5 |
| VALU opcode | 5 |
| LOAD opcode | 4 |
| STORE opcode | 3 |
| FLOW opcode | 5 |
| MATRIX opcode | 5 |

With the current default scratch size (`1536`) and simulation IMEM depth (`1024`), the slot widths are:

| Slot | Width |
|------|------|
| ALU | 41 bits |
| VALU | 57 bits |
| LOAD | 49 bits |
| STORE | 29 bits |
| FLOW | 49 bits |
| MATRIX | 65 bits |

Bundle width is computed from configured slot counts and padded up to the next 64-bit boundary.

Examples:
- baseline `1/1/1/1/0/1` bundle: `256` bits
- matrix-enabled `1/1/1/1/1/1` bundle: `320` bits

---

## Address and Data Model

- **IMEM (Instruction Memory):**
  - Addressed by bundle index, not byte address.
  - Loaded via CSR (`IMBAS`, `IMWD`) or AXI-Lite writes.
  - Bundles are written as 32-bit words; hardware auto-commits after the last word per bundle.
- **DMEM (Data Memory):**
  - Main data memory, accessible via AXI4 and optionally via CSR (`DMWA`, `DMWD`).
  - Used for program data, results, and host communication.
  - Supports both scalar and vector accesses.
- **Scalar scratch state** uses 32-bit words.
- **Vector operations** use `VLEN` consecutive 32-bit scratch words starting at `destBase`, `src1Base`, `src2Base`, and `src3Base`.
- The default verified configuration uses `VLEN = 8`.
- See DRIVER_API.md for C driver usage and memory protocol details.

---

## Slot Layouts

### ALU Slot

```text
[40] valid
[39:35] opcode
[34:24] dest
[23:13] src1
[12:2] src2
[1:0] reserved
```

Notes:
- `dest`, `src1`, and `src2` are scratch word addresses.
- `valid = 0` encodes NOP.

### VALU Slot

```text
[56] valid
[55:51] opcode
[50:40] destBase
[39:29] src1Base
[28:18] src2Base
[17:7]  src3Base
[6:4]   ewidth
[3:1]   dwidth
[0]     signed
```

Notes:
- Each base address points at a contiguous vector region in scratch.
- `src3Base` is used by `multiply_add` and by `vbroadcast` in the current assembler lowering.
- `signed` affects compare, right shift, multiply, multiply-add, and cast behavior.

### LOAD Slot

```text
[48] valid
[47:44] opcode
[43:33] dest
[32:22] addrReg
[21:19] offset
[18:0]  remaining operand bits
```

Notes:
- For `const`, the 32-bit immediate is packed into bits `[31:0]` of the operand region.
- For `load_offset`, `offset` is a 3-bit unsigned field.

### STORE Slot

```text
[28] valid
[27:25] opcode
[24:14] addrReg
[13:3]  srcReg
[2:0]   reserved
```

### MATRIX Slot

```text
[64] valid
[63:59] opcode
[58:48] dest
[47:37] srcA
[36:26] srcB
[25:15] srcC
[14:11] tileRows
[10:7]  tileCols
[6:1]   flags
[0]     reserved
```

Notes:
- The v1 matrix engine is fixed at `8x8` with 8-bit operand storage and 32-bit accumulator storage.
- `tileRows` and `tileCols` are still encoded, but current hardware requires 8x8 configuration.

### FLOW Slot

```text
[48] valid
[47:43] opcode
[42:32] dest
[31:21] operandA
[20:10] operandB
[9:0]   immediate
```

Notes:
- `immediate` is sized to `imemAddrWidth`; in the default simulation configuration this is `10` bits.
- `FlowEngine.scala` still forms absolute targets for `jump` and `cond_jump` as `Cat(operandB, immediate)`, but then resizes to `imemAddrWidth`. In current configurations this means only the low `immediate` bits are architecturally relevant.

---

## Opcode Tables

### ALU Opcodes

| Value | Mnemonic | Semantics |
|------|------|------|
| 0 | `add` | `dest = src1 + src2` |
| 1 | `sub` | `dest = src1 - src2` |
| 2 | `mul` | `dest = src1 * src2` |
| 3 | `xor` | bitwise XOR |
| 4 | `and` | bitwise AND |
| 5 | `or` | bitwise OR |
| 6 | `shl` | logical shift left |
| 7 | `shr` | logical shift right |
| 8 | `lt` | unsigned less-than |
| 9 | `eq` | equality compare |
| 10 | `mod` | modulo |
| 11 | `div` | unsigned divide |
| 12 | `cdiv` | ceiling divide |
| 13 | `max` | unsigned maximum |
| 14 | `min` | unsigned minimum |

Assembler aliases for ALU ops include symbolic forms such as `+`, `-`, `*`, `^`, `&`, `|`, `<<`, `>>`, `<`, `==`, `%`, and `//`.

### FP32 Opcodes

Opcode values `18..26` are shared between the scalar ALU and the EW32 VALU path.

| Value | Mnemonic | Semantics |
|------|------|------|
| 18 | `fadd` | IEEE-754 FP32 add, round-to-nearest-even |
| 19 | `fsub` | IEEE-754 FP32 subtract, round-to-nearest-even |
| 20 | `fmul` | IEEE-754 FP32 multiply, round-to-nearest-even |
| 21 | `fmax` | FP32 max with NaN handling defined by current RTL |
| 22 | `fmin` | FP32 min with NaN handling defined by current RTL |
| 23 | `i2f` | signed int32 to FP32 conversion |
| 24 | `f2i` | FP32 to signed int32 conversion (truncate toward zero, saturating on overflow) |
| 25 | `u2f` | unsigned int32 to FP32 conversion |
| 26 | `f2u` | FP32 to unsigned int32 conversion (truncate toward zero, saturating on overflow) |

Notes:
- These are real FP32 datapath operations in the current RTL, not the earlier fixed-point approximation.
- The scalar ALU accepts these opcodes directly.
- The VALU accepts the same opcodes only for `ewidth = EW32`; packed FP32 subword modes are not defined.
- FP divide is not implemented.
- IEEE exception flags are not architecturally exposed.

### FP32 Pseudo-Ops

The software stack exposes fused-multiply-add style helpers, but they lower to ordinary FP32 instructions rather than a dedicated fused opcode.

| Pseudo-op | Lowering |
|------|------|
| `fmadd dst, a, b, c` | `fmul tmp, a, b` then `fadd dst, tmp, c` |
| `vfmadd dst, a, b, c` | `valu.fmul tmp, a, b` then `valu.fadd dst, tmp, c` |

These pseudo-ops are therefore not fused IEEE FMA operations. Rounding occurs once after the multiply and again after the add.

### VALU Opcodes

The VALU reuses ALU opcode values `0..14` for lane-wise vector and packed operations, then adds VALU-specific opcodes:

| Value | Mnemonic |
|------|------|
| 15 | `vbroadcast` |
| 16 | `multiply_add` |
| 17 | `vcast` |

For opcode values `0..14`, semantics depend on `ewidth`, `dwidth`, and `signed`.
FP32 opcodes `18..26` are additionally valid for `ewidth = dwidth = EW32`.

### LOAD Opcodes

| Value | Mnemonic | Semantics |
|------|------|------|
| 0 | `nop` | unused slot |
| 1 | `load` | scalar load |
| 2 | `load_offset` | scalar load with encoded offset |
| 3 | `vload` | vector load of `VLEN` words |
| 4 | `const` | write 32-bit immediate into scratch |
| 5 | `wait_for_load` | stall until addressed load completes |
| 6 | `scopy_m2v` | copy `VLEN` words from matrix-local → vector scratch |
| 7 | `scopy_v2m` | copy `VLEN` words from vector scratch → matrix-local |
| 8 | `scopy_v2s` | copy 1 word from vector scratch → scalar scratch |
| 9 | `scopy_s2v` | copy 1 word from scalar scratch → vector scratch |

Opcodes 5–9 use the `dest` and `addrReg` fields of the load slot for their operand addressing. `scopy_m2v` and `scopy_v2m` are multi-cycle operations managed by `MemoryEngine`. `wait_for_load` is architecturally encodable but superseded in practice by hardware load-use hazard detection in `VliwCore`.

### STORE Opcodes

| Value | Mnemonic | Semantics |
|------|------|------|
| 0 | `nop` | unused slot |
| 1 | `store` | scalar store |
| 2 | `vstore` | vector store of `VLEN` words |

### FLOW Opcodes

| Value | Mnemonic | Semantics |
|------|------|------|
| 0 | `nop` | unused slot |
| 1 | `select` | scalar conditional select |
| 2 | `vselect` | vector conditional select |
| 3 | `add_imm` | add sign-extended immediate |
| 4 | `halt` | stop core execution |
| 5 | `cond_jump` | absolute conditional jump |
| 6 | `cond_jump_rel` | relative conditional jump |
| 7 | `jump` | absolute jump |
| 8 | `jump_indirect` | jump through scratch value |
| 9 | `coreid` | write hardware core ID |

### MATRIX Opcodes

| Value | Mnemonic | Semantics |
|------|------|------|
| 0 | `nop` | unused slot |
| 1 | `mcfg` | reserved matrix configuration op |
| 2 | `mmload` | reserved matrix-local load op |
| 3 | `mmstore` | reserved matrix-local store op |
| 4 | `mdmvin` | DRAM to matrix-local transfer |
| 5 | `mdmvout` | matrix-local to DRAM transfer |
| 6 | `mpreload` | reserved preload op |
| 7 | `mcompute` | matrix multiply into accumulator |
| 8 | `mcompute_acc` | matrix multiply accumulate |
| 9 | `mzero` | clear accumulator tile |
| 10 | `mcompute_fp8_e4m3` | FP8 E4M3 matrix multiply into FP32 accumulator |
| 11 | `mcompute_fp8_e4m3_acc` | FP8 E4M3 matrix multiply accumulate into FP32 accumulator |
| 12 | `mcompute_fp8_e5m2` | FP8 E5M2 matrix multiply into FP32 accumulator |
| 13 | `mcompute_fp8_e5m2_acc` | FP8 E5M2 matrix multiply accumulate into FP32 accumulator |

`mmload`, `mmstore`, and `mpreload` are encoded and tool-visible, but the current v1 execution path is centered on `mdmvin`, `mdmvout`, `mzero`, and the compute-family opcodes above.

---

## VALU Element Width Encoding

| Code | Name | Meaning |
|------|------|------|
| 0 | `EW32` | one 32-bit element per lane |
| 1 | `EW8` | four 8-bit elements per lane |
| 2 | `EW16` | two 16-bit elements per lane |
| 3 | `EW4` | eight 4-bit elements per lane |
| 4 | `EW64` | one 64-bit element per lane pair |

Current behavior:
- `EW32` is the default and preserves legacy vector behavior.
- `EW64` pairs lanes `(0,1)`, `(2,3)`, `(4,5)`, `(6,7)`.
- `mul`, `multiply_add`, `div`, `mod`, and `cdiv` have width-specific restrictions documented in the architecture and known-issues docs.

---

## Operational Semantics by Class

### ALU

- ALU addresses refer to scalar scratch words.
- `max` and `min` are unsigned in the scalar ALU.
- `div`, `mod`, and `cdiv` are multi-cycle.

### VALU

- Base addresses refer to vector regions of `VLEN` consecutive scratch words.
- For `vbroadcast`, the current assembler encodes the source scratch address into both `src1Base` and `src3Base`; hardware consumes the needed operand path from the VLIW core wiring.
- `vcast` uses `src2Base[0]` as the lower-half versus upper-half selector in assembler lowering.
- `max` and `min` are signed or unsigned depending on the `signed` flag.

### LOAD / STORE

- Memory addresses are expressed in scratch as word addresses and converted to byte addresses in `MemoryEngine` by shifting left by 2.
- `vload` and `vstore` operate on one AXI beat worth of `VLEN` 32-bit words in the baseline `VLEN=8` configuration.
- `load_offset` uses the encoded `offset` both for address calculation and for adjusting the destination scratch address.
- `const` writes an immediate directly through the load/writeback path.
- `wait_for_load`: encodes the destination scratch address as `dest`; stalls until that address has been committed to scratch by a prior load completion. Hardware load-use hazard detection in `VliwCore` handles this automatically in all current configurations — `wait_for_load` remains encodable but is typically not emitted by the DSL.
- `scopy_m2v` (opcode 6): multi-cycle scratchpad copy. `dest` = vector scratch base, `addrReg` = matrix-local base. Copies `VLEN` 32-bit words from the matrix accumulator (or operand scratch, controlled by flags) to vector scratch. Managed by a micro-sequencer in `MemoryEngine`.
- `scopy_v2m` (opcode 7): reverse of `scopy_m2v`. `dest` = matrix-local base, `addrReg` = vector scratch base. Copies `VLEN` words from vector scratch to matrix-local memory.
- `scopy_v2s` (opcode 8): single-word copy from vector scratch to scalar scratch. `dest` = scalar scratch destination, `addrReg` = vector scratch source.
- `scopy_s2v` (opcode 9): single-word copy from scalar scratch to vector scratch. `dest` = vector scratch destination, `addrReg` = scalar scratch source.

### FLOW

- `select`: `dest = operandA_data if cond != 0 else operandB_data`
- `vselect`: same rule lane-wise across `VLEN` lanes
- `add_imm`: uses sign extension of the encoded immediate field
- `jump_indirect`: target is read from scratch at `operandA`
- `coreid`: writes the hardwired core index

### MATRIX

Current v1 conventions from `SlotBundles.scala` and `MemoryEngine.scala`:

- `mdmvin`
  - `dest` = matrix-local base
  - `srcA` = DRAM base word address
- `mdmvout`
  - `dest` = DRAM base word address
  - `srcA` = matrix-local base
- `mcompute` / `mcompute_acc`
  - `dest` = accumulator base
  - `srcA` = operand-A local base
  - `srcB` = operand-B local base
- `mcompute_fp8_e4m3` / `mcompute_fp8_e4m3_acc`
  - same operand convention as `mcompute`
  - interprets both operand tiles as FP8 E4M3 values
  - accumulator memory stores IEEE-754 FP32 words
- `mcompute_fp8_e5m2` / `mcompute_fp8_e5m2_acc`
  - same operand convention as `mcompute`
  - interprets both operand tiles as FP8 E5M2 values
  - accumulator memory stores IEEE-754 FP32 words
- `mzero`
  - clears the addressed accumulator tile

#### FP8 Format Reference

Both FP8 formats pack one element per byte in matrix-local operand memory, stored row-major
(row index is the outer dimension). The `[sign | exponent | mantissa]` field order applies
to both variants.

**E4M3 — 1 sign, 4 exponent, 3 mantissa**

| Field    | Bits  |
|----------|-------|
| Sign     | [7]   |
| Exponent | [6:3] |
| Mantissa | [2:0] |

- Exponent bias: **7**
- Normal value: $(-1)^s \times 2^{e-7} \times 1.\text{mmm}_2$
- Subnormal ($e = 0$): $(-1)^s \times 2^{-6} \times 0.\text{mmm}_2$
- Dynamic range: ~±1.95 × 10⁻³ to **±448**
- **No Inf encoding.** All-ones exponent with any mantissa is **NaN** (`0x7F` / `0xFF`), following the ML FP8 convention (OCP MX spec).
- Maximum finite magnitude: 448 (`0x7E` / `0xFE`)

**E5M2 — 1 sign, 5 exponent, 2 mantissa**

| Field    | Bits  |
|----------|-------|
| Sign     | [7]   |
| Exponent | [6:2] |
| Mantissa | [1:0] |

- Exponent bias: **15**
- Normal value: $(-1)^s \times 2^{e-15} \times 1.\text{mm}_2$
- Subnormal ($e = 0$): $(-1)^s \times 2^{-14} \times 0.\text{mm}_2$
- Dynamic range: ~±6.10 × 10⁻⁵ to **±57344**
- **Inf:** exponent field = `11111`, mantissa = `00` — value is $\pm\infty$
- **NaN:** exponent field = `11111`, mantissa ≠ `00`
- Maximum finite magnitude: 57344 (`0x7B` / `0xFB`)

**Compute model**

Each matrix-local operand element is decoded from its 8-bit FP8 encoding to a full FP32
value in the MAC stage. The per-MAC product is then accumulated into the 32-bit FP32
accumulator word:

```
accum[i][j] += fp32(A_fp8[i][k]) * fp32(B_fp8[k][j])   for k in 0..7
```

For `mcompute_fp8_e4m3_acc` and `mcompute_fp8_e5m2_acc`, the existing accumulator value
is read back first and the products are summed on top of it. For the non-`_acc` variants,
the accumulator destination words are treated as zero prior to accumulation for that tile.

See `MatrixEngine.v` wires `fpA_E4M3_shift`, `fpB_E4M3_shift`, `fpProductE4M3`,
`fpA_E5M2_shift`, `fpB_E5M2_shift`, `fpProductE5M2` for the hardware decode path.

**NaN and special-value propagation**

- **E4M3:** If either operand byte is NaN (`0x7F` or `0xFF`), the FP32 product is NaN;
  the accumulator inherits a quiet NaN for that output element.
- **E5M2:** If either operand is Inf, the product follows IEEE-754 Inf × 0 = NaN and
  Inf × finite = Inf rules. If either operand is NaN, the product is NaN.
- NaN in the accumulator is sticky — subsequent `_acc` operations on a NaN-poisoned
  accumulator element continue to produce NaN.

**Choosing E4M3 vs E5M2**

| Criterion | E4M3 | E5M2 |
|-----------|------|------|
| Mantissa precision | Higher (3 bits → ~1% relative error) | Lower (2 bits → ~3% relative error) |
| Exponent range | Narrower (bias 7, max 448) | Wider (bias 15, max 57344) |
| Inf representation | Not available | Available |
| Typical ML use | Weights and activations with bounded range | Gradients or values with large dynamic range |
| Max finite value | 448 | 57344 |

Flag conventions:
- `flags[0] = 1` selects accumulator memory, otherwise operand scratch
- `flags[1] = 1` selects operand-B scratch when `flags[0] = 0`, otherwise operand-A scratch

Transfer constraints in current hardware:
- `mdmvin` / `mdmvout` require 64-byte aligned DRAM base addresses

---

## Assembler Surface Syntax

The assembler accepts per-bundle dictionaries keyed by engine class:

```python
{
    "alu": [("add", 2, 0, 1)],
    "valu": [("vbroadcast", 128, 7, 8)],
    "load": [("const", 0, 42)],
    "store": [("store", 10, 2)],
    "matrix": [("mzero", 0, 0, 0, 0, 8, 8, 0)],
    "flow": [("halt",)],
}
```

Common tuple forms in `tools/assembler.py`:

- ALU: `(op, dest, src1, src2)`
- VALU lane-wise: `(op, dest, src1, src2[, ew[, signed]])`
- VALU widening multiply: `("mul", dest, src1, src2, ew, dw[, signed])`
- `vbroadcast`: `("vbroadcast", dest, src[, ew])`
- `multiply_add`: `("multiply_add", dest, a, b, c[, ew[, dw[, signed]]])`
- `vcast`: `("vcast", dest, src, ew, dw[, signed[, upper_half]])`
- `load`: `("load", dest, addr)`
- `load_offset`: `("load_offset", dest, addr, offset)`
- `vload`: `("vload", dest, addr)`
- `const`: `("const", dest, value)`
- `store` / `vstore`: `(op, addr, src)`
- `select` / `vselect`: `(op, dest, cond, a, b)`
- `add_imm`: `("add_imm", dest, src, imm)`
- `cond_jump`: `("cond_jump", cond, addr)`
- `cond_jump_rel`: `("cond_jump_rel", cond, offset)`
- `jump`: `("jump", addr)`
- `jump_indirect`: `("jump_indirect", addr_reg)`
- `coreid`: `("coreid", dest)`
- `wait_for_load`: `("wait_for_load", dest)` — dest is the scratch address of the pending load to wait on
- `scopy_m2v`: `("scopy_m2v", dest_vec_base, src_mat_base)` — copy `VLEN` words matrix-local → vector scratch
- `scopy_v2m`: `("scopy_v2m", dest_mat_base, src_vec_base)` — copy `VLEN` words vector scratch → matrix-local
- `scopy_v2s`: `("scopy_v2s", dest_scalar, src_vec)` — copy 1 word vector scratch → scalar scratch
- `scopy_s2v`: `("scopy_s2v", dest_vec, src_scalar)` — copy 1 word scalar scratch → vector scratch
- `mcompute_fp8_e4m3`: `("mcompute_fp8_e4m3", dest, srcA, srcB[, srcC[, tileRows[, tileCols[, flags]]]])`
- `mcompute_fp8_e4m3_acc`: `("mcompute_fp8_e4m3_acc", dest, srcA, srcB[, srcC[, tileRows[, tileCols[, flags]]]])`
- `mcompute_fp8_e5m2`: `("mcompute_fp8_e5m2", dest, srcA, srcB[, srcC[, tileRows[, tileCols[, flags]]]])`
- `mcompute_fp8_e5m2_acc`: `("mcompute_fp8_e5m2_acc", dest, srcA, srcB[, srcC[, tileRows[, tileCols[, flags]]]])`

---

## Source of Truth Files

- `src/main/scala/vliw/bundle/SlotBundles.scala`
- `src/main/scala/vliw/config/VliwSocConfig.scala`
- `src/main/scala/vliw/core/DecodeUnit.scala`
- `src/main/scala/vliw/engine/FlowEngine.scala`
- `src/main/scala/vliw/engine/MemoryEngine.scala`
- `src/main/scala/vliw/engine/MatrixEngine.scala`
- `tools/assembler.py`
