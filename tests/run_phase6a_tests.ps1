param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$source = "tests\phase6_modern_interface_examples.tex"
$log = "tests\build\tests\phase6_modern_interface_examples.log"

Push-Location $root
try {
    if (-not (Test-Path $source)) {
        throw "Required Phase 6A learning fixture is missing: $source"
    }

    $latexmk = Get-Command latexmk -ErrorAction Stop
    & $latexmk.Source -pdf -interaction=nonstopmode -halt-on-error -outdir=build\tests $source
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $source"
    }

    if (-not (Test-Path $log)) {
        throw "Expected Phase 6A log is missing: $log"
    }

    $logText = Get-Content -Raw -Path $log
    foreach ($marker in @(
            "PQ6A-DEMO:KEYS",
            "PQ6A-DEMO:NEWDOCUMENTCOMMAND",
            "PQ6A-DEMO:EXPL3"
        )) {
        if ($logText -notmatch [regex]::Escape($marker)) {
            throw "Missing Phase 6A marker: $marker"
        }
    }

    Write-Host "All Phase 6A tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
