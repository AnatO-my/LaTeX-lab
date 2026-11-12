<#
.SYNOPSIS
    Test runner for LuaLaTeX Typography profile.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/lualatex"
$testSource = "examples/otbook/lualatex_example.tex"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

# Set TEXINPUTS explicitly
$env:TEXINPUTS = "$root/src/classes;$root/src/packages;" + $env:TEXINPUTS

Write-Host "Starting LuaLaTeX Profile Tests..." -ForegroundColor Cyan

# Build the example using lualatex
Write-Host "Step 1: Building with lualatex..." -ForegroundColor Yellow
& lualatex -interaction=nonstopmode -output-directory="$buildDir" "$testSource"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build lualatex example"
}

# 2. Verify output PDF exists
Write-Host "Step 2: Verifying output..." -ForegroundColor Yellow
$pdfPath = Join-Path $buildDir "lualatex_example.pdf"
if (Test-Path $pdfPath) {
    $size = (Get-Item $pdfPath).Length
    Write-Host "SUCCESS: $pdfPath exists ($size bytes)" -ForegroundColor Green
} else {
    Write-Error "FAILURE: $pdfPath not found"
}

# 3. Check logs for fontspec
Write-Host "Step 3: Checking logs for fontspec..." -ForegroundColor Yellow
$logPath = Join-Path $buildDir "lualatex_example.log"
if (Test-Path $logPath) {
    $logContent = Get-Content $logPath
    if ($logContent -match "fontspec.sty") {
        Write-Host "SUCCESS: fontspec.sty successfully loaded" -ForegroundColor Green
    }
}

Write-Host "LuaLaTeX Profile tests completed." -ForegroundColor Green
