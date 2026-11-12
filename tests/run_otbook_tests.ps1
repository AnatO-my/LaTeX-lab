param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

$documents = @(
    [pscustomobject]@{
        Source = "examples\otbook\starter_personal_book.tex"
        Output = "build\examples\otbook"
        Stem = "starter_personal_book"
        Marker = "OTBOOK-STARTER:PERSONAL-BOOK"
    },
    [pscustomobject]@{
        Source = "tests\otbook_class_smoke.tex"
        Output = "build\tests\otbook"
        Stem = "otbook_class_smoke"
        Marker = "OTBOOK-SMOKE:CLASS"
    }
)

Push-Location $root
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    foreach ($document in $documents) {
        if (-not (Test-Path $document.Source)) {
            throw "Required otbook document is missing: $($document.Source)"
        }

        $outputDir = Join-Path $root $document.Output
        New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

        Write-Host "Building otbook document $($document.Source)..." -ForegroundColor Cyan
        & latexmk -pdf -g -interaction=nonstopmode -halt-on-error "-outdir=$outputDir" $document.Source
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $($document.Source)"
        }

        $logPath = Join-Path $outputDir "$($document.Stem).log"
        $pdfPath = Join-Path $outputDir "$($document.Stem).pdf"
        if (-not (Test-Path $logPath)) {
            throw "Expected otbook log is missing: $logPath"
        }
        if (-not (Test-Path $pdfPath)) {
            throw "Expected otbook PDF is missing: $pdfPath"
        }
        if (-not (Invoke-LogSelectString -Path $logPath -SimpleMatch -Pattern $document.Marker -Quiet)) {
            throw "$($document.Source) did not emit expected marker: $($document.Marker)"
        }

        Write-Host "PASS otbook document: $($document.Source)" -ForegroundColor Green
    }

    $templateDir = Join-Path $root "templates\otbook-project"
    $templateLog = Join-Path $templateDir "build\aux\main.log"
    $templatePdf = Join-Path $templateDir "build\pdf\main.pdf"
    if (-not (Test-Path (Join-Path $templateDir "main.tex"))) {
        throw "Required otbook project template is missing: $templateDir"
    }

    Write-Host "Building the copyable otbook project template..." -ForegroundColor Cyan
    Push-Location $templateDir
    try {
        & latexmk -pdf -g main.tex
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for templates\\otbook-project\\main.tex"
        }
    }
    finally {
        Pop-Location
    }

    if (-not (Test-Path $templateLog)) {
        throw "Expected template log is missing: $templateLog"
    }
    if (-not (Test-Path $templatePdf)) {
        throw "Expected template PDF is missing: $templatePdf"
    }

    $global:LASTEXITCODE = 0
    Write-Host "All otbook tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
