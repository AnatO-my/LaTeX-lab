$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$buildDir = Join-Path $repoRoot "build\tests"
$exampleBuildDir = Join-Path $repoRoot "build\examples\physicsquiz"
$legacySource = Join-Path $repoRoot "examples\physicsquiz\PHY104_Exam revision.tex"
$fullBank = Join-Path $repoRoot "examples\physicsquiz\banks\phy104_full_question_bank.tex"
$structuredExample = Join-Path $repoRoot "examples\physicsquiz\PHY104_structured_revision.tex"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
New-Item -ItemType Directory -Force -Path $exampleBuildDir | Out-Null

function Assert-CleanLog {
    param([string]$LogPath)
    $diagnostics = Select-String -Path $LogPath -SimpleMatch -Pattern @(
        "LaTeX Warning:",
        "Package xsim Warning:",
        "Overfull \hbox",
        "Underfull \hbox"
    )
    if ($diagnostics) {
        $diagnostics | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
        throw "Unexpected LaTeX diagnostics in $LogPath"
    }
}

function Assert-Artifacts {
    param([string]$Directory, [string]$Stem)
    foreach ($extension in @("log", "pdf", "synctex.gz")) {
        $artifact = Join-Path $Directory "$Stem.$extension"
        if (-not (Test-Path $artifact)) {
            throw "Expected build artifact was not created: $artifact"
        }
    }
}

Push-Location $repoRoot
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }
    foreach ($package in @("xsim.sty", "siunitx.sty")) {
        if (-not (& kpsewhich $package)) {
            throw "$package was not found. Install it with MiKTeX Console before running Phase 4G."
        }
    }
    foreach ($source in @($legacySource, $fullBank, $structuredExample)) {
        if (-not (Test-Path $source)) {
            throw "Required Phase 4G source is missing: $source"
        }
    }

    $phase4fRunner = "tests\run_physicsquiz_phase4f_tests.ps1"
    if (-not (Test-Path $phase4fRunner)) {
        throw "The accepted Phase 4F regression runner is missing: $phase4fRunner"
    }
    Write-Host "Running the accepted Phase 4F regression suite..." -ForegroundColor Cyan
    try {
        & $phase4fRunner
    }
    catch {
        throw "The Phase 4F regression suite failed: $($_.Exception.Message)"
    }
    $global:LASTEXITCODE = 0

    $positiveTests = @(
        "physicsquiz_full_migration_all",
        "physicsquiz_full_migration_foundation",
        "physicsquiz_full_migration_applied",
        "physicsquiz_full_migration_challenge",
        "physicsquiz_full_migration_ids",
        "physicsquiz_full_migration_metadata",
        "physicsquiz_full_migration_tags",
        "physicsquiz_full_migration_random",
        "physicsquiz_full_migration_random_repeat"
    )

    foreach ($name in $positiveTests) {
        $source = "tests\$name.tex"
        Write-Host "Building $name..." -ForegroundColor Cyan
        & latexmk -pdf -g "-outdir=$buildDir" $source
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $source"
        }
        Assert-Artifacts -Directory $buildDir -Stem $name
        Assert-CleanLog -LogPath (Join-Path $buildDir "$name.log")
    }

    Write-Host "Building the complete structured example..." -ForegroundColor Cyan
    & latexmk -pdf -g "-outdir=$exampleBuildDir" "examples\physicsquiz\PHY104_structured_revision.tex"
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for the complete structured example."
    }
    Assert-Artifacts -Directory $exampleBuildDir -Stem "PHY104_structured_revision"
    Assert-CleanLog -LogPath (Join-Path $exampleBuildDir "PHY104_structured_revision.log")

    $checkerArgs = @(
        "tests\check_physicsquiz_full_migration.py",
        $legacySource,
        $fullBank,
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
        throw "The Phase 4G full-migration checker failed."
    }

    $global:LASTEXITCODE = 0
    Write-Host "All Phase 4G tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
