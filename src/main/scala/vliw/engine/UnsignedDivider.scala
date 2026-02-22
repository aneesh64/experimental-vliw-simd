package vliw.engine

import spinal.core._

/**
 * Unsigned integer divider — restoring algorithm, 1 bit per clock cycle.
 *
 * Computes:  quotient  = dividend / divisor
 *            remainder = dividend % divisor
 *
 * Latency: `width + 1` clock cycles from start to done.
 *
 * Protocol:
 *   - Assert `start` for 1 cycle while `busy` is low.
 *   - `done` pulses high for exactly 1 cycle when results are ready.
 *   - `quotient` and `remainder` are valid on the `done` cycle and
 *     remain stable until the next `start`.
 *   - A new `start` may be asserted on the same cycle as `done`
 *     (zero dead cycles for back-to-back operations).
 *   - Division by zero is undefined (compiler must never emit it).
 *
 * FPGA resources (per instance):
 *   1 × (width+2)-bit subtractor (carry chain), ~3×width flip-flops.
 *   No DSP, no BRAM.
 */
class UnsignedDivider(width: Int) extends Component {
  require(width >= 2, s"UnsignedDivider requires width >= 2, got $width")

  val io = new Bundle {
    val start     = in Bool()
    val dividend  = in UInt(width bits)
    val divisor   = in UInt(width bits)

    val done      = out Bool()
    val busy      = out Bool()
    val quotient  = out UInt(width bits)
    val remainder = out UInt(width bits)
  }

  // ---- State ----
  val running   = RegInit(False)
  val counter   = Reg(UInt(log2Up(width + 1) bits)) init 0
  val donePulse = RegInit(False)

  // ---- Working registers ----
  val r = Reg(UInt((width + 1) bits)) init 0   // partial remainder
  val q = Reg(UInt(width bits)) init 0         // quotient being built
  val d = Reg(UInt((width + 1) bits)) init 0   // captured divisor (zero-extended)

  // ---- Outputs (stable until next start) ----
  donePulse := False                           // default: one-cycle pulse
  io.busy      := running
  io.done      := donePulse
  io.quotient  := q
  io.remainder := r.resize(width)

  // ---- Start: latch operands, begin iteration ----
  when(io.start && !running) {
    r       := U(0, (width + 1) bits)
    q       := io.dividend
    d       := io.divisor.resize(width + 1)
    counter := U(width, log2Up(width + 1) bits)
    running := True
  }

  // ---- Iteration: restoring division, 1 quotient bit per cycle ----
  when(running) {
    // Step 1: shift partial remainder left, bring in MSB of quotient
    val rShifted = r(width - 1 downto 0) @@ q(width - 1).asUInt   // (width+1) bits
    val qShifted = q(width - 2 downto 0) @@ U(0, 1 bits)          // width bits

    // Step 2: trial subtraction with borrow detection
    //   Extend to (width+2) bits so the MSB indicates borrow.
    val sub      = rShifted.resize(width + 2) - d.resize(width + 2)
    val noBorrow = !sub(width + 1)

    when(noBorrow) {
      // rShifted >= divisor: commit subtraction, set quotient bit 0
      r := sub.resize(width + 1)
      q := qShifted | U(1, width bits)
    } otherwise {
      // rShifted < divisor: restore (keep rShifted), quotient bit stays 0
      r := rShifted
      q := qShifted
    }

    counter := counter - 1
    when(counter === 1) {
      running   := False
      donePulse := True
    }
  }
}
