<#
.SYNOPSIS
    Test runner for the PGFPlots data-plot layer.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/plots"
$scriptPath = Join-Path $root "scripts/build-figures.ps1"
$exampleSource = "examples/figures"

Write-Host "Starting PGFPlots Integration Tests..." -ForegroundColor Cyan

# 1. Build the plot example using the standalone figure workflow
Write-Host "Step 1: Building plot example..." -ForegroundColor Yellow
powershell -File $scriptPath -SourceDir $exampleSource -OutputDir "build/tests/plots"

# 2. Verify output PDF exists
Write-Host "Step 2: Verifying output..." -ForegroundColor Yellow
$pdfPath = Join-Path $buildDir "plot_example.pdf"
if (Test-Path $pdfPath) {
    $size = (Get-Item $pdfPath).Length
    Write-Host "SUCCESS: $pdfPath exists ($size bytes)" -ForegroundColor Green
} else {
    Write-Error "FAILURE: $pdfPath not found"
}

# 3. Audit log for package loading
Write-Host "Step 3: Auditing log for package loading..." -ForegroundColor Yellow
$logPath = Join-Path $buildDir "plot_example.log"
if (Test-Path $logPath) {
    $logContent = Get-Content $logPath
    if ($logContent -match "otplots.sty") {
        Write-Host "SUCCESS: otplots.sty successfully loaded" -ForegroundColor Green
    } else {
        Write-Error "FAILURE: otplots.sty not found in log"
    }

    if ($logContent -match "pgfplots.sty") {
        Write-Host "SUCCESS: pgfplots.sty successfully loaded" -ForegroundColor Green
    }
}

Write-Host "All PGFPlots tests passed." -ForegroundColor Green
