$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$buildDir = Join-Path $repoRoot "build\tests"
$legacySource = Join-Path $repoRoot "examples\physicsquiz\PHY104_Exam revision.tex"
$pilotBank = Join-Path $repoRoot "examples\physicsquiz\banks\phy104_migration_pilot_bank.tex"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

Push-Location $repoRoot
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }
    if (-not (& kpsewhich xsim.sty)) {
        throw "xsim.sty was not found. Install xsim with MiKTeX Console before running Phase 4F."
    }
    if (-not (Test-Path $legacySource)) {
        throw "The representative legacy quiz is missing: $legacySource"
    }
    if (-not (Test-Path $pilotBank)) {
        throw "The migration-pilot bank is missing: $pilotBank"
    }

    $phase4eRunner = "tests\run_physicsquiz_phase4e_tests.ps1"
    if (-not (Test-Path $phase4eRunner)) {
        throw "The accepted Phase 4E regression runner is missing: $phase4eRunner"
    }

    Write-Host "Running the accepted Phase 4E regression suite..." -ForegroundColor Cyan
    try {
        & $phase4eRunner
    }
    catch {
        throw "The Phase 4E regression suite failed: $($_.Exception.Message)"
    }
    $global:LASTEXITCODE = 0

    $positiveTests = @(
        "physicsquiz_migration_pilot_ids",
        "physicsquiz_migration_pilot_metadata",
        "physicsquiz_migration_pilot_random",
        "physicsquiz_migration_pilot_random_repeat"
    )

    foreach ($name in $positiveTests) {
        $source = "tests\$name.tex"
        Write-Host "Building $name..." -ForegroundColor Cyan
        & latexmk -pdf -g "-outdir=$buildDir" $source
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $source"
        }

        $log = Join-Path $buildDir "$name.log"
        $pdf = Join-Path $buildDir "$name.pdf"
        $synctex = Join-Path $buildDir "$name.synctex.gz"
        foreach ($artifact in @($log, $pdf, $synctex)) {
            if (-not (Test-Path $artifact)) {
                throw "Expected build artifact was not created: $artifact"
            }
        }

        $diagnostics = Invoke-LogSelectString -Path $log -SimpleMatch -Pattern @(
            "LaTeX Warning:",
            "Package xsim Warning:",
            "Overfull \hbox",
            "Underfull \hbox"
        )
        if ($diagnostics) {
            $diagnostics | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
            throw "Unexpected LaTeX diagnostics in $log"
        }
    }

    $checkerArgs = @(
        "tests\check_physicsquiz_migration_pilot.py",
        $legacySource,
        $pilotBank,
        $buildDir
    )
    if (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 @checkerArgs
    }
    elseif (Get-Command python -ErrorAction SilentlyContinue) {
        & python @checkerArgs
    }
    else {
        throw "Python was not found. Install Python or make py/python available."
    }
    if ($LASTEXITCODE -ne 0) {
        throw "The Phase 4F migration-pilot checker failed."
    }

    $global:LASTEXITCODE = 0
    Write-Host "All Phase 4F tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
