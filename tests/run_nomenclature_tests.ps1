<#
.SYNOPSIS
    Test runner for the Nomenclature & Symbol Management package.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/nomenclature"
$testSource = "examples/otbook/nomenclature_example.tex"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

Write-Host "Starting Nomenclature Package Tests..." -ForegroundColor Cyan

# Set TEXINPUTS explicitly for this run
$env:TEXINPUTS = "$root/src/classes;$root/src/packages;" + $env:TEXINPUTS

# 1. First pass with pdflatex
Write-Host "Step 1: Building nomenclature example (Pass 1)..." -ForegroundColor Yellow
& latexmk -pdf -interaction=nonstopmode -output-directory="$buildDir" "$testSource"

# 2. Run makeglossaries
# Note: latexmk often handles this if configured, but we'll be explicit.
Write-Host "Step 2: Running makeglossaries..." -ForegroundColor Yellow
$jobName = [System.IO.Path]::GetFileNameWithoutExtension($testSource)
Push-Location $buildDir
& makeglossaries $jobName
Pop-Location

# 3. Second pass with pdflatex
Write-Host "Step 3: Building nomenclature example (Pass 2)..." -ForegroundColor Yellow
& latexmk -pdf -interaction=nonstopmode -output-directory="$buildDir" "$testSource"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build nomenclature example"
}

# 4. Verify output PDF exists
Write-Host "Step 4: Verifying output..." -ForegroundColor Yellow
$pdfPath = Join-Path $buildDir "nomenclature_example.pdf"
if (Test-Path $pdfPath) {
    $size = (Get-Item $pdfPath).Length
    Write-Host "SUCCESS: $pdfPath exists ($size bytes)" -ForegroundColor Green
} else {
    Write-Error "FAILURE: $pdfPath not found"
}

# 5. Check logs
Write-Host "Step 5: Checking logs..." -ForegroundColor Yellow
$logPath = Join-Path $buildDir "nomenclature_example.log"
if (Test-Path $logPath) {
    $logContent = Get-Content $logPath
    if ($logContent -match "otsymbols.sty") {
        Write-Host "SUCCESS: otsymbols.sty successfully loaded" -ForegroundColor Green
    }
}

Write-Host "All Nomenclature package tests completed." -ForegroundColor Green
