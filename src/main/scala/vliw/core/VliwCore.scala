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
  val alu      = new AluEngine(cfg)
  val valu     = new ValuEngine(cfg)
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

  // ======================== Scratch read address wiring ========================
  // 3-stage pipeline: scratch read addresses are presented from the decoded
  // bundle (combinatorial on exBundle, which is IF stage output). Because
  // BRAM reads are synchronous (1-cycle latency), the data appears at the
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

  // ---- Store scratch reads: 2 per slot (addrReg, srcReg) ----
  for (i <- 0 until cfg.nStoreSlots) {
    val sslot = decode.io.storeSlots(i)
    scratch.io.scalarReadAddr(scalarReadIdx) := decode.io.storeSlots(i).addrReg
    scratch.io.scalarReadEn(scalarReadIdx)   := decode.io.storeSlots(i).valid
    scalarReadIdx += 1

    scratch.io.scalarReadAddr(scalarReadIdx) := decode.io.storeSlots(i).srcReg
    scratch.io.scalarReadEn(scalarReadIdx)   := sslot.valid && (sslot.opcode === StoreOpcode.STORE)
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

  // Hold vstore vector source controls while memory engine stalls so
  // vector source lane addressing remains stable for multi-beat vstore.
  val vstoreValidHeld  = Vec(Reg(Bool()) init False, cfg.nStoreSlots)
  val vstoreOpcodeHeld = Vec(Reg(UInt(2 bits)) init StoreOpcode.STORE, cfg.nStoreSlots)
  val vstoreSrcRegHeld = Vec(Reg(UInt(cfg.scratchAddrWidth bits)) init 0, cfg.nStoreSlots)

  when(!mem.io.stall) {
    for (i <- 0 until cfg.nStoreSlots) {
      vstoreValidHeld(i)  := decode.io.storeSlots(i).valid
      vstoreOpcodeHeld(i) := decode.io.storeSlots(i).opcode
      vstoreSrcRegHeld(i) := decode.io.storeSlots(i).srcReg
    }
  }

  // ---- VALU active flag ----
  // Vector read groups are multiplexed between:
  //   - VALU src1/src2 reads (when any VALU slot is valid)
  //   - VSTORE source vector reads (when VALU is idle)
  val valuActiveDecode = decode.io.valuSlots.map(_.valid).reduce(_ || _)
  val vstoreVectorReadActiveDecode = (0 until cfg.nStoreSlots).map { i =>
    val slotValid = Mux(mem.io.stall, vstoreValidHeld(i), decode.io.storeSlots(i).valid)
    val slotIsVstore = Mux(mem.io.stall, vstoreOpcodeHeld(i) === StoreOpcode.VSTORE, decode.io.storeSlots(i).opcode === StoreOpcode.VSTORE)
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
      val slotValid = Mux(mem.io.stall, vstoreValidHeld(i), decode.io.storeSlots(i).valid)
      val slotIsVstore = Mux(mem.io.stall, vstoreOpcodeHeld(i) === StoreOpcode.VSTORE, decode.io.storeSlots(i).opcode === StoreOpcode.VSTORE)
      val slotSrcReg = Mux(mem.io.stall, vstoreSrcRegHeld(i), decode.io.storeSlots(i).srcReg)
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
    val flowSlot  = Reg(FlowSlot(cfg))
    val pc        = RegNext(fetch.io.pc) init 0

    for (i <- 0 until cfg.nAluSlots)  aluSlots(i)  := decode.io.aluSlots(i)
    for (i <- 0 until cfg.nValuSlots) valuSlots(i) := decode.io.valuSlots(i)
    for (i <- 0 until cfg.nLoadSlots) loadSlots(i) := decode.io.loadSlots(i)
    for (i <- 0 until cfg.nStoreSlots) storeSlots(i) := decode.io.storeSlots(i)
    flowSlot := decode.io.flowSlot
  }

  // When stalled, hold ALL pipeline registers (not just valid).
  // Without this, the next instruction's decode output leaks into
  // exSlotsReg during stall, causing premature execution of the
  // following instruction (e.g., HALT fires before STORE completes).
  // The scheduler enforces sufficient spacing for memory dependencies;
  // pipeline stall is driven by true memory backpressure only.
  val pipelineStall = mem.io.stall

  // Hold EX registers only on real memory backpressure stalls.
  // For load-use hazards we stall fetch/decode, but let EX advance so
  // the issued load instruction doesn't self-hold and deadlock hazard logic.
  when(mem.io.stall) {
    exSlotsReg.valid := exSlotsReg.valid  // hold
    for (i <- 0 until cfg.nAluSlots)   exSlotsReg.aluSlots(i)   := exSlotsReg.aluSlots(i)
    for (i <- 0 until cfg.nValuSlots)  exSlotsReg.valuSlots(i)  := exSlotsReg.valuSlots(i)
    for (i <- 0 until cfg.nLoadSlots)  exSlotsReg.loadSlots(i)  := exSlotsReg.loadSlots(i)
    for (i <- 0 until cfg.nStoreSlots) exSlotsReg.storeSlots(i) := exSlotsReg.storeSlots(i)
    exSlotsReg.flowSlot := exSlotsReg.flowSlot
    exSlotsReg.pc       := exSlotsReg.pc
  }

  // ======================== Engine data wiring (EX stage) ========================
  // BRAM read data is now available (1 cycle after address was presented)

  // 3-stage pipeline: engines fire in EX when valid and not stalled.
  // Stall directly gates engine firing — no suppressRefire needed.
  // When stall clears, the held instruction fires exactly once (memProcessed
  // in MemoryEngine prevents double-push; WB register captures results).
  val engineFireValid = exSlotsReg.valid && !pipelineStall

  // ---- ALU operand wiring ----
  alu.io.valid := engineFireValid
  for (i <- 0 until cfg.nAluSlots) {
    alu.io.slots(i) := exSlotsReg.aluSlots(i)
    // scalarReadData indices match the order addresses were assigned
    alu.io.operandA(i) := scratch.io.scalarReadData(i * 2)
    alu.io.operandB(i) := scratch.io.scalarReadData(i * 2 + 1)
  }

  // ---- VALU operand wiring ----
  valu.io.valid := engineFireValid
  for (s <- 0 until cfg.nValuSlots) {
    valu.io.slots(s) := exSlotsReg.valuSlots(s)
    // Vector operands A and B from VALU read ports
    for (lane <- 0 until cfg.vlen) {
      valu.io.operandA(s)(lane) := scratch.io.valuReadData(s * 2)(lane)
      valu.io.operandB(s)(lane) := scratch.io.valuReadData(s * 2 + 1)(lane)
    }
    // Operand C: for multiply_add, read from src3Base vector; for vbroadcast, scalar
    // For v1: use the scalar read for src3 and broadcast it to all lanes
    val src3ScalarIdx = cfg.scalarReadPorts + s  // scalar read index for VALU src3
    for (lane <- 0 until cfg.vlen) {
      valu.io.operandC(s)(lane) := scratch.io.scalarReadData(src3ScalarIdx)
    }
  }

  // ---- Memory engine wiring ----
  mem.io.valid := exSlotsReg.valid
  for (i <- 0 until cfg.nLoadSlots) {
    mem.io.loadSlots(i) := exSlotsReg.loadSlots(i)
    val loadReadIdx = cfg.nAluSlots * 2 + i
    mem.io.loadAddrData(i) := scratch.io.scalarReadData(loadReadIdx)
  }
  for (i <- 0 until cfg.nStoreSlots) {
    mem.io.storeSlots(i) := exSlotsReg.storeSlots(i)
    val storeAddrIdx = cfg.nAluSlots * 2 + cfg.nLoadSlots + i * 2
    val storeSrcIdx  = cfg.nAluSlots * 2 + cfg.nLoadSlots + i * 2 + 1
    mem.io.storeAddrData(i) := scratch.io.scalarReadData(storeAddrIdx)
    mem.io.storeSrcData(i)  := scratch.io.scalarReadData(storeSrcIdx)

    // vstore source lanes are supplied via scratch vector read groups.
    val vstoreGroupIdx = (i * 2 + 1) % (cfg.nValuSlots * 2)
    for (l <- 0 until cfg.vlen) {
      mem.io.vstoreSrcData(i)(l) := scratch.io.valuReadData(vstoreGroupIdx)(l)
    }
  }

  // ---- Flow engine wiring ----
  flow.io.valid := exSlotsReg.valid
  flow.io.slot  := exSlotsReg.flowSlot
  flow.io.currentPc := exSlotsReg.pc

  val flowCondIdx = cfg.nAluSlots * 2 + cfg.nLoadSlots + cfg.nStoreSlots * 2
  flow.io.operandCond := scratch.io.scalarReadData(flowCondIdx)
  flow.io.operandA    := scratch.io.scalarReadData(flowCondIdx + 1)
  flow.io.operandB    := scratch.io.scalarReadData(flowCondIdx + 2)

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
  // NOTE: scratch.io.conflict removed from stall path.
  // Bank conflicts cause an infinite stall (same instruction re-decodes,
  // same conflict persists).  The scheduler is responsible for avoiding
  // bank conflicts; any unintended conflict degrades to stale data
  // rather than a livelock.
  fetch.io.stall := pipelineStall

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

  // ======================== Status outputs ========================
  io.halted      := fetch.io.halted
  io.running     := fetch.io.running
  io.pc          := fetch.io.pc
  io.wawConflict := wb.io.wawConflict
}
