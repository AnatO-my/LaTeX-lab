param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$source = "tests\physicsquiz_capability_marker_smoke.tex"
$log = "tests\build\tests\physicsquiz_capability_marker_smoke.log"

Push-Location $root
try {
    $phase6aRunner = "tests\run_phase6a_tests.ps1"
    if (-not (Test-Path $phase6aRunner)) {
        throw "The Phase 6A runner is missing: $phase6aRunner"
    }

    Write-Host "Running the Phase 6A learning scaffold..." -ForegroundColor Cyan
    try {
        & $phase6aRunner
    }
    catch {
        throw "The Phase 6A scaffold failed: $($_.Exception.Message)"
    }

    if (-not (Test-Path $source)) {
        throw "Required Phase 6B capability smoke is missing: $source"
    }

    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    if (-not (& kpsewhich xsim.sty)) {
        throw "xsim.sty was not found. Install xsim with MiKTeX Console before running Phase 6B."
    }

    Write-Host "Building the Phase 6B capability marker smoke..." -ForegroundColor Cyan
    & latexmk -pdf -interaction=nonstopmode -halt-on-error -outdir=build\tests $source
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $source"
    }

    if (-not (Test-Path $log)) {
        throw "Expected Phase 6B log is missing: $log"
    }

    $logText = Get-Content -Raw -Path $log
    foreach ($marker in @(
            "PQ6B-CAPABILITY:CLASS=0.1",
            "PQ6B-CAPABILITY:STRUCTURED=1",
            "PQ6B-CAPABILITY:ID=physicsquiz-structured-v1",
            "PQ4C-COUNT:1",
            "PQ4C-TOTAL:1",
            "PQ4D-COUNT:1",
            "PQ4D-TOTAL:1",
            "PQ4D-ORDER:pq6b-capability-001"
        )) {
        if ($logText -notmatch [regex]::Escape($marker)) {
            throw "Missing Phase 6B marker: $marker"
        }
    }

    Write-Host "All Phase 6B tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
