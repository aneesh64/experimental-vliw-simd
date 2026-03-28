package vliw.engine

import spinal.core._
import vliw.bundle.Fp32Opcode
import vliw.config.VliwSocConfig

/**
 * Serialized FP32 execution unit.
 *
 * Arithmetic is implemented directly on IEEE-754 single-precision fields
 * using normalized significands, exponent alignment, and round-to-nearest-even.
 * One FP32 op may be in flight per unit. Add/sub/max/min/conversions complete
 * after cfg.fp32AddLatency cycles; multiply completes after cfg.fp32MulLatency.
 */
class Fp32Unit(cfg: VliwSocConfig) extends Component {
  private val ExpWidth = 10
  private val SigWidth = 24
  private val ExtSigWidth = 27
  private val IntToFpWide = 35
  private val MulProdWidth = 48
  private val ExpBias = 127
  private val MinNormalExp = -126
  private val MaxNormalExp = 127
  private val CanonicalQNaN = 0x7FC00000L

  val io = new Bundle {
    val fire   = in Bool()
    val mode   = in UInt(5 bits)
    val a      = in UInt(32 bits)
    val b      = in UInt(32 bits)
    val tagIn  = in UInt(cfg.scratchAddrWidth bits)

    val busy   = out Bool()
    val done   = out Bool()
    val result = out UInt(32 bits)
    val tagOut = out UInt(cfg.scratchAddrWidth bits)
  }

  case class DecodedFp() extends Bundle {
    val sign = Bool()
    val exp = SInt(ExpWidth bits)
    val sig = UInt(SigWidth bits)
    val isZero = Bool()
    val isInf = Bool()
    val isNaN = Bool()
  }

  private def qnan: UInt = U(CanonicalQNaN, 32 bits)

  private def inf(sign: Bool): UInt = (sign.asBits ## B(255, 8 bits) ## B(0, 23 bits)).asUInt

  private def highestSetBit(value: UInt): UInt = {
    val result = UInt(log2Up(value.getWidth) bits)
    result := 0
    for (bit <- 0 until value.getWidth) {
      when(value(bit)) {
        result := bit
      }
    }
    result
  }

  private def shiftRightJamTo(value: UInt, shift: UInt, outWidth: Int, maxShift: Int): UInt = {
    val result = UInt(outWidth bits)
    result := 0

    when(shift === 0) {
      result := value.resize(outWidth)
    }

    for (amount <- 1 to maxShift) {
      when(shift === U(amount, shift.getWidth bits)) {
        if (amount < value.getWidth) {
          val shifted = (value >> amount).resize(outWidth)
          val sticky = value(amount - 1 downto 0).orR
          result := shifted | sticky.asUInt.resize(outWidth)
        } else {
          result := value.orR.asUInt.resize(outWidth)
        }
      }
    }

    when(shift > U(maxShift, shift.getWidth bits)) {
      result := value.orR.asUInt.resize(outWidth)
    }

    result
  }

  private def decodeFp32(raw: UInt): DecodedFp = {
    val decoded = DecodedFp()
    val expField = raw(30 downto 23)
    val frac = raw(22 downto 0)

    decoded.sign := raw(31)
    decoded.exp := S(MinNormalExp, ExpWidth bits)
    decoded.sig := 0
    decoded.isZero := expField === 0 && frac === 0
    decoded.isInf := expField === U(255, 8 bits) && frac === 0
    decoded.isNaN := expField === U(255, 8 bits) && frac =/= 0

    when(expField === 0) {
      when(frac =/= 0) {
        val msb = highestSetBit(frac)
        val shift = (U(23, 5 bits) - msb).resize(6)
        decoded.sig := (frac.resize(SigWidth) |<< shift).resize(SigWidth)
        decoded.exp := (S(MinNormalExp, ExpWidth bits) - shift.asSInt.resize(ExpWidth)).resize(ExpWidth)
      }
    } elsewhen(expField =/= U(255, 8 bits)) {
      decoded.sig := (U(1, 1 bits) ## frac).asUInt
      decoded.exp := (expField.resize(ExpWidth).asSInt - S(ExpBias, ExpWidth bits)).resize(ExpWidth)
    }

    decoded
  }

  private def roundPack(sign: Bool, expIn: SInt, sigIn: UInt): UInt = {
    val result = UInt(32 bits)
    result := (sign.asBits ## B(0, 31 bits)).asUInt

    val needsSubnormalShift = expIn < S(MinNormalExp, ExpWidth bits)
    val subShift = UInt(ExpWidth bits)
    subShift := 0
    when(needsSubnormalShift) {
      subShift := (S(MinNormalExp, ExpWidth bits) - expIn).asUInt.resize(ExpWidth)
    }

    val sigForRound = UInt(ExtSigWidth bits)
    sigForRound := sigIn
    when(needsSubnormalShift) {
      sigForRound := shiftRightJamTo(sigIn, subShift, ExtSigWidth, 31)
    }

    val expForRound = SInt(ExpWidth bits)
    expForRound := expIn
    when(needsSubnormalShift) {
      expForRound := S(MinNormalExp, ExpWidth bits)
    }

    val mantPre = sigForRound(26 downto 3)
    val roundUp = sigForRound(2) && (sigForRound(1) || sigForRound(0) || mantPre(0))
    val mantRounded = (mantPre.resize(25) + roundUp.asUInt.resize(25)).resize(25)

    val mantFinal = UInt(24 bits)
    mantFinal := mantRounded(23 downto 0)
    val expFinal = SInt(ExpWidth bits)
    expFinal := expForRound
    when(mantRounded(24)) {
      mantFinal := mantRounded(24 downto 1)
      expFinal := (expForRound + 1).resize(ExpWidth)
    }

    when(mantFinal === 0) {
      result := (sign.asBits ## B(0, 31 bits)).asUInt
    } elsewhen(expFinal > S(MaxNormalExp, ExpWidth bits)) {
      result := inf(sign)
    } otherwise {
      val expField = UInt(8 bits)
      expField := 0

      when(expFinal === S(MinNormalExp, ExpWidth bits) && mantFinal(23)) {
        expField := U(1, 8 bits)
      } elsewhen(expFinal > S(MinNormalExp, ExpWidth bits)) {
        expField := (expFinal + S(ExpBias, ExpWidth bits)).asUInt.resize(8)
      }

      result := (sign.asBits ## expField.asBits ## mantFinal(22 downto 0).asBits).asUInt
    }

    result
  }

  private def intToFp32Bits(magnitude: UInt, sign: Bool): UInt = {
    val result = UInt(32 bits)
    result := (sign.asBits ## B(0, 31 bits)).asUInt

    when(magnitude =/= 0) {
      val msb = highestSetBit(magnitude)
      val extWide = UInt(IntToFpWide bits)
      extWide := (magnitude.resize(IntToFpWide) |<< 3).resize(IntToFpWide)

      val extSig = UInt(ExtSigWidth bits)
      extSig := 0
      when(msb <= U(23, msb.getWidth bits)) {
        val leftShift = (U(23, msb.getWidth bits) - msb).resize(6)
        extSig := (extWide |<< leftShift).resize(ExtSigWidth)
      } otherwise {
        val rightShift = (msb - U(23, msb.getWidth bits)).resize(6)
        extSig := shiftRightJamTo(extWide, rightShift, ExtSigWidth, IntToFpWide - 1)
      }

      result := roundPack(sign, msb.resize(ExpWidth).asSInt, extSig)
    }

    result
  }

  private def floatLess(a: UInt, b: UInt): Bool = {
    val aSign = a(31)
    val bSign = b(31)
    val aMag = a(30 downto 0)
    val bMag = b(30 downto 0)
    val result = Bool()
    result := False

    when((a(30 downto 0) === 0) && (b(30 downto 0) === 0)) {
      result := False
    } elsewhen(aSign =/= bSign) {
      result := aSign
    } elsewhen(aMag === bMag) {
      result := False
    } elsewhen(!aSign) {
      result := aMag < bMag
    } otherwise {
      result := aMag > bMag
    }

    result
  }

  val decA = decodeFp32(io.a)
  val decB = decodeFp32(io.b)

  val effBSign = Bool()
  effBSign := decB.sign ^ (io.mode === Fp32Opcode.FSUB)

  val sameSignAdd = decA.sign === effBSign
  val aMagGreater = (decA.exp > decB.exp) || ((decA.exp === decB.exp) && (decA.sig >= decB.sig))

  val bigExp = SInt(ExpWidth bits)
  bigExp := decA.exp
  when(!aMagGreater) {
    bigExp := decB.exp
  }

  val smallExp = SInt(ExpWidth bits)
  smallExp := decB.exp
  when(!aMagGreater) {
    smallExp := decA.exp
  }

  val bigSig = UInt(SigWidth bits)
  bigSig := decA.sig
  when(!aMagGreater) {
    bigSig := decB.sig
  }

  val smallSig = UInt(SigWidth bits)
  smallSig := decB.sig
  when(!aMagGreater) {
    smallSig := decA.sig
  }

  val bigSign = Bool()
  bigSign := decA.sign
  when(!aMagGreater) {
    bigSign := effBSign
  }

  val expDiff = UInt(ExpWidth bits)
  expDiff := (bigExp - smallExp).asUInt.resize(ExpWidth)

  val bigExt = (bigSig.resize(ExtSigWidth) |<< 3).resize(ExtSigWidth)
  val smallExtBase = (smallSig.resize(ExtSigWidth) |<< 3).resize(ExtSigWidth)
  val smallExt = shiftRightJamTo(smallExtBase, expDiff, ExtSigWidth, 31)

  val addFiniteSign = Bool()
  addFiniteSign := bigSign
  val addFiniteExp = SInt(ExpWidth bits)
  addFiniteExp := bigExp
  val addFiniteSig = UInt(ExtSigWidth bits)
  addFiniteSig := 0

  when(sameSignAdd) {
    val sum = (bigExt.resize(ExtSigWidth + 1) + smallExt.resize(ExtSigWidth + 1)).resize(ExtSigWidth + 1)
    when(sum(ExtSigWidth)) {
      addFiniteSig := sum(ExtSigWidth downto 1) | sum(0).asUInt.resize(ExtSigWidth)
      addFiniteExp := (bigExp + 1).resize(ExpWidth)
    } otherwise {
      addFiniteSig := sum(ExtSigWidth - 1 downto 0)
      addFiniteExp := bigExp
    }
  } otherwise {
    val diff = (bigExt - smallExt).resize(ExtSigWidth)
    when(diff === 0) {
      addFiniteSign := False
      addFiniteExp := S(MinNormalExp, ExpWidth bits)
      addFiniteSig := 0
    } otherwise {
      val msb = highestSetBit(diff)
      val leftShift = (U(26, msb.getWidth bits) - msb).resize(6)
      addFiniteSign := bigSign
      addFiniteExp := (bigExp - leftShift.asSInt.resize(ExpWidth)).resize(ExpWidth)
      addFiniteSig := (diff |<< leftShift).resize(ExtSigWidth)
    }
  }

  val addResult = UInt(32 bits)
  addResult := roundPack(addFiniteSign, addFiniteExp, addFiniteSig)
  when(decA.isNaN || decB.isNaN) {
    addResult := qnan
  } elsewhen(decA.isInf && decB.isInf && (decA.sign =/= effBSign)) {
    addResult := qnan
  } elsewhen(decA.isInf) {
    addResult := inf(decA.sign)
  } elsewhen(decB.isInf) {
    addResult := inf(effBSign)
  }

  val mulResult = UInt(32 bits)
  mulResult := 0
  val mulSign = decA.sign ^ decB.sign
  when(decA.isNaN || decB.isNaN) {
    mulResult := qnan
  } elsewhen((decA.isInf && decB.isZero) || (decB.isInf && decA.isZero)) {
    mulResult := qnan
  } elsewhen(decA.isInf || decB.isInf) {
    mulResult := inf(mulSign)
  } elsewhen(decA.isZero || decB.isZero) {
    mulResult := (mulSign.asBits ## B(0, 31 bits)).asUInt
  } otherwise {
    val prod = (decA.sig.resize(MulProdWidth) * decB.sig.resize(MulProdWidth)).resize(MulProdWidth)
    val mulExp = SInt(ExpWidth bits)
    mulExp := (decA.exp + decB.exp).resize(ExpWidth)
    val mulExtSig = UInt(ExtSigWidth bits)
    mulExtSig := 0

    when(prod(47)) {
      mulExp := (decA.exp + decB.exp + 1).resize(ExpWidth)
      val sticky = prod(20 downto 0).orR
      mulExtSig := prod(47 downto 21) | sticky.asUInt.resize(ExtSigWidth)
    } otherwise {
      val sticky = prod(19 downto 0).orR
      mulExtSig := prod(46 downto 20) | sticky.asUInt.resize(ExtSigWidth)
    }

    mulResult := roundPack(mulSign, mulExp, mulExtSig)
  }

  val maxMinResult = UInt(32 bits)
  maxMinResult := io.a
  when(decA.isNaN && decB.isNaN) {
    maxMinResult := qnan
  } elsewhen(decA.isNaN) {
    maxMinResult := io.b
  } elsewhen(decB.isNaN) {
    maxMinResult := io.a
  } otherwise {
    val aLessB = floatLess(io.a, io.b)
    when(io.mode === Fp32Opcode.FMAX) {
      when((io.a(30 downto 0) === 0) && (io.b(30 downto 0) === 0)) {
        maxMinResult := U(0, 32 bits)
      } otherwise {
        maxMinResult := Mux(aLessB, io.b, io.a)
      }
    } otherwise {
      when((io.a(30 downto 0) === 0) && (io.b(30 downto 0) === 0)) {
        maxMinResult := U(0x80000000L, 32 bits)
      } otherwise {
        maxMinResult := Mux(aLessB, io.a, io.b)
      }
    }
  }

  val iMag = UInt(32 bits)
  iMag := Mux(io.a.msb, (-io.a.asSInt).asUInt.resize(32), io.a)
  val i2fResult = intToFp32Bits(iMag, io.a.msb)
  val u2fResult = intToFp32Bits(io.a, False)

  val intMagnitude = UInt(33 bits)
  intMagnitude := 0
  when(!decA.isNaN && !decA.isInf && !decA.isZero && decA.exp >= 0) {
    when(decA.exp >= S(23, ExpWidth bits)) {
      val leftShift = (decA.exp - S(23, ExpWidth bits)).asUInt.resize(6)
      intMagnitude := (decA.sig.resize(33) |<< leftShift).resize(33)
    } otherwise {
      val rightShift = (S(23, ExpWidth bits) - decA.exp).asUInt.resize(6)
      intMagnitude := (decA.sig |>> rightShift).resize(33)
    }
  }

  val f2iResult = UInt(32 bits)
  f2iResult := 0
  when(decA.isNaN) {
    f2iResult := 0
  } elsewhen(decA.isInf) {
    f2iResult := Mux(decA.sign, U(0x80000000L, 32 bits), U(0x7FFFFFFFL, 32 bits))
  } elsewhen(decA.isZero || decA.exp < 0) {
    f2iResult := 0
  } elsewhen(!decA.sign) {
    when(decA.exp > S(30, ExpWidth bits) || intMagnitude > U(0x7FFFFFFFL, 33 bits)) {
      f2iResult := U(0x7FFFFFFFL, 32 bits)
    } otherwise {
      f2iResult := intMagnitude(31 downto 0)
    }
  } otherwise {
    when(decA.exp > S(31, ExpWidth bits) || intMagnitude > U(0x80000000L, 33 bits)) {
      f2iResult := U(0x80000000L, 32 bits)
    } otherwise {
      f2iResult := (-intMagnitude.asSInt.resize(34)).resize(32).asUInt
    }
  }

  val f2uResult = UInt(32 bits)
  f2uResult := 0
  when(decA.isNaN) {
    f2uResult := 0
  } elsewhen(decA.isInf) {
    f2uResult := Mux(decA.sign, U(0, 32 bits), U(0xFFFFFFFFL, 32 bits))
  } elsewhen(decA.sign || decA.isZero || decA.exp < 0) {
    f2uResult := 0
  } elsewhen(decA.exp > S(31, ExpWidth bits) || intMagnitude > U(0xFFFFFFFFL, 33 bits)) {
    f2uResult := U(0xFFFFFFFFL, 32 bits)
  } otherwise {
    f2uResult := intMagnitude(31 downto 0)
  }

  val addClassResult = UInt(32 bits)
  addClassResult := addResult
  switch(io.mode) {
    is(Fp32Opcode.FADD) { addClassResult := addResult }
    is(Fp32Opcode.FSUB) { addClassResult := addResult }
    is(Fp32Opcode.FMAX) { addClassResult := maxMinResult }
    is(Fp32Opcode.FMIN) { addClassResult := maxMinResult }
    is(Fp32Opcode.I2F)  { addClassResult := i2fResult }
    is(Fp32Opcode.U2F)  { addClassResult := u2fResult }
    is(Fp32Opcode.F2I)  { addClassResult := f2iResult }
    is(Fp32Opcode.F2U)  { addClassResult := f2uResult }
  }

  val addValids = Vec(Reg(Bool()) init False, cfg.fp32AddLatency)
  val addResults = Vec(Reg(UInt(32 bits)) init 0, cfg.fp32AddLatency)
  val addTags = Vec(Reg(UInt(cfg.scratchAddrWidth bits)) init 0, cfg.fp32AddLatency)

  val mulValids = Vec(Reg(Bool()) init False, cfg.fp32MulLatency)
  val mulResults = Vec(Reg(UInt(32 bits)) init 0, cfg.fp32MulLatency)
  val mulTags = Vec(Reg(UInt(cfg.scratchAddrWidth bits)) init 0, cfg.fp32MulLatency)

  val addBusy = addValids.map(v => v).reduce(_ || _)
  val mulBusy = mulValids.map(v => v).reduce(_ || _)
  io.busy := addBusy || mulBusy
  io.done := addValids.last || mulValids.last
  io.result := Mux(mulValids.last, mulResults.last, addResults.last)
  io.tagOut := Mux(mulValids.last, mulTags.last, addTags.last)

  for (idx <- cfg.fp32AddLatency - 1 downto 1) {
    addValids(idx) := addValids(idx - 1)
    addResults(idx) := addResults(idx - 1)
    addTags(idx) := addTags(idx - 1)
  }
  addValids(0) := False

  for (idx <- cfg.fp32MulLatency - 1 downto 1) {
    mulValids(idx) := mulValids(idx - 1)
    mulResults(idx) := mulResults(idx - 1)
    mulTags(idx) := mulTags(idx - 1)
  }
  mulValids(0) := False

  when(io.fire && !io.busy) {
    when(io.mode === Fp32Opcode.FMUL) {
      mulValids(0) := True
      mulResults(0) := mulResult
      mulTags(0) := io.tagIn
    } otherwise {
      addValids(0) := True
      addResults(0) := addClassResult
      addTags(0) := io.tagIn
    }
  }
}