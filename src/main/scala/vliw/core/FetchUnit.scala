package vliw.core

import spinal.core._
import spinal.lib._
import vliw.config.VliwSocConfig
import vliw.bundle._

/**
 * Fetch Unit — Stage 1 of the 3-stage pipeline (IF | EX | WB).
 *
 * Responsibilities:
 *   1. Manage the Program Counter (PC) register
 *   2. Drive IMEM read address
 *   3. Register the fetched instruction bundle for EX stage
 *   4. Handle jumps (1-cycle bubble on taken branch)
 *   5. Handle stalls (freeze PC and pipeline register)
 *   6. Control core lifecycle: IDLE → RUNNING → HALTED
 */
class FetchUnit(cfg: VliwSocConfig) extends Component {
  val io = new Bundle {
    // ---- IMEM interface ----
    val imemAddr = out UInt(cfg.imemAddrWidth bits)          // To InstructionMemory
    val imemData = in  Bits(cfg.bundleWidth bits)             // From InstructionMemory

    // ---- Pipeline output (to EX stage) ----
    val exBundle = out Bits(cfg.bundleWidth bits)
    val exValid  = out Bool()

    // ---- Control inputs ----
    val jump     = slave(Flow(UInt(cfg.imemAddrWidth bits)))  // From FlowEngine
    val halt     = in Bool()                                   // From FlowEngine
    val start    = in Bool()                                   // From HostInterface
    val stall    = in Bool()                                   // From MemoryEngine

    // ---- Status outputs ----
    val pc       = out UInt(cfg.imemAddrWidth bits)
    val running  = out Bool()
    val halted   = out Bool()
  }

  // ---- Core state machine ----
  object CoreState extends SpinalEnum {
    val IDLE, RUNNING, HALTED = newElement()
  }

  val state = RegInit(CoreState.IDLE)
  val pc    = Reg(UInt(cfg.imemAddrWidth bits)) init 0
  val cycleActive = state === CoreState.RUNNING

  // Pipeline register: holds the instruction bundle for EX stage
  val exBundleReg = Reg(Bits(cfg.bundleWidth bits)) init 0
  val exValidReg  = RegInit(False)

  // Startup bubble: IMEM readSync has 1-cycle latency.  During IDLE the IMEM
  // already reads mem[0] (pc=0).  On the first running cycle the fetch unit
  // captures that (correct) bundle and advances PC to 1.  But the IMEM output
  // on the SECOND running cycle is still mem[0] (captured from address 0 which
  // was active between the start edge and the first running edge).  We suppress
  // the second capture with startupBubble to prevent executing bundle 0 twice.
  val startupBubble = RegInit(False)

  // ---- State transitions ----
  switch(state) {
    is(CoreState.IDLE) {
      when(io.start) {
        state := CoreState.RUNNING
        pc    := 0
        startupBubble := True   // suppress duplicate fetch of bundle 0
      }
    }
    is(CoreState.RUNNING) {
      when(io.halt) {
        state := CoreState.HALTED
      }
    }
    is(CoreState.HALTED) {
      when(io.start) {
        // Restart: reset PC and go
        state := CoreState.RUNNING
        pc    := 0
        startupBubble := True
      }
    }
  }

  // ---- IMEM address ----
  io.imemAddr := pc

  // ---- Pipeline progression ----
  when(!io.stall) {
    when(cycleActive) {
      when(startupBubble) {
        // Second cycle after start: IMEM still outputs stale mem[0].
        // Suppress valid but advance PC so IMEM fetches correct address.
        startupBubble := False
        exValidReg    := False
        pc            := pc + 1
      } elsewhen(io.jump.valid) {
        // Taken branch: load target, invalidate in-flight
        pc          := io.jump.payload
        exValidReg  := False
        exBundleReg := 0
      } elsewhen(io.halt) {
        // Halt this cycle: the current EX instruction is the halt
        exValidReg := False
      } otherwise {
        // Normal: advance PC, register fetched bundle
        exBundleReg := io.imemData
        exValidReg  := True
        pc          := pc + 1
      }
    } otherwise {
      exValidReg := False
    }
  }
  // When stalled: pc, exBundleReg, exValidReg hold their values

  // ---- Outputs ----
  io.exBundle := exBundleReg
  io.exValid  := exValidReg
  io.pc       := pc
  io.running  := cycleActive
  io.halted   := (state === CoreState.HALTED)
}
