param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$starterSource = "examples\physicsquiz\starter_quiz_bank.tex"
$starterLog = "build\examples\physicsquiz\starter_quiz_bank.log"
$starterOutDir = Join-Path $root "build\examples\physicsquiz"

Push-Location $root
try {
    $phase6dRunner = "tests\run_phase6d_tests.ps1"
    if (-not (Test-Path $phase6dRunner)) {
        throw "The Phase 6D runner is missing: $phase6dRunner"
    }

    Write-Host "Running the Phase 6D marks checkpoint..." -ForegroundColor Cyan
    try {
        & $phase6dRunner
    }
    catch {
        throw "The Phase 6D checkpoint failed: $($_.Exception.Message)"
    }

    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    if (-not (& kpsewhich xsim.sty)) {
        throw "xsim.sty was not found. Install xsim with MiKTeX Console before running Phase 6E."
    }

    if (-not (Test-Path $starterSource)) {
        throw "Required Phase 6E starter document is missing: $starterSource"
    }

    New-Item -ItemType Directory -Force -Path $starterOutDir | Out-Null

    Write-Host "Building the Phase 6E starter quiz-bank document..." -ForegroundColor Cyan
    & latexmk -pdf -interaction=nonstopmode -halt-on-error "-outdir=$starterOutDir" $starterSource
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $starterSource"
    }

    if (-not (Test-Path $starterLog)) {
        throw "Expected Phase 6E starter log is missing: $starterLog"
    }

    $starterText = Get-Content -Raw -Path $starterLog
    foreach ($marker in @(
            "PQ4D-SELECT:starter-units-001",
            "PQ4D-SELECT:starter-waves-001"
        )) {
        if ($starterText -notmatch [regex]::Escape($marker)) {
            throw "Missing Phase 6E starter marker: $marker"
        }
    }

    $expectedFailures = @(
        @{
            Name = "physicsquiz_author_message_invalid_id"
            Marker = "PQ4C-VALIDATION:INVALID-ID:Invalid_ID"
            Hints = @("PQ6E-HINT:INVALID-ID:id=waves-001")
        },
        @{
            Name = "physicsquiz_author_message_invalid_marks"
            Marker = "PQ4C-VALIDATION:INVALID-MARKS:.0"
            Hints = @("PQ6E-HINT:INVALID-MARKS:marks=0.5-or-.5")
        },
        @{
            Name = "physicsquiz_author_message_empty_filter"
            Marker = "PQ4D-VALIDATION:EMPTY-FILTER"
            Hints = @("PQ6E-HINT:EMPTY-FILTER:quizselectall-or-filter")
        }
    )

    foreach ($test in $expectedFailures) {
        $source = "tests\$($test.Name).tex"
        Write-Host "Building expected-failure test $($test.Name)..." -ForegroundColor Yellow
        & latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build\tests $source
        if ($LASTEXITCODE -eq 0) {
            throw "$source unexpectedly compiled successfully."
        }

        $log = "tests\build\tests\$($test.Name).log"
        if (-not (Test-Path $log)) {
            throw "Expected failure log is missing: $log"
        }
        $logText = Get-Content -Raw -Path $log

        if ($logText -notmatch [regex]::Escape($test.Marker)) {
            throw "$source failed without the expected validation marker: $($test.Marker)"
        }

        foreach ($hint in $test.Hints) {
            if ($logText -notmatch [regex]::Escape($hint)) {
                throw "$source failed without the expected author hint: $hint"
            }
        }

        Write-Host "PASS expected failure: $($test.Name)" -ForegroundColor Green
    }

    $global:LASTEXITCODE = 0
    Write-Host "All Phase 6E tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
