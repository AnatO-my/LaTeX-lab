param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

$starters = @(
    [pscustomobject]@{
        Source = "examples\physicsquiz\starter_quiz_bank.tex"
        Output = "build\examples\physicsquiz"
        Stem = "starter_quiz_bank"
        Markers = @(
            "OT7C-STARTER:PHYSICSQUIZ-BANK",
            "PQ4D-SELECT:starter-units-001",
            "PQ4D-SELECT:starter-waves-001"
        )
    },
    [pscustomobject]@{
        Source = "examples\physicsquiz\starter_versioned_quiz.tex"
        Output = "build\examples\physicsquiz"
        Stem = "starter_versioned_quiz"
        Markers = @(
            "OT7C-STARTER:PHYSICSQUIZ-VERSIONED",
            "PQ4J-VERSION:A",
            "PQ4D-SELECT:starter-version-units-001",
            "PQ4D-SELECT:starter-version-waves-001"
        )
    },
    [pscustomobject]@{
        Source = "examples\studentnotes\starter_notes.tex"
        Output = "build\examples\studentnotes"
        Stem = "starter_notes"
        Markers = @("OT7C-STARTER:STUDENTNOTES")
    },
    [pscustomobject]@{
        Source = "examples\otengineering\starter_engineering_notes.tex"
        Output = "build\examples\otengineering"
        Stem = "starter_engineering_notes"
        Markers = @("OT7C-STARTER:OTENGINEERING")
    },
    [pscustomobject]@{
        Source = "examples\otscience\starter_science_notes.tex"
        Output = "build\examples\otscience"
        Stem = "starter_science_notes"
        Markers = @("OT7C-STARTER:OTSCIENCE")
    },
    [pscustomobject]@{
        Source = "examples\vector-workbook\starter_module.tex"
        Output = "build\examples\vector-workbook"
        Stem = "starter_module"
        Markers = @("OT7C-STARTER:VECTOR-WORKBOOK")
    },
    [pscustomobject]@{
        Source = "examples\vector-workbook\starter_combined_workbook.tex"
        Output = "build\examples\vector-workbook"
        Stem = "starter_combined_workbook"
        Markers = @(
            "OT7J-STARTER:VECTOR-WORKBOOK-COMBINED",
            "OT7C-STARTER:VECTOR-WORKBOOK"
        )
    }
)

Push-Location $root
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    foreach ($starter in $starters) {
        if (-not (Test-Path $starter.Source)) {
            throw "Required Phase 7C starter is missing: $($starter.Source)"
        }
    }

    foreach ($starter in $starters) {
        $outputDir = Join-Path $root $starter.Output
        New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

        Write-Host "Building Phase 7C starter $($starter.Source)..." -ForegroundColor Cyan
        & latexmk -pdf -interaction=nonstopmode -halt-on-error "-outdir=$outputDir" $starter.Source
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $($starter.Source)"
        }

        $logPath = Join-Path $outputDir "$($starter.Stem).log"
        $pdfPath = Join-Path $outputDir "$($starter.Stem).pdf"
        if (-not (Test-Path $logPath)) {
            throw "Expected starter log is missing: $logPath"
        }
        if (-not (Test-Path $pdfPath)) {
            throw "Expected starter PDF is missing: $pdfPath"
        }

        foreach ($marker in $starter.Markers) {
            if (-not (Invoke-LogSelectString -Path $logPath -SimpleMatch -Pattern $marker -Quiet)) {
                throw "$($starter.Source) did not emit expected marker: $marker"
            }
        }

        Write-Host "PASS Phase 7C starter: $($starter.Source)" -ForegroundColor Green
    }

    $global:LASTEXITCODE = 0
    Write-Host "All Phase 7C starter tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
