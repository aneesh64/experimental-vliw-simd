package vliw.engine.valu

import spinal.core._
import spinal.lib._

trait ValuPackedOps {
  protected def packedAdd(a: UInt, b: UInt, ew: Int, n: Int): UInt = {
    val subs = (0 until n).map { k =>
      val sa = a(k * ew + ew - 1 downto k * ew)
      val sb = b(k * ew + ew - 1 downto k * ew)
      (sa + sb).resize(ew)
    }
    Cat(subs.reverse: _*).asUInt.resize(32)
  }

  protected def packedSub(a: UInt, b: UInt, ew: Int, n: Int): UInt = {
    val subs = (0 until n).map { k =>
      val sa = a(k * ew + ew - 1 downto k * ew)
      val sb = b(k * ew + ew - 1 downto k * ew)
      (sa - sb).resize(ew)
    }
    Cat(subs.reverse: _*).asUInt.resize(32)
  }

  protected def packedMul(a: UInt, b: UInt, ew: Int, n: Int, signed: Bool): UInt = {
    val subs = (0 until n).map { k =>
      val sa = a(k * ew + ew - 1 downto k * ew)
      val sb = b(k * ew + ew - 1 downto k * ew)
      Mux(signed,
        (sa.asSInt * sb.asSInt).resize(ew).asUInt,
        (sa * sb).resize(ew))
    }
    Cat(subs.reverse: _*).asUInt.resize(32)
  }

  protected def packedShl(a: UInt, b: UInt, ew: Int, n: Int): UInt = {
    val shBits = log2Up(ew)
    val subs = (0 until n).map { k =>
      val sa = a(k * ew + ew - 1 downto k * ew)
      val sb = b(k * ew + ew - 1 downto k * ew)
      (sa |<< sb(shBits - 1 downto 0)).resize(ew)
    }
    Cat(subs.reverse: _*).asUInt.resize(32)
  }

  protected def packedShr(a: UInt, b: UInt, ew: Int, n: Int, signed: Bool): UInt = {
    val shBits = log2Up(ew)
    val subs = (0 until n).map { k =>
      val sa = a(k * ew + ew - 1 downto k * ew)
      val sb = b(k * ew + ew - 1 downto k * ew)
      val shamt = sb(shBits - 1 downto 0)
      Mux(signed,
        (sa.asSInt >> shamt).resize(ew).asUInt,
        sa |>> shamt)
    }
    Cat(subs.reverse: _*).asUInt.resize(32)
  }

  protected def packedLt(a: UInt, b: UInt, ew: Int, n: Int, signed: Bool): UInt = {
    val subs = (0 until n).map { k =>
      val sa = a(k * ew + ew - 1 downto k * ew)
      val sb = b(k * ew + ew - 1 downto k * ew)
      Mux(signed,
        (sa.asSInt < sb.asSInt).asUInt.resize(ew),
        (sa < sb).asUInt.resize(ew))
    }
    Cat(subs.reverse: _*).asUInt.resize(32)
  }

  protected def packedEq(a: UInt, b: UInt, ew: Int, n: Int): UInt = {
    val subs = (0 until n).map { k =>
      val sa = a(k * ew + ew - 1 downto k * ew)
      val sb = b(k * ew + ew - 1 downto k * ew)
      (sa === sb).asUInt.resize(ew)
    }
    Cat(subs.reverse: _*).asUInt.resize(32)
  }

  protected def packedBroadcast(scalarWord: UInt, ew: Int, n: Int): UInt = {
    val lowest = scalarWord(ew - 1 downto 0)
    Cat(Seq.fill(n)(lowest): _*).asUInt.resize(32)
  }

  protected def packedFma(a: UInt, b: UInt, c: UInt, ew: Int, n: Int, signed: Bool): UInt = {
    val subs = (0 until n).map { k =>
      val sa = a(k * ew + ew - 1 downto k * ew)
      val sb = b(k * ew + ew - 1 downto k * ew)
      val sc = c(k * ew + ew - 1 downto k * ew)
      Mux(signed,
        (sa.asSInt * sb.asSInt + sc.asSInt).resize(ew).asUInt,
        (sa * sb + sc).resize(ew))
    }
    Cat(subs.reverse: _*).asUInt.resize(32)
  }
}
