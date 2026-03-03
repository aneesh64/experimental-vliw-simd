package vliw.engine

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig
import vliw.bundle._
import vliw.plugin._
import vliw.engine.valu.ValuResultBuilders

/**
 * Vector ALU Engine — executes N VALU slots, each over VLEN lanes.
 *
 * Supports multi-width packed sub-element operations:
 *   EW32 (32-bit): 1 element/lane, 8 elements/vector (default, backward compat)
 *   EW16 (16-bit): 2 elements/lane, 16 elements/vector
 *   EW8  (8-bit):  4 elements/lane, 32 elements/vector
 *   EW4  (4-bit):  8 elements/lane, 64 elements/vector
 *   EW64 (64-bit): lane pairing (0+1, 2+3, ...), 4 elements/vector
 *
 * Single-cycle: ADD, SUB, MUL, XOR, AND, OR, SHL, SHR, LT, EQ,
 *   VBROADCAST, MULTIPLY_ADD, VCAST (all widths).
 * Multi-cycle:  MOD, DIV, CDIV (EW32 only — dividers not packed).
 *
 * Widening operations (ewidth < dwidth):
 *   MUL/MULTIPLY_ADD: element-wise, processes 32/dwidth elements per lane
 *   VCAST: type conversion (sign/zero extend or truncate)
 *
 * Signed flag: affects LT→SLT, SHR→SAR, MUL→SMUL, VCAST→sign-extension.
 *
 * 64-bit: lane pairing (even=lo, odd=hi). Carry chains for ADD/SUB.
 *   No 64-bit MUL (too expensive). No 64-bit DIV/MOD/CDIV.
 */
class ValuEngine(cfg: VliwSocConfig) extends Component with EnginePlugin with ValuResultBuilders {
  val io = new Bundle {
    val slots = in Vec(ValuSlot(cfg), cfg.nValuSlots)
    val valid = in Bool()

    val operandA = in Vec(Vec(UInt(cfg.dataWidth bits), cfg.vlen), cfg.nValuSlots)
    val operandB = in Vec(Vec(UInt(cfg.dataWidth bits), cfg.vlen), cfg.nValuSlots)
    val operandC = in Vec(Vec(UInt(cfg.dataWidth bits), cfg.vlen), cfg.nValuSlots)

    val writeReqs = Vec(Vec(master(Flow(ScratchWriteReq(cfg))), cfg.vlen), cfg.nValuSlots)
  }

  override def engineName: String = "VALU"
  override def numScalarReadPorts: Int = cfg.nValuSlots
  override def numVectorReadGroups: Int = cfg.nValuSlots * 2
  override def numScalarWritePorts: Int = 0
  override def numVectorWriteGroups: Int = cfg.nValuSlots

  // Packed/widening/cast helper methods are split under vliw.engine.valu

  // =========================================================================
  //  64-bit inter-lane signals (carry, borrow, comparison)
  // =========================================================================

  // 64-bit inter-lane signals: driven by even-lane logic, read by odd-lane logic.
  // Each (slot, pairIdx) is assigned by exactly one even lane in the
  // compile-time-unrolled loop — no default loop needed, no overlap.
  val carry64  = Vec(Vec(Bool(), cfg.vlen / 2), cfg.nValuSlots)
  val borrow64 = Vec(Vec(Bool(), cfg.vlen / 2), cfg.nValuSlots)
  val ltLo64   = Vec(Vec(Bool(), cfg.vlen / 2), cfg.nValuSlots)
  val eqLo64   = Vec(Vec(Bool(), cfg.vlen / 2), cfg.nValuSlots)

  // =========================================================================
  //  Per-slot, per-lane computation
  // =========================================================================

  for (s <- 0 until cfg.nValuSlots) {
    val slot  = io.slots(s)
    val slotValid = slot.valid && io.valid
    val ew  = slot.ewidth
    val dw  = slot.dwidth
    val sgn = slot.isSigned

    for (lane <- 0 until cfg.vlen) {
      val a = io.operandA(s)(lane)
      val b = io.operandB(s)(lane)
      val c = io.operandC(s)(lane)

      // ---- Per-lane divider (EW32 only, fire-and-forget) ----
      val divider    = new UnsignedDivider(cfg.dataWidth)
      val divCapDest = Reg(UInt(cfg.scratchAddrWidth bits)) init 0
      val divCapMode = Reg(UInt(2 bits)) init 0

      val isDiv = slot.opcode === AluOpcode.MOD ||
                  slot.opcode === AluOpcode.DIV ||
                  slot.opcode === AluOpcode.CDIV

      divider.io.start    := slotValid && isDiv && !divider.io.busy && (ew === ElemWidth.EW32)
      divider.io.dividend := Mux(slot.opcode === AluOpcode.CDIV,
                                 (a + b - 1).resize(cfg.dataWidth), a)
      divider.io.divisor  := b

      when(divider.io.start) {
        divCapDest := (slot.destBase + lane).resize(cfg.scratchAddrWidth)
        when(slot.opcode === AluOpcode.MOD)  { divCapMode := 0 }
        .elsewhen(slot.opcode === AluOpcode.DIV) { divCapMode := 1 }
        .otherwise { divCapMode := 2 }
      }

      val divResult = Mux(divCapMode === 0, divider.io.remainder, divider.io.quotient)

      // ---- Packed ALU results per EW (all opcodes) ----
      val packedResults = genPackedResults(a, b, c, slot, sgn)

      // ---- Widening MUL/FMA results ----
      // EW8→EW16 (2 dest elements)
      val widen8to16 = UInt(32 bits); widen8to16 := 0
      when(slot.opcode === AluOpcode.MUL)          { widen8to16 := wideningMul(a, b, 8, 16, 2, sgn) }
      .elsewhen(slot.opcode === ValuOpcode.MULTIPLY_ADD) { widen8to16 := wideningFma(a, b, c, 8, 16, 2, sgn) }
      // EW8→EW32 (1 dest element)
      val widen8to32 = UInt(32 bits); widen8to32 := 0
      when(slot.opcode === AluOpcode.MUL)          { widen8to32 := wideningMul(a, b, 8, 32, 1, sgn) }
      .elsewhen(slot.opcode === ValuOpcode.MULTIPLY_ADD) { widen8to32 := wideningFma(a, b, c, 8, 32, 1, sgn) }
      // EW16→EW32 (1 dest element)
      val widen16to32 = UInt(32 bits); widen16to32 := 0
      when(slot.opcode === AluOpcode.MUL)          { widen16to32 := wideningMul(a, b, 16, 32, 1, sgn) }
      .elsewhen(slot.opcode === ValuOpcode.MULTIPLY_ADD) { widen16to32 := wideningFma(a, b, c, 16, 32, 1, sgn) }
      // EW4→EW8 (4 dest elements)
      val widen4to8 = UInt(32 bits); widen4to8 := 0
      when(slot.opcode === AluOpcode.MUL)          { widen4to8 := wideningMul(a, b, 4, 8, 4, sgn) }
      .elsewhen(slot.opcode === ValuOpcode.MULTIPLY_ADD) { widen4to8 := wideningFma(a, b, c, 4, 8, 4, sgn) }
      // EW4→EW16 (2 dest elements)
      val widen4to16 = UInt(32 bits); widen4to16 := 0
      when(slot.opcode === AluOpcode.MUL)          { widen4to16 := wideningMul(a, b, 4, 16, 2, sgn) }
      .elsewhen(slot.opcode === ValuOpcode.MULTIPLY_ADD) { widen4to16 := wideningFma(a, b, c, 4, 16, 2, sgn) }
      // EW4→EW32 (1 dest element)
      val widen4to32 = UInt(32 bits); widen4to32 := 0
      when(slot.opcode === AluOpcode.MUL)          { widen4to32 := wideningMul(a, b, 4, 32, 1, sgn) }
      .elsewhen(slot.opcode === ValuOpcode.MULTIPLY_ADD) { widen4to32 := wideningFma(a, b, c, 4, 32, 1, sgn) }

      // ---- VCAST results (widening and narrowing) ----
      val upperHalf = slot.src2Base(0)
      // widening casts
      val cast8to16  = castWiden(a, 8, 16, 2, sgn, upperHalf)
      val cast8to32  = castWiden(a, 8, 32, 1, sgn, upperHalf)
      val cast16to32 = castWiden(a, 16, 32, 1, sgn, upperHalf)
      val cast4to8   = castWiden(a, 4, 8, 4, sgn, upperHalf)
      val cast4to16  = castWiden(a, 4, 16, 2, sgn, upperHalf)
      val cast4to32  = castWiden(a, 4, 32, 1, sgn, upperHalf)
      // narrowing casts
      val cast32to16 = castNarrow(a, 32, 16, 1, sgn, upperHalf)
      val cast32to8  = castNarrow(a, 32, 8, 1, sgn, upperHalf)
      val cast32to4  = castNarrow(a, 32, 4, 1, sgn, upperHalf)
      val cast16to8  = castNarrow(a, 16, 8, 2, sgn, upperHalf)
      val cast16to4  = castNarrow(a, 16, 4, 2, sgn, upperHalf)
      val cast8to4   = castNarrow(a, 8, 4, 4, sgn, upperHalf)

      // ---- 64-bit lane pairing (even=lo, odd=hi) ----
      val pairIdx = lane / 2
      val isEvenLane = (lane % 2 == 0)
      val result64 = UInt(32 bits)
      result64 := 0

      if (isEvenLane) {
        val sum33  = a.resize(33) +^ b.resize(33)
        val diff33 = a.resize(33) -^ b.resize(33)
        carry64(s)(pairIdx)  := sum33(32)
        borrow64(s)(pairIdx) := diff33(32)
        ltLo64(s)(pairIdx)   := a < b
        eqLo64(s)(pairIdx)   := a === b

        switch(slot.opcode) {
          is(AluOpcode.ADD) { result64 := sum33.resize(32) }
          is(AluOpcode.SUB) { result64 := diff33.resize(32) }
          is(AluOpcode.XOR) { result64 := a ^ b }
          is(AluOpcode.AND) { result64 := a & b }
          is(AluOpcode.OR)  { result64 := a | b }
          is(AluOpcode.SHL) {
            val shamt = b(5 downto 0)
            when(shamt >= 32) { result64 := 0 }
            .otherwise        { result64 := (a |<< shamt).resize(32) }
          }
          is(AluOpcode.SHR) {
            val shamt = b(5 downto 0)
            val hiWord = io.operandA(s)(lane + 1)
            when(shamt >= 32) { result64 := Mux(sgn, (hiWord.asSInt >> (shamt - 32)).resize(32).asUInt, hiWord |>> (shamt - 32)) }
            .otherwise {
              when(shamt === 0) { result64 := a }
              .otherwise        { result64 := ((a |>> shamt) | (hiWord |<< (U(32) - shamt))).resize(32) }
            }
          }
          is(AluOpcode.LT)  { result64 := 0 }
          is(AluOpcode.EQ)  { result64 := 0 }
          is(ValuOpcode.VBROADCAST) { result64 := c }
        }
      } else {
        val cIn = carry64(s)(pairIdx).asUInt.resize(32)
        val bIn = borrow64(s)(pairIdx).asUInt.resize(32)

        switch(slot.opcode) {
          is(AluOpcode.ADD) { result64 := (a + b + cIn).resize(32) }
          is(AluOpcode.SUB) { result64 := (a - b - bIn).resize(32) }
          is(AluOpcode.XOR) { result64 := a ^ b }
          is(AluOpcode.AND) { result64 := a & b }
          is(AluOpcode.OR)  { result64 := a | b }
          is(AluOpcode.SHL) {
            val shamt = io.operandB(s)(lane - 1)(5 downto 0)
            val loWord = io.operandA(s)(lane - 1)
            when(shamt >= 32) { result64 := (loWord |<< (shamt - 32)).resize(32) }
            .otherwise {
              when(shamt === 0) { result64 := a }
              .otherwise        { result64 := ((a |<< shamt) | (loWord |>> (U(32) - shamt))).resize(32) }
            }
          }
          is(AluOpcode.SHR) {
            val shamt = io.operandB(s)(lane - 1)(5 downto 0)
            when(shamt >= 32) { result64 := Mux(sgn, S(0, 32 bits).asUInt, U(0, 32 bits)) }
            .otherwise {
              when(shamt === 0) { result64 := a }
              .otherwise { result64 := Mux(sgn, (a.asSInt >> shamt).resize(32).asUInt, a |>> shamt) }
            }
          }
          is(AluOpcode.LT) {
            val loLt = ltLo64(s)(pairIdx)
            val loEq = eqLo64(s)(pairIdx)
            val hiLt = Mux(sgn, a.asSInt < b.asSInt, a < b)
            val hiEq = a === b
            result64 := (hiLt || (hiEq && loLt)).asUInt.resize(32)
          }
          is(AluOpcode.EQ) {
            result64 := (eqLo64(s)(pairIdx) && (a === b)).asUInt.resize(32)
          }
          is(ValuOpcode.VBROADCAST) { result64 := c }
        }
      }

      // ---- Final result MUX ----
      val result = UInt(cfg.dataWidth bits)
      result := packedResults(0)  // default: EW32

      val isCast = slot.opcode === ValuOpcode.VCAST
      val isWiden = (slot.opcode === AluOpcode.MUL || slot.opcode === ValuOpcode.MULTIPLY_ADD) &&
                    (ew =/= dw) && (ew =/= ElemWidth.EW32) && (ew =/= ElemWidth.EW64)

      when(isWiden) {
        when(ew === ElemWidth.EW8  && dw === ElemWidth.EW16) { result := widen8to16  }
        .elsewhen(ew === ElemWidth.EW8  && (dw === ElemWidth.EW32 || dw === 0)) { result := widen8to32  }
        .elsewhen(ew === ElemWidth.EW16 && (dw === ElemWidth.EW32 || dw === 0)) { result := widen16to32 }
        .elsewhen(ew === ElemWidth.EW4  && dw === ElemWidth.EW8)  { result := widen4to8   }
        .elsewhen(ew === ElemWidth.EW4  && dw === ElemWidth.EW16) { result := widen4to16  }
        .elsewhen(ew === ElemWidth.EW4  && (dw === ElemWidth.EW32 || dw === 0)) { result := widen4to32  }
      } .elsewhen(isCast) {
        // VCAST: ewidth → dwidth conversion
        when(ew === ElemWidth.EW8) {
          when(dw === ElemWidth.EW16) { result := cast8to16 }
          .elsewhen(dw === ElemWidth.EW32 || dw === 0) { result := cast8to32 }
          .elsewhen(dw === ElemWidth.EW4)  { result := cast8to4 }
          .otherwise { result := a }
        } .elsewhen(ew === ElemWidth.EW16) {
          when(dw === ElemWidth.EW32 || dw === 0) { result := cast16to32 }
          .elsewhen(dw === ElemWidth.EW8)  { result := cast16to8 }
          .elsewhen(dw === ElemWidth.EW4)  { result := cast16to4 }
          .otherwise { result := a }
        } .elsewhen(ew === ElemWidth.EW4) {
          when(dw === ElemWidth.EW8)  { result := cast4to8  }
          .elsewhen(dw === ElemWidth.EW16) { result := cast4to16 }
          .elsewhen(dw === ElemWidth.EW32 || dw === 0) { result := cast4to32 }
          .otherwise { result := a }
        } .elsewhen(ew === ElemWidth.EW32 || ew === 0) {
          when(dw === ElemWidth.EW16) { result := cast32to16 }
          .elsewhen(dw === ElemWidth.EW8) { result := cast32to8 }
          .elsewhen(dw === ElemWidth.EW4) { result := cast32to4 }
          .otherwise { result := a }
        } .otherwise { result := a }
      } .otherwise {
        // Same-width ALU: select by ewidth
        when(ew === ElemWidth.EW8)       { result := packedResults(1) }
        .elsewhen(ew === ElemWidth.EW16) { result := packedResults(2) }
        .elsewhen(ew === ElemWidth.EW4)  { result := packedResults(3) }
        .elsewhen(ew === ElemWidth.EW64) { result := result64 }
        .otherwise                       { result := packedResults(0) }
      }

      // ---- Write port ----
      val destAddr = (slot.destBase + lane).resize(cfg.scratchAddrWidth)
      val singleCycleWrite = slotValid && !isDiv

      io.writeReqs(s)(lane).valid := divider.io.done || singleCycleWrite
      io.writeReqs(s)(lane).addr  := Mux(divider.io.done, divCapDest, destAddr)
      io.writeReqs(s)(lane).data  := Mux(divider.io.done, divResult, result)
    }
  }
}
