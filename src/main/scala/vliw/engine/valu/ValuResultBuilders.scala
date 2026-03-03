package vliw.engine.valu

import spinal.core._
import spinal.lib._
import vliw.bundle._

trait ValuResultBuilders extends ValuPackedOps with ValuWideningOps with ValuCastOps {
  protected def genPackedResults(a: UInt, b: UInt, c: UInt, slot: ValuSlot,
                                 sgn: Bool): Map[Int, UInt] = {
    val configs = Seq((0, 32, 1), (1, 8, 4), (2, 16, 2), (3, 4, 8))

    configs.map { case (ewCode, ew, n) =>
      val r = UInt(32 bits)
      r := 0
      switch(slot.opcode) {
        is(AluOpcode.ADD) { r := packedAdd(a, b, ew, n) }
        is(AluOpcode.SUB) { r := packedSub(a, b, ew, n) }
        is(AluOpcode.MUL) {
          if (ew == 32)
            r := Mux(sgn, (a.asSInt * b.asSInt).resize(32).asUInt, (a * b).resize(32))
          else
            r := packedMul(a, b, ew, n, sgn)
        }
        is(AluOpcode.XOR) { r := a ^ b }
        is(AluOpcode.AND) { r := a & b }
        is(AluOpcode.OR)  { r := a | b }
        is(AluOpcode.SHL) {
          if (ew == 32) r := (a |<< b(4 downto 0)).resize(32)
          else r := packedShl(a, b, ew, n)
        }
        is(AluOpcode.SHR) {
          if (ew == 32) r := Mux(sgn, (a.asSInt >> b(4 downto 0)).resize(32).asUInt, a |>> b(4 downto 0))
          else r := packedShr(a, b, ew, n, sgn)
        }
        is(AluOpcode.LT) {
          if (ew == 32) r := Mux(sgn, (a.asSInt < b.asSInt).asUInt.resize(32), (a < b).asUInt.resize(32))
          else r := packedLt(a, b, ew, n, sgn)
        }
        is(AluOpcode.EQ) {
          if (ew == 32) r := (a === b).asUInt.resize(32)
          else r := packedEq(a, b, ew, n)
        }
        is(ValuOpcode.VBROADCAST) {
          if (ew == 32) r := c
          else r := packedBroadcast(c, ew, n)
        }
        is(ValuOpcode.MULTIPLY_ADD) {
          if (ew == 32)
            r := Mux(sgn, (a.asSInt * b.asSInt + c.asSInt).resize(32).asUInt, (a * b + c).resize(32))
          else
            r := packedFma(a, b, c, ew, n, sgn)
        }
        is(ValuOpcode.VCAST) { r := a }
      }
      (ewCode, r)
    }.toMap
  }
}
