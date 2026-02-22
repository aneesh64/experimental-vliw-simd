package vliw.core

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig
import vliw.bundle._

/**
 * Decode Unit — combinatorial instruction bundle decoder.
 *
 * Slices a fixed-width instruction bundle into typed slot structures
 * for each engine. Pure combinatorial logic (no registers) — lives
 * in the EX stage operating on the registered bundle from FetchUnit.
 *
 * Bundle layout (LSB first):
 *   [ ALU_0 | ALU_1 | ... | VALU_0 | ... | LOAD_0 | ... | STORE_0 | ... | FLOW | PAD ]
 *
 * Each slot is a fixed-width field; unused slots have valid=0 (NOP).
 */
class DecodeUnit(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    val bundle     = in Bits(cfg.bundleWidth bits)
    val valid      = in Bool()

    val aluSlots   = out Vec(AluSlot(cfg), cfg.nAluSlots)
    val valuSlots  = out Vec(ValuSlot(cfg), cfg.nValuSlots)
    val loadSlots  = out Vec(LoadSlot(cfg), cfg.nLoadSlots)
    val storeSlots = out Vec(StoreSlot(cfg), cfg.nStoreSlots)
    val flowSlot   = out(FlowSlot(cfg))
  }

  var bitOffset = 0

  // ---- ALU slots ----
  for (i <- 0 until cfg.nAluSlots) {
    val raw = io.bundle(bitOffset + cfg.aluSlotWidth - 1 downto bitOffset)
    val slot = io.aluSlots(i)

    // [39] valid | [38:35] opcode | [34:24] dest | [23:13] src1 | [12:2] src2 | [1:0] rsvd
    slot.valid  := raw(39) && io.valid
    slot.opcode := raw(38 downto 35).asUInt
    slot.dest   := raw(34 downto 24).asUInt.resize(cfg.scratchAddrWidth)
    slot.src1   := raw(23 downto 13).asUInt.resize(cfg.scratchAddrWidth)
    slot.src2   := raw(12 downto 2).asUInt.resize(cfg.scratchAddrWidth)

    bitOffset += cfg.aluSlotWidth
  }

  // ---- VALU slots ----
  for (i <- 0 until cfg.nValuSlots) {
    val raw = io.bundle(bitOffset + cfg.valuSlotWidth - 1 downto bitOffset)
    val slot = io.valuSlots(i)

    // [55] valid | [54:51] opcode | [50:40] destBase | [39:29] src1Base |
    // [28:18] src2Base | [17:7] src3Base | [6:0] rsvd
    slot.valid    := raw(55) && io.valid
    slot.opcode   := raw(54 downto 51).asUInt
    slot.destBase := raw(50 downto 40).asUInt.resize(cfg.scratchAddrWidth)
    slot.src1Base := raw(39 downto 29).asUInt.resize(cfg.scratchAddrWidth)
    slot.src2Base := raw(28 downto 18).asUInt.resize(cfg.scratchAddrWidth)
    slot.src3Base := raw(17 downto 7).asUInt.resize(cfg.scratchAddrWidth)

    bitOffset += cfg.valuSlotWidth
  }

  // ---- Load slots ----
  for (i <- 0 until cfg.nLoadSlots) {
    val raw = io.bundle(bitOffset + cfg.loadSlotWidth - 1 downto bitOffset)
    val slot = io.loadSlots(i)

    // [47] valid | [46:44] opcode | [43:33] dest | [32:22] addrReg |
    // [21:19] offset | [18:0] rsvd
    // For CONST: we need 32-bit immediate. We pack it across addrReg+offset+rsvd
    // fields (bits 32:0 = 33 bits available, enough for 32-bit immediate).
    slot.valid     := raw(47) && io.valid
    slot.opcode    := raw(46 downto 44).asUInt
    slot.dest      := raw(43 downto 33).asUInt.resize(cfg.scratchAddrWidth)
    slot.addrReg   := raw(32 downto 22).asUInt.resize(cfg.scratchAddrWidth)
    slot.offset    := raw(21 downto 19).asUInt
    // For CONST: immediate is packed in bits [31:0] of the operand region
    slot.immediate := raw(31 downto 0).asUInt

    bitOffset += cfg.loadSlotWidth
  }

  // ---- Store slots ----
  for (i <- 0 until cfg.nStoreSlots) {
    val raw = io.bundle(bitOffset + cfg.storeSlotWidth - 1 downto bitOffset)
    val slot = io.storeSlots(i)

    // [27] valid | [26:25] opcode | [24:14] addrReg | [13:3] srcReg | [2:0] rsvd
    slot.valid   := raw(27) && io.valid
    slot.opcode  := raw(26 downto 25).asUInt
    slot.addrReg := raw(24 downto 14).asUInt.resize(cfg.scratchAddrWidth)
    slot.srcReg  := raw(13 downto 3).asUInt.resize(cfg.scratchAddrWidth)

    bitOffset += cfg.storeSlotWidth
  }

  // ---- Flow slot ----
  {
    val raw = io.bundle(bitOffset + cfg.flowSlotWidth - 1 downto bitOffset)
    val slot = io.flowSlot

    // [47] valid | [46:43] opcode | [42:32] dest | [31:21] operandA |
    // [20:10] operandB | [9:0] immediate
    slot.valid     := raw(47) && io.valid
    slot.opcode    := raw(46 downto 43).asUInt
    slot.dest      := raw(42 downto 32).asUInt.resize(cfg.scratchAddrWidth)
    slot.operandA  := raw(31 downto 21).asUInt.resize(cfg.scratchAddrWidth)
    slot.operandB  := raw(20 downto 10).asUInt.resize(cfg.scratchAddrWidth)
    slot.immediate := raw(9 downto 0).asUInt.resize(cfg.imemAddrWidth)

    bitOffset += cfg.flowSlotWidth
  }
}
