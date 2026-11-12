<#
.SYNOPSIS
    Test runner for Accessibility pilot.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/access"
$testSource = "examples/manual/accessibility_example.tex"

if (Test-Path $buildDir) {
    Remove-Item -Path $buildDir -Recurse -Force
}
New-Item -ItemType Directory -Path $buildDir -Force | Out-Null

# Set TEXINPUTS explicitly
$env:TEXINPUTS = "$root/src/classes;$root/src/packages;" + $env:TEXINPUTS

Write-Host "Starting Accessibility Profile Tests..." -ForegroundColor Cyan

# Build the example
Write-Host "Step 1: Building with pdflatex..." -ForegroundColor Yellow
& pdflatex -interaction=nonstopmode -output-directory="$buildDir" "$testSource"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build access example"
}

# 2. Verify output PDF exists
Write-Host "Step 2: Verifying output..." -ForegroundColor Yellow
$pdfPath = Join-Path $buildDir "accessibility_example.pdf"
if (Test-Path $pdfPath) {
    $size = (Get-Item $pdfPath).Length
    Write-Host "SUCCESS: $pdfPath exists ($size bytes)" -ForegroundColor Green
} else {
    Write-Error "FAILURE: $pdfPath not found"
}

# 3. Check logs
Write-Host "Step 3: Checking logs..." -ForegroundColor Yellow
$logPath = Join-Path $buildDir "accessibility_example.log"
if (Test-Path $logPath) {
    $logContent = Get-Content $logPath
    if ($logContent -match "otaccess.sty") {
        Write-Host "SUCCESS: otaccess.sty successfully loaded" -ForegroundColor Green
    }
}

Write-Host "Accessibility tests completed." -ForegroundColor Green
