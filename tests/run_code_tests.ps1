<#
.SYNOPSIS
    Test runner for the OT Code and Algorithms package.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/code"
$testSource = "examples/figures/code_example.tex"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

Write-Host "Starting OT Code Package Tests..." -ForegroundColor Cyan

# 1. Build the code example
Write-Host "Step 1: Building code example..." -ForegroundColor Yellow
& latexmk -pdf -interaction=nonstopmode -output-directory="$buildDir" "$testSource"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build code example"
}

# 2. Verify output PDF exists
Write-Host "Step 2: Verifying output..." -ForegroundColor Yellow
$pdfPath = Join-Path $buildDir "code_example.pdf"
if (Test-Path $pdfPath) {
    $size = (Get-Item $pdfPath).Length
    Write-Host "SUCCESS: $pdfPath exists ($size bytes)" -ForegroundColor Green
} else {
    Write-Error "FAILURE: $pdfPath not found"
}

# 3. Check for package loading in log
Write-Host "Step 3: Checking logs..." -ForegroundColor Yellow
$logPath = Join-Path $buildDir "code_example.log"
if (Test-Path $logPath) {
    $logContent = Get-Content $logPath
    if ($logContent -match "otcode.sty") {
        Write-Host "SUCCESS: otcode.sty successfully loaded" -ForegroundColor Green
    } else {
        Write-Error "FAILURE: otcode.sty not found in log"
    }
}

Write-Host "All OT Code package tests completed." -ForegroundColor Green
