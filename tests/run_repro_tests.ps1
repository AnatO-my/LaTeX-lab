<#
.SYNOPSIS
    Test runner for Reproducible Documents (Ot-Calculator integration).
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/repro"
$testSource = "examples/otbook/reproducible_example.tex"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

# Copy snippets file to build dir
Copy-Item "examples/otbook/math_snippets.tex" $buildDir -Force

# Set TEXINPUTS explicitly
$env:TEXINPUTS = "$root/src/classes;$root/src/packages;" + $env:TEXINPUTS

Write-Host "Starting Reproducible Docs Tests..." -ForegroundColor Cyan

# Build the example
Write-Host "Step 1: Building with pdflatex..." -ForegroundColor Yellow
& pdflatex -interaction=nonstopmode -output-directory="$buildDir" "$testSource"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build reproducible example"
}

# 2. Verify output PDF exists
Write-Host "Step 2: Verifying output..." -ForegroundColor Yellow
$pdfPath = Join-Path $buildDir "reproducible_example.pdf"
if (Test-Path $pdfPath) {
    $size = (Get-Item $pdfPath).Length
    Write-Host "SUCCESS: $pdfPath exists ($size bytes)" -ForegroundColor Green
} else {
    Write-Error "FAILURE: $pdfPath not found"
}

# 3. Check logs
Write-Host "Step 3: Checking logs..." -ForegroundColor Yellow
$logPath = Join-Path $buildDir "reproducible_example.log"
if (Test-Path $logPath) {
    $logContent = Get-Content $logPath
    if ($logContent -match "otreproduce.sty") {
        Write-Host "SUCCESS: otreproduce.sty successfully loaded" -ForegroundColor Green
    }
}

Write-Host "Reproducible Docs tests completed." -ForegroundColor Green
