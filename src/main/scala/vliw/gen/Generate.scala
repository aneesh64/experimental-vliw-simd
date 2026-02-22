package vliw.gen

import spinal.core._
import vliw.config.VliwSocConfig
import vliw.soc.VliwSimdSoc

/**
 * Verilog generation entry points.
 *
 * Usage:
 *   sbt "runMain vliw.gen.GenerateSim"        — Simulation preset (1 core)
 *   sbt "runMain vliw.gen.GenerateKintex325T"  — Kintex-7 325T (2 cores)
 *   sbt "runMain vliw.gen.GenerateKintex480T"  — Kintex-7 480T (4 cores)
 *   sbt "runMain vliw.gen.GenerateKintexU060"  — Kintex UltraScale 060 (4 cores)
 *   sbt "runMain vliw.gen.GenerateKintexUP15P" — Kintex US+ 15P (8 cores)
 *   sbt "runMain vliw.gen.GenerateCustom"      — Override via system properties
 */

object GenerateHelper {
  def generateVerilog(cfg: VliwSocConfig, tag: String): Unit = {
    val outDir = s"generated_rtl/$tag"

    val spinalConfig = SpinalConfig(
      mode                  = Verilog,
      targetDirectory       = outDir,
      defaultConfigForClockDomains = ClockDomainConfig(
        resetKind         = SYNC,
        resetActiveLevel  = HIGH
      ),
      defaultClockDomainFrequency = FixedFrequency(100 MHz),
      onlyStdLogicVectorAtTopLevelIo = true
    )

    val report = spinalConfig.generate(new VliwSimdSoc(cfg))

    println(s"===== VLIW SIMD SoC [$tag] =====")
    println(s"  Cores:         ${cfg.nCores}")
    println(s"  ALU slots:     ${cfg.nAluSlots}")
    println(s"  VALU slots:    ${cfg.nValuSlots}")
    println(s"  Load slots:    ${cfg.nLoadSlots}")
    println(s"  Store slots:   ${cfg.nStoreSlots}")
    println(s"  VLEN:          ${cfg.vlen}")
    println(s"  Scratch/core:  ${cfg.scratchSize} words (${cfg.scratchBanks} banks × ${cfg.scratchReplicas} replicas)")
    println(s"  IMEM depth:    ${cfg.imemDepth}")
    println(s"  Bundle width:  ${cfg.bundleWidth} bits")
    println(s"  Main memory:   ${cfg.mainMemWords} words")
    println(s"  UltraRAM:      ${cfg.useUltraRam}")
    println(s"  Output:        $outDir/")
    println(s"================================")
  }
}

object GenerateSim extends App {
  GenerateHelper.generateVerilog(VliwSocConfig.Sim, "Sim")
}

object GenerateKintex325T extends App {
  GenerateHelper.generateVerilog(VliwSocConfig.Kintex7_325T, "Kintex7_325T")
}

object GenerateKintex480T extends App {
  GenerateHelper.generateVerilog(VliwSocConfig.Kintex7_480T, "Kintex7_480T")
}

object GenerateKintexU060 extends App {
  GenerateHelper.generateVerilog(VliwSocConfig.KintexU_060, "KintexU_060")
}

object GenerateKintexUP15P extends App {
  GenerateHelper.generateVerilog(VliwSocConfig.KintexUP_15P, "KintexUP_15P")
}

/** Generate with custom parameters via system properties. */
object GenerateCustom extends App {
  val cfg = VliwSocConfig(
    nCores      = sys.props.getOrElse("nCores", "1").toInt,
    nAluSlots   = sys.props.getOrElse("nAluSlots", "1").toInt,
    nValuSlots  = sys.props.getOrElse("nValuSlots", "1").toInt,
    nLoadSlots  = sys.props.getOrElse("nLoadSlots", "1").toInt,
    nStoreSlots = sys.props.getOrElse("nStoreSlots", "1").toInt,
    imemDepth   = sys.props.getOrElse("imemDepth", "1024").toInt,
    mainMemWords= sys.props.getOrElse("mainMemWords", "16384").toInt,
    useUltraRam = sys.props.getOrElse("useUltraRam", "false").toBoolean
  )
  GenerateHelper.generateVerilog(cfg, "Custom")
}
