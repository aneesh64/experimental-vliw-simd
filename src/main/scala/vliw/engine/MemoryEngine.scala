package vliw.engine

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import vliw.config.VliwSocConfig
import vliw.bundle._
import vliw.plugin._

/**
 * Memory Engine v2 — 512-bit AXI4, FIFO-based non-blocking load/store.
 *
 * Architecture changes from v1:
 *   - 512-bit AXI data bus: all scalar/vector ops are single-beat
 *   - Store buffer (FIFO): stores are decoupled until FIFO is full
 *   - Load queue (FIFO): loads are non-blocking; pipeline stalls only when queue is full
 *   - Overlapped AW+W: store address and data sent in same cycle when possible
 *   - Load results arrive asynchronously and write to scratch directly
 *   - Pipeline stalls when load register is full or store FIFO is full
 *
 * With 512-bit bus (16 × 32-bit words per beat):
 *   - Scalar LOAD/STORE:  1 beat, extract/insert 1 word using byte strobes
 *   - VLOAD/VSTORE (8w):  1 beat, extract/insert 8 consecutive words
 *   - All operations are len=0 (single beat) with SIZE=6 (64 bytes)
 *
 * Compiler responsibility:
 *   - Schedule enough independent work between load issue and result consumption
 *   - Ensure no scratch bank conflicts between async load writebacks and pipeline writes
 *   - CONST remains combinatorial (no AXI, no stall)
 */
class MemoryEngine(cfg: VliwSocConfig) extends Component with EnginePlugin {
  val io = new Bundle {
    val loadSlots  = in Vec(LoadSlot(cfg), cfg.nLoadSlots)
    val storeSlots = in Vec(StoreSlot(cfg), cfg.nStoreSlots)
    val matrixSlots = in Vec(MatrixSlot(cfg), cfg.nMatrixSlots)
    val valid      = in Bool()

    // Scratch read data for address computation
    val loadAddrData  = in Vec(UInt(cfg.dataWidth bits), cfg.nLoadSlots)
    val storeAddrData = in Vec(UInt(cfg.dataWidth bits), cfg.nStoreSlots)
    val storeSrcData  = in Vec(UInt(cfg.dataWidth bits), cfg.nStoreSlots)

    // Vector store source data (VLEN per slot)
    val vstoreSrcData = in Vec(Vec(UInt(cfg.dataWidth bits), cfg.vlen), cfg.nStoreSlots)

    // AXI4 master port (512-bit data bus)
    val axiMaster = master(Axi4(cfg.axiConfig))

    // Scratch write results
    val loadWriteReqs  = Vec(master(Flow(ScratchWriteReq(cfg))), cfg.nLoadSlots)
    val constWriteReqs = Vec(master(Flow(ScratchWriteReq(cfg))), cfg.nLoadSlots)
    val vloadWriteReqs = Vec(Vec(master(Flow(ScratchWriteReq(cfg))), cfg.vlen), cfg.nLoadSlots)

    // Scratchpad copy write results (M2V: matrix→vector scratch, one word per cycle)
    val scopyWriteReq = master(Flow(ScratchWriteReq(cfg)))

    // Scratchpad copy read from vector scratch (V2M: vector→matrix, one word per cycle)
    val scopyReadAddr = out UInt(cfg.scratchAddrWidth bits)
    val scopyReadEn   = out Bool()
    val scopyReadData = in UInt(cfg.dataWidth bits)

    // Scratchpad copy busy flag
    val scopyBusy = out Bool()

    // Matrix-local memory system-side ports
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

    // Pipeline stall: only when FIFOs are full
    val stall = out Bool()
    val scalarStoreBusy = out Bool()
    val matrixTransferBusy = out Bool()
    val matrixTransferBypassable = out Bool()
    val matrixTransferStartPulse = out Bool()

    // Pending load metadata (for load-use hazard detection in core)
    val loadPendingValid    = out Bool()
    val loadPendingDestAddr = out UInt(cfg.scratchAddrWidth bits)
    val loadPendingIsVector = out Bool()
  }

  override def engineName: String = "MEM"
  override def numScalarReadPorts: Int = cfg.nLoadSlots + cfg.nStoreSlots * 2
  override def numVectorReadGroups: Int = 0
  override def numScalarWritePorts: Int = cfg.nLoadSlots
  override def numVectorWriteGroups: Int = 0

  // ===================== Constants =====================
  val axiBytes     = cfg.axiDataBytes          // 64
  val wordsPerBeat = cfg.wordsPerAxiBeat       // 16
  val axiSizeVal   = U(cfg.axiSizeLog2, 3 bits) // 6 for 64 bytes
  val strbPerWord  = cfg.dataWidth / 8         // 4
  val alignMask    = U(axiBytes - 1, cfg.axiAddrWidth bits)
  val scratchElemsPerBeat = cfg.axiDataWidth / cfg.matrixElemBits
  val accumElemsPerBeat   = cfg.axiDataWidth / cfg.matrixAccumBits
  val matrixLocalAddrWidth = log2Up((cfg.matrixScratchSize max cfg.matrixAccumSize) max 2)

  // ===================== Default outputs =====================
  io.stall := False
  io.matrixTransferStartPulse := False
  io.scopyWriteReq.valid := False
  io.scopyWriteReq.addr  := 0
  io.scopyWriteReq.data  := 0
  io.scopyReadAddr := 0
  io.scopyReadEn   := False
  io.scopyBusy     := False
  for (i <- 0 until cfg.nLoadSlots) {
    io.loadWriteReqs(i).valid  := False
    io.loadWriteReqs(i).addr   := 0
    io.loadWriteReqs(i).data   := 0
    io.constWriteReqs(i).valid := False
    io.constWriteReqs(i).addr  := 0
    io.constWriteReqs(i).data  := 0
    for (l <- 0 until cfg.vlen) {
      io.vloadWriteReqs(i)(l).valid := False
      io.vloadWriteReqs(i)(l).addr  := 0
      io.vloadWriteReqs(i)(l).data  := 0
    }
  }
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

  // ===================== AXI defaults =====================
  io.axiMaster.aw.valid := False
  io.axiMaster.aw.addr  := 0
  io.axiMaster.aw.len   := 0
  io.axiMaster.aw.size  := axiSizeVal
  io.axiMaster.aw.burst := 1
  io.axiMaster.aw.id    := 0

  io.axiMaster.w.valid := False
  io.axiMaster.w.data  := 0
  io.axiMaster.w.strb  := 0
  io.axiMaster.w.last  := True

  io.axiMaster.b.ready := False

  // ===================== CONST handling (combinatorial, no AXI) =====================
  for (i <- 0 until cfg.nLoadSlots) {
    val slot = io.loadSlots(i)
    when(slot.valid && io.valid && slot.opcode === LoadOpcode.CONST) {
      io.constWriteReqs(i).valid := True
      io.constWriteReqs(i).addr  := slot.dest
      io.constWriteReqs(i).data  := slot.immediate
    }
  }

  // ===================== Request entry types =====================

  case class LoadReqEntry() extends Bundle {
    val axiAddr   = UInt(cfg.axiAddrWidth bits)
    val destAddr  = UInt(cfg.scratchAddrWidth bits)
    val isVector  = Bool()
    val slotIdx   = UInt(log2Up(cfg.nLoadSlots max 2) bits)
    val wordOff   = UInt(cfg.wordOffsetBits bits)
  }

  case class StoreReqEntry() extends Bundle {
    val axiAddr = UInt(cfg.axiAddrWidth bits)
    val wdata   = Bits(cfg.axiDataWidth bits)
    val wstrb   = Bits(axiBytes bits)
  }

  // ===================== Request FIFOs =====================
  val storeReqFifo = StreamFifo(StoreReqEntry(), cfg.storeQueueDepth)

  // Default store FIFO push
  storeReqFifo.io.push.valid := False
  storeReqFifo.io.push.payload.assignFromBits(B(0, storeReqFifo.io.push.payload.getBitsWidth bits))

  // ===================== Store AXI FSM state =====================
  object MemState extends SpinalEnum {
    val IDLE, STORE_AW_W, STORE_B,
        MATRIX_READ_AR, MATRIX_READ_R, MATRIX_READ_DRAIN,
        MATRIX_WRITE_GATHER, MATRIX_WRITE_AW_W, MATRIX_WRITE_B,
        SCOPY_M2V, SCOPY_V2M = newElement()
  }

  val state = RegInit(MemState.IDLE)
  val capStoreReq = Reg(StoreReqEntry())
  val awAccepted  = RegInit(False)
  val wAccepted   = RegInit(False)

  // ===================== Simplified Load Request Tracking =====================
  // Instead of loadReqFifo + loadPendingFifo, use single register + valid bit
  val loadReqValid = RegInit(False)
  val loadAddrAccepted = RegInit(False)
  val loadReqEntry = Reg(LoadReqEntry())

  // ===================== Load Completion Tracking Queue =====================
  // Register-based FIFO (depth 4) tracking loads between AXI R completion and
  // scratch capture.  Loads issued back-to-back have in-order AXI responses,
  // so a simple FIFO is sufficient.  Each entry counts down 3 cycles after
  // AXI R arrives to ensure the WB pipeline register has committed the data
  // to scratch memory before releasing the WAIT_FOR_LOAD stall.
  val loadTrackDepth = 4
  val loadTrackValid     = Seq.fill(loadTrackDepth)(RegInit(False))
  val loadTrackDestAddr  = Seq.fill(loadTrackDepth)(Reg(UInt(cfg.scratchAddrWidth bits)) init 0)
  val loadTrackCountdown = Seq.fill(loadTrackDepth)(RegInit(U(0, 2 bits)))
  val loadTrackHead = RegInit(U(0, 2 bits))
  val loadTrackTail = RegInit(U(0, 2 bits))

  val matrixUseAccum = RegInit(False)
  val matrixUseScratchB = RegInit(False)
  val matrixTransferBypassable = RegInit(False)
  val matrixIssueSeen = RegInit(False)
  val matrixLocalBase = Reg(UInt(matrixLocalAddrWidth bits)) init 0
  val matrixDramAddr = Reg(UInt(cfg.axiAddrWidth bits)) init 0
  val matrixTotalElems = Reg(UInt(7 bits)) init 0
  val matrixElemsTransferred = Reg(UInt(7 bits)) init 0
  val matrixBeatElems = Reg(UInt(7 bits)) init 0
  val matrixDrainIndex = Reg(UInt(7 bits)) init 0
  val matrixGatherIssued = Reg(UInt(7 bits)) init 0
  val matrixGatherCaptured = Reg(UInt(7 bits)) init 0
  val matrixReadPipeValid = RegInit(False)
  val matrixReadPipeIndex = Reg(UInt(7 bits)) init 0
  val matrixBeatBuffer = Reg(Bits(cfg.axiDataWidth bits)) init 0

  // ===================== Scratchpad Copy State =====================
  // SCOPY_M2V: reads matrix accum one word/cycle, writes to vector scratch
  // SCOPY_V2M: reads vector scratch one word/cycle, writes to matrix accum
  val scopyIsM2V = RegInit(False)         // True=M2V, False=V2M
  val scopyVectorBase = Reg(UInt(cfg.scratchAddrWidth bits)) init 0
  val scopyMatrixBase = Reg(UInt(matrixLocalAddrWidth bits)) init 0
  val scopyElemIdx = Reg(UInt(log2Up(cfg.vlen + 1) bits)) init 0
  val scopyTotalElems = Reg(UInt(log2Up(cfg.vlen + 1) bits)) init 0
  val scopyUseAccum = RegInit(False)
  val scopyUseScratchB = RegInit(False)
  val scopyReadPipeValid = RegInit(False) // M2V: 1-cycle read latency from matrix BRAM

  matrixUseAccum := matrixUseAccum
  matrixUseScratchB := matrixUseScratchB
  matrixTransferBypassable := matrixTransferBypassable
  matrixIssueSeen := matrixIssueSeen
  matrixLocalBase := matrixLocalBase
  matrixTotalElems := matrixTotalElems

  io.loadPendingValid    := loadReqValid
  io.loadPendingDestAddr := loadReqEntry.destAddr
  io.loadPendingIsVector := loadReqEntry.isVector

  // ---- Load completion queue: countdown tick & pop ----
  for (i <- 0 until loadTrackDepth) {
    when(loadTrackValid(i) && loadTrackCountdown(i) > 0) {
      loadTrackCountdown(i) := loadTrackCountdown(i) - 1
    }
  }
  // Pop head entry once its countdown reaches 0
  for (i <- 0 until loadTrackDepth) {
    when(U(i, 2 bits) === loadTrackHead && loadTrackValid(i) && loadTrackCountdown(i) === 0) {
      loadTrackValid(i) := False
      loadTrackHead := loadTrackHead + 1
    }
  }

  def nextMatrixBeatElems(remaining: UInt, useAccum: Bool): UInt = {
    val limited = UInt(7 bits)
    limited := remaining.resized
    when(useAccum && remaining > U(accumElemsPerBeat, 7 bits)) {
      limited := U(accumElemsPerBeat, 7 bits)
    }
    limited
  }

  // ===================== Pipeline → Load Register & Store FIFO Logic =====================

  val anyLoadOp = Bool()
  anyLoadOp := False

  // Detect load operations in EX stage
  val isLoadOp = Vec(Bool(), cfg.nLoadSlots)
  for (i <- 0 until cfg.nLoadSlots) {
    val slot = io.loadSlots(i)
    isLoadOp(i) := slot.valid && io.valid &&
                   (slot.opcode === LoadOpcode.LOAD ||
                    slot.opcode === LoadOpcode.LOAD_OFFSET ||
                    slot.opcode === LoadOpcode.VLOAD)
    when(isLoadOp(i)) { anyLoadOp := True }
  }

  // Detect WAIT_FOR_LOAD: software barrier that stalls until pending loads complete
  val isWaitForLoad = Vec(Bool(), cfg.nLoadSlots)
  val anyWaitForLoad = Bool()
  anyWaitForLoad := False
  for (i <- 0 until cfg.nLoadSlots) {
    val slot = io.loadSlots(i)
    isWaitForLoad(i) := slot.valid && io.valid && slot.opcode === LoadOpcode.WAIT_FOR_LOAD
    when(isWaitForLoad(i)) { anyWaitForLoad := True }
  }

  // Detect SCOPY operations in EX stage
  val isScopyOp = Vec(Bool(), cfg.nLoadSlots)
  val anyScopyOp = Bool()
  anyScopyOp := False
  for (i <- 0 until cfg.nLoadSlots) {
    val slot = io.loadSlots(i)
    isScopyOp(i) := slot.valid && io.valid &&
                    (slot.opcode === LoadOpcode.SCOPY_M2V ||
                     slot.opcode === LoadOpcode.SCOPY_V2M)
    when(isScopyOp(i)) { anyScopyOp := True }
  }

  // Detect store operations in EX stage
  val anyStoreOp = Bool()
  anyStoreOp := False
  val isStoreOp = Vec(Bool(), cfg.nStoreSlots)
  for (i <- 0 until cfg.nStoreSlots) {
    val slot = io.storeSlots(i)
    isStoreOp(i) := slot.valid && io.valid &&
                    (slot.opcode === StoreOpcode.STORE ||
                     slot.opcode === StoreOpcode.VSTORE)
    when(isStoreOp(i)) { anyStoreOp := True }
  }

  val hasMatrixSlot = cfg.nMatrixSlots > 0
  val matrixTransferRequested = if (hasMatrixSlot) {
    io.valid && io.matrixSlots(0).valid &&
      (io.matrixSlots(0).opcode === MatrixOpcode.MDMVIN || io.matrixSlots(0).opcode === MatrixOpcode.MDMVOUT)
  } else {
    False
  }
  when(!matrixTransferRequested) {
    matrixIssueSeen := False
  }
  val matrixTransferInFlight = state === MemState.MATRIX_READ_AR ||
    state === MemState.MATRIX_READ_R ||
    state === MemState.MATRIX_READ_DRAIN ||
    state === MemState.MATRIX_WRITE_GATHER ||
    state === MemState.MATRIX_WRITE_AW_W ||
    state === MemState.MATRIX_WRITE_B
  val scopyInFlight = state === MemState.SCOPY_M2V || state === MemState.SCOPY_V2M
  val scalarStoreInFlight = state === MemState.STORE_AW_W ||
    state === MemState.STORE_B
  val scalarStorePending = scalarStoreInFlight || (storeReqFifo.io.occupancy =/= 0)
  val regularMemBusyForMatrix = loadReqValid ||
    scalarStorePending
  val matrixBundleConflict = matrixTransferRequested && (anyLoadOp || anyStoreOp)

  // Stall only when new load is requested but register already full
  when(anyLoadOp && loadReqValid) {
    io.stall := True
  }
  // WAIT_FOR_LOAD: address-specific barrier stalls until the specific load completes
  // and its data has been captured in scratch memory (via completion queue countdown).
  for (i <- 0 until cfg.nLoadSlots) {
    when(isWaitForLoad(i)) {
      val waitAddr = io.loadSlots(i).dest  // scratch address encoded in the instruction

      // Match 1: load still in-flight (waiting for AXI R response)
      val matchInFlight = loadReqValid && loadReqEntry.destAddr === waitAddr

      // Match 2: load completed AXI but still in post-completion countdown
      val matchCompletion = Bool()
      matchCompletion := False
      for (j <- 0 until loadTrackDepth) {
        when(loadTrackValid(j) && loadTrackCountdown(j) =/= 0 &&
             loadTrackDestAddr(j) === waitAddr) {
          matchCompletion := True
        }
      }

      when(matchInFlight || matchCompletion) {
        io.stall := True
      }
    }
  }
  // Stall while scratchpad copy is in progress
  when(scopyInFlight) {
    io.stall := True
    io.scopyBusy := True
  }
  // Stall if SCOPY requested while state machine is busy
  when(anyScopyOp && state =/= MemState.IDLE) {
    io.stall := True
  }
  // The scalar load and store paths share one AXI master. Keep stores from
  // issuing until an earlier scalar load response has drained to avoid
  // overlapping AR/R and AW/W traffic in the core memory engine.
  when(anyStoreOp && loadReqValid) {
    io.stall := True
  }

  // If the pipeline issues a store while queue capacity is exhausted, stall and replay bundle.
  // Note: one store can be held in capStoreReq while STORE_AW_W/STORE_B is active, so we
  // treat FIFO depth-1 as full in those states to keep total outstanding <= storeQueueDepth.
  val storeQueueFull = !storeReqFifo.io.push.ready
  val storeQueueNearFullWithInFlight =
    (state =/= MemState.IDLE) &&
    (storeReqFifo.io.occupancy === U(cfg.storeQueueDepth - 1, storeReqFifo.io.occupancy.getWidth bits))
  val stallOnStoreFull = anyStoreOp && (storeQueueFull || storeQueueNearFullWithInFlight)
  when(stallOnStoreFull) {
    io.stall := True
  }
  // Scalar stores are architecturally visible side effects.
  // HALT is independently gated by fetch.io.memBusy (driven by
  // io.scalarStoreBusy) so the pipeline can continue after a store push
  // without a blanket stall. Specific contention cases (FIFO full,
  // concurrent load, matrix transfer) are handled by the targeted stalls above.
  when(matrixTransferRequested && (matrixBundleConflict || regularMemBusyForMatrix)) {
    io.stall := True
  }

  io.scalarStoreBusy := scalarStorePending
  io.matrixTransferBusy := matrixTransferInFlight
  io.matrixTransferBypassable := matrixTransferBypassable

  // ===================== Push requests into load register / store FIFO =====================

  // Load request: only process first active load slot
  for (i <- 0 until cfg.nLoadSlots) {
    when(isLoadOp(i) && !io.stall) {
      val slot = io.loadSlots(i)
      val memAddr = io.loadAddrData(i)
      val byteAddr = (memAddr << 2).resize(cfg.axiAddrWidth)
      val alignedAddr = byteAddr & ~alignMask
      val wordOffset = (byteAddr >> 2).resize(cfg.wordOffsetBits)

      loadReqEntry.slotIdx  := U(i).resized
      loadReqEntry.wordOff  := wordOffset
      loadReqEntry.isVector := (slot.opcode === LoadOpcode.VLOAD)

      switch(slot.opcode) {
        is(LoadOpcode.LOAD) {
          loadReqEntry.axiAddr  := alignedAddr
          loadReqEntry.destAddr := slot.dest
        }
        is(LoadOpcode.LOAD_OFFSET) {
          val offAddr = (memAddr + slot.offset.resize(cfg.dataWidth))
          val offByteAddr = (offAddr << 2).resize(cfg.axiAddrWidth)
          loadReqEntry.axiAddr  := offByteAddr & ~alignMask
          loadReqEntry.destAddr := (slot.dest + slot.offset).resize(cfg.scratchAddrWidth)
          loadReqEntry.wordOff  := (offByteAddr >> 2).resize(cfg.wordOffsetBits)
        }
        is(LoadOpcode.VLOAD) {
          loadReqEntry.axiAddr  := alignedAddr
          loadReqEntry.destAddr := slot.dest
          // Debug: vector word offset must fit within a single AXI beat.
          // wordOffset + VLEN - 1 must be < wordsPerBeat, else lanes wrap.
          if (cfg.enableTracePort || true) {
            assert(
              wordOffset <= U(wordsPerBeat - cfg.vlen, cfg.wordOffsetBits bits),
              "VLOAD: vector crosses AXI beat boundary (word offset + VLEN > wordsPerBeat). Use aligned address."
            )
          }
        }
      }
      loadReqValid := True
      loadAddrAccepted := False
    }
  }

  // Store request: only process first active store slot
  for (i <- 0 until cfg.nStoreSlots) {
    when(isStoreOp(i) && !io.stall) {
      val slot = io.storeSlots(i)
      val memAddr = io.storeAddrData(i)
      val byteAddr = (memAddr << 2).resize(cfg.axiAddrWidth)
      val alignedAddr = byteAddr & ~alignMask
      val wordOffset = (byteAddr >> 2).resize(cfg.wordOffsetBits)

      storeReqFifo.io.push.payload.axiAddr := alignedAddr

      // Build 512-bit data word and byte strobes
      val wdata = Bits(cfg.axiDataWidth bits)
      val wstrb = Bits(axiBytes bits)
      wdata := 0
      wstrb := 0

      switch(slot.opcode) {
        is(StoreOpcode.STORE) {
          // Single word at wordOffset
          for (w <- 0 until wordsPerBeat) {
            when(wordOffset === w) {
              wdata(w * cfg.dataWidth, cfg.dataWidth bits) := io.storeSrcData(i).asBits
              wstrb(w * strbPerWord, strbPerWord bits) := B((1 << strbPerWord) - 1, strbPerWord bits)
            }
          }
        }
        is(StoreOpcode.VSTORE) {
          // VLEN words starting at wordOffset.
          // Debug: vector word offset must fit within a single AXI beat.
          if (cfg.enableTracePort || true) {
            assert(
              wordOffset <= U(wordsPerBeat - cfg.vlen, cfg.wordOffsetBits bits),
              "VSTORE: vector crosses AXI beat boundary (word offset + VLEN > wordsPerBeat). Use aligned address."
            )
          }
          for (lane <- 0 until cfg.vlen) {
            val wpos = (wordOffset + lane).resize(cfg.wordOffsetBits)
            for (w <- 0 until wordsPerBeat) {
              when(wpos === w) {
                wdata(w * cfg.dataWidth, cfg.dataWidth bits) := io.vstoreSrcData(i)(lane).asBits
                wstrb(w * strbPerWord, strbPerWord bits) := B((1 << strbPerWord) - 1, strbPerWord bits)
              }
            }
          }
        }
      }

      storeReqFifo.io.push.payload.wdata := wdata
      storeReqFifo.io.push.payload.wstrb := wstrb
      storeReqFifo.io.push.valid := True
    }
  }

  if (hasMatrixSlot) {
    val matrixSlot = io.matrixSlots(0)
    val matrixIsIn = matrixSlot.opcode === MatrixOpcode.MDMVIN
    val dramWordBase = Mux(matrixIsIn, matrixSlot.srcA, matrixSlot.dest).resize(cfg.axiAddrWidth)
    val localBase = Mux(matrixIsIn, matrixSlot.dest, matrixSlot.srcA).resize(matrixLocalAddrWidth)
    val dramByteAddr = ((dramWordBase << 2).resize(cfg.axiAddrWidth)) & ~alignMask
    val totalElems = (matrixSlot.tileRows * matrixSlot.tileCols).resize(7)

    when(matrixTransferRequested && !matrixIssueSeen && !io.stall && !matrixTransferInFlight) {
      matrixIssueSeen := True
      if (cfg.enableTracePort || true) {
        assert(
          dramWordBase(cfg.wordOffsetBits - 1 downto 0) === 0,
          "MDMVIN/MDMVOUT require 64-byte aligned DRAM base addresses in v1"
        )
      }

      matrixUseAccum := matrixSlot.flags(0)
      matrixUseScratchB := matrixSlot.flags(1)
      matrixTransferBypassable := matrixIsIn
      matrixLocalBase := localBase
      matrixDramAddr := dramByteAddr
      matrixTotalElems := totalElems
      matrixElemsTransferred := 0
      matrixBeatElems := nextMatrixBeatElems(totalElems, matrixSlot.flags(0))
      matrixDrainIndex := 0
      matrixGatherIssued := 0
      matrixGatherCaptured := 0
      matrixReadPipeValid := False
      matrixReadPipeIndex := 0
      matrixBeatBuffer := 0
      io.matrixTransferStartPulse := True

      when(totalElems === 0) {
        matrixBeatElems := 0
        matrixElemsTransferred := 0
      } elsewhen(matrixIsIn) {
        state := MemState.MATRIX_READ_AR
      } otherwise {
        state := MemState.MATRIX_WRITE_GATHER
      }
    }
  }

  // ===================== Scratchpad Copy Initiation =====================
  // SCOPY_M2V: dest=vector scratch base, addrReg=matrix-local base (immediate),
  //            offset[0]=use accumulator, offset[1]=use scratchB
  // SCOPY_V2M: dest=matrix-local base, addrReg=vector scratch base (immediate),
  //            offset[0]=use accumulator, offset[1]=use scratchB
  for (i <- 0 until cfg.nLoadSlots) {
    when(isScopyOp(i) && !io.stall && state === MemState.IDLE) {
      val slot = io.loadSlots(i)
      val isM2V = slot.opcode === LoadOpcode.SCOPY_M2V
      scopyIsM2V := isM2V
      scopyUseAccum := slot.offset(0)
      scopyUseScratchB := slot.offset(1)
      scopyTotalElems := U(cfg.vlen, log2Up(cfg.vlen + 1) bits)
      scopyElemIdx := 0
      scopyReadPipeValid := False

      when(isM2V) {
        // M2V: matrix-local address in addrReg, vector scratch dest in dest
        scopyVectorBase := slot.dest
        scopyMatrixBase := slot.addrReg.resize(matrixLocalAddrWidth)
        state := MemState.SCOPY_M2V
      } otherwise {
        // V2M: vector scratch source in addrReg, matrix-local dest in dest
        scopyVectorBase := slot.addrReg.resize(cfg.scratchAddrWidth)
        scopyMatrixBase := slot.dest.resize(matrixLocalAddrWidth)
        state := MemState.SCOPY_V2M
      }
    }
  }

  // ===================== Simplified AXI FSM =====================

  // Default FIFO pop
  storeReqFifo.io.pop.ready := False

  // Load AR: drive combinatorially from loadReqEntry when valid (no FSM state needed)
  io.axiMaster.ar.valid := loadReqValid && !loadAddrAccepted
  io.axiMaster.ar.addr  := loadReqEntry.axiAddr
  io.axiMaster.ar.len   := 0  // Single-beat
  io.axiMaster.ar.size  := axiSizeVal
  io.axiMaster.ar.burst := 1
  io.axiMaster.ar.id    := 0
  when(io.axiMaster.ar.fire) {
    loadAddrAccepted := True
  }

  // Load R: accept response directly and writeback
  io.axiMaster.r.ready := loadReqValid  // Only accept if we're tracking a load
  when(io.axiMaster.r.valid && loadReqValid) {
    // Load response is valid - write to scratch
    val rdata = io.axiMaster.r.data
    val pendingEntry = loadReqEntry  // Use current register entry

    for (i <- 0 until cfg.nLoadSlots) {
      when(pendingEntry.slotIdx === i) {
        when(!pendingEntry.isVector) {
          // Scalar: extract one 32-bit word
          val readWord = UInt(cfg.dataWidth bits)
          readWord := 0
          for (w <- 0 until wordsPerBeat) {
            when(pendingEntry.wordOff === w) {
              readWord := rdata(w * cfg.dataWidth, cfg.dataWidth bits).asUInt
            }
          }
          io.loadWriteReqs(i).valid := True
          io.loadWriteReqs(i).addr  := pendingEntry.destAddr
          io.loadWriteReqs(i).data  := readWord
        } otherwise {
          // Vector: extract VLEN consecutive words
          for (lane <- 0 until cfg.vlen) {
            val laneWord = UInt(cfg.dataWidth bits)
            laneWord := 0
            val wpos = (pendingEntry.wordOff + lane).resize(cfg.wordOffsetBits)
            for (w <- 0 until wordsPerBeat) {
              when(wpos === w) {
                laneWord := rdata(w * cfg.dataWidth, cfg.dataWidth bits).asUInt
              }
            }
            io.vloadWriteReqs(i)(lane).valid := True
            io.vloadWriteReqs(i)(lane).addr  := (pendingEntry.destAddr + lane).resize(cfg.scratchAddrWidth)
            io.vloadWriteReqs(i)(lane).data  := laneWord
          }
        }
      }
    }

    // Clear load request after response
    loadReqValid := False
    loadAddrAccepted := False

    // Push into load completion tracking queue with 3-cycle countdown
    for (i <- 0 until loadTrackDepth) {
      when(U(i, 2 bits) === loadTrackTail) {
        loadTrackValid(i) := True
        loadTrackDestAddr(i) := pendingEntry.destAddr
        loadTrackCountdown(i) := 3
      }
    }
    loadTrackTail := loadTrackTail + 1
  }

  val matrixBeatBytes = UInt(log2Up(axiBytes + 1) bits)
  matrixBeatBytes := matrixBeatElems.resize(log2Up(axiBytes + 1))
  when(matrixUseAccum) {
    matrixBeatBytes := (matrixBeatElems.resize(log2Up(axiBytes + 1)) << 2).resize(log2Up(axiBytes + 1))
  }

  val matrixWriteStrb = Bits(axiBytes bits)
  matrixWriteStrb := 0
  for (b <- 0 until axiBytes) {
    when(U(b, matrixBeatBytes.getWidth bits) < matrixBeatBytes) {
      matrixWriteStrb(b) := True
    }
  }

  // Store FSM: unchanged
  switch(state) {
    is(MemState.IDLE) {
      when(storeReqFifo.io.pop.valid) {
        capStoreReq := storeReqFifo.io.pop.payload
        storeReqFifo.io.pop.ready := True
        awAccepted := False
        wAccepted  := False
        state := MemState.STORE_AW_W
      }
    }

    is(MemState.STORE_AW_W) {
      when(!awAccepted) { io.axiMaster.aw.valid := True }
      when(!wAccepted)  { io.axiMaster.w.valid  := True }

      io.axiMaster.aw.addr := capStoreReq.axiAddr
      io.axiMaster.aw.len  := 0
      io.axiMaster.aw.size := axiSizeVal
      io.axiMaster.w.data  := capStoreReq.wdata
      io.axiMaster.w.strb  := capStoreReq.wstrb
      io.axiMaster.w.last  := True

      when(io.axiMaster.aw.fire) { awAccepted := True }
      when(io.axiMaster.w.fire)  { wAccepted  := True }

      when((io.axiMaster.aw.fire || awAccepted) && (io.axiMaster.w.fire || wAccepted)) {
        awAccepted := False
        wAccepted  := False
        state := MemState.STORE_B
      }
    }

    is(MemState.STORE_B) {
      io.axiMaster.b.ready := True
      when(io.axiMaster.b.valid) {
        state := MemState.IDLE
      }
    }

    is(MemState.MATRIX_READ_AR) {
      io.axiMaster.ar.valid := True
      io.axiMaster.ar.addr := matrixDramAddr
      io.axiMaster.ar.len := 0
      io.axiMaster.ar.size := axiSizeVal
      io.axiMaster.ar.burst := 1
      io.axiMaster.ar.id := 0
      when(io.axiMaster.ar.fire) {
        state := MemState.MATRIX_READ_R
      }
    }

    is(MemState.MATRIX_READ_R) {
      io.axiMaster.r.ready := True
      when(io.axiMaster.r.valid) {
        matrixBeatBuffer := io.axiMaster.r.data
        matrixDrainIndex := 0
        state := MemState.MATRIX_READ_DRAIN
      }
    }

    is(MemState.MATRIX_READ_DRAIN) {
      val localAddr = (matrixLocalBase + matrixElemsTransferred.resize(matrixLocalAddrWidth) +
        matrixDrainIndex.resize(matrixLocalAddrWidth)).resize(matrixLocalAddrWidth)
      when(matrixUseAccum) {
        val accumWord = UInt(cfg.matrixAccumBits bits)
        accumWord := 0
        for (idx <- 0 until accumElemsPerBeat) {
          when(matrixDrainIndex === idx) {
            accumWord := matrixBeatBuffer(idx * cfg.matrixAccumBits, cfg.matrixAccumBits bits).asUInt
          }
        }
        io.matrixAccumAddr := localAddr.resize(cfg.matrixAccumAddrWidth)
        io.matrixAccumEn := True
        io.matrixAccumWe := True
        io.matrixAccumWrData := accumWord
      } otherwise {
        val scratchByte = UInt(cfg.matrixElemBits bits)
        scratchByte := 0
        for (idx <- 0 until scratchElemsPerBeat) {
          when(matrixDrainIndex === idx) {
            scratchByte := matrixBeatBuffer(idx * cfg.matrixElemBits, cfg.matrixElemBits bits).asUInt
          }
        }
        when(matrixUseScratchB) {
          io.matrixScratchBAddr := localAddr.resize(cfg.matrixScratchAddrWidth)
          io.matrixScratchBEn := True
          io.matrixScratchBWe := True
          io.matrixScratchBWrData := scratchByte
        } otherwise {
          io.matrixScratchAAddr := localAddr.resize(cfg.matrixScratchAddrWidth)
          io.matrixScratchAEn := True
          io.matrixScratchAWe := True
          io.matrixScratchAWrData := scratchByte
        }
      }

      val nextDrain = matrixDrainIndex + 1
      val nextTransferred = matrixElemsTransferred + matrixBeatElems
      when(nextDrain === matrixBeatElems) {
        matrixDrainIndex := 0
        matrixElemsTransferred := nextTransferred
        matrixDramAddr := matrixDramAddr + axiBytes
        when(nextTransferred === matrixTotalElems) {
          state := MemState.IDLE
        } otherwise {
          matrixBeatElems := nextMatrixBeatElems((matrixTotalElems - nextTransferred).resized, matrixUseAccum)
          state := MemState.MATRIX_READ_AR
        }
      } otherwise {
        matrixDrainIndex := nextDrain
      }
    }

    is(MemState.MATRIX_WRITE_GATHER) {
      val issueRead = matrixGatherIssued < matrixBeatElems
      val localAddr = (matrixLocalBase + matrixElemsTransferred.resize(matrixLocalAddrWidth) +
        matrixGatherIssued.resize(matrixLocalAddrWidth)).resize(matrixLocalAddrWidth)

      when(matrixReadPipeValid) {
        when(matrixUseAccum) {
          for (idx <- 0 until accumElemsPerBeat) {
            when(matrixReadPipeIndex === idx) {
              matrixBeatBuffer(idx * cfg.matrixAccumBits, cfg.matrixAccumBits bits) := io.matrixAccumRdData.asBits
            }
          }
        } otherwise {
          for (idx <- 0 until scratchElemsPerBeat) {
            when(matrixReadPipeIndex === idx) {
              when(matrixUseScratchB) {
                matrixBeatBuffer(idx * cfg.matrixElemBits, cfg.matrixElemBits bits) := io.matrixScratchBRdData.asBits
              } otherwise {
                matrixBeatBuffer(idx * cfg.matrixElemBits, cfg.matrixElemBits bits) := io.matrixScratchARdData.asBits
              }
            }
          }
        }
        matrixGatherCaptured := matrixGatherCaptured + 1
      }

      when(issueRead) {
        when(matrixUseAccum) {
          io.matrixAccumAddr := localAddr.resize(cfg.matrixAccumAddrWidth)
          io.matrixAccumEn := True
          io.matrixAccumWe := False
        } otherwise {
          when(matrixUseScratchB) {
            io.matrixScratchBAddr := localAddr.resize(cfg.matrixScratchAddrWidth)
            io.matrixScratchBEn := True
            io.matrixScratchBWe := False
          } otherwise {
            io.matrixScratchAAddr := localAddr.resize(cfg.matrixScratchAddrWidth)
            io.matrixScratchAEn := True
            io.matrixScratchAWe := False
          }
        }
        matrixReadPipeValid := True
        matrixReadPipeIndex := matrixGatherIssued
        matrixGatherIssued := matrixGatherIssued + 1
      } otherwise {
        matrixReadPipeValid := False
      }

      when(!issueRead && matrixReadPipeValid && (matrixGatherCaptured + 1 === matrixBeatElems)) {
        awAccepted := False
        wAccepted := False
        state := MemState.MATRIX_WRITE_AW_W
      }
    }

    is(MemState.MATRIX_WRITE_AW_W) {
      when(!awAccepted) { io.axiMaster.aw.valid := True }
      when(!wAccepted)  { io.axiMaster.w.valid  := True }

      io.axiMaster.aw.addr := matrixDramAddr
      io.axiMaster.aw.len := 0
      io.axiMaster.aw.size := axiSizeVal
      io.axiMaster.w.data := matrixBeatBuffer
      io.axiMaster.w.strb := matrixWriteStrb
      io.axiMaster.w.last := True

      when(io.axiMaster.aw.fire) { awAccepted := True }
      when(io.axiMaster.w.fire)  { wAccepted := True }

      when((io.axiMaster.aw.fire || awAccepted) && (io.axiMaster.w.fire || wAccepted)) {
        awAccepted := False
        wAccepted := False
        state := MemState.MATRIX_WRITE_B
      }
    }

    is(MemState.MATRIX_WRITE_B) {
      io.axiMaster.b.ready := True
      when(io.axiMaster.b.valid) {
        val nextTransferred = matrixElemsTransferred + matrixBeatElems
        matrixElemsTransferred := nextTransferred
        matrixDramAddr := matrixDramAddr + axiBytes
        matrixBeatBuffer := 0
        matrixGatherIssued := 0
        matrixGatherCaptured := 0
        matrixReadPipeValid := False
        matrixReadPipeIndex := 0
        when(nextTransferred === matrixTotalElems) {
          state := MemState.IDLE
        } otherwise {
          matrixBeatElems := nextMatrixBeatElems((matrixTotalElems - nextTransferred).resized, matrixUseAccum)
          state := MemState.MATRIX_WRITE_GATHER
        }
      }
    }

    // ===================== SCOPY_M2V: Matrix → Vector Scratch =====================
    // Reads one word per cycle from matrix accum/scratch, writes to vector scratch.
    // Uses pipelined read (1-cycle BRAM latency), so we issue read then capture next cycle.
    is(MemState.SCOPY_M2V) {
      val localAddr = (scopyMatrixBase + scopyElemIdx.resize(matrixLocalAddrWidth)).resize(matrixLocalAddrWidth)
      val issueRead = scopyElemIdx < scopyTotalElems

      // Capture previous cycle's read result
      when(scopyReadPipeValid) {
        val writeIdx = (scopyElemIdx - 1).resize(log2Up(cfg.vlen + 1) bits)
        val destAddr = (scopyVectorBase + writeIdx.resize(cfg.scratchAddrWidth)).resize(cfg.scratchAddrWidth)
        io.scopyWriteReq.valid := True
        io.scopyWriteReq.addr  := destAddr
        when(scopyUseAccum) {
          io.scopyWriteReq.data := io.matrixAccumRdData.resize(cfg.dataWidth)
        } otherwise {
          when(scopyUseScratchB) {
            io.scopyWriteReq.data := io.matrixScratchBRdData.resize(cfg.dataWidth)
          } otherwise {
            io.scopyWriteReq.data := io.matrixScratchARdData.resize(cfg.dataWidth)
          }
        }
      }

      // Issue read for current element
      when(issueRead) {
        when(scopyUseAccum) {
          io.matrixAccumAddr := localAddr.resize(cfg.matrixAccumAddrWidth)
          io.matrixAccumEn   := True
          io.matrixAccumWe   := False
        } otherwise {
          when(scopyUseScratchB) {
            io.matrixScratchBAddr := localAddr.resize(cfg.matrixScratchAddrWidth)
            io.matrixScratchBEn   := True
            io.matrixScratchBWe   := False
          } otherwise {
            io.matrixScratchAAddr := localAddr.resize(cfg.matrixScratchAddrWidth)
            io.matrixScratchAEn   := True
            io.matrixScratchAWe   := False
          }
        }
        scopyReadPipeValid := True
        scopyElemIdx := scopyElemIdx + 1
      } otherwise {
        scopyReadPipeValid := False
      }

      // Done when last element has been written (one cycle after last read)
      when(!issueRead && !scopyReadPipeValid) {
        state := MemState.IDLE
      }
    }

    // ===================== SCOPY_V2M: Vector Scratch → Matrix =====================
    // Reads one word per cycle from vector scratch, writes to matrix accum/scratch.
    // Uses pipelined read from vector scratch (1-cycle latency).
    is(MemState.SCOPY_V2M) {
      val issueRead = scopyElemIdx < scopyTotalElems

      // Capture previous cycle's vector scratch read result
      when(scopyReadPipeValid) {
        val writeIdx = (scopyElemIdx - 1).resize(log2Up(cfg.vlen + 1) bits)
        val localAddr = (scopyMatrixBase + writeIdx.resize(matrixLocalAddrWidth)).resize(matrixLocalAddrWidth)
        when(scopyUseAccum) {
          io.matrixAccumAddr   := localAddr.resize(cfg.matrixAccumAddrWidth)
          io.matrixAccumEn     := True
          io.matrixAccumWe     := True
          io.matrixAccumWrData := io.scopyReadData.resize(cfg.matrixAccumBits)
        } otherwise {
          when(scopyUseScratchB) {
            io.matrixScratchBAddr   := localAddr.resize(cfg.matrixScratchAddrWidth)
            io.matrixScratchBEn     := True
            io.matrixScratchBWe     := True
            io.matrixScratchBWrData := io.scopyReadData.resize(cfg.matrixElemBits)
          } otherwise {
            io.matrixScratchAAddr   := localAddr.resize(cfg.matrixScratchAddrWidth)
            io.matrixScratchAEn     := True
            io.matrixScratchAWe     := True
            io.matrixScratchAWrData := io.scopyReadData.resize(cfg.matrixElemBits)
          }
        }
      }

      // Issue read from vector scratch for current element
      when(issueRead) {
        val srcAddr = (scopyVectorBase + scopyElemIdx.resize(cfg.scratchAddrWidth)).resize(cfg.scratchAddrWidth)
        io.scopyReadAddr := srcAddr
        io.scopyReadEn   := True
        scopyReadPipeValid := True
        scopyElemIdx := scopyElemIdx + 1
      } otherwise {
        scopyReadPipeValid := False
      }

      // Done when last element has been written
      when(!issueRead && !scopyReadPipeValid) {
        state := MemState.IDLE
      }
    }
  }
}
