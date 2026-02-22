# PowerShell script to run all cocotb module testbenches
# Usage: .\run_all_tests.ps1
# Requires: Icarus Verilog (C:\iverilog\bin), cocotb, generated Verilog

param(
    [string]$Sim = "icarus",
    [string[]]$OnlyModules = @()
)

$ErrorActionPreference = "Continue"

# Ensure iverilog is on PATH
$env:PATH = "C:\iverilog\bin;$env:PATH"

$testsDir = $PSScriptRoot
$results = @{}
$totalPass = 0
$totalFail = 0

# Module definitions: name → (test file, Makefile subdir)
$modules = [ordered]@{
    "divider"  = @{ Module = "test_divider"; TopLevel = "UnsignedDivider" }
    "alu"      = @{ Module = "test_alu";     TopLevel = "AluEngine" }
    "valu"     = @{ Module = "test_valu";    TopLevel = "ValuEngine" }
    "flow"     = @{ Module = "test_flow";    TopLevel = "FlowEngine" }
    "mem"      = @{ Module = "test_mem";     TopLevel = "MemoryEngine" }
    "scratch"  = @{ Module = "test_scratch"; TopLevel = "BankedScratchMemory" }
    "core"     = @{ Module = "test_core";    TopLevel = "VliwCore" }
}

if ($OnlyModules.Count -gt 0) {
    $filtered = [ordered]@{}
    foreach ($m in $OnlyModules) {
        if ($modules.Contains($m)) { $filtered[$m] = $modules[$m] }
        else { Write-Warning "Unknown module: $m" }
    }
    $modules = $filtered
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " VLIW SIMD cocotb Test Runner"  -ForegroundColor Cyan
Write-Host " Simulator: $Sim" -ForegroundColor Cyan
Write-Host " Modules:   $($modules.Keys -join ', ')" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

foreach ($name in $modules.Keys) {
    $info = $modules[$name]
    $subdir = Join-Path $testsDir $name

    Write-Host ">>> Running: $name ($($info.TopLevel))" -ForegroundColor Yellow

    if (-not (Test-Path $subdir)) {
        Write-Warning "  Subdir $subdir not found, skipping."
        $results[$name] = "SKIP"
        continue
    }

    # Set PYTHONPATH so cocotb finds the test module in the parent dir
    $env:PYTHONPATH = $testsDir

    Push-Location $subdir
    try {
        # Clean previous sim_build
        if (Test-Path "sim_build") { Remove-Item -Recurse -Force "sim_build" }
        if (Test-Path "results.xml") { Remove-Item -Force "results.xml" }

        # Run make
        $output = make SIM=$Sim 2>&1 | Out-String
        $exitCode = $LASTEXITCODE

        # Parse results.xml if it exists, or use exit code
        if (Test-Path "results.xml") {
            $xml = [xml](Get-Content "results.xml")
            $tests = $xml.testsuites.testsuite.testcase
            $passed = @($tests | Where-Object { -not $_.failure -and -not $_.error }).Count
            $failed = @($tests | Where-Object { $_.failure -or $_.error }).Count
            $results[$name] = "${passed}P/${failed}F"
            $totalPass += $passed
            $totalFail += $failed

            if ($failed -gt 0) {
                Write-Host "  FAIL ($passed passed, $failed failed)" -ForegroundColor Red
                foreach ($t in ($tests | Where-Object { $_.failure -or $_.error })) {
                    Write-Host "    FAILED: $($t.name)" -ForegroundColor Red
                }
            } else {
                Write-Host "  PASS ($passed tests)" -ForegroundColor Green
            }
        } else {
            if ($exitCode -eq 0) {
                Write-Host "  PASS (no XML)" -ForegroundColor Green
                $results[$name] = "PASS"
            } else {
                Write-Host "  FAIL (exit=$exitCode)" -ForegroundColor Red
                $results[$name] = "FAIL"
                $totalFail += 1
                # Show last 20 lines of output
                $lines = $output -split "`n"
                $tail = $lines | Select-Object -Last 20
                Write-Host ($tail -join "`n") -ForegroundColor DarkGray
            }
        }
    } finally {
        Pop-Location
    }
    Write-Host ""
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Summary" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
foreach ($name in $results.Keys) {
    $r = $results[$name]
    $color = if ($r -match "F" -and $r -notmatch "0F") { "Red" } else { "Green" }
    Write-Host "  ${name}: $r" -ForegroundColor $color
}
Write-Host ""
Write-Host "Total: $totalPass passed, $totalFail failed" -ForegroundColor $(if ($totalFail -gt 0) {"Red"} else {"Green"})
