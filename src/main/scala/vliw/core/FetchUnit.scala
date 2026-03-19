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
    val stall       = in Bool()                                // Any stall source that must freeze fetch/PC
    val replayStall = in Bool()                                // Memory replay stall that needs a stall-release bubble
    val matrixStall = in Bool()                                // Matrix-specific stall (skip stallReleaseBubble)
    val memBusy     = in Bool()                                // Outstanding AXI transactions still in flight

    // ---- Status outputs ----
    val pc       = out UInt(cfg.imemAddrWidth bits)
    val running  = out Bool()
    val halted   = out Bool()
  }

  // ---- Core state machine ----
  object CoreState extends SpinalEnum {
    val IDLE, RUNNING, HALT_DRAIN, HALTED = newElement()
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

  // Stall-release bubble: during a replay-style stall the fetch unit drives
  // imemAddr=pc-1 so the synchronous IMEM keeps outputting the in-flight
  // instruction. On the first cycle after stall release, that stale instruction
  // is still present on io.imemData. Suppress one capture so the next cycle
  // sees the true pc bundle.
  val stallReleaseBubble = RegInit(False)

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
        when(io.memBusy) {
          state := CoreState.HALT_DRAIN
        } otherwise {
          state := CoreState.HALTED
        }
      }
    }
    is(CoreState.HALT_DRAIN) {
      when(!io.memBusy) {
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
  // During any stall, drive pc-1 so the IMEM keeps outputting the next
  // instruction to be fetched.  With readSync (1-cycle latency), pc is
  // always TWO ahead of exBundleReg:
  //   exBundleReg = mem[pc-2],  IMEM during stall outputs mem[pc-1]
  // On stall release, the fresh instruction on io.imemData is captured
  // normally by the `otherwise` branch — no stallReleaseBubble needed.
  io.imemAddr := Mux(io.stall, (pc - 1).resized, pc)

  // ---- Pipeline progression ----
  when(!io.stall) {
    when(cycleActive) {
      when(startupBubble) {
        // Second cycle after start: IMEM still outputs stale mem[0].
        // Suppress valid but advance PC so IMEM fetches correct address.
        startupBubble := False
        exValidReg    := False
        pc            := pc + 1
      } elsewhen(stallReleaseBubble) {
        stallReleaseBubble := False
        exValidReg := False
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
  // When stalled: pc, exBundleReg, exValidReg hold their values.
  // With the 3-stage pipeline and synchronous IMEM, stallReleaseBubble is
  // NOT needed for memory replay stalls: imemAddr=pc-1 outputs the correct
  // next instruction (mem[pc-1]), which is fresh, not a duplicate.
  // stallReleaseBubble is kept as infrastructure but replayStall is always
  // False (see VliwCore wiring).
  when(io.replayStall && cycleActive && !io.matrixStall) {
    stallReleaseBubble := True
  }

  // ---- Outputs ----
  io.exBundle := exBundleReg
  // Combinatorially suppress exValid when HALT fires in the EX stage.
  // Without this, the instruction fetched after HALT (at HALT_PC+1) would
  // be decoded with valid=True during the same cycle HALT fires, and the
  // registered exValidReg := False only takes effect one cycle later —
  // too late to prevent the post-HALT instruction from entering exSlotsReg
  // and executing.  This is critical when a shorter program follows a
  // longer one: stale IMEM at HALT_PC+1 could contain active instructions
  // (e.g. STORE) from the previous program.
  io.exValid  := exValidReg && !io.halt
  io.pc       := pc
  io.running  := cycleActive
  io.halted   := (state === CoreState.HALTED)
}
