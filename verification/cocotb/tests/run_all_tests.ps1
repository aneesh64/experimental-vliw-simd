# PowerShell script to run Python-based cocotb verification flows on Windows.
# Usage: .\run_all_tests.ps1

param(
    [string[]]$OnlyModules = @(),
    [switch]$SkipSmoke,
    [switch]$SkipIntegration,
    [string]$Config
)

$ErrorActionPreference = "Stop"
if ($PSVersionTable.PSVersion.Major -ge 7) {
    $PSNativeCommandUseErrorActionPreference = $false
}

$testsDir = $PSScriptRoot
$cocotbDir = Split-Path $testsDir -Parent
$repoRoot = Split-Path (Split-Path $cocotbDir -Parent) -Parent

$python = "python"
if ($Config) {
    $configArgs = @("--config", $Config)
} else {
    $configArgs = @()
}

$defaultIntegrationModules = @(
    "test_slot_configs",
    "test_integration",
    "test_integration_scalar",
    "test_integration_memory",
    "test_integration_control",
    "test_integration_vector",
    "test_dsl_integration",
    "test_dsl_helpers_integration",
    "test_dsl_algorithms_integration",
    "test_algorithms",
    "test_algorithms_kernels",
    "test_algorithms_multiwidth",
    "test_driver_integration",
    "test_debug_pipeline"
)

$matrixIntegrationConfig = Join-Path $repoRoot "verification\config\test_config_matrix.properties"
$integrationSuites = @(
    @{
        Name = "Matrix-enabled DSL integration suite"
        Module = "test_dsl_matrix_integration"
        Config = $matrixIntegrationConfig
        Label = "matrix-dsl"
    }
)

foreach ($module in $defaultIntegrationModules) {
    $integrationSuites += @{
        Name = "Integration suite: $module"
        Module = $module
        Config = $null
        Label = $module
    }
}

$totalPassed = 0
$totalFailed = 0
$totalSkipped = 0
$failedTests = New-Object System.Collections.Generic.List[string]

function Add-FailedTest {
    param([string]$Name)

    if ([string]::IsNullOrWhiteSpace($Name)) {
        return
    }
    if (-not $failedTests.Contains($Name)) {
        $failedTests.Add($Name)
    }
}

function Invoke-And-Summarize {
    param(
        [string]$SuiteName,
        [string[]]$CommandArgs
    )

    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $outputLines = @(& $python @CommandArgs 2>&1 | ForEach-Object { $_.ToString() })
    } finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }
    $exitCode = $LASTEXITCODE

    foreach ($line in $outputLines) {
        Write-Host $line
    }

    $suitePassed = 0
    $suiteFailed = 0
    $suiteSkipped = 0
    $totalRegex = [regex]'Total:\s+(\d+)\s+passed,\s+(\d+)\s+failed(?:,\s+(\d+)\s+skipped)?'
    for ($idx = $outputLines.Count - 1; $idx -ge 0; $idx--) {
        $match = $totalRegex.Match($outputLines[$idx])
        if ($match.Success) {
            $suitePassed = [int]$match.Groups[1].Value
            $suiteFailed = [int]$match.Groups[2].Value
            if ($match.Groups[3].Success -and $match.Groups[3].Value -ne "") {
                $suiteSkipped = [int]$match.Groups[3].Value
            }
            break
        }
    }

    $failRegex = [regex]'FAIL:\s+([^|]+?)(?:\s+\||$)'
    foreach ($line in $outputLines) {
        $match = $failRegex.Match($line)
        if ($match.Success) {
            Add-FailedTest $match.Groups[1].Value.Trim()
        }
    }

    $script:totalPassed += $suitePassed
    $script:totalFailed += $suiteFailed
    $script:totalSkipped += $suiteSkipped

    return [pscustomobject]@{
        ExitCode = $exitCode
        Passed = $suitePassed
        Failed = $suiteFailed
        Skipped = $suiteSkipped
        Suite = $SuiteName
    }
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " VLIW SIMD cocotb Test Runner" -ForegroundColor Cyan
Write-Host " Python:    $python" -ForegroundColor Cyan
Write-Host " Root:      $repoRoot" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host ">>> Running module/unit suite" -ForegroundColor Yellow
$moduleRunner = Join-Path $repoRoot "verification\cocotb\tests\run_tests.py"
$moduleArgs = @($moduleRunner) + $configArgs + $OnlyModules
$unitResult = Invoke-And-Summarize -SuiteName "Unit suite" -CommandArgs $moduleArgs
$unitExit = $unitResult.ExitCode
Write-Host ""

$smokeExit = 0
if (-not $SkipSmoke) {
    Write-Host ">>> Running top-level SoC smoke suite" -ForegroundColor Yellow
    $smokeRunner = Join-Path $repoRoot "verification\cocotb\run_smoke.py"
    $smokeArgs = @($smokeRunner) + $configArgs
    $smokeResult = Invoke-And-Summarize -SuiteName "SoC smoke suite" -CommandArgs $smokeArgs
    $smokeExit = $smokeResult.ExitCode
    Write-Host ""
}

$integrationExit = 0
$altDslHelperExit = 0
if (-not $SkipIntegration) {
    $integrationRunner = Join-Path $repoRoot "verification\cocotb\integration\run_integration.py"
    foreach ($suite in $integrationSuites) {
        Write-Host ">>> Running $($suite.Name)" -ForegroundColor Yellow

        if ($suite.Config) {
            $suiteConfigArgs = @("--config", $suite.Config)
        } else {
            $suiteConfigArgs = $configArgs
        }

        $integrationArgs = @(
            $integrationRunner,
            "--modules", $suite.Module,
            "--label", $suite.Label
        ) + $suiteConfigArgs

        $suiteResult = Invoke-And-Summarize -SuiteName $suite.Name -CommandArgs $integrationArgs
        if ($suiteResult.ExitCode -ne 0) {
            $integrationExit = 1
        }
        Write-Host ""
    }

    Write-Host ">>> Running alternate-slot DSL helper suite (2 ALU)" -ForegroundColor Yellow
    $altDslHelperArgs = @(
        $integrationRunner,
        "--modules", "test_dsl_helpers_integration",
        "--config", (Join-Path $repoRoot "verification\config\test_config_alu2.properties"),
        "--label", "alt-dsl-helpers-alu2"
    )
    $altDslHelperResult = Invoke-And-Summarize -SuiteName "Alternate-slot DSL helper suite" -CommandArgs $altDslHelperArgs
    $altDslHelperExit = $altDslHelperResult.ExitCode
    Write-Host ""
}

$overallExit = 0
if (($unitExit -ne 0) -or ($smokeExit -ne 0) -or ($integrationExit -ne 0) -or ($altDslHelperExit -ne 0)) {
    $overallExit = 1
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Summary" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Unit suite exit:        $unitExit" -ForegroundColor $(if ($unitExit -eq 0) {"Green"} else {"Red"})
Write-Host "  SoC smoke suite exit:   $smokeExit" -ForegroundColor $(if ($smokeExit -eq 0) {"Green"} else {"Red"})
Write-Host "  Integration suite exit: $integrationExit" -ForegroundColor $(if ($integrationExit -eq 0) {"Green"} else {"Red"})
Write-Host "  Alt DSL helper exit:    $altDslHelperExit" -ForegroundColor $(if ($altDslHelperExit -eq 0) {"Green"} else {"Red"})
Write-Host ""
Write-Host ("  Final counts:           {0} passed, {1} failed, {2} skipped" -f $totalPassed, $totalFailed, $totalSkipped) -ForegroundColor $(if ($totalFailed -eq 0) {"Green"} else {"Red"})

if ($failedTests.Count -gt 0) {
    Write-Host "" 
    Write-Host "  Failing tests:" -ForegroundColor Red
    foreach ($name in $failedTests) {
        Write-Host "    - $name" -ForegroundColor Red
    }
}

exit $overallExit
