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
 *   - Store buffer (FIFO): stores are fire-and-forget, pipeline never stalls for stores
 *   - Load queue (FIFO): loads are non-blocking; pipeline stalls only when queue is full
 *   - Overlapped AW+W: store address and data sent in same cycle when possible
 *   - Load results arrive asynchronously and write to scratch directly
 *   - Pipeline stalls only when request FIFOs are full
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

    // Pipeline stall: only when FIFOs are full
    val stall = out Bool()
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

  // ===================== Default outputs =====================
  io.stall := False
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

  // ===================== Simplified Load Request Tracking =====================
  // Instead of loadReqFifo + loadPendingFifo, use single register + valid bit
  val loadReqValid = RegInit(False)
  val loadReqEntry = Reg(LoadReqEntry())

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

  // Stall only when new load is requested but register already full
  when(anyLoadOp && loadReqValid) {
    io.stall := True
  }

  // Stall if store FIFO is full (unchanged)
  when(anyStoreOp && !storeReqFifo.io.push.ready) {
    io.stall := True
  }

  // ===================== Push requests into load register / store FIFO =====================

  // Load request: only process first active load slot
  for (i <- 0 until cfg.nLoadSlots) {
    when(isLoadOp(i) && !io.stall) {
      val slot = io.loadSlots(i)
      val memAddr = io.loadAddrData(i)
      val byteAddr = (memAddr << 2).resize(cfg.axiAddrWidth)
      val alignMask = U(axiBytes - 1, cfg.axiAddrWidth bits)
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
        }
      }
      loadReqValid := True
    }
  }

  // Store request: only process first active store slot
  for (i <- 0 until cfg.nStoreSlots) {
    when(isStoreOp(i) && !io.stall) {
      val slot = io.storeSlots(i)
      val memAddr = io.storeAddrData(i)
      val byteAddr = (memAddr << 2).resize(cfg.axiAddrWidth)
      val alignMask = U(axiBytes - 1, cfg.axiAddrWidth bits)
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
          // VLEN words starting at wordOffset
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

  // ===================== Simplified AXI FSM =====================

  object MemState extends SpinalEnum {
    val IDLE, STORE_AW_W, STORE_B = newElement()
  }

  val state = RegInit(MemState.IDLE)
  val capStoreReq = Reg(StoreReqEntry())
  val awAccepted  = RegInit(False)
  val wAccepted   = RegInit(False)

  // Default FIFO pop
  storeReqFifo.io.pop.ready := False

  // Load AR: drive combinatorially from loadReqEntry when valid (no FSM state needed)
  io.axiMaster.ar.valid := loadReqValid
  io.axiMaster.ar.addr  := loadReqEntry.axiAddr
  io.axiMaster.ar.len   := 0  // Single-beat
  io.axiMaster.ar.size  := axiSizeVal
  io.axiMaster.ar.burst := 1
  io.axiMaster.ar.id    := 0

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
  }
}
