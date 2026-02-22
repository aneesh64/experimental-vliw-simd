package vliw.engine

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig
import vliw.bundle._
import vliw.plugin._

/**
 * Vector ALU Engine — executes N VALU slots, each over VLEN lanes.
 *
 * Single-cycle: ADD, SUB, MUL, XOR, AND, OR, SHL, SHR, LT, EQ,
 *   VBROADCAST (replicate scalar), MULTIPLY_ADD (DSP48 a*b+c).
 * Multi-cycle:  MOD, DIV, CDIV — each lane has its own UnsignedDivider
 *   (VLEN parallel dividers per slot, all fire-and-forget).
 *
 * Read ports per slot:
 *   - src1Base[0..VLEN-1]: vector operand A
 *   - src2Base[0..VLEN-1]: vector operand B
 *   - src3Base: scalar (vbroadcast) or vector (multiply_add) read
 *
 * Write ports per slot: VLEN writes (destBase+0..+VLEN-1)
 */
class ValuEngine(cfg: VliwSocConfig) extends Component with EnginePlugin {
  val io = new Bundle {
    val slots = in Vec(ValuSlot(cfg), cfg.nValuSlots)
    val valid = in Bool()

    // Vector operands A and B: [slot][lane]
    val operandA = in Vec(Vec(UInt(cfg.dataWidth bits), cfg.vlen), cfg.nValuSlots)
    val operandB = in Vec(Vec(UInt(cfg.dataWidth bits), cfg.vlen), cfg.nValuSlots)

    // Operand C: for multiply_add, per-lane; for vbroadcast, single scalar
    // We provide VLEN values; vbroadcast replicates index 0.
    val operandC = in Vec(Vec(UInt(cfg.dataWidth bits), cfg.vlen), cfg.nValuSlots)

    // Write results: [slot][lane]
    val writeReqs = Vec(Vec(master(Flow(ScratchWriteReq(cfg))), cfg.vlen), cfg.nValuSlots)
  }

  override def engineName: String = "VALU"
  override def numScalarReadPorts: Int = cfg.nValuSlots  // src3 scalar read
  override def numVectorReadGroups: Int = cfg.nValuSlots * 2  // src1 + src2
  override def numScalarWritePorts: Int = 0
  override def numVectorWriteGroups: Int = cfg.nValuSlots

  for (s <- 0 until cfg.nValuSlots) {
    val slot = io.slots(s)
    val slotValid = slot.valid && io.valid

    for (lane <- 0 until cfg.vlen) {
      val a = io.operandA(s)(lane)
      val b = io.operandB(s)(lane)
      val c = io.operandC(s)(lane)

      // ---- Per-lane divider (fire-and-forget) ----
      val divider    = new UnsignedDivider(cfg.dataWidth)
      val divCapDest = Reg(UInt(cfg.scratchAddrWidth bits)) init 0
      val divCapMode = Reg(UInt(2 bits)) init 0

      val isDiv = slot.opcode === AluOpcode.MOD ||
                  slot.opcode === AluOpcode.DIV ||
                  slot.opcode === AluOpcode.CDIV

      val isSrc3Op = slot.opcode === ValuOpcode.VBROADCAST ||
             slot.opcode === ValuOpcode.MULTIPLY_ADD

      divider.io.start    := slotValid && isDiv && !divider.io.busy
      divider.io.dividend := Mux(slot.opcode === AluOpcode.CDIV,
                                 (a + b - 1).resize(cfg.dataWidth), a)
      divider.io.divisor  := b

      when(divider.io.start) {
        divCapDest := (slot.destBase + lane).resize(cfg.scratchAddrWidth)
        when(slot.opcode === AluOpcode.MOD) {
          divCapMode := 0
        } elsewhen (slot.opcode === AluOpcode.DIV) {
          divCapMode := 1
        } otherwise {
          divCapMode := 2  // CDIV
        }
      }

      val divResult = Mux(divCapMode === 0, divider.io.remainder, divider.io.quotient)

      // ---- Single-cycle combinatorial lane ALU ----
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
        // MOD, DIV, CDIV: handled by per-lane dividers
        is(ValuOpcode.VBROADCAST) {
          result := io.operandC(s)(0)
        }
        is(ValuOpcode.MULTIPLY_ADD) {
          result := (a * b + c).resize(cfg.dataWidth)
        }
      }

      // ---- All non-div ops are single-cycle (including FMA/VBROADCAST) ----
      // With the 3-stage pipeline (IF|EX|WB), the WB stage naturally
      // provides the extra cycle that src3 ops previously needed.
      val destAddr = (slot.destBase + lane).resize(cfg.scratchAddrWidth)
      val singleCycleWrite = slotValid && !isDiv

      // ---- Write-port mux: divider.done takes priority ----
      io.writeReqs(s)(lane).valid := divider.io.done || singleCycleWrite
      io.writeReqs(s)(lane).addr  := Mux(divider.io.done, divCapDest, destAddr)
      io.writeReqs(s)(lane).data  := Mux(divider.io.done, divResult, result)
    }
  }
}
