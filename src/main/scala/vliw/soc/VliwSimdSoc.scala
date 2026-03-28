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
 *   dmemAxi  : AXI4 master     — DDR data-memory port (connect to DDR controller / Zynq PS HP port)
 *   irq      : interrupt output — all cores halted
 *
 * Internal architecture:
 *   N × VliwCore       → per-core pipeline, engines, banked scratch
 *   MemorySubsystem    → AXI4 crossbar arbitrating N core masters + 1 IMEM loader → 1 DDR master
 *   ImemLoader         → DMA engine that copies program bundles from DDR into per-core IMEM
 *   HostInterface      → CSR register block with cycle counters, control, and IMEM load regs
 *
 * Program and data loading flow:
 *   1. Host writes program bundles and operand data into DDR (via Zynq PS memory controller).
 *   2. Host sets IMEM_SRC_ADDR and IMEM_BUNDLE_COUNT CSRs.
 *   3. Host writes CTRL with LOAD bit → ImemLoader DMA's bundles from DDR into on-chip IMEM.
 *   4. Host writes CTRL with START bit → cores begin execution.
 *   5. Cores pull data from DDR via LOAD/VLOAD and push results via STORE/VSTORE.
 *   6. Host reads results directly from DDR after cores halt.
 */
class VliwSimdSoc(cfg: VliwSocConfig) extends Component {
  setDefinitionName(s"VliwSimdSoc_${cfg.nCores}c")

  val io = new Bundle {
    /** Host CSR access (control, status, config read-out, IMEM load control) */
    val csrAxi  = slave(AxiLite4(cfg.axiLiteConfig))

    /** DDR data-memory master (connect to DDR controller / Zynq PS HP port) */
    val dmemAxi = master(Axi4(cfg.ddrAxiConfig))

    /** Interrupt: asserted when all cores have halted */
    val irq = out Bool()
  }

  // ====================== Cores ======================

  val cores = Array.tabulate(cfg.nCores) { i =>
    new VliwCore(cfg, coreId = i)
  }

  // ====================== IMEM Loader ======================

  val imemLoader = new ImemLoader(cfg)

  // ====================== Memory Subsystem ======================

  val memSub = new MemorySubsystem(cfg)

  // Wire each core's AXI data-memory master → memory subsystem slave port
  for (i <- 0 until cfg.nCores) {
    memSub.io.corePorts(i) <> cores(i).io.dmemAxi
  }

  // Wire IMEM loader's AXI master → memory subsystem loader port
  memSub.io.loaderPort <> imemLoader.io.axiMaster

  // DDR master port → top-level
  io.dmemAxi <> memSub.io.ddrPort

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

  // ====================== IMEM loader wiring ======================

  imemLoader.io.srcAddr     := hostIf.io.imemSrcAddr
  imemLoader.io.bundleCount := hostIf.io.imemBundleCount
  imemLoader.io.start       := hostIf.io.imemLoadStart

  hostIf.io.imemLoaderBusy := imemLoader.io.busy
  hostIf.io.imemLoaderDone := imemLoader.io.done

  // IMEM write: loader drives per-core IMEM write ports
  for (i <- 0 until cfg.nCores) {
    cores(i).io.imemWrite.valid        := imemLoader.io.imemWrite(i).valid
    cores(i).io.imemWrite.payload.addr := imemLoader.io.imemWrite(i).payload.addr
    cores(i).io.imemWrite.payload.data := imemLoader.io.imemWrite(i).payload.data
  }

  // ====================== Core reset from host ======================
  // Soft reset from HostInterface drives a synchronous reset on each core
  // For v1: we use the coreReset signal to reset fetch unit state
  // This requires the core to have a separate reset path; for now,
  // the host writes CTRL.bit1 → we pulse start after loading new program

  // (Soft reset not wired as async reset in v1 — host re-starts after reload)
}
