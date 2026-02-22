package vliw.soc

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import vliw.config.VliwSocConfig

/**
 * Memory Subsystem — shared main data memory.
 *
 * Backed by on-chip BRAM (or URAM on UltraScale+).
 * Provides an AXI4 slave port per core plus one for host access.
 * Uses SpinalHDL's Axi4SharedOnChipRam with a crossbar arbiter.
 */
class MemorySubsystem(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    val corePorts = Vec(slave(Axi4(cfg.axiConfig)), cfg.nCores)
    val hostPort  = slave(Axi4(cfg.axiConfig))
  }

  // Wider ID to accommodate multiple masters through the crossbar
  val crossbarIdWidth = cfg.axiIdWidth + log2Up(cfg.nCores + 1) + 1

  val ramConfig = Axi4Config(
    addressWidth = cfg.axiAddrWidth,
    dataWidth    = cfg.axiDataWidth,
    idWidth      = crossbarIdWidth,
    useBurst     = true,
    useLen       = true,
    useSize      = true,
    useLock      = false,
    useCache     = false,
    useProt      = false,
    useQos       = false,
    useRegion    = false
  )

  // On-chip RAM with AXI4 slave interface
  val ram = Axi4SharedOnChipRam(
    dataWidth = cfg.axiDataWidth,
    byteCount = cfg.mainMemWords.toLong * (cfg.dataWidth / 8),
    idWidth   = crossbarIdWidth,
    arwStage  = true
  )

  // AXI4 crossbar: N core ports + 1 host port → 1 RAM port
  val crossbar = Axi4CrossbarFactory()
  val ramAddrRange = (BigInt(0), BigInt(cfg.mainMemWords.toLong * (cfg.dataWidth / 8)))

  crossbar.addSlaves(ram.io.axi -> ramAddrRange)

  for (i <- 0 until cfg.nCores) {
    crossbar.addConnections(io.corePorts(i) -> List(ram.io.axi))
  }
  crossbar.addConnections(io.hostPort -> List(ram.io.axi))

  crossbar.build()
}
