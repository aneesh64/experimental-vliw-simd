package vliw.core

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig
import vliw.bundle._

/**
 * Writeback Controller — collects write requests from the WB pipeline
 * stage (synchronous engines) and async memory load results, then drives
 * the scratch memory write crossbar.
 *
 * In the 3-stage pipeline (IF|EX|WB):
 *   - ALU, VALU, Flow, CONST writes arrive pre-registered (WB stage in VliwCore)
 *   - Load/Vload writes arrive asynchronously from MemoryEngine (bypass WB)
 *
 * Responsibilities:
 *   1. Aggregate all write requests (scalar + vector) from engines
 *   2. WAW conflict detection (debug assertion — should never fire
 *      for correctly compiled VLIW programs)
 *   3. Route writes to the scratch memory write ports
 *
 * The controller does NOT arbitrate — compiler guarantees at most
 * one write per scratch bank per cycle. If two writes target the
 * same bank, the WAW assertion fires (debug only).
 */
class WritebackController(cfg: VliwSocConfig) extends Component {
  // Compute total write port count across all engines:
  //   ALU: nAluSlots scalar writes
  //   VALU: nValuSlots * vlen writes
  //   Load: nLoadSlots scalar writes (load result)
  //   Load: nLoadSlots scalar writes (const result)
  //   Load: nLoadSlots * vlen writes (vload result)
  //   Flow: 1 scalar write + vlen writes (vselect)
  val nAluWrites   = cfg.nAluSlots
  val nValuWrites  = cfg.nValuSlots * cfg.vlen
  val nLoadWrites  = cfg.nLoadSlots      // scalar load results
  val nConstWrites = cfg.nLoadSlots      // const results
  val nVloadWrites = cfg.nLoadSlots * cfg.vlen
  val nFlowScalar  = 1
  val nFlowVector  = cfg.vlen            // vselect
  val totalWrites  = nAluWrites + nValuWrites + nLoadWrites + nConstWrites +
                     nVloadWrites + nFlowScalar + nFlowVector

  val io = new Bundle {
    // ---- Write requests from engines ----
    val aluWrites   = Vec(slave(Flow(ScratchWriteReq(cfg))), nAluWrites)
    val valuWrites  = Vec(slave(Flow(ScratchWriteReq(cfg))), nValuWrites)
    val loadWrites  = Vec(slave(Flow(ScratchWriteReq(cfg))), nLoadWrites)
    val constWrites = Vec(slave(Flow(ScratchWriteReq(cfg))), nConstWrites)
    val vloadWrites = Vec(slave(Flow(ScratchWriteReq(cfg))), nVloadWrites)
    val flowScalarWrite = slave(Flow(ScratchWriteReq(cfg)))
    val flowVectorWrites = Vec(slave(Flow(ScratchWriteReq(cfg))), nFlowVector)

    // ---- Scratch write ports (output to BankedScratchMemory) ----
    val scratchWriteAddr = out Vec(UInt(cfg.scratchAddrWidth bits), totalWrites)
    val scratchWriteData = out Vec(UInt(cfg.dataWidth bits), totalWrites)
    val scratchWriteEn   = out Vec(Bool(), totalWrites)

    // ---- Debug ----
    val wawConflict = out Bool()
  }

  // Flatten all write requests into a single indexed structure
  val allWrites = new Array[Flow[ScratchWriteReq]](totalWrites)
  var idx = 0

  for (i <- 0 until nAluWrites)   { allWrites(idx) = io.aluWrites(i);   idx += 1 }
  for (i <- 0 until nValuWrites)  { allWrites(idx) = io.valuWrites(i);  idx += 1 }
  for (i <- 0 until nLoadWrites)  { allWrites(idx) = io.loadWrites(i);  idx += 1 }
  for (i <- 0 until nConstWrites) { allWrites(idx) = io.constWrites(i); idx += 1 }
  for (i <- 0 until nVloadWrites) { allWrites(idx) = io.vloadWrites(i); idx += 1 }
  allWrites(idx) = io.flowScalarWrite; idx += 1
  for (i <- 0 until nFlowVector)  { allWrites(idx) = io.flowVectorWrites(i); idx += 1 }

  // Drive scratch write ports
  for (i <- 0 until totalWrites) {
    io.scratchWriteAddr(i) := allWrites(i).addr
    io.scratchWriteData(i) := allWrites(i).data
    io.scratchWriteEn(i)   := allWrites(i).valid
  }

  // ---- WAW conflict detection ----
  io.wawConflict := False
  if (cfg.enableWawCheck) {
    for (i <- 0 until totalWrites) {
      for (j <- i + 1 until totalWrites) {
        when(allWrites(i).valid && allWrites(j).valid &&
             allWrites(i).addr === allWrites(j).addr) {
          io.wawConflict := True
          report(
            Seq(s"WAW CONFLICT detected: port $i and port $j both writing to addr ",
                allWrites(i).addr)
          )
        }
      }
    }
  }
}
