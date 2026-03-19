package vliw.core

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import vliw.config.VliwSocConfig
import vliw.bundle._
import vliw.engine._
import vliw.memory._

/**
 * VLIW Core — single processor core with 3-stage pipeline.
 *
 * Stage 1 (IF):  PC → IMEM read; decode bundle; present scratch read addresses
 * Stage 2 (EX):  BRAM read data available; engines compute results
 * Stage 3 (WB):  Write computed results back to scratch (registered)
 *
 * Architecture:
 *   FetchUnit → InstructionMemory → DecodeUnit → Engines → WB Registers → WritebackController → BankedScratchMemory
 *
 * Write forwarding: WB writes at cycle T, EX reads at cycle T → bypass detects
 * match and forwards data. Enables NORMAL_LATENCY=1 in the scheduler.
 *
 * Memory load/vload results arrive asynchronously from the FIFO-based MemoryEngine
 * and bypass the WB pipeline registers (written to scratch directly).
 */
class VliwCore(cfg: VliwSocConfig, coreId: Int) extends Component {
  val io = new Bundle {
    // Instruction memory write (host loading)
    val imemWrite = slave(Flow(ImemWriteCmd(cfg)))

    // Data memory AXI4 master
    val dmemAxi = master(Axi4(cfg.axiConfig))

    // Control
    val start   = in Bool()
    val halted  = out Bool()
    val running = out Bool()
    val pc      = out UInt(cfg.imemAddrWidth bits)

    // Debug
    val wawConflict = out Bool()
    val cycleCount  = out UInt(32 bits)
  }

  // ======================== Module instantiation ========================

  val imem     = new InstructionMemory(cfg)
  val fetch    = new FetchUnit(cfg)
  val decode   = new DecodeUnit(cfg)
  val scratch  = new BankedScratchMemory(cfg)
  val matrixScratchA = new MatrixScratchpad(cfg)
  val matrixScratchB = new MatrixScratchpad(cfg)
  val matrixAccum = new MatrixAccumulatorMemory(cfg)
  val alu      = new AluEngine(cfg)
  val valu     = new ValuEngine(cfg)
  val matrix   = new MatrixEngine(cfg)
  val flow     = new FlowEngine(cfg, coreId)
  val mem      = new MemoryEngine(cfg)
  val wb       = new WritebackController(cfg)

  // ======================== Cycle counter ========================

  val cycleCounter = Reg(UInt(32 bits)) init 0
  when(fetch.io.running) { cycleCounter := cycleCounter + 1 }
  io.cycleCount := cycleCounter

  // ======================== IF stage wiring ========================

  // IMEM write from host
  imem.io.write << io.imemWrite

  // Fetch → IMEM
  imem.io.fetchAddr := fetch.io.imemAddr
  fetch.io.imemData := imem.io.fetchData

  // Fetch control
  fetch.io.start := io.start

  // ======================== EX stage: decode ========================

  decode.io.bundle := fetch.io.exBundle
  decode.io.valid  := fetch.io.exValid
  // start of EX (next cycle after address presentation).
  //
  // exSlotsReg registers the decoded slots to align with BRAM read data.
  // Engines in EX compute using the registered slots and BRAM read data.
  // Results are captured into WB pipeline registers for writeback next cycle.

  // ---- ALU scratch reads: 2 per slot (src1, src2) ----
  var scalarReadIdx = 0

  for (i <- 0 until cfg.nAluSlots) {
    scratch.io.scalarReadAddr(scalarReadIdx) := decode.io.aluSlots(i).src1
    scratch.io.scalarReadEn(scalarReadIdx)   := decode.io.aluSlots(i).valid
    scalarReadIdx += 1

    scratch.io.scalarReadAddr(scalarReadIdx) := decode.io.aluSlots(i).src2
    scratch.io.scalarReadEn(scalarReadIdx)   := decode.io.aluSlots(i).valid
    scalarReadIdx += 1
  }

  // ---- Load scratch reads: 1 per slot (addrReg) ----
  // CONST opcode doesn't use addrReg (it writes an immediate to dest),
  // so suppress the read enable to avoid unnecessary bank conflicts.
  for (i <- 0 until cfg.nLoadSlots) {
    val lslot = decode.io.loadSlots(i)
    val needsAddrRead = lslot.valid && (lslot.opcode =/= LoadOpcode.CONST)
    scratch.io.scalarReadAddr(scalarReadIdx) := lslot.addrReg
    scratch.io.scalarReadEn(scalarReadIdx)   := needsAddrRead
    scalarReadIdx += 1
  }

  // Hold store source controls while memory engine stalls so scalar/vector
  // store operand addressing remains stable for replayed or multi-cycle stores.
  val storeValidHeld   = Vec(Reg(Bool()) init False, cfg.nStoreSlots)
  val storeOpcodeHeld  = Vec(Reg(UInt(SlotEncodingWidths.StoreOpcodeBits bits)) init StoreOpcode.STORE, cfg.nStoreSlots)
  val storeAddrRegHeld = Vec(Reg(UInt(cfg.scratchAddrWidth bits)) init 0, cfg.nStoreSlots)
  val storeSrcRegHeld  = Vec(Reg(UInt(cfg.scratchAddrWidth bits)) init 0, cfg.nStoreSlots)

  when(!mem.io.stall) {
    for (i <- 0 until cfg.nStoreSlots) {
      storeValidHeld(i)   := decode.io.storeSlots(i).valid
      storeOpcodeHeld(i)  := decode.io.storeSlots(i).opcode
      storeAddrRegHeld(i) := decode.io.storeSlots(i).addrReg
      storeSrcRegHeld(i)  := decode.io.storeSlots(i).srcReg
    }
  }

  // ---- Store scratch reads: 2 per slot (addrReg, srcReg) ----
  for (i <- 0 until cfg.nStoreSlots) {
    val sslot = decode.io.storeSlots(i)
    val slotValid = Mux(mem.io.stall, storeValidHeld(i), sslot.valid)
    val slotOpcode = Mux(mem.io.stall, storeOpcodeHeld(i), sslot.opcode)
    val slotAddrReg = Mux(mem.io.stall, storeAddrRegHeld(i), sslot.addrReg)
    val slotSrcReg = Mux(mem.io.stall, storeSrcRegHeld(i), sslot.srcReg)
    scratch.io.scalarReadAddr(scalarReadIdx) := slotAddrReg
    scratch.io.scalarReadEn(scalarReadIdx)   := slotValid
    scalarReadIdx += 1

    scratch.io.scalarReadAddr(scalarReadIdx) := slotSrcReg
    scratch.io.scalarReadEn(scalarReadIdx)   := slotValid && (slotOpcode === StoreOpcode.STORE)
    scalarReadIdx += 1
  }

  // ---- Flow scratch reads: gate enables by opcode to avoid unnecessary bank conflicts ----
  // Port 0 (operandA → operandCond): SELECT, VSELECT, ADD_IMM, COND_JUMP, COND_JUMP_REL, JUMP_INDIRECT
  // Port 1 (operandB → operandA):    SELECT, VSELECT
  // Port 2 (immediate → operandB):   SELECT, VSELECT
  {
    val fv = decode.io.flowSlot.valid
    val op = decode.io.flowSlot.opcode

    val needsCond = fv && (op === FlowOpcode.SELECT || op === FlowOpcode.VSELECT ||
                           op === FlowOpcode.ADD_IMM || op === FlowOpcode.COND_JUMP ||
                           op === FlowOpcode.COND_JUMP_REL || op === FlowOpcode.JUMP_INDIRECT)
    val needsSrcA = fv && (op === FlowOpcode.SELECT || op === FlowOpcode.VSELECT)
    val needsSrcB = fv && (op === FlowOpcode.SELECT || op === FlowOpcode.VSELECT)

    scratch.io.scalarReadAddr(scalarReadIdx) := decode.io.flowSlot.operandA
    scratch.io.scalarReadEn(scalarReadIdx)   := needsCond
    scalarReadIdx += 1

    scratch.io.scalarReadAddr(scalarReadIdx) := decode.io.flowSlot.operandB
    scratch.io.scalarReadEn(scalarReadIdx)   := needsSrcA
    scalarReadIdx += 1

    // srcB for select: stored in immediate field, but used as scratch addr
    scratch.io.scalarReadAddr(scalarReadIdx) := decode.io.flowSlot.immediate.resize(cfg.scratchAddrWidth)
    scratch.io.scalarReadEn(scalarReadIdx)   := needsSrcB
    scalarReadIdx += 1
  }

  // ---- VALU src3 scalar read (1 per VALU slot — for vbroadcast) ----
  for (s <- 0 until cfg.nValuSlots) {
    scratch.io.scalarReadAddr(scalarReadIdx) := decode.io.valuSlots(s).src3Base
    scratch.io.scalarReadEn(scalarReadIdx)   := decode.io.valuSlots(s).valid
    scalarReadIdx += 1
  }

  // ---- VALU active flag ----
  // Vector read groups are multiplexed between:
  //   - VALU src1/src2 reads (when any VALU slot is valid)
  //   - VSTORE source vector reads (when VALU is idle)
  val valuActiveDecode = decode.io.valuSlots.map(_.valid).reduce(_ || _)
  val vstoreVectorReadActiveDecode = (0 until cfg.nStoreSlots).map { i =>
    val slotValid = Mux(mem.io.stall, storeValidHeld(i), decode.io.storeSlots(i).valid)
    val slotIsVstore = Mux(mem.io.stall, storeOpcodeHeld(i) === StoreOpcode.VSTORE, decode.io.storeSlots(i).opcode === StoreOpcode.VSTORE)
    slotValid && slotIsVstore
  }.reduce(_ || _)
  scratch.io.valuActive       := valuActiveDecode
  scratch.io.vectorReadActive := valuActiveDecode || vstoreVectorReadActiveDecode
  scratch.io.blockScalarReads := valuActiveDecode

  // Default vector read groups to disabled
  for (g <- 0 until cfg.nValuSlots * 2) {
    for (lane <- 0 until cfg.vlen) {
      scratch.io.valuReadAddr(g)(lane) := 0
      scratch.io.valuReadEn(g)(lane)   := False
    }
  }

  // ---- VALU vector reads (src1 and src2, each VLEN lanes) ----
  when(valuActiveDecode) {
    for (s <- 0 until cfg.nValuSlots) {
      // src1: group index = s * 2
      for (lane <- 0 until cfg.vlen) {
        scratch.io.valuReadAddr(s * 2)(lane) :=
          (decode.io.valuSlots(s).src1Base + lane).resize(cfg.scratchAddrWidth)
        scratch.io.valuReadEn(s * 2)(lane) := decode.io.valuSlots(s).valid
      }
      // src2: group index = s * 2 + 1
      for (lane <- 0 until cfg.vlen) {
        scratch.io.valuReadAddr(s * 2 + 1)(lane) :=
          (decode.io.valuSlots(s).src2Base + lane).resize(cfg.scratchAddrWidth)
        scratch.io.valuReadEn(s * 2 + 1)(lane) := decode.io.valuSlots(s).valid
      }
    }
  } otherwise {
    // When VALU is idle, reuse vector read groups for VSTORE source lanes.
    // Use odd groups (Port B) so scalar store address reads can continue on Port A.
    for (i <- 0 until cfg.nStoreSlots) {
      val groupIdx = (i * 2 + 1) % (cfg.nValuSlots * 2)
      val slotValid = Mux(mem.io.stall, storeValidHeld(i), decode.io.storeSlots(i).valid)
      val slotIsVstore = Mux(mem.io.stall, storeOpcodeHeld(i) === StoreOpcode.VSTORE, decode.io.storeSlots(i).opcode === StoreOpcode.VSTORE)
      val slotSrcReg = Mux(mem.io.stall, storeSrcRegHeld(i), decode.io.storeSlots(i).srcReg)
      when(slotValid && slotIsVstore) {
        for (lane <- 0 until cfg.vlen) {
          scratch.io.valuReadAddr(groupIdx)(lane) :=
            (slotSrcReg + lane).resize(cfg.scratchAddrWidth)
          scratch.io.valuReadEn(groupIdx)(lane) := True
        }
      }
    }
  }

  // ======================== Pipeline register for operand data ========================
  // BRAM reads are synchronous: address presented this cycle, data available next cycle.
  // We register the decoded slots and valid signal to align with read data.

  val exSlotsReg = new Area {
    val valid     = RegNext(fetch.io.exValid) init False
    val aluSlots  = Vec(Reg(AluSlot(cfg)), cfg.nAluSlots)
    val valuSlots = Vec(Reg(ValuSlot(cfg)), cfg.nValuSlots)
    val loadSlots = Vec(Reg(LoadSlot(cfg)), cfg.nLoadSlots)
    val storeSlots= Vec(Reg(StoreSlot(cfg)), cfg.nStoreSlots)
    val matrixSlots = Vec(Reg(MatrixSlot(cfg)), cfg.nMatrixSlots)
    val flowSlot  = Reg(FlowSlot(cfg))
    val pc        = RegNext(fetch.io.pc) init 0

    for (i <- 0 until cfg.nAluSlots)  aluSlots(i)  := decode.io.aluSlots(i)
    for (i <- 0 until cfg.nValuSlots) valuSlots(i) := decode.io.valuSlots(i)
    for (i <- 0 until cfg.nLoadSlots) loadSlots(i) := decode.io.loadSlots(i)
    for (i <- 0 until cfg.nStoreSlots) storeSlots(i) := decode.io.storeSlots(i)
    for (i <- 0 until cfg.nMatrixSlots) matrixSlots(i) := decode.io.matrixSlots(i)
    flowSlot := decode.io.flowSlot
  }

  // ======================== Decode-time load-use hazard detection ========================
  // REMOVED: Hardware load-use hazard detection has been replaced by software-managed
  // hazard avoidance. The scheduler now inserts WAIT_FOR_LOAD barriers before any
  // instruction that consumes a pending load result. The MemoryEngine stalls the
  // pipeline when WAIT_FOR_LOAD is issued while a load is still pending.
  // This simplifies the hardware significantly by eliminating combinatorial
  // dependency checking across all engine slots.

  // Software-managed hazard avoidance: no hardware load-use detection needed.
  // The WAIT_FOR_LOAD instruction in the load slot stalls the pipeline via
  // mem.io.stall until all pending loads have completed.

  val decodeHasMatrixOp = if (cfg.nMatrixSlots > 0) {
    decode.io.matrixSlots.map(_.valid).reduce(_ || _)
  } else {
    False
  }
  val matrixLoadWaitStall = mem.io.matrixTransferBusy &&
    mem.io.matrixTransferBypassable && decodeHasMatrixOp
  val matrixTransferStall = mem.io.matrixTransferBusy && !mem.io.matrixTransferBypassable

  // When stalled, hold ALL pipeline registers (not just valid).
  // Without this, the next instruction's decode output leaks into
  // exSlotsReg during stall, causing premature execution of the
  // following instruction (e.g., HALT fires before STORE completes).
  // Pipeline stall covers memory backpressure, long-latency matrix compute,
  // outbound matrix stores, which must drain before later work proceeds.
  val pipelineStall = mem.io.stall || matrix.io.busy || matrixTransferStall

  // Hold EX registers on pipeline stalls.
  // Software-managed hazard avoidance: WAIT_FOR_LOAD stalls via mem.io.stall,
  // so no EX-side load-use hazard detection is needed.
  val exStageHold = pipelineStall
  when(exStageHold) {
    exSlotsReg.valid := exSlotsReg.valid  // hold
    for (i <- 0 until cfg.nAluSlots)   exSlotsReg.aluSlots(i)   := exSlotsReg.aluSlots(i)
    for (i <- 0 until cfg.nValuSlots)  exSlotsReg.valuSlots(i)  := exSlotsReg.valuSlots(i)
    for (i <- 0 until cfg.nLoadSlots)  exSlotsReg.loadSlots(i)  := exSlotsReg.loadSlots(i)
    for (i <- 0 until cfg.nStoreSlots) exSlotsReg.storeSlots(i) := exSlotsReg.storeSlots(i)
    for (i <- 0 until cfg.nMatrixSlots) exSlotsReg.matrixSlots(i) := exSlotsReg.matrixSlots(i)
    exSlotsReg.flowSlot := exSlotsReg.flowSlot
    exSlotsReg.pc       := exSlotsReg.pc
  }

  // When an EX bundle is held, the decode stage may already have advanced to a
  // different instruction. Snapshot the aligned scratch read data on the first
  // hold cycle so the resumed EX bundle executes with its original operands.
  val scalarOperandCount = cfg.scalarReadPorts + cfg.nValuSlots
  val heldScalarReadData = Vec(Reg(UInt(cfg.dataWidth bits)) init 0, scalarOperandCount)
  val heldValuReadData = Vec(Vec(Reg(UInt(cfg.dataWidth bits)) init 0, cfg.vlen), cfg.nValuSlots * 2)
  val heldReadDataValid = RegInit(False)
  val prevExStageHold = RegNext(exStageHold) init False

  when(exStageHold && !prevExStageHold) {
    for (i <- 0 until scalarOperandCount) {
      heldScalarReadData(i) := scratch.io.scalarReadData(i)
    }
    for (g <- 0 until cfg.nValuSlots * 2) {
      for (lane <- 0 until cfg.vlen) {
        heldValuReadData(g)(lane) := scratch.io.valuReadData(g)(lane)
      }
    }
    heldReadDataValid := exSlotsReg.valid
  } elsewhen(!exStageHold && heldReadDataValid && exSlotsReg.valid) {
    heldReadDataValid := False
  }

  // NOTE: Hardware load-use hazard bubble injection removed.
  // Software WAIT_FOR_LOAD instruction now handles load-use dependencies.

  // Inbound matrix loads are allowed to overlap unrelated bundles, but the
  // first later matrix bundle must wait in fetch/decode until the matrix-local
  // scratchpad has been filled. Bubble EX so that bundle enters with fresh
  // operand reads once the transfer completes.
  when(matrixLoadWaitStall && !pipelineStall) {
    exSlotsReg.valid := False
    for (i <- 0 until cfg.nAluSlots)   exSlotsReg.aluSlots(i).valid := False
    for (i <- 0 until cfg.nValuSlots)  exSlotsReg.valuSlots(i).valid := False
    for (i <- 0 until cfg.nLoadSlots)  exSlotsReg.loadSlots(i).valid := False
    for (i <- 0 until cfg.nStoreSlots) exSlotsReg.storeSlots(i).valid := False
    for (i <- 0 until cfg.nMatrixSlots) exSlotsReg.matrixSlots(i).valid := False
    exSlotsReg.flowSlot.valid := False
  }

  // Matrix operations are long-latency resources driven from EX.
  // Once a matrix compute or direct matrix transfer starts, consume the EX
  // slot immediately so the same bundle cannot re-fire when the busy window
  // eventually clears.
  when(matrix.io.startPulse || mem.io.matrixTransferStartPulse) {
    exSlotsReg.valid := False
    for (i <- 0 until cfg.nAluSlots)   exSlotsReg.aluSlots(i).valid := False
    for (i <- 0 until cfg.nValuSlots)  exSlotsReg.valuSlots(i).valid := False
    for (i <- 0 until cfg.nLoadSlots)  exSlotsReg.loadSlots(i).valid := False
    for (i <- 0 until cfg.nStoreSlots) exSlotsReg.storeSlots(i).valid := False
    for (i <- 0 until cfg.nMatrixSlots) exSlotsReg.matrixSlots(i).valid := False
    exSlotsReg.flowSlot.valid := False
  }

  // ======================== Engine data wiring (EX stage) ========================
  // BRAM read data is now available (1 cycle after address was presented)

  // 3-stage pipeline: engines fire in EX when valid and not stalled.
  // Stall directly gates engine firing — no suppressRefire needed.
  // When stall clears, the held instruction fires exactly once because
  // exSlotsReg advances to the next instruction on the following clock edge.
  // The blanket scalarStorePending stall has been removed; HALT waits for
  // stores via fetch.io.memBusy independently.
  // Scratch bank conflicts can block the current cycle's operand reads. Hold the
  // EX bundle and suppress data-consuming engines until the read ports are clear.
  val vectorBankConflictStall = scratch.io.vectorBankConflict
  val scratchBankConflictStall = vectorBankConflictStall || scratch.io.scalarBankConflict
  when(scratchBankConflictStall && !pipelineStall) {
    exSlotsReg.valid := False
    for (i <- 0 until cfg.nAluSlots)   exSlotsReg.aluSlots(i).valid := False
    for (i <- 0 until cfg.nValuSlots)  exSlotsReg.valuSlots(i).valid := False
    for (i <- 0 until cfg.nLoadSlots)  exSlotsReg.loadSlots(i).valid := False
    for (i <- 0 until cfg.nStoreSlots) exSlotsReg.storeSlots(i).valid := False
    for (i <- 0 until cfg.nMatrixSlots) exSlotsReg.matrixSlots(i).valid := False
    exSlotsReg.flowSlot.valid := False
  }

  val engineFireValid = exSlotsReg.valid && !pipelineStall

  // Held read data: when EX stalls, exSlotsReg holds instruction I while
  // exBundleReg (frozen by fetch.io.stall) holds instruction I+1. Since
  // scratch read addresses are driven by decode(exBundleReg) = I+1's addresses,
  // the live scratch data after the first stall cycle is for I+1 — wrong for
  // instruction I in exSlotsReg. The snapshot captured at the first stall cycle
  // contains the correct data for I (from reads set up one cycle before the
  // stall when decode still processed I). Use that snapshot whenever valid.
  val useHeldReadData = heldReadDataValid

  // ---- ALU operand wiring ----
  alu.io.valid := engineFireValid
  for (i <- 0 until cfg.nAluSlots) {
    alu.io.slots(i) := exSlotsReg.aluSlots(i)
    // scalarReadData indices match the order addresses were assigned
    alu.io.operandA(i) := Mux(useHeldReadData, heldScalarReadData(i * 2), scratch.io.scalarReadData(i * 2))
    alu.io.operandB(i) := Mux(useHeldReadData, heldScalarReadData(i * 2 + 1), scratch.io.scalarReadData(i * 2 + 1))
  }

  // ---- VALU operand wiring ----
  valu.io.valid := engineFireValid
  for (s <- 0 until cfg.nValuSlots) {
    valu.io.slots(s) := exSlotsReg.valuSlots(s)
    // Vector operands A and B from VALU read ports
    for (lane <- 0 until cfg.vlen) {
      valu.io.operandA(s)(lane) := Mux(useHeldReadData, heldValuReadData(s * 2)(lane), scratch.io.valuReadData(s * 2)(lane))
      valu.io.operandB(s)(lane) := Mux(useHeldReadData, heldValuReadData(s * 2 + 1)(lane), scratch.io.valuReadData(s * 2 + 1)(lane))
    }
    // Operand C: for multiply_add, read from src3Base vector; for vbroadcast, scalar
    // For v1: use the scalar read for src3 and broadcast it to all lanes
    val src3ScalarIdx = cfg.scalarReadPorts + s  // scalar read index for VALU src3
    for (lane <- 0 until cfg.vlen) {
      valu.io.operandC(s)(lane) := Mux(useHeldReadData, heldScalarReadData(src3ScalarIdx), scratch.io.scalarReadData(src3ScalarIdx))
    }
  }

  // ---- Memory engine wiring ----
  mem.io.valid := exSlotsReg.valid
  for (i <- 0 until cfg.nLoadSlots) {
    mem.io.loadSlots(i) := exSlotsReg.loadSlots(i)
    val loadReadIdx = cfg.nAluSlots * 2 + i
    mem.io.loadAddrData(i) := Mux(useHeldReadData, heldScalarReadData(loadReadIdx), scratch.io.scalarReadData(loadReadIdx))
  }
  for (i <- 0 until cfg.nStoreSlots) {
    mem.io.storeSlots(i) := exSlotsReg.storeSlots(i)
    val storeAddrIdx = cfg.nAluSlots * 2 + cfg.nLoadSlots + i * 2
    val storeSrcIdx  = cfg.nAluSlots * 2 + cfg.nLoadSlots + i * 2 + 1
    mem.io.storeAddrData(i) := Mux(useHeldReadData, heldScalarReadData(storeAddrIdx), scratch.io.scalarReadData(storeAddrIdx))
    mem.io.storeSrcData(i)  := Mux(useHeldReadData, heldScalarReadData(storeSrcIdx), scratch.io.scalarReadData(storeSrcIdx))

    // vstore source lanes are supplied via scratch vector read groups.
    val vstoreGroupIdx = (i * 2 + 1) % (cfg.nValuSlots * 2)
    for (l <- 0 until cfg.vlen) {
      mem.io.vstoreSrcData(i)(l) := Mux(useHeldReadData, heldValuReadData(vstoreGroupIdx)(l), scratch.io.valuReadData(vstoreGroupIdx)(l))
    }
  }
  for (i <- 0 until cfg.nMatrixSlots) {
    mem.io.matrixSlots(i) := exSlotsReg.matrixSlots(i)
  }
  matrixScratchA.io.systemPort.addr := mem.io.matrixScratchAAddr
  matrixScratchA.io.systemPort.en := mem.io.matrixScratchAEn
  matrixScratchA.io.systemPort.we := mem.io.matrixScratchAWe
  matrixScratchA.io.systemPort.wrData := mem.io.matrixScratchAWrData
  mem.io.matrixScratchARdData := matrixScratchA.io.systemPort.rdData

  matrixScratchB.io.systemPort.addr := mem.io.matrixScratchBAddr
  matrixScratchB.io.systemPort.en := mem.io.matrixScratchBEn
  matrixScratchB.io.systemPort.we := mem.io.matrixScratchBWe
  matrixScratchB.io.systemPort.wrData := mem.io.matrixScratchBWrData
  mem.io.matrixScratchBRdData := matrixScratchB.io.systemPort.rdData

  matrixAccum.io.systemPort.addr := mem.io.matrixAccumAddr
  matrixAccum.io.systemPort.en := mem.io.matrixAccumEn
  matrixAccum.io.systemPort.we := mem.io.matrixAccumWe
  matrixAccum.io.systemPort.wrData := mem.io.matrixAccumWrData
  mem.io.matrixAccumRdData := matrixAccum.io.systemPort.rdData

  // ---- Flow engine wiring ----
  flow.io.valid := engineFireValid
  flow.io.slot  := exSlotsReg.flowSlot
  flow.io.currentPc := exSlotsReg.pc

  // ---- Matrix engine wiring ----
  matrix.io.valid := engineFireValid
  for (i <- 0 until cfg.nMatrixSlots) {
    matrix.io.slots(i) := exSlotsReg.matrixSlots(i)
  }
  matrixScratchA.io.matrixPort.addr := matrix.io.matrixScratchAAddr
  matrixScratchA.io.matrixPort.en := matrix.io.matrixScratchAEn
  matrixScratchA.io.matrixPort.we := matrix.io.matrixScratchAWe
  matrixScratchA.io.matrixPort.wrData := matrix.io.matrixScratchAWrData
  matrix.io.matrixScratchARdData := matrixScratchA.io.matrixPort.rdData

  matrixScratchB.io.matrixPort.addr := matrix.io.matrixScratchBAddr
  matrixScratchB.io.matrixPort.en := matrix.io.matrixScratchBEn
  matrixScratchB.io.matrixPort.we := matrix.io.matrixScratchBWe
  matrixScratchB.io.matrixPort.wrData := matrix.io.matrixScratchBWrData
  matrix.io.matrixScratchBRdData := matrixScratchB.io.matrixPort.rdData

  matrixAccum.io.matrixPort.addr := matrix.io.matrixAccumAddr
  matrixAccum.io.matrixPort.en := matrix.io.matrixAccumEn
  matrixAccum.io.matrixPort.we := matrix.io.matrixAccumWe
  matrixAccum.io.matrixPort.wrData := matrix.io.matrixAccumWrData
  matrix.io.matrixAccumRdData := matrixAccum.io.matrixPort.rdData

  val flowCondIdx = cfg.nAluSlots * 2 + cfg.nLoadSlots + cfg.nStoreSlots * 2
  flow.io.operandCond := Mux(useHeldReadData, heldScalarReadData(flowCondIdx), scratch.io.scalarReadData(flowCondIdx))
  flow.io.operandA    := Mux(useHeldReadData, heldScalarReadData(flowCondIdx + 1), scratch.io.scalarReadData(flowCondIdx + 1))
  flow.io.operandB    := Mux(useHeldReadData, heldScalarReadData(flowCondIdx + 2), scratch.io.scalarReadData(flowCondIdx + 2))

  // vselect vector operands: for v1, not connected via dedicated vector paths
  // (would need additional VALU-style read groups)
  for (l <- 0 until cfg.vlen) {
    flow.io.vCond(l) := 0  // TODO: wire vselect vector reads
    flow.io.vSrcA(l) := 0
    flow.io.vSrcB(l) := 0
  }

  // ---- Flow → Fetch feedback ----
  fetch.io.jump << flow.io.jumpTarget
  fetch.io.halt := flow.io.halt
  fetch.io.memBusy := mem.io.scalarStoreBusy || mem.io.matrixTransferBusy
  fetch.io.stall := mem.io.stall ||
    matrix.io.busy || matrix.io.startPulse ||
    mem.io.matrixTransferStartPulse || matrixTransferStall || matrixLoadWaitStall ||
    scratchBankConflictStall

  // Replay-style stall handling: with the 3-stage pipeline and synchronous IMEM
  // (readSync, 1-cycle latency), pc is always TWO ahead of exBundleReg:
  //   exBundleReg = mem[pc - 2], next-to-fetch = mem[pc - 1]
  //
  // During a stall the fetch unit drives imemAddr = pc-1, so io.imemData holds
  // mem[pc-1] — the NEXT instruction to be fetched, NOT a duplicate of
  // exBundleReg.  On stall release the `otherwise` branch correctly captures
  // this fresh instruction.  No stallReleaseBubble is needed; setting it would
  // suppress a valid instruction and cause a bundle skip.
  fetch.io.replayStall := False

  // Tell FetchUnit when the stall is from a matrix operation so it can skip
  // the stallReleaseBubble. Matrix stalls are one cycle late (combinatorial
  // chain through exSlotsReg -> engine issue -> stall), so on stall release
  // the pipeline should continue normally without suppressing a capture.
  fetch.io.matrixStall := matrix.io.busy || matrix.io.startPulse ||
    mem.io.matrixTransferStartPulse || matrixTransferStall || matrixLoadWaitStall ||
    mem.io.scalarStoreBusy

  // ======================== WB Pipeline Registers (3-stage) ========================
  // Synchronous engine writes are registered here for 1-cycle delay (EX→WB).
  // Asynchronous memory writes (load/vload) bypass these registers.

  // Helper to register a Flow(ScratchWriteReq)
  def regWriteReq(src: Flow[ScratchWriteReq]): Flow[ScratchWriteReq] = {
    val r = Flow(ScratchWriteReq(cfg))
    r.valid := RegNext(src.valid, False)
    r.addr  := RegNext(src.addr)
    r.data  := RegNext(src.data)
    r
  }

  // ALU writes → WB register
  val wbAluWrites = (0 until cfg.nAluSlots).map(i => regWriteReq(alu.io.writeReqs(i)))

  // VALU writes → WB register
  val wbValuWrites = (0 until cfg.nValuSlots).flatMap { s =>
    (0 until cfg.vlen).map(l => regWriteReq(valu.io.writeReqs(s)(l)))
  }

  // CONST writes → WB register (synchronous, no AXI)
  val wbConstWrites = (0 until cfg.nLoadSlots).map(i => regWriteReq(mem.io.constWriteReqs(i)))

  // Load/Vload writes → WB register (async arrival from MemoryEngine FIFO)
  // Registering these ensures the single-cycle AXI completion pulse is aligned
  // to a clock edge and cannot be silently dropped by Port B arbitration in
  // BankedScratchMemory when a concurrent write targets the same bank.
  // LOAD_RESULT_LATENCY=20 in the scheduler provides ample margin for the
  // extra register stage.
  val wbLoadWrites = (0 until cfg.nLoadSlots).map(i => regWriteReq(mem.io.loadWriteReqs(i)))
  val wbVloadWrites = (0 until cfg.nLoadSlots).flatMap { i =>
    (0 until cfg.vlen).map(l => regWriteReq(mem.io.vloadWriteReqs(i)(l)))
  }

  // Flow writes → WB register
  val wbFlowScalarWrite = regWriteReq(flow.io.scalarWriteReq)
  val wbFlowVectorWrites = (0 until cfg.vlen).map(l => regWriteReq(flow.io.vectorWriteReqs(l)))

  // Scratchpad copy writes → WB register (M2V writes to vector scratch)
  val wbScopyWrite = regWriteReq(mem.io.scopyWriteReq)

  // ======================== Writeback wiring (WB stage → WritebackController) ========================

  // ALU writes (through WB register)
  for (i <- 0 until cfg.nAluSlots) {
    wb.io.aluWrites(i) << wbAluWrites(i)
  }

  // VALU writes (through WB register)
  for (s <- 0 until cfg.nValuSlots) {
    for (l <- 0 until cfg.vlen) {
      wb.io.valuWrites(s * cfg.vlen + l) << wbValuWrites(s * cfg.vlen + l)
    }
  }

  // Load/Vload and Const writes (all through WB register)
  for (i <- 0 until cfg.nLoadSlots) {
    wb.io.loadWrites(i)  << wbLoadWrites(i)
    wb.io.constWrites(i) << wbConstWrites(i)
    for (l <- 0 until cfg.vlen) {
      wb.io.vloadWrites(i * cfg.vlen + l) << wbVloadWrites(i * cfg.vlen + l)
    }
  }

  // Flow writes (through WB register)
  wb.io.flowScalarWrite << wbFlowScalarWrite
  for (l <- 0 until cfg.vlen) {
    wb.io.flowVectorWrites(l) << wbFlowVectorWrites(l)
  }

  // Scratchpad copy writes (through WB register)
  wb.io.scopyWrite << wbScopyWrite

  // ======================== Scratch write crossbar ========================

  val totalWrites = wb.totalWrites
  for (i <- 0 until totalWrites) {
    scratch.io.writeAddr(i) := wb.io.scratchWriteAddr(i)
    scratch.io.writeData(i) := wb.io.scratchWriteData(i)
    scratch.io.writeEn(i)   := wb.io.scratchWriteEn(i)
  }

  // Pad unused write ports if scratch has more ports than total writes
  for (i <- totalWrites until scratch.io.writeEn.length) {
    scratch.io.writeAddr(i) := 0
    scratch.io.writeData(i) := 0
    scratch.io.writeEn(i)   := False
  }

  // ======================== AXI passthrough ========================
  io.dmemAxi <> mem.io.axiMaster

  // ======================== SCOPY read port (V2M direction) ========================
  // During SCOPY_V2M, MemoryEngine reads from vector scratch.
  // Pipeline is stalled during SCOPY, so we safely hijack scalar read port 0.
  // The stalled decode outputs are overridden; no engine consumes the data.
  when(mem.io.scopyBusy) {
    scratch.io.scalarReadAddr(0) := mem.io.scopyReadAddr
    scratch.io.scalarReadEn(0)   := mem.io.scopyReadEn
  }
  mem.io.scopyReadData := scratch.io.scalarReadData(0)

  // ======================== Status outputs ========================
  io.halted      := fetch.io.halted
  io.running     := fetch.io.running
  io.pc          := fetch.io.pc
  io.wawConflict := wb.io.wawConflict
}
