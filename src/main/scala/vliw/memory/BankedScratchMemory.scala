package vliw.memory

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig

/**
 * True Dual-Port BRAM bank.
 *
 * Both ports are full read/write with readFirst semantics.
 * SpinalHDL emits Verilog that Xilinx Vivado infers as RAMB18E1/RAMB36E1
 * in True Dual-Port mode.
 *
 * Technology selection:
 *   ramBlock (default):  Block RAM, synchronous 1-cycle read latency.
 *     Each bank = wordsPerBank * dataWidth bits (e.g., 192*32 = 6 Kbit
 *     → fits in one RAMB18E1).
 *
 *   ramDistributed:  LUT-based distributed RAM.
 *     Asynchronous reads (0-cycle latency) — could eliminate 1 pipeline stage.
 *     Cost ≈ 96 LUT6 per bank (768 total for 8 banks) per read port.
 *     Practical only when BRAMs are scarce or for very small scratch sizes.
 *     To switch: change `ramBlock` to `ramDistributed` below and consider
 *     using `mem.readAsync()` for true 0-latency reads (requires pipeline changes).
 */
class TdpBank(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    // Port A
    val aAddr   = in  UInt(cfg.bankAddrWidth bits)
    val aEn     = in  Bool()
    val aWe     = in  Bool()
    val aWrData = in  UInt(cfg.dataWidth bits)
    val aRdData = out UInt(cfg.dataWidth bits)
    // Port B
    val bAddr   = in  UInt(cfg.bankAddrWidth bits)
    val bEn     = in  Bool()
    val bWe     = in  Bool()
    val bWrData = in  UInt(cfg.dataWidth bits)
    val bRdData = out UInt(cfg.dataWidth bits)
  }

  val mem = Mem(UInt(cfg.dataWidth bits), cfg.wordsPerBank)
  mem.setTechnology(ramBlock)

  // Port A: synchronous read-only (no write — aWe/aWrData unused in TDP bank,
  // kept in interface for future extensibility or alternate BRAM modes).
  io.aRdData := mem.readSync(
    address = io.aAddr,
    enable  = io.aEn
  )

  // Port B: synchronous read/write.
  // readUnderWrite = dontCare is the only mode SpinalHDL supports for Verilog
  // emission of readWriteSync.  Cross-port RAW (Port A reads while Port B
  // writes same address) is handled by the forwarding logic in BankedScratchMemory.
  io.bRdData := mem.readWriteSync(
    address = io.bAddr,
    data    = io.bWrData,
    enable  = io.bEn,
    write   = io.bWe,
    readUnderWrite = dontCare
  )
}

/**
 * Banked scratch memory — VLEN banks of True Dual-Port BRAM (no replicas).
 *
 * Architecture (replaces previous 3-replica SDP design):
 *   Old: 8 banks x 3 replicas = 24 SDP BRAMs (broadcast write to all replicas)
 *   New: 8 banks x 1 TDP BRAM = 8 TDP BRAMs (67% BRAM savings)
 *
 * Port allocation per bank per clock cycle:
 *   Port A — Read-only port.
 *     When !valuActive: serves scalar reads (ALU/Load/Store/Flow/VALU_src3)
 *     When  valuActive: serves VALU vsrc1 (lane i -> bank i, natural striping)
 *
 *   Port B — Read/Write port.
 *     Write mode (priority): serves WB writes from all engines.
 *     Read  mode (when no WB write pending for this bank):
 *       When valuActive: serves VALU vsrc2 (lane i -> bank i)
 *       Otherwise:       idle (future: secondary scalar read)
 *
 * Write forwarding (register bypass):
 *   readFirst returns OLD value when Port A reads and Port B writes the same
 *   address in the same cycle.  With the 3-stage pipeline (IF|EX|WB), the
 *   bypass compares CURRENT WB write address with PREVIOUS cycle's read
 *   address (the EX-stage read presented one cycle earlier). This detects
 *   the RAW hazard and substitutes the write data.  Reduces effective
 *   RAW latency from 2 bundles to 1 bundle (NORMAL_LATENCY = 1 in scheduler).
 *
 * Address mapping (unchanged):
 *   bank  = addr % scratchBanks     (addr[bankSelWidth-1 : 0])
 *   row   = addr / scratchBanks     (addr[addrWidth-1 : bankSelWidth])
 *
 * Scheduler constraints:
 *   SC1: At most 1 scalar read per bank per bundle (Port A has 1 addr input).
 *   SC2: At most 1 write per bank per bundle (Port B has 1 addr input).
 *   SC3: VALU reads claim both ports on all banks — no scalar engines may
 *        also read from scratch in a VALU bundle.
 *
 * Pipeline depth discussion:
 *   Current 3-stage (IF | EX | WB) temporally separates reads (address in IF,
 *   data in EX) from writes (WB). The write forwarding bypass compares
 *   current WB writes with previous-cycle EX read addresses, enabling
 *   NORMAL_LATENCY = 1 without false-positive hazards.  This is optimal
 *   for the workload: tight dependency chains benefit from low latency.
 */
class BankedScratchMemory(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    // ---- VALU vector reads: nValuSlots * 2 operand groups, each VLEN lanes ----
    val valuReadAddr = in  Vec(Vec(UInt(cfg.scratchAddrWidth bits), cfg.vlen), cfg.nValuSlots * 2)
    val valuReadEn   = in  Vec(Vec(Bool(), cfg.vlen), cfg.nValuSlots * 2)
    val valuReadData = out Vec(Vec(UInt(cfg.dataWidth bits), cfg.vlen), cfg.nValuSlots * 2)

    // ---- Scalar reads: ALU + Load + Store + Flow + VALU src3 ----
    val scalarReadAddr = in  Vec(UInt(cfg.scratchAddrWidth bits), cfg.scalarReadPorts + cfg.nValuSlots)
    val scalarReadEn   = in  Vec(Bool(), cfg.scalarReadPorts + cfg.nValuSlots)
    val scalarReadData = out Vec(UInt(cfg.dataWidth bits), cfg.scalarReadPorts + cfg.nValuSlots)

    // ---- Write ports (from all engines) ----
    val writeAddr = in Vec(UInt(cfg.scratchAddrWidth bits), cfg.totalWritePorts)
    val writeData = in Vec(UInt(cfg.dataWidth bits), cfg.totalWritePorts)
    val writeEn   = in Vec(Bool(), cfg.totalWritePorts)

    // ---- VALU active flag ----
    val valuActive = in Bool()

    // ---- Vector/scalar arbitration control ----
    // vectorReadActive enables vector read groups.
    // blockScalarReads blocks scalar read routing while vector reads own ports.
    val vectorReadActive = in Bool()
    val blockScalarReads = in Bool()

    // ---- Bank conflict indication (debug — scheduler should prevent) ----
    val conflict = out Bool()
  }

  // ======================== Bank array ========================
  val banks = Array.tabulate(cfg.scratchBanks)(b => new TdpBank(cfg))

  // ======================== Address decomposition ========================
  def bankOf(addr: UInt): UInt = addr(cfg.bankSelWidth - 1 downto 0)
  def rowOf(addr: UInt):  UInt = addr(cfg.scratchAddrWidth - 1 downto cfg.bankSelWidth)

  // ======================== Defaults ========================
  for (b <- 0 until cfg.scratchBanks) {
    banks(b).io.aAddr   := 0
    banks(b).io.aEn     := False
    banks(b).io.aWe     := False
    banks(b).io.aWrData := 0
    banks(b).io.bAddr   := 0
    banks(b).io.bEn     := False
    banks(b).io.bWe     := False
    banks(b).io.bWrData := 0
  }
  io.conflict := False

  // ======================== Write crossbar (Port B, write mode) ========================
  // Route each write to Port B of its target bank.
  // Scheduler guarantees at most 1 write per bank per cycle.
  // Last-assignment-wins: higher-index write port has priority (same as before).
  val bankWriteActive = Vec(Bool(), cfg.scratchBanks)
  for (b <- 0 until cfg.scratchBanks) bankWriteActive(b) := False

  val totalWrites = cfg.totalWritePorts
  for (w <- 0 until totalWrites) {
    when(io.writeEn(w)) {
      val bk  = bankOf(io.writeAddr(w))
      val row = rowOf(io.writeAddr(w))
      for (b <- 0 until cfg.scratchBanks) {
        when(bk === b) {
          banks(b).io.bAddr   := row
          banks(b).io.bEn     := True
          banks(b).io.bWe     := True
          banks(b).io.bWrData := io.writeData(w)
          bankWriteActive(b)  := True
        }
      }
    }
  }

  // ======================== Scalar read crossbar (Port A primary, Port B secondary) ========================
  // TDP provides 2 reads per bank per cycle (Port A + Port B).
  // Port A: 1st scalar read per bank     Port B: 2nd scalar read (if no WB write)
  // With VALU active, both ports serve vector reads; scalar reads are blocked.
  //
  // Implementation: per-bank priority scan.  For each bank b, scan all scalar
  // read ports in priority order.  The first enabled port gets Port A, the
  // second gets Port B (if available).  Third+ → conflict.
  // This uses a prefix-OR chain per bank — no combinational feedback loops.

  val scalarCount = cfg.scalarReadPorts + cfg.nValuSlots
  for (i <- 0 until scalarCount) io.scalarReadData(i) := 0

  val scalarBankReq = Vec(UInt(cfg.bankSelWidth bits), scalarCount)
  val scalarBankRow = Vec(UInt(cfg.bankAddrWidth bits), scalarCount)
  for (i <- 0 until scalarCount) {
    scalarBankReq(i) := bankOf(io.scalarReadAddr(i))
    scalarBankRow(i) := rowOf(io.scalarReadAddr(i))
  }

  // Track which port each scalar read uses (for output mux alignment)
  val scalarUsedPortB = Vec(Bool(), scalarCount)
  for (i <- 0 until scalarCount) scalarUsedPortB(i) := False

  // Per-bank priority scan using prefix-OR chains (no feedback)
  for (b <- 0 until cfg.scratchBanks) {
    // Scala vars hold SpinalHDL signals — each loop iteration creates a
    // NEW signal derived from the previous one.  No combinational loop.
    var anyBefore: Bool = False
    var twoBefore: Bool = False

    for (i <- 0 until scalarCount) {
      val isCandidate = io.scalarReadEn(i) && !io.blockScalarReads &&
                        (scalarBankReq(i) === U(b, cfg.bankSelWidth bits))

      val isFirst  = isCandidate && !anyBefore
      val isSecond = isCandidate &&  anyBefore && !twoBefore
      val isThird  = isCandidate &&  twoBefore

      // Advance prefix state (new signals, no feedback)
      val nextTwoBefore = twoBefore || (anyBefore && isCandidate)
      val nextAnyBefore = anyBefore || isCandidate
      anyBefore = nextAnyBefore
      twoBefore = nextTwoBefore

      // First reader → Port A
      when(isFirst) {
        banks(b).io.aAddr := scalarBankRow(i)
        banks(b).io.aEn   := True
      }

      // Second reader → Port B (only when Port B is not writing to this bank)
      when(isSecond && !bankWriteActive(b)) {
        banks(b).io.bAddr := scalarBankRow(i)
        banks(b).io.bEn   := True
        banks(b).io.bWe   := False
        scalarUsedPortB(i) := True
      }

      // Conflict cases
      when(isSecond && bankWriteActive(b)) {
        io.conflict := True   // Port B busy with write
      }
      when(isThird) {
        io.conflict := True   // 3+ reads to same bank
      }
    }
  }

  // Register bank and port selection for output mux (1-cycle BRAM latency)
  val scalarBankReqReg   = Vec(Reg(UInt(cfg.bankSelWidth bits)) init 0, scalarCount)
  val scalarUsedPortBReg = Vec(Reg(Bool()) init False, scalarCount)
  for (i <- 0 until scalarCount) {
    scalarBankReqReg(i)   := scalarBankReq(i)
    scalarUsedPortBReg(i) := scalarUsedPortB(i)
  }

  // Output data mux: select Port A or Port B read data from the correct bank
  for (i <- 0 until scalarCount) {
    for (b <- 0 until cfg.scratchBanks) {
      when(scalarBankReqReg(i) === b) {
        when(scalarUsedPortBReg(i)) {
          io.scalarReadData(i) := banks(b).io.bRdData
        } otherwise {
          io.scalarReadData(i) := banks(b).io.aRdData
        }
      }
    }
  }

  // ======================== VALU vector reads ========================
  // Even groups (g=0,2,...) = vsrc1 -> Port A (when valuActive)
  // Odd  groups (g=1,3,...) = vsrc2 -> Port B read mode (when valuActive && no WB write)
  for (g <- 0 until cfg.nValuSlots * 2) {
    val usePortA = (g % 2 == 0)
    for (lane <- 0 until cfg.vlen) {
      val addr    = io.valuReadAddr(g)(lane)
      val en      = io.valuReadEn(g)(lane)
      val bankIdx = bankOf(addr)
      val row     = rowOf(addr)

      val bankIdxReg = RegNext(bankIdx) init 0

      for (b <- 0 until cfg.scratchBanks) {
        when(bankIdx === b && en) {
          if (usePortA) {
            // vsrc1 -> Port A (when valuActive)
            when(io.vectorReadActive) {
              banks(b).io.aAddr := row
              banks(b).io.aEn   := True
            }
          } else {
            // vsrc2 -> Port B read mode (only when not writing to this bank)
            when(io.vectorReadActive && !bankWriteActive(b)) {
              banks(b).io.bAddr  := row
              banks(b).io.bEn    := True
              banks(b).io.bWe    := False
            }
          }
        }
      }

      // Output mux — select the right bank output
      val readData = UInt(cfg.dataWidth bits)
      readData := 0
      for (b <- 0 until cfg.scratchBanks) {
        when(bankIdxReg === b) {
          if (usePortA) {
            readData := banks(b).io.aRdData
          } else {
            readData := banks(b).io.bRdData
          }
        }
      }
      io.valuReadData(g)(lane) := readData
    }
  }

  // ======================== Write forwarding (bypass) — 3-stage pipeline ========================
  // TDP readFirst semantics: when Port B writes addr X and Port A reads addr X
  // in the same clock cycle, the BRAM output is the OLD value.
  //
  // With the 3-stage pipeline (IF|EX|WB):
  //   - WB writes at cycle T (io.writeAddr/writeData/writeEn driven by WB stage)
  //   - EX reads at cycle T (BRAM output for address presented at cycle T-1)
  //
  // TWO forwarding paths are needed because of the 3-stage structure:
  //
  // Gap-1 forwarding:
  //   Producer at bundle N, consumer at bundle N+1.
  //   Producer WB drives write ports at cycle T+1. Consumer EX uses BRAM data at T+1.
  //   The BRAM write (edge T+2) happens AFTER the read (edge T+1), so the read
  //   returns stale data. Compare CURRENT write with PREVIOUS read address:
  //     if io.writeAddr[w] == prevScalarReadAddr[i] && io.writeEn[w] → substitute
  //
  // Gap-2 forwarding:
  //   Producer at bundle N, consumer at bundle N+2.
  //   Producer WB write and consumer IF read present addresses in the SAME cycle.
  //   Both are captured at the SAME BRAM edge → cross-port collision (undefined).
  //   Compare CURRENT write with CURRENT read address; register the match and
  //   apply the forwarded data one cycle later (when BRAM output is available):
  //     if io.writeAddr[w] == io.scalarReadAddr[i] → register, apply next cycle
  //
  // Gap-3+: no collision; BRAM already contains correct value.

  // ---- Gap-2 forwarding registers ----
  val fwdGap2Valid = Vec(Reg(Bool()) init False, scalarCount)
  val fwdGap2Data  = Vec(Reg(UInt(cfg.dataWidth bits)), scalarCount)

  for (i <- 0 until scalarCount) {
    // Detect same-cycle write/read address match
    var anyMatch: Bool = False
    val matchData = UInt(cfg.dataWidth bits)
    matchData := 0  // default (overridden by when blocks via last-assignment-wins)

    for (w <- 0 until totalWrites) {
      val hit = io.writeEn(w) && io.scalarReadEn(i) &&
                io.writeAddr(w) === io.scalarReadAddr(i)
      when(hit) {
        matchData := io.writeData(w)  // SpinalHDL :=, properly conditional
      }
      anyMatch = anyMatch || hit
    }

    fwdGap2Valid(i) := anyMatch
    fwdGap2Data(i)  := matchData
  }

  // ---- Previous-cycle read tracking (for gap-1 forwarding) ----

  val prevScalarReadEn   = Vec(Reg(Bool()) init False, scalarCount)
  val prevScalarReadAddr = Vec(Reg(UInt(cfg.scratchAddrWidth bits)) init 0, scalarCount)
  for (i <- 0 until scalarCount) {
    prevScalarReadEn(i)   := io.scalarReadEn(i)
    prevScalarReadAddr(i) := io.scalarReadAddr(i)
  }

  // ---- Apply gap-2 forwarding (lower priority) ----
  for (i <- 0 until scalarCount) {
    when(fwdGap2Valid(i)) {
      io.scalarReadData(i) := fwdGap2Data(i)
    }
  }

  // ---- Apply gap-1 forwarding (higher priority, last-assignment-wins) ----
  for (i <- 0 until scalarCount) {
    for (w <- 0 until totalWrites) {
      when(io.writeEn(w) && prevScalarReadEn(i) &&
           io.writeAddr(w) === prevScalarReadAddr(i)) {
        io.scalarReadData(i) := io.writeData(w)
      }
    }
  }

  // ---- Vector read forwarding (VALU/VSTORE vector groups) ----
  val valuGroups = cfg.nValuSlots * 2

  // Gap-2 registers for vector reads
  val fwdValuGap2Valid = Vec(Vec(Reg(Bool()) init False, cfg.vlen), valuGroups)
  val fwdValuGap2Data  = Vec(Vec(Reg(UInt(cfg.dataWidth bits)), cfg.vlen), valuGroups)

  for (g <- 0 until valuGroups) {
    for (lane <- 0 until cfg.vlen) {
      var anyMatch: Bool = False
      val matchData = UInt(cfg.dataWidth bits)
      matchData := 0

      for (w <- 0 until totalWrites) {
        val hit = io.writeEn(w) && io.valuReadEn(g)(lane) &&
                  io.writeAddr(w) === io.valuReadAddr(g)(lane)
        when(hit) {
          matchData := io.writeData(w)
        }
        anyMatch = anyMatch || hit
      }

      fwdValuGap2Valid(g)(lane) := anyMatch
      fwdValuGap2Data(g)(lane)  := matchData
    }
  }

  // Previous-cycle vector read tracking for gap-1 forwarding
  val prevValuReadEn   = Vec(Vec(Reg(Bool()) init False, cfg.vlen), valuGroups)
  val prevValuReadAddr = Vec(Vec(Reg(UInt(cfg.scratchAddrWidth bits)) init 0, cfg.vlen), valuGroups)

  for (g <- 0 until valuGroups) {
    for (lane <- 0 until cfg.vlen) {
      prevValuReadEn(g)(lane)   := io.valuReadEn(g)(lane)
      prevValuReadAddr(g)(lane) := io.valuReadAddr(g)(lane)
    }
  }

  // Apply gap-2 (lower priority)
  for (g <- 0 until valuGroups) {
    for (lane <- 0 until cfg.vlen) {
      when(fwdValuGap2Valid(g)(lane)) {
        io.valuReadData(g)(lane) := fwdValuGap2Data(g)(lane)
      }
    }
  }

  // Apply gap-1 (higher priority)
  for (g <- 0 until valuGroups) {
    for (lane <- 0 until cfg.vlen) {
      for (w <- 0 until totalWrites) {
        when(io.writeEn(w) && prevValuReadEn(g)(lane) &&
             io.writeAddr(w) === prevValuReadAddr(g)(lane)) {
          io.valuReadData(g)(lane) := io.writeData(w)
        }
      }
    }
  }
}
