package vliw.config

import spinal.core._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.amba4.axilite._

/**
 * Master configuration for the VLIW SIMD co-processor.
 *
 * Every parameter is user-overridable. FPGA preset objects provide
 * device-specific defaults. The design adapts instruction bundle width,
 * scratch crossbar sizing, and memory technology automatically.
 */
case class VliwSocConfig(
  // ---- Core topology ----
  nCores:          Int = 1,

  // ---- Engine slot counts (per core) ----
  nAluSlots:       Int = 1,       // 1..12 scalar ALU slots
  nValuSlots:      Int = 1,       // 1..6  vector ALU slots
  nLoadSlots:      Int = 1,       // 1..2  memory load slots
  nStoreSlots:     Int = 1,       // 1..2  memory store slots
  nFlowSlots:      Int = 1,       // always 1 (architectural limit)

  // ---- Vector configuration ----
  vlen:            Int = 8,       // lanes per vector operation
  dataWidth:       Int = 32,      // operand width in bits

  // ---- Memory sizing ----
  scratchSize:     Int = 1536,    // scratch words per core
  scratchBanks:    Int = 8,       // bank count (should equal vlen)
  scratchReplicas: Int = 3,       // DEPRECATED — TDP design uses 0 replicas (kept for compat)
  imemDepth:       Int = 4096,    // instruction bundles per core
  mainMemWords:    Int = 65536,   // 32-bit words (shared across cores)

  // ---- Technology hints ----
  useUltraRam:     Boolean = false,
  bramTechnology:  String  = "ramBlock",

  // ---- AXI parameters ----
  axiDataWidth:    Int = 512,     // Full-width AXI4 to fabric (512-bit)
  axiLiteDataWidth: Int = 32,     // AXI4-Lite for CSR/IMEM stays 32-bit
  axiAddrWidth:    Int = 32,
  axiIdWidth:      Int = 4,

  // ---- Pipeline ----
  pipelineStages:  Int = 3,       // 3 = IF | EX | WB

  // ---- Memory engine (non-blocking) ----
  loadQueueDepth:  Int = 16,      // Outstanding load requests
  storeQueueDepth: Int = 16,      // Outstanding store requests

  // ---- Debug / trace ----
  enableWawCheck:  Boolean = true,
  enableTracePort: Boolean = false
) {
  // ---------- Derived constants ----------

  def wordsPerBank:    Int = scratchSize / scratchBanks
  def scratchAddrWidth: Int = log2Up(scratchSize)       // 11 bits for 1536
  def bankAddrWidth:   Int = log2Up(wordsPerBank)       // 8 bits for 192
  def bankSelWidth:    Int = log2Up(scratchBanks)        // 3 bits for 8

  def imemAddrWidth:   Int = log2Up(imemDepth)

  /** Divider latency in clock cycles (start → done). */
  def divLatency:      Int = dataWidth + 1  // 33 for 32-bit operands

  // ---- AXI-512 derived constants ----
  /** Bytes per AXI beat (512/8 = 64). */
  def axiDataBytes:    Int = axiDataWidth / 8
  /** log2 of bytes per beat, used as AXI AxSIZE. */
  def axiSizeLog2:     Int = log2Up(axiDataBytes)
  /** 32-bit words per AXI beat (512/32 = 16). */
  def wordsPerAxiBeat: Int = axiDataWidth / dataWidth
  /** Bits needed to index a word within one AXI beat. */
  def wordOffsetBits:  Int = log2Up(wordsPerAxiBeat)

  // ---- Slot bit-widths (encoding) ----
  def aluSlotWidth:   Int = 40
  def valuSlotWidth:  Int = 56
  def loadSlotWidth:  Int = 48
  def storeSlotWidth: Int = 28
  def flowSlotWidth:  Int = 48

  /** Total instruction bundle width in bits, padded to 64-bit boundary. */
  def bundleWidth: Int = {
    val raw = nAluSlots  * aluSlotWidth  +
              nValuSlots * valuSlotWidth +
              nLoadSlots * loadSlotWidth +
              nStoreSlots * storeSlotWidth +
              nFlowSlots * flowSlotWidth
    ((raw + 63) / 64) * 64
  }

  // ---- Port counts (for scratch crossbar sizing) ----
  /** Scalar read ports: ALU(2 per slot) + Load(1) + Store(2) + Flow(3) */
  def scalarReadPorts: Int =
    nAluSlots * 2 + nLoadSlots * 1 + nStoreSlots * 2 + nFlowSlots * 3

  /** Vector read groups: each VALU slot reads up to 3 operands × VLEN lanes */
  def vectorReadGroups: Int = nValuSlots * 3

  /** Total write ports across all engines */
  def totalWritePorts: Int =
    nAluSlots * 1 +                    // scalar ALU results
    nValuSlots * vlen +                // vector ALU results (per lane)
    nLoadSlots * 1 +                   // load results (scalar load)
    nLoadSlots * 1 +                   // const results
    nLoadSlots * vlen +                // vload results (VLEN writes per load slot)
    nFlowSlots * 1 +                   // flow scalar results (select)
    nFlowSlots * vlen                  // flow vector results (vselect)
    // stores write to memory, not scratch

  // ---- AXI configs ----
  def axiConfig: Axi4Config = Axi4Config(
    addressWidth = axiAddrWidth,
    dataWidth    = axiDataWidth,
    idWidth      = axiIdWidth,
    useBurst     = true,
    useLen       = true,
    useSize      = true,
    useLock      = false,
    useCache     = false,
    useProt      = false,
    useQos       = false,
    useRegion    = false
  )

  def axiLiteConfig: AxiLite4Config = AxiLite4Config(
    addressWidth = axiAddrWidth,
    dataWidth    = axiLiteDataWidth
  )

  // ---- Validation ----
  require(scratchBanks == vlen,
    s"scratchBanks ($scratchBanks) must equal vlen ($vlen) for natural vector striping")
  require(scratchSize % scratchBanks == 0,
    s"scratchSize ($scratchSize) must be divisible by scratchBanks ($scratchBanks)")
  require(isPow2(vlen), s"vlen ($vlen) must be a power of 2")
  require(nFlowSlots == 1, "Only 1 flow slot is architecturally supported")
  require(pipelineStages == 3, "3-stage pipeline (IF|EX|WB) is the current architecture")
  require(axiDataWidth >= dataWidth, s"axiDataWidth ($axiDataWidth) must be >= dataWidth ($dataWidth)")
  require(nAluSlots >= 1 && nAluSlots <= 12)
  require(nValuSlots >= 1 && nValuSlots <= 6)
  require(nLoadSlots >= 1 && nLoadSlots <= 2)
  require(nStoreSlots >= 1 && nStoreSlots <= 2)

  private def isPow2(x: Int): Boolean = x > 0 && (x & (x - 1)) == 0
}

// ============================================================================
//  FPGA Preset Configurations
// ============================================================================

object VliwSocConfig {

  /** Xilinx Kintex-7 XC7K325T: 445 BRAM36K, 840 DSP48E1, 204K LUT */
  def Kintex7_325T: VliwSocConfig = VliwSocConfig(
    nCores       = 2,
    nAluSlots    = 1,
    nValuSlots   = 1,
    nLoadSlots   = 1,
    nStoreSlots  = 1,
    imemDepth    = 2048,
    mainMemWords = 32768,
    useUltraRam  = false
  )

  /** Xilinx Kintex-7 XC7K480T: 955 BRAM36K, 1920 DSP48E1, 299K LUT */
  def Kintex7_480T: VliwSocConfig = VliwSocConfig(
    nCores       = 4,
    nAluSlots    = 1,
    nValuSlots   = 1,
    nLoadSlots   = 1,
    nStoreSlots  = 1,
    imemDepth    = 2048,
    mainMemWords = 65536,
    useUltraRam  = false
  )

  /** Xilinx Kintex UltraScale XCKU060: 1080 BRAM36K, 2760 DSP48E2, 332K LUT */
  def KintexU_060: VliwSocConfig = VliwSocConfig(
    nCores       = 4,
    nAluSlots    = 2,
    nValuSlots   = 1,
    nLoadSlots   = 2,
    nStoreSlots  = 2,
    imemDepth    = 4096,
    mainMemWords = 65536,
    useUltraRam  = false
  )

  /** Xilinx Kintex UltraScale+ XCKU15P: 984 BRAM36K, 1968 DSP48E2, 523K LUT, 128 URAM */
  def KintexUP_15P: VliwSocConfig = VliwSocConfig(
    nCores       = 8,
    nAluSlots    = 2,
    nValuSlots   = 1,
    nLoadSlots   = 2,
    nStoreSlots  = 2,
    imemDepth    = 4096,
    mainMemWords = 65536,
    useUltraRam  = true
  )

  /** Minimal configuration for simulation & verification. */
  def Sim: VliwSocConfig = VliwSocConfig(
    nCores       = 1,
    nAluSlots    = 1,
    nValuSlots   = 1,
    nLoadSlots   = 1,
    nStoreSlots  = 1,
    imemDepth    = 1024,
    mainMemWords = 16384,
    useUltraRam  = false,
    loadQueueDepth  = 8,
    storeQueueDepth = 8
  )
}
