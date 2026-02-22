package vliw.bundle

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig

// ============================================================================
//  ALU Opcode Enumeration
// ============================================================================

object AluOpcode {
  def ADD  : UInt = U(0, 4 bits)
  def SUB  : UInt = U(1, 4 bits)
  def MUL  : UInt = U(2, 4 bits)
  def XOR  : UInt = U(3, 4 bits)
  def AND  : UInt = U(4, 4 bits)
  def OR   : UInt = U(5, 4 bits)
  def SHL  : UInt = U(6, 4 bits)
  def SHR  : UInt = U(7, 4 bits)
  def LT   : UInt = U(8, 4 bits)
  def EQ   : UInt = U(9, 4 bits)
  def MOD  : UInt = U(10, 4 bits)
  def DIV  : UInt = U(11, 4 bits)
  def CDIV : UInt = U(12, 4 bits)
  def COUNT: Int  = 13  // number of base ALU ops
}

// ============================================================================
//  VALU Extra Opcodes (beyond lane-wise ALU ops)
// ============================================================================

object ValuOpcode {
  def VBROADCAST  : UInt = U(13, 4 bits)
  def MULTIPLY_ADD: UInt = U(14, 4 bits)
}

// ============================================================================
//  Load Opcode
// ============================================================================

object LoadOpcode {
  def NOP         : UInt = U(0, 3 bits)
  def LOAD        : UInt = U(1, 3 bits)
  def LOAD_OFFSET : UInt = U(2, 3 bits)
  def VLOAD       : UInt = U(3, 3 bits)
  def CONST       : UInt = U(4, 3 bits)
}

// ============================================================================
//  Store Opcode
// ============================================================================

object StoreOpcode {
  def NOP    : UInt = U(0, 2 bits)
  def STORE  : UInt = U(1, 2 bits)
  def VSTORE : UInt = U(2, 2 bits)
}

// ============================================================================
//  Flow Opcode
// ============================================================================

object FlowOpcode {
  def NOP            : UInt = U(0, 4 bits)
  def SELECT         : UInt = U(1, 4 bits)
  def VSELECT        : UInt = U(2, 4 bits)
  def ADD_IMM        : UInt = U(3, 4 bits)
  def HALT           : UInt = U(4, 4 bits)
  def COND_JUMP      : UInt = U(5, 4 bits)
  def COND_JUMP_REL  : UInt = U(6, 4 bits)
  def JUMP           : UInt = U(7, 4 bits)
  def JUMP_INDIRECT  : UInt = U(8, 4 bits)
  def COREID         : UInt = U(9, 4 bits)
}

// ============================================================================
//  Decoded Slot Bundles — one per engine type
// ============================================================================

/** Scalar ALU slot — 40 bits encoded.
 *  [39] valid | [38:35] opcode | [34:24] dest | [23:13] src1 | [12:2] src2 | [1:0] rsvd
 */
case class AluSlot(cfg: VliwSocConfig) extends Bundle {
  val valid  = Bool()
  val opcode = UInt(4 bits)
  val dest   = UInt(cfg.scratchAddrWidth bits)
  val src1   = UInt(cfg.scratchAddrWidth bits)
  val src2   = UInt(cfg.scratchAddrWidth bits)
}

/** Vector ALU slot — 56 bits encoded.
 *  [55] valid | [54:51] opcode | [50:40] destBase | [39:29] src1Base |
 *  [28:18] src2Base | [17:7] src3Base | [6:0] rsvd
 */
case class ValuSlot(cfg: VliwSocConfig) extends Bundle {
  val valid    = Bool()
  val opcode   = UInt(4 bits)
  val destBase = UInt(cfg.scratchAddrWidth bits)
  val src1Base = UInt(cfg.scratchAddrWidth bits)
  val src2Base = UInt(cfg.scratchAddrWidth bits)
  val src3Base = UInt(cfg.scratchAddrWidth bits)  // multiply_add operand C / vbroadcast scalar src
}

/** Load slot — 48 bits encoded.
 *  [47] valid | [46:44] opcode | [43:33] dest | [32:22] addrReg |
 *  [21:19] offset | [18:0] rsvd
 *  For CONST: dest is scratch addr, immediate is a separate 32-bit field
 *  which we encode in the upper bits.
 */
case class LoadSlot(cfg: VliwSocConfig) extends Bundle {
  val valid     = Bool()
  val opcode    = UInt(3 bits)
  val dest      = UInt(cfg.scratchAddrWidth bits)
  val addrReg   = UInt(cfg.scratchAddrWidth bits)
  val offset    = UInt(3 bits)       // for load_offset (0..7)
  val immediate = UInt(32 bits)      // for CONST instruction
}

/** Store slot — 28 bits encoded.
 *  [27] valid | [26:25] opcode | [24:14] addrReg | [13:3] srcReg | [2:0] rsvd
 */
case class StoreSlot(cfg: VliwSocConfig) extends Bundle {
  val valid   = Bool()
  val opcode  = UInt(2 bits)
  val addrReg = UInt(cfg.scratchAddrWidth bits)
  val srcReg  = UInt(cfg.scratchAddrWidth bits)
}

/** Flow slot — 48 bits encoded.
 *  [47] valid | [46:43] opcode | [42:32] dest | [31:21] operandA |
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
  val opcode   = UInt(4 bits)
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
