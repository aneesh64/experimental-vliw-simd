package vliw.plugin

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig
import vliw.bundle._

/**
 * Abstract trait for all execution engine plugins.
 *
 * Each engine plugin declares:
 *   - How many scratch read ports it needs (addresses presented in IF stage)
 *   - How many scratch write ports it produces (results committed in EX+WB stage)
 *   - A decode method: extract read addresses from the decoded slot
 *   - An execute method: given operand data, compute results
 *
 * The VliwCore collects all plugins, sizes the scratch crossbar,
 * and wires addresses/data between plugins and banked scratch memory.
 *
 * Inspired by VexRiscv's plugin architecture: each engine is self-contained
 * and registers its resource needs. Adding a new instruction type means
 * creating a new plugin or extending an existing one — no changes to core wiring.
 */
trait EnginePlugin {

  /** Human-readable engine name (for debug / waveform labeling). */
  def engineName: String

  /** Number of scalar scratch read ports this engine needs.
   *  Each port reads one 32-bit word per cycle. */
  def numScalarReadPorts: Int

  /** Number of vector scratch read groups this engine needs.
   *  Each group reads VLEN contiguous words (one per bank). */
  def numVectorReadGroups: Int

  /** Number of scalar scratch write ports this engine produces. */
  def numScalarWritePorts: Int

  /** Number of vector scratch write groups (VLEN writes each). */
  def numVectorWriteGroups: Int
}

/**
 * Concrete ports that the core allocates for each engine.
 * After the core sizes the crossbar, it creates these ports
 * and passes them to the engine for wiring.
 */
case class EngineReadPorts(cfg: VliwSocConfig,
                           nScalar: Int,
                           nVectorGroups: Int) extends Bundle {
  /** Scalar read request addresses (IF stage). */
  val scalarAddr = Vec(UInt(cfg.scratchAddrWidth bits), nScalar)
  val scalarEn   = Vec(Bool(), nScalar)

  /** Scalar read data (available in EX stage, 1 cycle after address). */
  val scalarData = Vec(UInt(cfg.dataWidth bits), nScalar)

  /** Vector read request base addresses (IF stage). */
  val vectorAddr = Vec(UInt(cfg.scratchAddrWidth bits), nVectorGroups)
  val vectorEn   = Vec(Bool(), nVectorGroups)

  /** Vector read data: [group][lane] (available in EX stage). */
  val vectorData = Vec(Vec(UInt(cfg.dataWidth bits), cfg.vlen), nVectorGroups)
}

case class EngineWritePorts(cfg: VliwSocConfig,
                            nScalar: Int,
                            nVectorGroups: Int) extends Bundle {
  /** Scalar write requests (EX+WB stage). */
  val scalarReq  = Vec(Flow(ScratchWriteReq(cfg)), nScalar)

  /** Vector write requests: [group][lane] (EX+WB stage). */
  val vectorReq  = Vec(Vec(Flow(ScratchWriteReq(cfg)), cfg.vlen), nVectorGroups)
}
