ThisBuild / version      := "0.1.0"
ThisBuild / scalaVersion := "2.13.16"
ThisBuild / organization := "io.github.vliwsimd"

val spinalVersion = "1.10.2a"

lazy val root = (project in file("."))
  .settings(
    name := "vliw-simd",
    Compile / scalaSource := baseDirectory.value / "src" / "main" / "scala",
    libraryDependencies ++= Seq(
      "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion,
      "com.github.spinalhdl" %% "spinalhdl-lib"  % spinalVersion,
      compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion)
    )
  )

fork := true
