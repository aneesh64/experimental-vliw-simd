package vliw.engine

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig
import vliw.bundle._
import vliw.plugin._

/**
 * Flow Engine — control flow operations (1 slot per cycle).
 *
 * Operations:
 *   SELECT       : dest = scratch[a] if scratch[cond] != 0 else scratch[b]
 *   VSELECT      : lane-wise select over VLEN elements
 *   ADD_IMM      : dest = (scratch[a] + sign_ext(imm)) mod 2^32
 *   HALT         : stop core execution
 *   COND_JUMP    : if scratch[cond] != 0, PC = target
 *   COND_JUMP_REL: if scratch[cond] != 0, PC += signed_offset
 *   JUMP         : unconditional PC = target
 *   JUMP_INDIRECT: PC = scratch[addr]
 *   COREID       : dest = core hardware ID
 *
 * The flow engine produces:
 *   - Scratch write requests (for select/vselect/add_imm/coreid)
 *   - Jump target (for fetch unit PC update)
 *   - Halt signal
 */
class FlowEngine(cfg: VliwSocConfig, coreId: Int) extends Component with EnginePlugin {
  val io = new Bundle {
    val slot  = in(FlowSlot(cfg))
    val valid = in Bool()
    val currentPc = in UInt(cfg.imemAddrWidth bits)

    // Scalar operand data (cond, srcA, srcB for select — 3 reads)
    val operandCond = in UInt(cfg.dataWidth bits)   // scratch[operandA]
    val operandA    = in UInt(cfg.dataWidth bits)    // scratch[operandB] (srcA for select)
    val operandB    = in UInt(cfg.dataWidth bits)    // scratch[immediate as addr] (srcB for select)

    // Vector operands for vselect: [lane] for cond, a, b
    val vCond = in Vec(UInt(cfg.dataWidth bits), cfg.vlen)
    val vSrcA = in Vec(UInt(cfg.dataWidth bits), cfg.vlen)
    val vSrcB = in Vec(UInt(cfg.dataWidth bits), cfg.vlen)

    // ---- Outputs ----
    // Scalar write (select, add_imm, coreid)
    val scalarWriteReq = master(Flow(ScratchWriteReq(cfg)))

    // Vector write (vselect)
    val vectorWriteReqs = Vec(master(Flow(ScratchWriteReq(cfg))), cfg.vlen)

    // Jump target
    val jumpTarget = master(Flow(UInt(cfg.imemAddrWidth bits)))

    // Halt
    val halt = out Bool()
  }

  override def engineName: String = "FLOW"
  override def numScalarReadPorts: Int = 3   // cond, srcA, srcB
  override def numVectorReadGroups: Int = 0
  override def numScalarWritePorts: Int = 1
  override def numVectorWriteGroups: Int = 0

  val slotValid = io.slot.valid && io.valid

  // Defaults
  io.scalarWriteReq.valid := False
  io.scalarWriteReq.addr  := 0
  io.scalarWriteReq.data  := 0
  for (l <- 0 until cfg.vlen) {
    io.vectorWriteReqs(l).valid := False
    io.vectorWriteReqs(l).addr  := 0
    io.vectorWriteReqs(l).data  := 0
  }
  io.jumpTarget.valid   := False
  io.jumpTarget.payload := 0
  io.halt := False

  when(slotValid) {
    switch(io.slot.opcode) {

      is(FlowOpcode.SELECT) {
        io.scalarWriteReq.valid := True
        io.scalarWriteReq.addr  := io.slot.dest
        io.scalarWriteReq.data  := Mux(io.operandCond =/= 0, io.operandA, io.operandB)
      }

      is(FlowOpcode.VSELECT) {
        for (l <- 0 until cfg.vlen) {
          io.vectorWriteReqs(l).valid := True
          io.vectorWriteReqs(l).addr  := (io.slot.dest + l).resize(cfg.scratchAddrWidth)
          io.vectorWriteReqs(l).data  := Mux(io.vCond(l) =/= 0, io.vSrcA(l), io.vSrcB(l))
        }
      }

      is(FlowOpcode.ADD_IMM) {
        io.scalarWriteReq.valid := True
        io.scalarWriteReq.addr  := io.slot.dest
        // Sign-extend the immediate and add
        val immSext = io.slot.immediate.asSInt.resize(cfg.dataWidth).asUInt
        io.scalarWriteReq.data := io.operandCond + immSext  // operandCond = scratch[operandA]
      }

      is(FlowOpcode.HALT) {
        io.halt := True
      }

      is(FlowOpcode.COND_JUMP) {
        when(io.operandCond =/= 0) {
          io.jumpTarget.valid   := True
          // Target address = {operandB, immediate} concatenated
          io.jumpTarget.payload := Cat(io.slot.operandB, io.slot.immediate)
            .asUInt.resize(cfg.imemAddrWidth)
        }
      }

      is(FlowOpcode.COND_JUMP_REL) {
        when(io.operandCond =/= 0) {
          io.jumpTarget.valid   := True
          val offset = io.slot.immediate.asSInt.resize(cfg.imemAddrWidth)
          io.jumpTarget.payload := (io.currentPc.asSInt + offset).asUInt
        }
      }

      is(FlowOpcode.JUMP) {
        io.jumpTarget.valid   := True
        io.jumpTarget.payload := Cat(io.slot.operandB, io.slot.immediate)
          .asUInt.resize(cfg.imemAddrWidth)
      }

      is(FlowOpcode.JUMP_INDIRECT) {
        io.jumpTarget.valid   := True
        io.jumpTarget.payload := io.operandCond.resize(cfg.imemAddrWidth)  // scratch[operandA]
      }

      is(FlowOpcode.COREID) {
        io.scalarWriteReq.valid := True
        io.scalarWriteReq.addr  := io.slot.dest
        io.scalarWriteReq.data  := U(coreId, cfg.dataWidth bits)
      }
    }
  }
}
