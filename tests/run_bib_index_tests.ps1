<#
.SYNOPSIS
    Test runner for Bibliography and Indexing modules.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/bib_index"
$testSource = "examples/otbook/bib_index_example.tex"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

# Set TEXINPUTS explicitly
$env:TEXINPUTS = "$root/src/classes;$root/src/packages;" + $env:TEXINPUTS

Write-Host "Starting Bibliography & Indexing Tests..." -ForegroundColor Cyan

# Use latexmk to handle multiple passes, biber, and makeindex
Write-Host "Step 1: Building with latexmk (automatic biber/makeindex)..." -ForegroundColor Yellow
& latexmk -pdf -interaction=nonstopmode -output-directory="$buildDir" "$testSource"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build bib/index example"
}

# 2. Verify output PDF exists
Write-Host "Step 2: Verifying output..." -ForegroundColor Yellow
$pdfPath = Join-Path $buildDir "bib_index_example.pdf"
if (Test-Path $pdfPath) {
    $size = (Get-Item $pdfPath).Length
    Write-Host "SUCCESS: $pdfPath exists ($size bytes)" -ForegroundColor Green
} else {
    Write-Error "FAILURE: $pdfPath not found"
}

# 3. Check for specific markers in logs
Write-Host "Step 3: Checking logs for biber/index activity..." -ForegroundColor Yellow
$logPath = Join-Path $buildDir "bib_index_example.log"
$blgPath = Join-Path $buildDir "bib_index_example.blg" # Biber log

if (Test-Path $logPath) {
    $logContent = Get-Content $logPath
    if ($logContent -match "otbib.sty" -and $logContent -match "otindex.sty") {
        Write-Host "SUCCESS: Packages successfully loaded" -ForegroundColor Green
    }
}

if (Test-Path $blgPath) {
    Write-Host "SUCCESS: Biber was executed (.blg exists)" -ForegroundColor Green
}

Write-Host "Bibliography & Indexing tests completed." -ForegroundColor Green
