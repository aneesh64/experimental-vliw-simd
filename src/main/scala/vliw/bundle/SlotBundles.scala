package vliw.bundle

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig

object SlotEncodingWidths {
  val AluOpcodeBits = 5
  val ValuOpcodeBits = 5
  val LoadOpcodeBits = 4
  val StoreOpcodeBits = 3
  val FlowOpcodeBits = 5
  val MatrixOpcodeBits = 5
}

// ============================================================================
//  ALU Opcode Enumeration
// ============================================================================

object AluOpcode {
  def ADD  : UInt = U(0, SlotEncodingWidths.AluOpcodeBits bits)
  def SUB  : UInt = U(1, SlotEncodingWidths.AluOpcodeBits bits)
  def MUL  : UInt = U(2, SlotEncodingWidths.AluOpcodeBits bits)
  def XOR  : UInt = U(3, SlotEncodingWidths.AluOpcodeBits bits)
  def AND  : UInt = U(4, SlotEncodingWidths.AluOpcodeBits bits)
  def OR   : UInt = U(5, SlotEncodingWidths.AluOpcodeBits bits)
  def SHL  : UInt = U(6, SlotEncodingWidths.AluOpcodeBits bits)
  def SHR  : UInt = U(7, SlotEncodingWidths.AluOpcodeBits bits)
  def LT   : UInt = U(8, SlotEncodingWidths.AluOpcodeBits bits)
  def EQ   : UInt = U(9, SlotEncodingWidths.AluOpcodeBits bits)
  def MOD  : UInt = U(10, SlotEncodingWidths.AluOpcodeBits bits)
  def DIV  : UInt = U(11, SlotEncodingWidths.AluOpcodeBits bits)
  def CDIV : UInt = U(12, SlotEncodingWidths.AluOpcodeBits bits)
  def MAX  : UInt = U(13, SlotEncodingWidths.AluOpcodeBits bits)
  def MIN  : UInt = U(14, SlotEncodingWidths.AluOpcodeBits bits)
  def COUNT: Int  = 15  // number of base ALU ops
}

// ============================================================================
//  VALU Extra Opcodes (beyond lane-wise ALU ops)
// ============================================================================

object ValuOpcode {
  def VBROADCAST  : UInt = U(15, SlotEncodingWidths.ValuOpcodeBits bits)
  def MULTIPLY_ADD: UInt = U(16, SlotEncodingWidths.ValuOpcodeBits bits)
  def VCAST       : UInt = U(17, SlotEncodingWidths.ValuOpcodeBits bits)
}

// ============================================================================
//  FP32 Opcodes (shared by scalar ALU and EW32 VALU)
// ============================================================================

object Fp32Opcode {
  def FADD : UInt = U(18, SlotEncodingWidths.AluOpcodeBits bits)
  def FSUB : UInt = U(19, SlotEncodingWidths.AluOpcodeBits bits)
  def FMUL : UInt = U(20, SlotEncodingWidths.AluOpcodeBits bits)
  def FMAX : UInt = U(21, SlotEncodingWidths.AluOpcodeBits bits)
  def FMIN : UInt = U(22, SlotEncodingWidths.AluOpcodeBits bits)
  def I2F  : UInt = U(23, SlotEncodingWidths.AluOpcodeBits bits)
  def F2I  : UInt = U(24, SlotEncodingWidths.AluOpcodeBits bits)
  def U2F  : UInt = U(25, SlotEncodingWidths.AluOpcodeBits bits)
  def F2U  : UInt = U(26, SlotEncodingWidths.AluOpcodeBits bits)
}

// ============================================================================
//  Element Width Encoding (3-bit, packed in VALU reserved bits [6:4])
// ============================================================================

object ElemWidth {
  def EW32 : UInt = U(0, 3 bits)   // 32-bit elements (1 per lane, default)
  def EW8  : UInt = U(1, 3 bits)   // 8-bit  elements (4 per lane)
  def EW16 : UInt = U(2, 3 bits)   // 16-bit elements (2 per lane)
  def EW4  : UInt = U(3, 3 bits)   // 4-bit  elements (8 per lane)
  def EW64 : UInt = U(4, 3 bits)   // 64-bit elements (lane pairing, 4 per vector)

  /** Number of sub-elements per 32-bit lane word for a given ewidth. */
  def subsPerLane(ew: Int): Int = ew match {
    case 0 => 1   // EW32
    case 1 => 4   // EW8
    case 2 => 2   // EW16
    case 3 => 8   // EW4
    case 4 => 1   // EW64 (special: lane pairing)
    case _ => 1
  }

  /** Bit width of each sub-element for a given ewidth encoding. */
  def bitWidth(ew: Int): Int = ew match {
    case 0 => 32
    case 1 => 8
    case 2 => 16
    case 3 => 4
    case 4 => 64
    case _ => 32
  }
}

// ============================================================================
//  Load Opcode
// ============================================================================

object LoadOpcode {
  def NOP           : UInt = U(0, SlotEncodingWidths.LoadOpcodeBits bits)
  def LOAD          : UInt = U(1, SlotEncodingWidths.LoadOpcodeBits bits)
  def LOAD_OFFSET   : UInt = U(2, SlotEncodingWidths.LoadOpcodeBits bits)
  def VLOAD         : UInt = U(3, SlotEncodingWidths.LoadOpcodeBits bits)
  def CONST         : UInt = U(4, SlotEncodingWidths.LoadOpcodeBits bits)
  def WAIT_FOR_LOAD : UInt = U(5, SlotEncodingWidths.LoadOpcodeBits bits)
  def SCOPY_M2V     : UInt = U(6, SlotEncodingWidths.LoadOpcodeBits bits)  // matrix scratch → vector scratch (VLEN words)
  def SCOPY_V2M     : UInt = U(7, SlotEncodingWidths.LoadOpcodeBits bits)  // vector scratch → matrix scratch (VLEN words)
  def SCOPY_V2S     : UInt = U(8, SlotEncodingWidths.LoadOpcodeBits bits)  // vector scratch → scalar scratch (1 word)
  def SCOPY_S2V     : UInt = U(9, SlotEncodingWidths.LoadOpcodeBits bits)  // scalar scratch → vector scratch (1 word)
}

// ============================================================================
//  Store Opcode
// ============================================================================

object StoreOpcode {
  def NOP    : UInt = U(0, SlotEncodingWidths.StoreOpcodeBits bits)
  def STORE  : UInt = U(1, SlotEncodingWidths.StoreOpcodeBits bits)
  def VSTORE : UInt = U(2, SlotEncodingWidths.StoreOpcodeBits bits)
}

// ============================================================================
//  Flow Opcode
// ============================================================================

object FlowOpcode {
  def NOP            : UInt = U(0, SlotEncodingWidths.FlowOpcodeBits bits)
  def SELECT         : UInt = U(1, SlotEncodingWidths.FlowOpcodeBits bits)
  def VSELECT        : UInt = U(2, SlotEncodingWidths.FlowOpcodeBits bits)
  def ADD_IMM        : UInt = U(3, SlotEncodingWidths.FlowOpcodeBits bits)
  def HALT           : UInt = U(4, SlotEncodingWidths.FlowOpcodeBits bits)
  def COND_JUMP      : UInt = U(5, SlotEncodingWidths.FlowOpcodeBits bits)
  def COND_JUMP_REL  : UInt = U(6, SlotEncodingWidths.FlowOpcodeBits bits)
  def JUMP           : UInt = U(7, SlotEncodingWidths.FlowOpcodeBits bits)
  def JUMP_INDIRECT  : UInt = U(8, SlotEncodingWidths.FlowOpcodeBits bits)
  def COREID         : UInt = U(9, SlotEncodingWidths.FlowOpcodeBits bits)
}

// ============================================================================
//  Matrix Opcode (v1 fixed 8x8 engine, 8-bit inputs and 32-bit accumulators)
// ============================================================================

object MatrixOpcode {
  def NOP                  : UInt = U(0, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MCFG                 : UInt = U(1, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MMLOAD               : UInt = U(2, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MMSTORE              : UInt = U(3, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MDMVIN               : UInt = U(4, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MDMVOUT              : UInt = U(5, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MPRELOAD             : UInt = U(6, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MCOMPUTE             : UInt = U(7, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MCOMPUTE_ACC         : UInt = U(8, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MZERO                : UInt = U(9, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MCOMPUTE_FP8_E4M3    : UInt = U(10, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MCOMPUTE_FP8_E4M3_ACC: UInt = U(11, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MCOMPUTE_FP8_E5M2    : UInt = U(12, SlotEncodingWidths.MatrixOpcodeBits bits)
  def MCOMPUTE_FP8_E5M2_ACC: UInt = U(13, SlotEncodingWidths.MatrixOpcodeBits bits)

  def isCompute(op: UInt): Bool =
    op === MCOMPUTE ||
      op === MCOMPUTE_ACC ||
      op === MCOMPUTE_FP8_E4M3 ||
      op === MCOMPUTE_FP8_E4M3_ACC ||
      op === MCOMPUTE_FP8_E5M2 ||
      op === MCOMPUTE_FP8_E5M2_ACC

  def isAccumulate(op: UInt): Bool =
    op === MCOMPUTE_ACC ||
      op === MCOMPUTE_FP8_E4M3_ACC ||
      op === MCOMPUTE_FP8_E5M2_ACC

  def isFp8E4M3(op: UInt): Bool =
    op === MCOMPUTE_FP8_E4M3 || op === MCOMPUTE_FP8_E4M3_ACC

  def isFp8E5M2(op: UInt): Bool =
    op === MCOMPUTE_FP8_E5M2 || op === MCOMPUTE_FP8_E5M2_ACC

  def isFp8(op: UInt): Bool = isFp8E4M3(op) || isFp8E5M2(op)
}

// ============================================================================
//  Decoded Slot Bundles — one per engine type
// ============================================================================

/** Scalar ALU slot — 41 bits encoded.
 *  [40] valid | [39:35] opcode | [34:24] dest | [23:13] src1 | [12:2] src2 | [1:0] rsvd
 */
case class AluSlot(cfg: VliwSocConfig) extends Bundle {
  val valid  = Bool()
  val opcode = UInt(SlotEncodingWidths.AluOpcodeBits bits)
  val dest   = UInt(cfg.scratchAddrWidth bits)
  val src1   = UInt(cfg.scratchAddrWidth bits)
  val src2   = UInt(cfg.scratchAddrWidth bits)
}

/** Vector ALU slot — 57 bits encoded.
 *  [56] valid | [55:51] opcode | [50:40] destBase | [39:29] src1Base |
 *  [28:18] src2Base | [17:7] src3Base | [6:4] ewidth | [3:1] dwidth | [0] signed
 *
 *  ewidth/dwidth encoding: 000=32b, 001=8b, 010=16b, 011=4b, 100=64b
 *  signed: 0=unsigned, 1=signed (affects LT→SLT, SHR→SAR, MUL→SMUL, VCAST sign-extend)
 */
case class ValuSlot(cfg: VliwSocConfig) extends Bundle {
  val valid    = Bool()
  val opcode   = UInt(SlotEncodingWidths.ValuOpcodeBits bits)
  val destBase = UInt(cfg.scratchAddrWidth bits)
  val src1Base = UInt(cfg.scratchAddrWidth bits)
  val src2Base = UInt(cfg.scratchAddrWidth bits)
  val src3Base = UInt(cfg.scratchAddrWidth bits)  // multiply_add operand C / vbroadcast scalar src
  val ewidth   = UInt(3 bits)                     // source element width
  val dwidth   = UInt(3 bits)                     // dest element width (for cast/widening)
  val isSigned = Bool()                           // signed operations flag
}

/** Load slot — 49 bits encoded.
 *  [48] valid | [47:44] opcode | [43:33] dest | [32:22] addrReg |
 *  [21:19] offset | [18:0] rsvd
 *  For CONST: dest is scratch addr, immediate is a separate 32-bit field
 *  which we encode in the upper bits.
 */
case class LoadSlot(cfg: VliwSocConfig) extends Bundle {
  val valid     = Bool()
  val opcode    = UInt(SlotEncodingWidths.LoadOpcodeBits bits)
  val dest      = UInt(cfg.scratchAddrWidth bits)
  val addrReg   = UInt(cfg.scratchAddrWidth bits)
  val offset    = UInt(3 bits)       // for load_offset (0..7)
  val immediate = UInt(32 bits)      // for CONST instruction
}

/** Store slot — 29 bits encoded.
 *  [28] valid | [27:25] opcode | [24:14] addrReg | [13:3] srcReg | [2:0] rsvd
 */
case class StoreSlot(cfg: VliwSocConfig) extends Bundle {
  val valid   = Bool()
  val opcode  = UInt(SlotEncodingWidths.StoreOpcodeBits bits)
  val addrReg = UInt(cfg.scratchAddrWidth bits)
  val srcReg  = UInt(cfg.scratchAddrWidth bits)
}

/** Matrix slot — 65 bits encoded.
 *  v1 keeps the 8x8 matrix engine fixed and routes control through
 *  scratch-address-sized operands plus small tile/flag fields.
 *
 *  Direct DRAM move convention in v1:
 *    MDMVIN : dest=matrix-local base, srcA=DRAM base word address
 *    MDMVOUT: dest=DRAM base word address, srcA=matrix-local base
 *    flags[0]=1 selects accumulator memory, 0 selects int8 operand scratch
 *    flags[1]=1 selects operand-B scratch when flags[0]=0; otherwise operand-A
 *
 *  Compute convention in v1:
 *    MCOMPUTE/MCOMPUTE_ACC use signed int8 operands with int32 accumulation.
 *    MCOMPUTE_FP8_E4M3/MCOMPUTE_FP8_E4M3_ACC use FP8 E4M3 inputs with FP32 accumulation.
 *    MCOMPUTE_FP8_E5M2/MCOMPUTE_FP8_E5M2_ACC use FP8 E5M2 inputs with FP32 accumulation.
 *    All compute variants use srcA as operand-A base, srcB as operand-B base,
 *    and dest as accumulator base.
 *
 *  [64] valid | [63:59] opcode | [58:48] dest | [47:37] srcA |
 *  [36:26] srcB | [25:15] srcC | [14:11] tileRows | [10:7] tileCols |
 *  [6:1] flags | [0] reserved
 */
case class MatrixSlot(cfg: VliwSocConfig) extends Bundle {
  val valid    = Bool()
  val opcode   = UInt(SlotEncodingWidths.MatrixOpcodeBits bits)
  val dest     = UInt(cfg.scratchAddrWidth bits)
  val srcA     = UInt(cfg.scratchAddrWidth bits)
  val srcB     = UInt(cfg.scratchAddrWidth bits)
  val srcC     = UInt(cfg.scratchAddrWidth bits)
  val tileRows = UInt(4 bits)
  val tileCols = UInt(4 bits)
  val flags    = Bits(6 bits)
}

/** Flow slot — 49 bits encoded.
 *  [48] valid | [47:43] opcode | [42:32] dest | [31:21] operandA |
 *  [20:10] operandB | [9:0] immediate
 *
 *  Field usage by opcode:
 *    SELECT      : dest=write, operandA=cond, operandB=srcA, immediate[10:0]=srcB
 *    VSELECT     : same as SELECT but vector (VLEN lanes)
 *    ADD_IMM     : dest=write, operandA=srcA, immediate=value (sign-extended)
 *    COND_JUMP   : operandA=cond, {operandB,immediate}=target address
 *    COND_JUMP_REL: operandA=cond, immediate=signed offset
 *    JUMP        : {operandB,immediate}=target address
 *    JUMP_INDIRECT: operandA=scratch addr holding target
 *    HALT        : no operands
 *    COREID      : dest=write
 */
case class FlowSlot(cfg: VliwSocConfig) extends Bundle {
  val valid    = Bool()
  val opcode   = UInt(SlotEncodingWidths.FlowOpcodeBits bits)
  val dest     = UInt(cfg.scratchAddrWidth bits)
  val operandA = UInt(cfg.scratchAddrWidth bits)
  val operandB = UInt(cfg.scratchAddrWidth bits)
  val immediate = UInt(cfg.imemAddrWidth bits)  // sized for jump targets
}

// ============================================================================
//  Scratch Memory Access Bundles
// ============================================================================

/** Read request to the scratch memory crossbar. */
case class ScratchReadReq(cfg: VliwSocConfig) extends Bundle {
  val addr   = UInt(cfg.scratchAddrWidth bits)
  val enable = Bool()
}

/** Read response from scratch memory. */
case class ScratchReadRsp(cfg: VliwSocConfig) extends Bundle {
  val data = UInt(cfg.dataWidth bits)
}

/** Write request to the scratch memory (from engine writeback). */
case class ScratchWriteReq(cfg: VliwSocConfig) extends Bundle {
  val addr = UInt(cfg.scratchAddrWidth bits)
  val data = UInt(cfg.dataWidth bits)
}

// ============================================================================
//  Instruction Memory Write Command
// ============================================================================

case class ImemWriteCmd(cfg: VliwSocConfig) extends Bundle {
  val addr = UInt(cfg.imemAddrWidth bits)
  val data = Bits(cfg.bundleWidth bits)
}

// ============================================================================
//  Core Control / Status
// ============================================================================

case class CoreControl(cfg: VliwSocConfig) extends Bundle {
  val start = Bool()     // pulse to begin execution
  val reset = Bool()     // soft reset core
}

case class CoreStatus(cfg: VliwSocConfig) extends Bundle {
  val halted     = Bool()
  val running    = Bool()
  val pc         = UInt(cfg.imemAddrWidth bits)
  val cycleCount = UInt(32 bits)
}
