package vliw.soc

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import vliw.config.VliwSocConfig

/**
 * Memory Subsystem — DDR-facing AXI arbiter.
 *
 * Arbitrates N core AXI4 master ports plus the IMEM loader port into a
 * single AXI4 master port for connection to external DDR memory
 * (e.g., Zynq PS DDR controller).
 *
 * The host (e.g., Zynq PS ARM cores) accesses DDR directly through its
 * own memory controller, so no host port is needed here.  The host
 * pre-loads operand data and instruction bundles into DDR before starting
 * the accelerator, and reads results back from DDR after the cores halt.
 */
class MemorySubsystem(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    val corePorts  = Vec(slave(Axi4(cfg.axiConfig)), cfg.nCores)
    val loaderPort = slave(Axi4(cfg.axiConfig))
    val ddrPort    = master(Axi4(cfg.ddrAxiConfig))
  }

  // AXI4 crossbar: (N core ports + 1 loader port) → 1 DDR master port
  val crossbar = Axi4CrossbarFactory()
  val addrRange = (BigInt(0), BigInt(1) << cfg.axiAddrWidth)

  crossbar.addSlaves(io.ddrPort -> addrRange)

  for (i <- 0 until cfg.nCores) {
    crossbar.addConnections(io.corePorts(i) -> List(io.ddrPort))
  }
  crossbar.addConnections(io.loaderPort -> List(io.ddrPort))

  crossbar.build()
}
