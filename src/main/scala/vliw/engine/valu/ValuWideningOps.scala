package vliw.engine.valu

import spinal.core._
import spinal.lib._

trait ValuWideningOps {
  protected def wideningMul(a: UInt, b: UInt, sew: Int, dew: Int,
                            nDest: Int, signed: Bool): UInt = {
    val subs = (0 until nDest).map { k =>
      val sa = a(k * sew + sew - 1 downto k * sew)
      val sb = b(k * sew + sew - 1 downto k * sew)
      Mux(signed,
        (sa.asSInt.resize(dew) * sb.asSInt.resize(dew)).resize(dew).asUInt,
        (sa.resize(dew) * sb.resize(dew)).resize(dew))
    }
    if (nDest == 1) subs.head.resize(32)
    else Cat(subs.reverse: _*).asUInt.resize(32)
  }

  protected def wideningFma(a: UInt, b: UInt, c: UInt, sew: Int, dew: Int,
                            nDest: Int, signed: Bool): UInt = {
    val subs = (0 until nDest).map { k =>
      val sa = a(k * sew + sew - 1 downto k * sew)
      val sb = b(k * sew + sew - 1 downto k * sew)
      val sc = c(k * dew + dew - 1 downto k * dew)
      Mux(signed,
        (sa.asSInt.resize(dew) * sb.asSInt.resize(dew) + sc.asSInt).resize(dew).asUInt,
        (sa.resize(dew) * sb.resize(dew) + sc).resize(dew))
    }
    if (nDest == 1) subs.head.resize(32)
    else Cat(subs.reverse: _*).asUInt.resize(32)
  }
}
