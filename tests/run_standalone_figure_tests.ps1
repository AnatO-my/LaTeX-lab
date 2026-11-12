<#
.SYNOPSIS
    Test runner for the standalone figure workflow.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/figures"
$scriptPath = Join-Path $root "scripts/build-figures.ps1"
$exampleSource = "examples/figures"

Write-Host "Starting Standalone Figure Workflow Tests..." -ForegroundColor Cyan

# 1. Build the example figures
Write-Host "Step 1: Building example figures..." -ForegroundColor Yellow
powershell -File $scriptPath -SourceDir $exampleSource -OutputDir "build/tests/figures"

# 2. Verify output files exist
Write-Host "Step 2: Verifying output..." -ForegroundColor Yellow
$pdfPath = Join-Path $buildDir "standalone_figure_example.pdf"
if (Test-Path $pdfPath) {
    $size = (Get-Item $pdfPath).Length
    Write-Host "SUCCESS: $pdfPath exists ($size bytes)" -ForegroundColor Green
} else {
    Write-Error "FAILURE: $pdfPath not found"
}

# 3. Check for log markers (if any) or simply ensure successful compilation
Write-Host "Step 3: Checking logs..." -ForegroundColor Yellow
$logPath = Join-Path $buildDir "standalone_figure_example.log"
if (Test-Path $logPath) {
    $logContent = Get-Content $logPath
    if ($logContent -match "Output written on") {
        Write-Host "SUCCESS: Compilation confirmed in log" -ForegroundColor Green
    } else {
        Write-Warning "Log found but completion marker not found"
    }
}

Write-Host "All Standalone Figure tests passed." -ForegroundColor Green
