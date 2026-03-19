package vliw.engine

import spinal.core._
import vliw.bundle._
import vliw.config.VliwSocConfig
import vliw.plugin.EnginePlugin

/**
 * Matrix Engine v1 skeleton.
 *
 * Fixed configuration:
 *   - 8x8 systolic array
 *   - int8 inputs
 *   - int32 accumulation
 *   - one matrix slot may occupy the engine until completion
 *
 * v1 uses a functional micro-sequencer over matrix-local memories so the
 * compiler, memory paths, and accumulator behavior can be validated before a
 * real PE array replaces this implementation.
 */
class MatrixEngine(cfg: VliwSocConfig) extends Component with EnginePlugin {
  require(cfg.matrixRows == 8 && cfg.matrixCols == 8, "MatrixEngine v1 expects fixed 8x8 configuration")
  require(cfg.matrixElemBits == 8, "MatrixEngine v1 expects int8 inputs")
  require(cfg.matrixAccumBits == 32, "MatrixEngine v1 expects int32 accumulation")

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
    (slotOpcode === MatrixOpcode.MCOMPUTE || slotOpcode === MatrixOpcode.MCOMPUTE_ACC)
  val startsZero = slotValid && !issueSeenReg && state === MatrixState.IDLE && slotOpcode === MatrixOpcode.MZERO

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
    when(slotOpcode === MatrixOpcode.MCOMPUTE_ACC) {
      state := MatrixState.ACC_READ
    } otherwise {
      accReg := 0
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
      accReg := io.matrixAccumRdData.asSInt
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
      accReg := accReg + product
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
      io.matrixAccumWrData := accReg.asUInt

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
        when(activeOpcodeReg === MatrixOpcode.MCOMPUTE_ACC) {
          state := MatrixState.ACC_READ
        } otherwise {
          accReg := 0
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