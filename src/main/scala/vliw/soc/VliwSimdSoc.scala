package vliw.soc

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.amba4.axilite._
import vliw.config.VliwSocConfig
import vliw.bundle._
import vliw.core.VliwCore

/**
 * VliwSimdSoc — Top-level co-processor SoC.
 *
 * External interfaces:
 *   csrAxi   : AXI4-Lite slave — host-facing CSR register map (HostInterface)
 *   imemAxi  : AXI4-Lite slave — host writes instruction memory (broadcast to all cores or per-core)
 *   dmemAxi  : AXI4 slave      — host access to shared data memory
 *   irq      : interrupt output — all cores halted
 *
 * Internal architecture:
 *   N × VliwCore    → per-core pipeline, engines, banked scratch
 *   MemorySubsystem → shared BRAM/URAM with AXI4 crossbar  (N core ports + 1 host port)
 *   HostInterface   → CSR register block with cycle counters and control
 */
class VliwSimdSoc(cfg: VliwSocConfig) extends Component {
  setDefinitionName(s"VliwSimdSoc_${cfg.nCores}c")

  val io = new Bundle {
    /** Host CSR access (control, status, config read-out) */
    val csrAxi  = slave(AxiLite4(cfg.axiLiteConfig))

    /** Host instruction memory write port */
    val imemAxi = slave(AxiLite4(cfg.axiLiteConfig))

    /** Host data memory access port */
    val dmemAxi = slave(Axi4(cfg.axiConfig))

    /** Interrupt: asserted when all cores have halted */
    val irq = out Bool()
  }

  // ====================== Cores ======================

  val cores = Array.tabulate(cfg.nCores) { i =>
    new VliwCore(cfg, coreId = i)
  }

  // ====================== Memory Subsystem ======================

  val memSub = new MemorySubsystem(cfg)

  // Wire each core's AXI data-memory master → memory subsystem slave port
  for (i <- 0 until cfg.nCores) {
    memSub.io.corePorts(i) <> cores(i).io.dmemAxi
  }

  // Host data-memory port
  memSub.io.hostPort <> io.dmemAxi

  // ====================== Host Interface (CSR) ======================

  val hostIf = new HostInterface(cfg)
  hostIf.io.axiLite <> io.csrAxi

  for (i <- 0 until cfg.nCores) {
    hostIf.io.coreHalted(i)  := cores(i).io.halted
    hostIf.io.coreRunning(i) := cores(i).io.running
    hostIf.io.corePc(i)      := cores(i).io.pc
    hostIf.io.coreCycles(i)  := cores(i).io.cycleCount

    cores(i).io.start := hostIf.io.coreStart(i)
  }

  io.irq := hostIf.io.irq

  // ====================== IMEM loading via AXI4-Lite ======================
  // 
  // The host writes instruction bundles through the imemAxi port.
  // Address encoding:
  //   Bits [31 : imemAddrWidth + log2Up(bundleBytes) + coreSelWidth] : unused/reserved
  //   Bits [coreSelWidth + imemAddrWidth + log2Up(bundleBytes) - 1 : imemAddrWidth + log2Up(bundleBytes)] : core select
  //   Bits [imemAddrWidth + log2Up(bundleBytes) - 1 : log2Up(bundleBytes)] : instruction address
  //   Bits [log2Up(bundleBytes) - 1 : 0] : word within bundle
  //
  // Since the bundle is wider than 32 bits, the host writes one 32-bit word 
  // at a time. A small shim accumulates words and issues a full-width write 
  // once the last word in a bundle is written.
  //
  // For v1 simplicity: bundle width may be large. We use a shift-register 
  // accumulator that collects 32-bit chunks and commits on the last one.

  val bundleBytes  = cfg.bundleWidth / 8
  val wordsPerBundle = cfg.bundleWidth / cfg.axiLiteDataWidth
  val wordAddrBits = if (wordsPerBundle > 1) log2Up(wordsPerBundle) else 0
  val coreBits     = if (cfg.nCores > 1) log2Up(cfg.nCores) else 0
  val bytesPerWord = cfg.axiLiteDataWidth / 8
  val byteAddrBits = log2Up(bytesPerWord)

  // AXI4-Lite write channel handling
  val imemBusCtrl = new Area {
    val axiLite = io.imemAxi

    // Simple AXI4-Lite slave: accept writes, ACK immediately
    val awReady = RegInit(True)
    val wReady  = RegInit(True)
    val bValid  = RegInit(False)

    axiLite.aw.ready := awReady
    axiLite.w.ready  := wReady
    axiLite.b.valid  := bValid
    axiLite.b.resp   := B"00"  // OKAY

    // Read channel: not used, tie off
    axiLite.ar.ready := False
    axiLite.r.valid  := False
    axiLite.r.data   := 0
    axiLite.r.resp   := B"00"

    // Capture AW and W
    val awAddr = Reg(UInt(cfg.axiAddrWidth bits))
    val wData  = Reg(Bits(cfg.axiDataWidth bits))
    val awFire = Bool()
    val wFire  = Bool()
    awFire := axiLite.aw.valid && axiLite.aw.ready
    wFire  := axiLite.w.valid && axiLite.w.ready

    when(awFire) { awAddr := axiLite.aw.addr }
    when(wFire)  { wData  := axiLite.w.data }

    // Both fired → process
    val bothFired = RegInit(False)
    val awDone    = RegInit(False)
    val wDone     = RegInit(False)

    when(awFire && wFire) {
      bothFired := True
      awDone    := False
      wDone     := False
      awReady   := False
      wReady    := False
    } elsewhen (awFire) {
      awDone  := True
      awReady := False
    } elsewhen (wFire) {
      wDone   := True
      wReady  := False
    }

    when(awDone && wFire) {
      bothFired := True
      awDone    := False
      wDone     := False
      awReady   := False
      wReady    := False
    }
    when(wDone && awFire) {
      bothFired := True
      awDone    := False
      wDone     := False
      awReady   := False
      wReady    := False
    }

    // Bundle accumulator
    val accumulator = Reg(Bits(cfg.bundleWidth bits)) init 0
    val wordIdx     = if (wordsPerBundle > 1) {
      (awAddr >> byteAddrBits).resize(wordAddrBits)
    } else {
      U(0, 1 bits)
    }

    val instrAddr = if (wordAddrBits > 0) {
      (awAddr >> (byteAddrBits + wordAddrBits)).resize(cfg.imemAddrWidth)
    } else {
      (awAddr >> byteAddrBits).resize(cfg.imemAddrWidth)
    }

    val coreSelect = if (coreBits > 0) {
      (awAddr >> (byteAddrBits + wordAddrBits + cfg.imemAddrWidth)).resize(coreBits)
    } else {
      U(0, 1 bits)
    }

    val isLastWord = if (wordsPerBundle > 1) (wordIdx === U(wordsPerBundle - 1)) else True

    // Write accumulated word
    when(bothFired) {
      if (wordsPerBundle > 1) {
        val lo = wordIdx * cfg.axiLiteDataWidth
        for (b <- 0 until cfg.axiLiteDataWidth) {
          accumulator(lo.resize(log2Up(cfg.bundleWidth)) + b) := wData(b)
        }
      } else {
        accumulator := wData.resize(cfg.bundleWidth)
      }
    }

    // Commit to IMEM when last word written
    val commitValid = RegNext(bothFired && isLastWord) init False
    val commitAddr  = RegNext(instrAddr)
    val commitCore  = RegNext(coreSelect)
    val commitData  = Reg(Bits(cfg.bundleWidth bits))

    when(bothFired && isLastWord) {
      // Build the final bundle with the last word included
      commitData := accumulator
      if (wordsPerBundle > 1) {
        val lo = wordIdx * cfg.axiLiteDataWidth
        for (b <- 0 until cfg.axiLiteDataWidth) {
          commitData(lo.resize(log2Up(cfg.bundleWidth)) + b) := wData(b)
        }
      } else {
        commitData := wData.resize(cfg.bundleWidth)
      }
    }

    // Drive IMEM write ports
    for (i <- 0 until cfg.nCores) {
      cores(i).io.imemWrite.valid := commitValid && (if (coreBits > 0) commitCore === U(i) else True)
      cores(i).io.imemWrite.payload.addr := commitAddr.resize(cfg.imemAddrWidth)
      cores(i).io.imemWrite.payload.data := commitData
    }

    // B response
    when(bothFired) {
      bValid := True
    }
    when(axiLite.b.valid && axiLite.b.ready) {
      bValid    := False
      awReady   := True
      wReady    := True
      bothFired := False
    }
  }

  // ====================== Core reset from host ======================
  // Soft reset from HostInterface drives a synchronous reset on each core
  // For v1: we use the coreReset signal to reset fetch unit state
  // This requires the core to have a separate reset path; for now,
  // the host writes CTRL.bit1 → we pulse start after loading new program

  // (Soft reset not wired as async reset in v1 — host re-starts after reload)
}
