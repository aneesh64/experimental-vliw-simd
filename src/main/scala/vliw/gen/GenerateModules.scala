package vliw.gen

import spinal.core._
import vliw.config.VliwSocConfig
import vliw.engine._
import vliw.core._
import vliw.memory._
import java.nio.file.{Files, Paths}
import java.util.Properties
import scala.util.Try

/**
 * Individual module Verilog generators for cocotb unit testing.
 *
 * Each generates a single module with Sim config parameters.
 *
 * Usage:
 *   sbt "runMain vliw.gen.GenerateDivider"
 *   sbt "runMain vliw.gen.GenerateAlu"
 *   sbt "runMain vliw.gen.GenerateValu"
 *   sbt "runMain vliw.gen.GenerateFlow"
 *   sbt "runMain vliw.gen.GenerateMemEngine"
 *   sbt "runMain vliw.gen.GenerateFetch"
 *   sbt "runMain vliw.gen.GenerateDecode"
 *   sbt "runMain vliw.gen.GenerateWriteback"
 *   sbt "runMain vliw.gen.GenerateScratch"
 *   sbt "runMain vliw.gen.GenerateCore"
 *   sbt "runMain vliw.gen.GenerateAllModules"
 */

object ModuleGenHelper {
  private val configPath = Option(System.getProperty("vliw.config.file"))
    .orElse(Option(System.getenv("VLIW_CONFIG_FILE")))
    .getOrElse("verification/config/test_config.properties")

  private val props = new Properties()
  private val path = Paths.get(configPath)

  if (!Files.exists(path)) {
    throw new RuntimeException(s"Config file not found: $configPath")
  }

  private val in = Files.newInputStream(path)
  try {
    props.load(in)
  } finally {
    in.close()
  }

  private def propInt(key: String, default: Int): Int = {
    Option(props.getProperty(key)).flatMap(s => Try(s.trim.toInt).toOption).getOrElse(default)
  }

  val cfg = VliwSocConfig.Sim.copy(
    nAluSlots   = propInt("slots.alu", VliwSocConfig.Sim.nAluSlots),
    nValuSlots  = propInt("slots.valu", VliwSocConfig.Sim.nValuSlots),
    nLoadSlots  = propInt("slots.load", VliwSocConfig.Sim.nLoadSlots),
    nStoreSlots = propInt("slots.store", VliwSocConfig.Sim.nStoreSlots),
    nFlowSlots  = propInt("slots.flow", VliwSocConfig.Sim.nFlowSlots)
  )
  val outDir = "generated_rtl/modules"

  def spinalConfig: SpinalConfig = SpinalConfig(
    mode                  = Verilog,
    targetDirectory       = outDir,
    defaultConfigForClockDomains = ClockDomainConfig(
      resetKind         = SYNC,
      resetActiveLevel  = HIGH
    ),
    defaultClockDomainFrequency = FixedFrequency(100 MHz),
    onlyStdLogicVectorAtTopLevelIo = true
  )
}

object GenerateDivider extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new UnsignedDivider(32))
  println(s"[GenerateDivider] Generated UnsignedDivider in $outDir/")
}

object GenerateAlu extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new AluEngine(cfg))
  println(s"[GenerateAlu] Generated AluEngine in $outDir/")
}

object GenerateValu extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new ValuEngine(cfg))
  println(s"[GenerateValu] Generated ValuEngine in $outDir/")
}

object GenerateFlow extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new FlowEngine(cfg, coreId = 0))
  println(s"[GenerateFlow] Generated FlowEngine in $outDir/")
}

object GenerateMemEngine extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new MemoryEngine(cfg))
  println(s"[GenerateMemEngine] Generated MemoryEngine in $outDir/")
}

object GenerateFetch extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new FetchUnit(cfg))
  println(s"[GenerateFetch] Generated FetchUnit in $outDir/")
}

object GenerateDecode extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new DecodeUnit(cfg))
  println(s"[GenerateDecode] Generated DecodeUnit in $outDir/")
}

object GenerateWriteback extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new WritebackController(cfg))
  println(s"[GenerateWriteback] Generated WritebackController in $outDir/")
}

object GenerateScratch extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new BankedScratchMemory(cfg))
  println(s"[GenerateScratch] Generated BankedScratchMemory in $outDir/")
}

object GenerateCore extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new VliwCore(cfg, coreId = 0))
  println(s"[GenerateCore] Generated VliwCore in $outDir/")
}

/** Generate all individual modules in one go. */
object GenerateAllModules extends App {
  import ModuleGenHelper._
  spinalConfig.generate(new UnsignedDivider(32))
  spinalConfig.generate(new AluEngine(cfg))
  spinalConfig.generate(new ValuEngine(cfg))
  spinalConfig.generate(new FlowEngine(cfg, coreId = 0))
  spinalConfig.generate(new MemoryEngine(cfg))
  spinalConfig.generate(new FetchUnit(cfg))
  spinalConfig.generate(new DecodeUnit(cfg))
  spinalConfig.generate(new WritebackController(cfg))
  spinalConfig.generate(new BankedScratchMemory(cfg))
  spinalConfig.generate(new VliwCore(cfg, coreId = 0))
  println(s"[GenerateAllModules] All modules generated in $outDir/")
}
