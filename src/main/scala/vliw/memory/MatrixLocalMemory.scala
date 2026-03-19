package vliw.memory

import spinal.core._
import vliw.config.VliwSocConfig

case class MatrixMemPort(addrWidth: Int, dataWidth: Int) extends Bundle {
  val addr   = in UInt(addrWidth bits)
  val en     = in Bool()
  val we     = in Bool()
  val wrData = in UInt(dataWidth bits)
  val rdData = out UInt(dataWidth bits)
}

private class MatrixLocalMemory(depth: Int, addrWidth: Int, dataWidth: Int) extends Component {
  val io = new Bundle {
    val matrixPort = MatrixMemPort(addrWidth, dataWidth)
    val systemPort = MatrixMemPort(addrWidth, dataWidth)
  }

  val mem = Mem(UInt(dataWidth bits), depth)
  mem.setTechnology(ramBlock)

  io.matrixPort.rdData := mem.readWriteSync(
    address = io.matrixPort.addr,
    data = io.matrixPort.wrData,
    enable = io.matrixPort.en,
    write = io.matrixPort.we,
    readUnderWrite = dontCare
  )

  io.systemPort.rdData := mem.readWriteSync(
    address = io.systemPort.addr,
    data = io.systemPort.wrData,
    enable = io.systemPort.en,
    write = io.systemPort.we,
    readUnderWrite = dontCare
  )
}

/**
 * Matrix-local int8 operand scratchpad.
 *
 * Port usage is intentionally generic in v1:
 *   - matrixPort: reserved for MatrixEngine datapath/control
 *   - systemPort: reserved for MemoryEngine DRAM moves or future host/debug access
 *
 * Arbitration and ownership are handled outside this component.
 */
class MatrixScratchpad(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    val matrixPort = MatrixMemPort(cfg.matrixScratchAddrWidth, cfg.matrixElemBits)
    val systemPort = MatrixMemPort(cfg.matrixScratchAddrWidth, cfg.matrixElemBits)
  }

  private val mem = new MatrixLocalMemory(
    depth = cfg.matrixScratchSize,
    addrWidth = cfg.matrixScratchAddrWidth,
    dataWidth = cfg.matrixElemBits
  )

  mem.io.matrixPort <> io.matrixPort
  mem.io.systemPort <> io.systemPort
}

/**
 * Matrix-local int32 accumulator memory.
 *
 * Separate accumulator storage keeps systolic partial sums out of the normal
 * scratch path and provides a stable target for later MZERO/MMSTORE behavior.
 */
class MatrixAccumulatorMemory(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    val matrixPort = MatrixMemPort(cfg.matrixAccumAddrWidth, cfg.matrixAccumBits)
    val systemPort = MatrixMemPort(cfg.matrixAccumAddrWidth, cfg.matrixAccumBits)
  }

  private val mem = new MatrixLocalMemory(
    depth = cfg.matrixAccumSize,
    addrWidth = cfg.matrixAccumAddrWidth,
    dataWidth = cfg.matrixAccumBits
  )

  mem.io.matrixPort <> io.matrixPort
  mem.io.systemPort <> io.systemPort
}