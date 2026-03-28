package vliw.soc

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import vliw.config.VliwSocConfig
import vliw.bundle._

/**
 * IMEM Loader — DMA engine that copies instruction bundles from DDR into
 * per-core on-chip instruction memory.
 *
 * DDR layout: each bundle is stored in one AXI beat (axiDataWidth bits).
 * The lower bundleWidth bits hold the instruction bundle, upper bits are
 * zero-padded.  Bundles are stored at consecutive beat-aligned addresses:
 *
 *     srcAddr + 0 * axiDataBytes : bundle[0]
 *     srcAddr + 1 * axiDataBytes : bundle[1]
 *     ...
 *     srcAddr + (N-1) * axiDataBytes : bundle[N-1]
 *
 * The loader issues single-beat AXI4 reads, extracts the lower bundleWidth
 * bits, and writes them to every core's IMEM via the existing Flow(ImemWriteCmd)
 * ports.
 *
 * Control flow (driven by HostInterface CSRs):
 *   1. Host writes IMEM_SRC_ADDR and IMEM_BUNDLE_COUNT.
 *   2. Host writes CTRL with LOAD bit set → start pulse.
 *   3. Loader transitions IDLE → AR_REQ, reads bundles one by one.
 *   4. When all bundles are loaded, loader enters DONE state.
 *   5. Host can then start execution via CTRL.START.
 */
class ImemLoader(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    /** AXI4 master port — reads instruction bundles from DDR */
    val axiMaster = master(Axi4(cfg.axiConfig))

    /** Per-core IMEM write ports */
    val imemWrite = Vec(master(Flow(ImemWriteCmd(cfg))), cfg.nCores)

    /** DDR byte address where program bundles start */
    val srcAddr = in UInt(cfg.axiAddrWidth bits)

    /** Number of bundles to load (0..imemDepth-1) */
    val bundleCount = in UInt(cfg.imemAddrWidth bits)

    /** Start pulse — triggers loading from IDLE or DONE */
    val start = in Bool()

    /** High while the loader is actively transferring */
    val busy = out Bool()

    /** High when loading has completed (stays until next start) */
    val done = out Bool()
  }

  // ---------- State machine ----------

  val sIdle  = U"00"
  val sArReq = U"01"
  val sRWait = U"10"
  val sDone  = U"11"

  val state     = RegInit(sIdle)
  val bundleIdx = Reg(UInt(cfg.imemAddrWidth bits)) init 0

  io.busy := state =/= sIdle && state =/= sDone
  io.done := state === sDone

  // ---------- AXI4 read-only master defaults ----------

  val axiSizeVal = U(log2Up(cfg.axiDataBytes), 3 bits)

  // Write channels: permanently idle (read-only master)
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

  // Read channels: defaults (overridden in state machine)
  io.axiMaster.ar.valid := False
  io.axiMaster.ar.addr  := 0
  io.axiMaster.ar.len   := 0
  io.axiMaster.ar.size  := axiSizeVal
  io.axiMaster.ar.burst := 1
  io.axiMaster.ar.id    := 0

  io.axiMaster.r.ready := False

  // ---------- IMEM write defaults ----------

  for (i <- 0 until cfg.nCores) {
    io.imemWrite(i).valid        := False
    io.imemWrite(i).payload.addr := 0
    io.imemWrite(i).payload.data := 0
  }

  // ---------- FSM ----------

  switch(state) {
    is(sIdle) {
      when(io.start) {
        bundleIdx := 0
        state     := sArReq
      }
    }

    is(sArReq) {
      when(bundleIdx >= io.bundleCount) {
        state := sDone
      } otherwise {
        // Issue single-beat AXI read: srcAddr + bundleIdx * axiDataBytes
        io.axiMaster.ar.valid := True
        io.axiMaster.ar.addr  := (io.srcAddr + (bundleIdx << log2Up(cfg.axiDataBytes)).resize(cfg.axiAddrWidth)).resized
        io.axiMaster.ar.len   := 0        // single beat
        io.axiMaster.ar.size  := axiSizeVal
        io.axiMaster.ar.burst := 1        // INCR

        when(io.axiMaster.ar.fire) {
          state := sRWait
        }
      }
    }

    is(sRWait) {
      io.axiMaster.r.ready := True

      when(io.axiMaster.r.fire) {
        // Extract lower bundleWidth bits from the AXI data beat
        val bundleData = io.axiMaster.r.data.resize(cfg.bundleWidth)

        // Write to all cores' IMEM simultaneously
        for (i <- 0 until cfg.nCores) {
          io.imemWrite(i).valid        := True
          io.imemWrite(i).payload.addr := bundleIdx.resized
          io.imemWrite(i).payload.data := bundleData
        }

        bundleIdx := bundleIdx + 1
        state     := sArReq
      }
    }

    is(sDone) {
      when(io.start) {
        bundleIdx := 0
        state     := sArReq
      }
    }
  }
}
