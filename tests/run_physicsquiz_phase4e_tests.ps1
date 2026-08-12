$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$buildDir = Join-Path $repoRoot "build\tests"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

Push-Location $repoRoot
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    if (-not (& kpsewhich xsim.sty)) {
        throw "xsim.sty was not found. Install xsim with MiKTeX Console before running Phase 4E."
    }

    $phase4dRunner = "tests\run_physicsquiz_phase4d_tests.ps1"
    if (-not (Test-Path $phase4dRunner)) {
        throw "The Phase 4D regression runner is missing: $phase4dRunner"
    }

    Write-Host "Running the accepted Phase 4D regression suite..." -ForegroundColor Cyan
    try {
        & $phase4dRunner
    }
    catch {
        throw "The Phase 4D regression suite failed: $($_.Exception.Message)"
    }
    $global:LASTEXITCODE = 0

    $positiveTests = @(
        "physicsquiz_random_default",
        "physicsquiz_random_student",
        "physicsquiz_random_teacher",
        "physicsquiz_random_solutions",
        "physicsquiz_random_answerkey",
        "physicsquiz_random_repeat",
        "physicsquiz_random_other_seed",
        "physicsquiz_random_filtered",
        "physicsquiz_random_append",
        "physicsquiz_random_all_candidates"
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

    if (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 tests\check_physicsquiz_random_selection.py $buildDir
    }
    elseif (Get-Command python -ErrorAction SilentlyContinue) {
        & python tests\check_physicsquiz_random_selection.py $buildDir
    }
    else {
        throw "Python was not found. Install Python or make py/python available."
    }
    if ($LASTEXITCODE -ne 0) {
        throw "The Phase 4E semantic checker failed."
    }

    $expectedFailures = @(
        @{ Name = "physicsquiz_random_invalid_count_zero";    Marker = "PQ4E-VALIDATION:INVALID-COUNT:0" },
        @{ Name = "physicsquiz_random_invalid_count_decimal"; Marker = "PQ4E-VALIDATION:INVALID-COUNT:2.5" },
        @{ Name = "physicsquiz_random_invalid_seed_zero";     Marker = "PQ4E-VALIDATION:INVALID-SEED:0" },
        @{ Name = "physicsquiz_random_invalid_seed_large";    Marker = "PQ4E-VALIDATION:INVALID-SEED:2147483647" },
        @{ Name = "physicsquiz_random_count_exceeds";         Marker = "PQ4E-VALIDATION:COUNT-EXCEEDS-CANDIDATES:5/4" },
        @{ Name = "physicsquiz_random_no_candidates";         Marker = "PQ4E-VALIDATION:NO-CANDIDATES" },
        @{ Name = "physicsquiz_random_filter_no_match";       Marker = "PQ4E-VALIDATION:NO-CANDIDATES" }
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
    Write-Host "All Phase 4E tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
