package vliw.engine.valu

import spinal.core._
import spinal.lib._

trait ValuCastOps {
  protected def castWiden(a: UInt, sew: Int, dew: Int, nDest: Int,
                          signed: Bool, upperHalf: Bool): UInt = {
    val nSrc = 32 / sew
    val subs = (0 until nDest).map { k =>
      val loIdx = k
      val hiIdx = k + nDest
      val loSub = a(loIdx * sew + sew - 1 downto loIdx * sew)
      val hiSub = if (hiIdx < nSrc) a(hiIdx * sew + sew - 1 downto hiIdx * sew) else U(0, sew bits)
      val sub = Mux(upperHalf, hiSub, loSub)
      Mux(signed, sub.asSInt.resize(dew).asUInt, sub.resize(dew))
    }
    if (nDest == 1) subs.head.resize(32)
    else Cat(subs.reverse: _*).asUInt.resize(32)
  }

  protected def castNarrow(a: UInt, sew: Int, dew: Int, nSrc: Int,
                           signed: Bool, upperHalf: Bool): UInt = {
    val truncated = (0 until nSrc).map { k =>
      a(k * sew + dew - 1 downto k * sew)
    }
    val packedBits = nSrc * dew
    val packed = Cat(truncated.reverse: _*).asUInt
    val padded = packed.resize(32)
    val shifted = (packed.resize(32) |<< packedBits).resize(32)
    Mux(upperHalf, shifted, padded)
  }
}
