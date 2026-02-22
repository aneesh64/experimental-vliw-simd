package vliw.engine

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig
import vliw.bundle._
import vliw.plugin._

/**
 * Scalar ALU Engine — executes N independent ALU slots per cycle.
 *
 * Single-cycle ops: ADD, SUB, MUL, XOR, AND, OR, SHL, SHR, LT, EQ.
 * Multi-cycle ops:  MOD, DIV, CDIV — delegated to UnsignedDivider
 *   (restoring division, dataWidth+1 cycle latency, fire-and-forget).
 *
 * The compiler guarantees no reads/writes to the division destination
 * scratch address until the divider completes, and avoids scheduling
 * a write-producing op on the same slot at the divider's done cycle.
 */
class AluEngine(cfg: VliwSocConfig) extends Component with EnginePlugin {
  val io = new Bundle {
    val slots = in Vec(AluSlot(cfg), cfg.nAluSlots)
    val valid = in Bool()  // bundle-level valid (from pipeline)

    // Operand data from scratch (available in EX stage)
    val operandA = in Vec(UInt(cfg.dataWidth bits), cfg.nAluSlots)
    val operandB = in Vec(UInt(cfg.dataWidth bits), cfg.nAluSlots)

    // Write results
    val writeReqs = Vec(master(Flow(ScratchWriteReq(cfg))), cfg.nAluSlots)
  }

  override def engineName: String = "ALU"
  override def numScalarReadPorts: Int = cfg.nAluSlots * 2
  override def numVectorReadGroups: Int = 0
  override def numScalarWritePorts: Int = cfg.nAluSlots
  override def numVectorWriteGroups: Int = 0

  for (i <- 0 until cfg.nAluSlots) {
    val slot      = io.slots(i)
    val a         = io.operandA(i)
    val b         = io.operandB(i)
    val slotValid = slot.valid && io.valid

    // ---- Multi-cycle divider (fire-and-forget) ----
    val divider    = new UnsignedDivider(cfg.dataWidth)
    val divCapDest = Reg(UInt(cfg.scratchAddrWidth bits)) init 0
    val divCapMode = Reg(UInt(2 bits)) init 0  // 0=MOD, 1=DIV, 2=CDIV

    val isDiv = slot.opcode === AluOpcode.MOD ||
                slot.opcode === AluOpcode.DIV ||
                slot.opcode === AluOpcode.CDIV

    divider.io.start    := slotValid && isDiv && !divider.io.busy
    divider.io.dividend := Mux(slot.opcode === AluOpcode.CDIV,
                               (a + b - 1).resize(cfg.dataWidth), a)
    divider.io.divisor  := b

    when(divider.io.start) {
      divCapDest := slot.dest
      when(slot.opcode === AluOpcode.MOD) {
        divCapMode := 0
      } elsewhen (slot.opcode === AluOpcode.DIV) {
        divCapMode := 1
      } otherwise {
        divCapMode := 2  // CDIV
      }
    }

    val divResult = Mux(divCapMode === 0, divider.io.remainder, divider.io.quotient)

    // ---- Single-cycle combinatorial ALU ----
    val result = UInt(cfg.dataWidth bits)
    result := 0

    switch(slot.opcode) {
      is(AluOpcode.ADD) { result := a + b }
      is(AluOpcode.SUB) { result := a - b }
      is(AluOpcode.MUL) { result := (a * b).resize(cfg.dataWidth) }
      is(AluOpcode.XOR) { result := a ^ b }
      is(AluOpcode.AND) { result := a & b }
      is(AluOpcode.OR)  { result := a | b }
      is(AluOpcode.SHL) { result := (a |<< b(4 downto 0)).resize(cfg.dataWidth) }
      is(AluOpcode.SHR) { result := a |>> b(4 downto 0) }
      is(AluOpcode.LT)  { result := (a < b).asUInt.resize(cfg.dataWidth) }
      is(AluOpcode.EQ)  { result := (a === b).asUInt.resize(cfg.dataWidth) }
      // MOD, DIV, CDIV: handled by divider — combinatorial result unused
    }

    // ---- Write-port mux: divider.done takes priority ----
    // Compiler ensures no conflict (done never coincides with a valid non-div write).
    io.writeReqs(i).valid := divider.io.done || (slotValid && !isDiv)
    io.writeReqs(i).addr  := Mux(divider.io.done, divCapDest, slot.dest)
    io.writeReqs(i).data  := Mux(divider.io.done, divResult, result)
  }
}
