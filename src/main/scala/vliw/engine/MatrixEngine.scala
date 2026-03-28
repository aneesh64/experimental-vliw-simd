package vliw.engine

import spinal.core._
import vliw.bundle._
import vliw.config.VliwSocConfig
import vliw.plugin.EnginePlugin

/**
 * Matrix Engine v1 functional model.
 *
 * Fixed configuration:
 *   - 8x8 matrix shape
 *   - 8-bit matrix-local operand storage
 *   - 32-bit accumulator storage
 *   - one matrix slot may occupy the engine until completion
 *
 * Supported compute modes:
 *   - signed int8 -> int32 accumulation
 *   - FP8 E4M3 -> FP32 accumulation
 *   - FP8 E5M2 -> FP32 accumulation
 *
 * The engine is a micro-sequenced reference implementation over the dedicated
 * matrix-local memories. It prioritizes ISA/toolchain validation over PE-array
 * style throughput.
 */
class MatrixEngine(cfg: VliwSocConfig) extends Component with EnginePlugin {
  require(cfg.matrixRows == 8 && cfg.matrixCols == 8, "MatrixEngine v1 expects fixed 8x8 configuration")
  require(cfg.matrixElemBits == 8, "MatrixEngine v1 expects 8-bit matrix-local operand storage")
  require(cfg.matrixAccumBits == 32, "MatrixEngine v1 expects 32-bit accumulator storage")

  private val FpAccumBits = 72
  private val FpAccumFracBits = 32
  private val FpSigBits = 24
  private val MaxFixedToFp32RightShift = FpAccumBits - FpSigBits
  private val MaxFpProductShift = 58
  private val MaxFp32RightShift = 24

  override def engineName: String = "MAT"
  override def numScalarReadPorts: Int = 0
  override def numVectorReadGroups: Int = 0
  override def numScalarWritePorts: Int = 0
  override def numVectorWriteGroups: Int = 0
  override def usesDedicatedLocalMemory: Boolean = true

  val io = new Bundle {
    val slots = in Vec(MatrixSlot(cfg), cfg.nMatrixSlots)
    val valid = in Bool()

    val matrixScratchAAddr   = out UInt(cfg.matrixScratchAddrWidth bits)
    val matrixScratchAEn     = out Bool()
    val matrixScratchAWe     = out Bool()
    val matrixScratchAWrData = out UInt(cfg.matrixElemBits bits)
    val matrixScratchARdData = in UInt(cfg.matrixElemBits bits)

    val matrixScratchBAddr   = out UInt(cfg.matrixScratchAddrWidth bits)
    val matrixScratchBEn     = out Bool()
    val matrixScratchBWe     = out Bool()
    val matrixScratchBWrData = out UInt(cfg.matrixElemBits bits)
    val matrixScratchBRdData = in UInt(cfg.matrixElemBits bits)

    val matrixAccumAddr   = out UInt(cfg.matrixAccumAddrWidth bits)
    val matrixAccumEn     = out Bool()
    val matrixAccumWe     = out Bool()
    val matrixAccumWrData = out UInt(cfg.matrixAccumBits bits)
    val matrixAccumRdData = in UInt(cfg.matrixAccumBits bits)

    val busy        = out Bool()
    val startPulse  = out Bool()
    val activeOpcode= out UInt(SlotEncodingWidths.MatrixOpcodeBits bits)
    val countdown   = out UInt(11 bits)
  }

  object MatrixState extends SpinalEnum {
    val IDLE, ZERO, ACC_READ, ACC_LOAD, AB_READ, MAC, ACC_WRITE = newElement()
  }

  case class Fp8Decoded() extends Bundle {
    val isZero = Bool()
    val isSpecial = Bool()
    val sign = Bool()
    val sig = UInt(4 bits)
    val shift = UInt(6 bits)
  }

  def highestSetBit(value: UInt): UInt = {
    val result = UInt(log2Up(FpAccumBits) bits)
    result := 0
    for (bit <- 0 until FpAccumBits) {
      when(value(bit)) {
        result := bit
      }
    }
    result
  }

  def decodeE4M3(raw: UInt): Fp8Decoded = {
    val decoded = Fp8Decoded()
    val exp = raw(6 downto 3)
    val mant = raw(2 downto 0)

    decoded.sign := raw(7)
    decoded.isZero := exp === 0 && mant === 0
    decoded.isSpecial := exp === U(15, 4 bits) && mant === U(7, 3 bits)
    decoded.sig := 0
    decoded.shift := U(23, 6 bits)

    when(decoded.isSpecial || decoded.isZero) {
      decoded.sig := 0
    } elsewhen(exp === 0) {
      decoded.sig := mant.resize(4)
      decoded.shift := U(23, 6 bits)
    } otherwise {
      decoded.sig := (U(1, 1 bits) ## mant).asUInt.resize(4)
      decoded.shift := (exp.resize(6) + U(22, 6 bits)).resize(6)
    }

    decoded
  }

  def decodeE5M2(raw: UInt): Fp8Decoded = {
    val decoded = Fp8Decoded()
    val exp = raw(6 downto 2)
    val mant = raw(1 downto 0)

    decoded.sign := raw(7)
    decoded.isZero := exp === 0 && mant === 0
    decoded.isSpecial := exp === U(31, 5 bits)
    decoded.sig := 0
    decoded.shift := U(16, 6 bits)

    when(decoded.isSpecial || decoded.isZero) {
      decoded.sig := 0
    } elsewhen(exp === 0) {
      decoded.sig := mant.resize(4)
      decoded.shift := U(16, 6 bits)
    } otherwise {
      decoded.sig := (U(1, 2 bits) ## mant).asUInt.resize(4)
      decoded.shift := (exp.resize(6) + U(15, 6 bits)).resize(6)
    }

    decoded
  }

  def fixedContributionFromFp8(a: Fp8Decoded, b: Fp8Decoded): SInt = {
    val shiftSum = UInt(7 bits)
    shiftSum := a.shift.resize(7) + b.shift.resize(7)
    val productShift = (shiftSum - U(FpAccumFracBits, 7 bits)).resize(6)
    val sigProduct = (a.sig.resize(8) * b.sig.resize(8)).resize(8)
    val magnitude = UInt(FpAccumBits bits)
    magnitude := 0

    when(!a.isZero && !b.isZero) {
      for (shift <- 0 to MaxFpProductShift) {
        when(productShift === U(shift, 6 bits)) {
          magnitude := (sigProduct.resize(FpAccumBits) << shift).resize(FpAccumBits)
        }
      }
    }

    val signed = SInt(FpAccumBits bits)
    signed := magnitude.asSInt
    when(a.sign ^ b.sign) {
      signed := -magnitude.asSInt
    }
    signed
  }

  def fixedQ32ToFp32Bits(value: SInt): UInt = {
    val result = UInt(32 bits)
    result := 0

    val sign = value.msb
    val magnitude = UInt(FpAccumBits bits)
    magnitude := 0
    when(sign) {
      magnitude := (-value).asUInt.resize(FpAccumBits)
    } otherwise {
      magnitude := value.asUInt.resize(FpAccumBits)
    }

    val msbIndex = highestSetBit(magnitude)
    val shiftRight = UInt(6 bits)
    shiftRight := 0
    when(msbIndex > U(FpSigBits - 1, msbIndex.getWidth bits)) {
      shiftRight := (msbIndex - U(FpSigBits - 1, msbIndex.getWidth bits)).resize(6)
    }

    val shiftLeft = UInt(5 bits)
    shiftLeft := 0
    when(msbIndex <= U(FpSigBits - 1, msbIndex.getWidth bits)) {
      shiftLeft := (U(FpSigBits - 1, msbIndex.getWidth bits) - msbIndex).resize(5)
    }

    val sigBase = UInt(FpSigBits bits)
    sigBase := 0
    val guard = Bool()
    guard := False
    val sticky = Bool()
    sticky := False

    when(magnitude =/= 0) {
      when(msbIndex <= U(FpSigBits - 1, msbIndex.getWidth bits)) {
        for (shift <- 0 until FpSigBits) {
          when(shiftLeft === U(shift, shiftLeft.getWidth bits)) {
            sigBase := (magnitude.resize(FpSigBits) << shift).resize(FpSigBits)
          }
        }
      } otherwise {
        when(shiftRight === 0) {
          sigBase := magnitude(FpSigBits - 1 downto 0)
        }
        for (shift <- 1 to MaxFixedToFp32RightShift) {
          when(shiftRight === U(shift, shiftRight.getWidth bits)) {
            sigBase := (magnitude >> shift).resize(FpSigBits)
            guard := magnitude(shift - 1)
            if (shift > 1) {
              sticky := magnitude(shift - 2 downto 0).orR
            }
          }
        }
      }

      val roundUp = guard && (sticky || sigBase(0))
      val roundedSig = UInt((FpSigBits + 1) bits)
      roundedSig := sigBase.resize(FpSigBits + 1) + roundUp.asUInt.resize(FpSigBits + 1)

      val expBase = (msbIndex.resize(8 bits) + U(95, 8 bits)).resize(8)
      val expOut = UInt(8 bits)
      expOut := expBase
      val sigOut = UInt(FpSigBits bits)
      sigOut := roundedSig(FpSigBits - 1 downto 0)

      when(roundedSig(FpSigBits)) {
        sigOut := (roundedSig >> 1).resize(FpSigBits)
        expOut := expBase + 1
      }

      result := (sign.asBits ## expOut.asBits ## sigOut(FpSigBits - 2 downto 0).asBits).asUInt
    }

    result
  }

  def fp32BitsToFixedQ32(raw: UInt): SInt = {
    val sign = raw(31)
    val exp = raw(30 downto 23)
    val mant = raw(22 downto 0)
    val magnitude = UInt(FpAccumBits bits)
    magnitude := 0

    when(exp === 0) {
      assert(mant === 0, "MatrixEngine FP32 accumulator seed must not be subnormal in v1")
    } elsewhen(exp === U(255, 8 bits)) {
      assert(False, "MatrixEngine FP32 accumulator seed must be finite in v1")
    } otherwise {
      val sig = (U(1, 1 bits) ## mant).asUInt
      when(exp >= U(118, 8 bits)) {
        val leftShift = (exp - U(118, 8 bits)).resize(6)
        assert(leftShift <= U(FpAccumBits - FpSigBits, leftShift.getWidth bits),
          "MatrixEngine FP32 accumulator seed exceeds v1 fixed-point range")
        for (shift <- 0 to (FpAccumBits - FpSigBits)) {
          when(leftShift === U(shift, leftShift.getWidth bits)) {
            magnitude := (sig.resize(FpAccumBits) << shift).resize(FpAccumBits)
          }
        }
      } otherwise {
        val rightShiftFull = (U(118, 8 bits) - exp).resize(8)
        when(rightShiftFull > U(MaxFp32RightShift, 8 bits)) {
          magnitude := 0
        } otherwise {
          val rightShift = rightShiftFull.resize(5)
          when(rightShift === 0) {
            magnitude := sig.resize(FpAccumBits)
          }
          for (shift <- 1 to MaxFp32RightShift) {
            when(rightShift === U(shift, rightShift.getWidth bits)) {
              val shifted = (sig >> shift).resize(FpAccumBits)
              val guard = sig(shift - 1)
              val sticky = if (shift > 1) sig(shift - 2 downto 0).orR else False
              val roundUp = guard && (sticky || shifted(0))
              magnitude := shifted + roundUp.asUInt.resize(FpAccumBits)
            }
          }
        }
      }
    }

    val signed = SInt(FpAccumBits bits)
    signed := magnitude.asSInt
    when(sign) {
      signed := -magnitude.asSInt
    }
    signed
  }

  val state = RegInit(MatrixState.IDLE)
  val activeOpcodeReg = Reg(UInt(SlotEncodingWidths.MatrixOpcodeBits bits)) init MatrixOpcode.NOP
  val localBaseReg = Reg(UInt(cfg.matrixAccumAddrWidth bits)) init 0
  val totalElemsReg = Reg(UInt(7 bits)) init 0
  val operandABaseReg = Reg(UInt(cfg.matrixScratchAddrWidth bits)) init 0
  val operandBBaseReg = Reg(UInt(cfg.matrixScratchAddrWidth bits)) init 0
  val rowReg = Reg(UInt(3 bits)) init 0
  val colReg = Reg(UInt(3 bits)) init 0
  val kReg = Reg(UInt(3 bits)) init 0
  val accReg = Reg(SInt(cfg.matrixAccumBits bits)) init 0
  val fpAccReg = Reg(SInt(FpAccumBits bits)) init 0
  val debugCounter = Reg(UInt(11 bits)) init 0
  val issueSeenReg = RegInit(False)

  val hasSlot = cfg.nMatrixSlots > 0
  val slotValid = if (hasSlot) io.valid && io.slots(0).valid else False
  val slotOpcode = if (hasSlot) io.slots(0).opcode else MatrixOpcode.NOP
  val slotDest = if (hasSlot) io.slots(0).dest else U(0, cfg.scratchAddrWidth bits)
  val slotSrcA = if (hasSlot) io.slots(0).srcA else U(0, cfg.scratchAddrWidth bits)
  val slotSrcB = if (hasSlot) io.slots(0).srcB else U(0, cfg.scratchAddrWidth bits)
  val slotTileElems = if (hasSlot) (io.slots(0).tileRows * io.slots(0).tileCols).resize(7) else U(0, 7 bits)
  when(!slotValid) {
    issueSeenReg := False
  }

  val startsCompute = slotValid && !issueSeenReg && state === MatrixState.IDLE &&
    MatrixOpcode.isCompute(slotOpcode)
  val startsZero = slotValid && !issueSeenReg && state === MatrixState.IDLE && slotOpcode === MatrixOpcode.MZERO
  val activeUsesFp8 = MatrixOpcode.isFp8(activeOpcodeReg)
  val activeUsesFp8E5M2 = MatrixOpcode.isFp8E5M2(activeOpcodeReg)
  val activeAccumulates = MatrixOpcode.isAccumulate(activeOpcodeReg)

  io.matrixScratchAAddr := 0
  io.matrixScratchAEn := False
  io.matrixScratchAWe := False
  io.matrixScratchAWrData := 0
  io.matrixScratchBAddr := 0
  io.matrixScratchBEn := False
  io.matrixScratchBWe := False
  io.matrixScratchBWrData := 0
  io.matrixAccumAddr := 0
  io.matrixAccumEn := False
  io.matrixAccumWe := False
  io.matrixAccumWrData := 0

  val outputIndex = ((rowReg.resize(cfg.matrixAccumAddrWidth) * U(cfg.matrixCols, cfg.matrixAccumAddrWidth bits)) +
    colReg.resize(cfg.matrixAccumAddrWidth)).resize(cfg.matrixAccumAddrWidth)
  val aIndex = ((rowReg.resize(cfg.matrixScratchAddrWidth) * U(cfg.matrixCols, cfg.matrixScratchAddrWidth bits)) +
    kReg.resize(cfg.matrixScratchAddrWidth)).resize(cfg.matrixScratchAddrWidth)
  val bIndex = ((kReg.resize(cfg.matrixScratchAddrWidth) * U(cfg.matrixCols, cfg.matrixScratchAddrWidth bits)) +
    colReg.resize(cfg.matrixScratchAddrWidth)).resize(cfg.matrixScratchAddrWidth)
  val aValue = io.matrixScratchARdData.asSInt.resize(cfg.matrixAccumBits)
  val bValue = io.matrixScratchBRdData.asSInt.resize(cfg.matrixAccumBits)
  val product = (aValue * bValue).resize(cfg.matrixAccumBits)
  val fpA_E4M3 = decodeE4M3(io.matrixScratchARdData)
  val fpB_E4M3 = decodeE4M3(io.matrixScratchBRdData)
  val fpA_E5M2 = decodeE5M2(io.matrixScratchARdData)
  val fpB_E5M2 = decodeE5M2(io.matrixScratchBRdData)
  val fpProductE4M3 = fixedContributionFromFp8(fpA_E4M3, fpB_E4M3)
  val fpProductE5M2 = fixedContributionFromFp8(fpA_E5M2, fpB_E5M2)
  val fpProduct = SInt(FpAccumBits bits)
  fpProduct := Mux(activeUsesFp8E5M2, fpProductE5M2, fpProductE4M3)
  val fpProductHasSpecial = Mux(activeUsesFp8E5M2,
    fpA_E5M2.isSpecial || fpB_E5M2.isSpecial,
    fpA_E4M3.isSpecial || fpB_E4M3.isSpecial
  )
  val roundedFpAcc = fp32BitsToFixedQ32(fixedQ32ToFp32Bits(fpAccReg))

  when(state === MatrixState.IDLE) {
    debugCounter := 0
  }

  when(startsCompute) {
    issueSeenReg := True
    activeOpcodeReg := slotOpcode
    localBaseReg := slotDest.resize(cfg.matrixAccumAddrWidth)
    operandABaseReg := slotSrcA.resize(cfg.matrixScratchAddrWidth)
    operandBBaseReg := slotSrcB.resize(cfg.matrixScratchAddrWidth)
    totalElemsReg := slotTileElems
    rowReg := 0
    colReg := 0
    kReg := 0
    debugCounter := 0
    when(MatrixOpcode.isAccumulate(slotOpcode)) {
      state := MatrixState.ACC_READ
    } otherwise {
      when(MatrixOpcode.isFp8(slotOpcode)) {
        fpAccReg := 0
      } otherwise {
        accReg := 0
      }
      state := MatrixState.AB_READ
    }
  } elsewhen(startsZero) {
    issueSeenReg := True
    activeOpcodeReg := slotOpcode
    localBaseReg := slotDest.resize(cfg.matrixAccumAddrWidth)
    totalElemsReg := slotTileElems
    debugCounter := slotTileElems.resize(11)
    when(slotTileElems === 0) {
      activeOpcodeReg := MatrixOpcode.NOP
      state := MatrixState.IDLE
    } otherwise {
      state := MatrixState.ZERO
    }
  }

  switch(state) {
    is(MatrixState.ZERO) {
      val zeroIndex = (totalElemsReg.resize(cfg.matrixAccumAddrWidth) - debugCounter.resize(cfg.matrixAccumAddrWidth)).resize(cfg.matrixAccumAddrWidth)
      io.matrixAccumAddr := (localBaseReg + zeroIndex).resize(cfg.matrixAccumAddrWidth)
      io.matrixAccumEn := True
      io.matrixAccumWe := True
      io.matrixAccumWrData := 0

      when(debugCounter === 1) {
        activeOpcodeReg := MatrixOpcode.NOP
        debugCounter := 0
        state := MatrixState.IDLE
      } otherwise {
        debugCounter := debugCounter - 1
      }
    }

    is(MatrixState.ACC_READ) {
      io.matrixAccumAddr := (localBaseReg + outputIndex).resize(cfg.matrixAccumAddrWidth)
      io.matrixAccumEn := True
      io.matrixAccumWe := False
      debugCounter := kReg.resize(11)
      state := MatrixState.ACC_LOAD
    }

    is(MatrixState.ACC_LOAD) {
      when(activeUsesFp8) {
        fpAccReg := fp32BitsToFixedQ32(io.matrixAccumRdData)
      } otherwise {
        accReg := io.matrixAccumRdData.asSInt
      }
      kReg := 0
      debugCounter := 0
      state := MatrixState.AB_READ
    }

    is(MatrixState.AB_READ) {
      io.matrixScratchAAddr := (operandABaseReg + aIndex).resize(cfg.matrixScratchAddrWidth)
      io.matrixScratchAEn := True
      io.matrixScratchAWe := False
      io.matrixScratchBAddr := (operandBBaseReg + bIndex).resize(cfg.matrixScratchAddrWidth)
      io.matrixScratchBEn := True
      io.matrixScratchBWe := False
      debugCounter := kReg.resize(11)
      state := MatrixState.MAC
    }

    is(MatrixState.MAC) {
      when(activeUsesFp8) {
        assert(!fpProductHasSpecial, "MatrixEngine FP8 compute expects finite inputs in v1")
        fpAccReg := roundedFpAcc + fpProduct
      } otherwise {
        accReg := accReg + product
      }
      debugCounter := kReg.resize(11)
      when(kReg === U(cfg.matrixCols - 1, 3 bits)) {
        state := MatrixState.ACC_WRITE
      } otherwise {
        kReg := kReg + 1
        state := MatrixState.AB_READ
      }
    }

    is(MatrixState.ACC_WRITE) {
      io.matrixAccumAddr := (localBaseReg + outputIndex).resize(cfg.matrixAccumAddrWidth)
      io.matrixAccumEn := True
      io.matrixAccumWe := True
      when(activeUsesFp8) {
        io.matrixAccumWrData := fixedQ32ToFp32Bits(fpAccReg)
      } otherwise {
        io.matrixAccumWrData := accReg.asUInt
      }

      when(rowReg === U(cfg.matrixRows - 1, 3 bits) && colReg === U(cfg.matrixCols - 1, 3 bits)) {
        activeOpcodeReg := MatrixOpcode.NOP
        debugCounter := 0
        state := MatrixState.IDLE
      } otherwise {
        when(colReg === U(cfg.matrixCols - 1, 3 bits)) {
          colReg := 0
          rowReg := rowReg + 1
        } otherwise {
          colReg := colReg + 1
        }
        kReg := 0
        when(activeAccumulates) {
          state := MatrixState.ACC_READ
        } otherwise {
          when(activeUsesFp8) {
            fpAccReg := 0
          } otherwise {
            accReg := 0
          }
          state := MatrixState.AB_READ
        }
      }
    }
  }

  io.busy := state =/= MatrixState.IDLE
  io.startPulse := startsCompute || startsZero
  io.activeOpcode := activeOpcodeReg
  io.countdown := debugCounter
}
