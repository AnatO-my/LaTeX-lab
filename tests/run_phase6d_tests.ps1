param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$source = "tests\physicsquiz_marks_decimal_smoke.tex"
$log = "tests\build\tests\physicsquiz_marks_decimal_smoke.log"

Push-Location $root
try {
    $phase6cRunner = "tests\run_phase6c_tests.ps1"
    if (-not (Test-Path $phase6cRunner)) {
        throw "The Phase 6C runner is missing: $phase6cRunner"
    }

    Write-Host "Running the Phase 6C namespace checkpoint..." -ForegroundColor Cyan
    try {
        & $phase6cRunner
    }
    catch {
        throw "The Phase 6C checkpoint failed: $($_.Exception.Message)"
    }

    if (-not (Test-Path $source)) {
        throw "Required Phase 6D marks smoke is missing: $source"
    }

    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    if (-not (& kpsewhich xsim.sty)) {
        throw "xsim.sty was not found. Install xsim with MiKTeX Console before running Phase 6D."
    }

    Write-Host "Building the Phase 6D marks decimal smoke..." -ForegroundColor Cyan
    & latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build\tests $source
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $source"
    }

    if (-not (Test-Path $log)) {
        throw "Expected Phase 6D log is missing: $log"
    }

    $logText = Get-Content -Raw -Path $log
    foreach ($marker in @(
            "PQ4C-COUNT:4",
            "PQ4C-TOTAL:3.5",
            "PQ4D-COUNT:2",
            "PQ4D-TOTAL:1",
            "PQ4D-ORDER:pq6d-leading-zero,pq6d-leading-dot"
        )) {
        if ($logText -notmatch [regex]::Escape($marker)) {
            throw "Missing Phase 6D marker: $marker"
        }
    }

    Write-Host "All Phase 6D tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
