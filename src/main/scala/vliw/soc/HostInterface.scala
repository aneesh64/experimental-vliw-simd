package vliw.soc

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axilite._
import vliw.config.VliwSocConfig
import vliw.bundle._

/**
 * Host Interface — AXI4-Lite CSR block for co-processor control.
 *
 * Register map (all 32-bit):
 *   0x000  CTRL         R/W  Bit 0: start (self-clearing pulse)
 *                             Bit 1: soft reset
 *   0x004  STATUS       R    Bit 0: any core running
 *                             Bits [nCores:1]: per-core halted
 *   0x008  CYCLE_COUNT  R    Global cycle counter
 *   0x00C  CORE_COUNT   R    Number of cores (from config)
 *   0x010  VLEN         R    Vector length (from config)
 *   0x014  SCRATCH_SIZE R    Scratch words per core
 *   0x018  IMEM_DEPTH   R    Instructions per core
 *   0x01C  BUNDLE_WIDTH R    Instruction bundle width in bits
 *   0x020  SLOT_CONFIG  R    Packed: nAlu[3:0] nValu[7:4] nLoad[11:8] nStore[15:12]
 *   0x100+4*n CORE_PC[n] R   Per-core current PC
 *   0x200+4*n CORE_CYC[n] R  Per-core cycle count
 */
class HostInterface(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    val axiLite = slave(AxiLite4(cfg.axiLiteConfig))

    // Core control outputs
    val coreStart  = out Vec(Bool(), cfg.nCores)
    val coreReset  = out Vec(Bool(), cfg.nCores)

    // Core status inputs
    val coreHalted  = in Vec(Bool(), cfg.nCores)
    val coreRunning = in Vec(Bool(), cfg.nCores)
    val corePc      = in Vec(UInt(cfg.imemAddrWidth bits), cfg.nCores)
    val coreCycles  = in Vec(UInt(32 bits), cfg.nCores)

    // Interrupt: asserted when all cores halt
    val irq = out Bool()
  }

  val busCtrl = AxiLite4SlaveFactory(io.axiLite)

  // ---- CTRL register (0x000) ----
  val ctrlReg = Reg(Bits(32 bits)) init 0
  busCtrl.readAndWrite(ctrlReg, 0x000)

  // Start pulse: bit 0 rises → pulse → auto-clear
  val startPulse = ctrlReg(0) && !RegNext(ctrlReg(0), init = False)
  val resetPulse = ctrlReg(1) && !RegNext(ctrlReg(1), init = False)

  // Auto-clear start and reset bits after 1 cycle
  when(startPulse) { ctrlReg(0) := False }
  when(resetPulse) { ctrlReg(1) := False }

  for (i <- 0 until cfg.nCores) {
    io.coreStart(i) := startPulse
    io.coreReset(i) := resetPulse
  }

  // ---- STATUS register (0x004) ----
  val statusReg = Bits(32 bits)
  statusReg := 0
  statusReg(0) := io.coreRunning.reduce(_ || _)  // any running
  for (i <- 0 until cfg.nCores) {
    statusReg(i + 1) := io.coreHalted(i)
  }
  busCtrl.read(statusReg, 0x004)

  // ---- CYCLE_COUNT (0x008) ----
  val globalCycleCounter = Reg(UInt(32 bits)) init 0
  when(io.coreRunning.reduce(_ || _)) {
    globalCycleCounter := globalCycleCounter + 1
  }
  busCtrl.read(globalCycleCounter, 0x008)

  // ---- Config read-only registers ----
  busCtrl.read(U(cfg.nCores, 32 bits),      0x00C)
  busCtrl.read(U(cfg.vlen, 32 bits),         0x010)
  busCtrl.read(U(cfg.scratchSize, 32 bits),  0x014)
  busCtrl.read(U(cfg.imemDepth, 32 bits),    0x018)
  busCtrl.read(U(cfg.bundleWidth, 32 bits),  0x01C)

  val slotConfigBits = Bits(32 bits)
  slotConfigBits := 0
  slotConfigBits(3 downto 0)   := B(cfg.nAluSlots, 4 bits)
  slotConfigBits(7 downto 4)   := B(cfg.nValuSlots, 4 bits)
  slotConfigBits(11 downto 8)  := B(cfg.nLoadSlots, 4 bits)
  slotConfigBits(15 downto 12) := B(cfg.nStoreSlots, 4 bits)
  busCtrl.read(slotConfigBits, 0x020)

  // ---- Per-core PC (0x100 + 4*n) ----
  for (i <- 0 until cfg.nCores) {
    busCtrl.read(io.corePc(i).resize(32), 0x100 + i * 4)
  }

  // ---- Per-core cycle count (0x200 + 4*n) ----
  for (i <- 0 until cfg.nCores) {
    busCtrl.read(io.coreCycles(i), 0x200 + i * 4)
  }

  // ---- IRQ: all cores halted (at least one was started) ----
  val anyStarted = RegInit(False)
  when(startPulse) { anyStarted := True }
  when(resetPulse) { anyStarted := False }
  io.irq := anyStarted && io.coreHalted.reduce(_ && _)
}
