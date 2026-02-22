package vliw.memory

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig
import vliw.bundle._

/**
 * Instruction Memory — per-core program storage.
 *
 * Dual-port:
 *   Port A: synchronous read for fetch (1-cycle latency)
 *   Port B: write for host program loading (via Flow)
 *
 * Bundle width is determined by config: all engine slots packed
 * into a fixed-width word. SpinalHDL infers the required number
 * of BRAMs (or URAMs) based on width × depth.
 */
class InstructionMemory(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    // Fetch port: address in, data out (1 cycle later)
    val fetchAddr = in  UInt(cfg.imemAddrWidth bits)
    val fetchData = out Bits(cfg.bundleWidth bits)

    // Host write port
    val write = slave(Flow(ImemWriteCmd(cfg)))
  }

  val mem = Mem(Bits(cfg.bundleWidth bits), cfg.imemDepth)

  if (cfg.useUltraRam) {
    mem.setTechnology(ramBlock)
    mem.addAttribute("ram_style", "ultra")
  } else {
    mem.setTechnology(ramBlock)
  }

  // Synchronous read (1-cycle latency — registered address)
  io.fetchData := mem.readSync(io.fetchAddr)

  // Write port
  when(io.write.valid) {
    mem.write(
      address = io.write.addr,
      data    = io.write.data
    )
  }
}
