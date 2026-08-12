$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$buildDir = Join-Path $repoRoot "build\tests"
$exampleBuildDir = Join-Path $repoRoot "build\examples\physicsquiz"
$fullBank = Join-Path $repoRoot "examples\physicsquiz\banks\phy104_full_question_bank.tex"
$versionedExample = Join-Path $repoRoot "examples\physicsquiz\PHY104_versioned_paper.tex"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
New-Item -ItemType Directory -Force -Path $exampleBuildDir | Out-Null
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

function Assert-CleanLog {
    param([string]$LogPath)
    $diagnostics = Invoke-LogSelectString -Path $LogPath -SimpleMatch -Pattern @(
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
    foreach ($source in @($fullBank, $versionedExample)) {
        if (-not (Test-Path $source)) {
            throw "Required Phase 4I/4J source is missing: $source"
        }
    }

    $phase4gRunner = "tests\run_physicsquiz_phase4g_tests.ps1"
    if (-not (Test-Path $phase4gRunner)) {
        throw "The accepted Phase 4G regression runner is missing: $phase4gRunner"
    }
    Write-Host "Running the accepted Phase 4G regression suite..." -ForegroundColor Cyan
    try {
        & $phase4gRunner
    }
    catch {
        throw "The Phase 4G regression suite failed: $($_.Exception.Message)"
    }
    $global:LASTEXITCODE = 0

    $positiveTests = @(
        "physicsquiz_shuffle_default",
        "physicsquiz_shuffle_student",
        "physicsquiz_shuffle_teacher",
        "physicsquiz_shuffle_answerkey",
        "physicsquiz_shuffle_solutions",
        "physicsquiz_shuffle_repeat",
        "physicsquiz_shuffle_other_seed",
        "physicsquiz_shuffle_unshuffled",
        "physicsquiz_version_a",
        "physicsquiz_version_b"
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

    Write-Host "Building the versioned example..." -ForegroundColor Cyan
    & latexmk -pdf -g "-outdir=$exampleBuildDir" "examples\physicsquiz\PHY104_versioned_paper.tex"
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for the versioned example."
    }
    Assert-Artifacts -Directory $exampleBuildDir -Stem "PHY104_versioned_paper"
    Assert-CleanLog -LogPath (Join-Path $exampleBuildDir "PHY104_versioned_paper.log")

    $checkerArgs = @(
        "tests\check_physicsquiz_shuffle_versions.py",
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
        throw "The Phase 4I/4J checker failed."
    }

    $expectedFailures = @(
        @{ Name = "physicsquiz_shuffle_invalid_seed";       Marker = "PQ4E-VALIDATION:INVALID-SEED" },
        @{ Name = "physicsquiz_shuffle_invalid_seed_large"; Marker = "PQ4E-VALIDATION:INVALID-SEED" },
        @{ Name = "physicsquiz_shuffle_twice";              Marker = "PQ4I-VALIDATION:ALREADY-SHUFFLED" },
        @{ Name = "physicsquiz_shuffle_empty_selection";    Marker = "PQ4D-VALIDATION:EMPTY-SELECTION" },
        @{ Name = "physicsquiz_correctletter_outside";      Marker = "PQ4I-VALIDATION:NO-CURRENT-RECORD" },
        @{ Name = "physicsquiz_version_unknown";            Marker = "PQ4J-VALIDATION:UNKNOWN-VERSION" },
        @{ Name = "physicsquiz_version_duplicate";          Marker = "PQ4J-VALIDATION:DUPLICATE-VERSION" },
        @{ Name = "physicsquiz_version_already_active";     Marker = "PQ4J-VALIDATION:VERSION-ALREADY-ACTIVE" }
    )

    foreach ($test in $expectedFailures) {
        $source = "tests\$($test.Name).tex"
        Write-Host "Building expected-failure test $($test.Name)..." -ForegroundColor Yellow
        & latexmk -pdf -g "-outdir=$buildDir" $source
        if ($LASTEXITCODE -eq 0) {
            throw "$source unexpectedly compiled successfully."
        }

        $log = Join-Path $buildDir "$($test.Name).log"
        if (-not (Invoke-LogSelectString -Path $log -SimpleMatch -Pattern $test.Marker -Quiet)) {
            throw "$source failed without the expected validation marker: $($test.Marker)"
        }
        Write-Host "PASS expected failure: $($test.Name)" -ForegroundColor Green
    }

    $global:LASTEXITCODE = 0
    Write-Host "All Phase 4I/4J tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
