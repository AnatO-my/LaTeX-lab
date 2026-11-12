<#
.SYNOPSIS
    Test runner for the CircuiTikZ integration.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/circuits"
$scriptPath = Join-Path $root "scripts/build-figures.ps1"
$exampleSource = "examples/figures"

Write-Host "Starting CircuiTikZ Integration Tests..." -ForegroundColor Cyan

# 1. Build the circuit example using the standalone figure workflow
Write-Host "Step 1: Building circuit example..." -ForegroundColor Yellow
# We'll use the build-figures script directly as it's the intended workflow
powershell -File $scriptPath -SourceDir $exampleSource -OutputDir "build/tests/circuits"

# 2. Verify output PDF exists
Write-Host "Step 2: Verifying output..." -ForegroundColor Yellow
$pdfPath = Join-Path $buildDir "circuit_example.pdf"
if (Test-Path $pdfPath) {
    $size = (Get-Item $pdfPath).Length
    Write-Host "SUCCESS: $pdfPath exists ($size bytes)" -ForegroundColor Green
} else {
    Write-Error "FAILURE: $pdfPath not found"
}

# 3. Basic check of the log for the new package loading
Write-Host "Step 3: Auditing log for package loading..." -ForegroundColor Yellow
$logPath = Join-Path $buildDir "circuit_example.log"
if (Test-Path $logPath) {
    $logContent = Get-Content $logPath
    if ($logContent -match "otcircuits.sty") {
        Write-Host "SUCCESS: otcircuits.sty successfully loaded" -ForegroundColor Green
    } else {
        Write-Error "FAILURE: otcircuits.sty not found in log"
    }

    if ($logContent -match "circuitikz.sty") {
        Write-Host "SUCCESS: circuitikz.sty successfully loaded" -ForegroundColor Green
    }
}

Write-Host "All CircuiTikZ tests passed." -ForegroundColor Green
