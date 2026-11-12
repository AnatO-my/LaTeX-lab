<#
.SYNOPSIS
    Build runner for the "Spong Re-construction" Project.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/spong"
$testSource = "examples/spong_reconstruction/spong_reconstruction.tex"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

# Set TEXINPUTS
$env:TEXINPUTS = "$root/src/classes;$root/src/packages;" + $env:TEXINPUTS

Write-Host "Building The Spong Re-construction..." -ForegroundColor Cyan

# 1. First pass
& pdflatex -interaction=nonstopmode -output-directory="$buildDir" "$testSource"

# 2. Run tools
Push-Location $buildDir
& makeglossaries spong_reconstruction
& makeindex spong_reconstruction
& biber spong_reconstruction
Pop-Location

# 3. Final passes
& latexmk -pdf -interaction=nonstopmode -output-directory="$buildDir" "$testSource"

if ($LASTEXITCODE -ne 0) {
    Write-Error "Failed to build Spong Reconstruction"
}

Write-Host "SUCCESS: Spong Reconstruction PDF built at $buildDir\spong_reconstruction.pdf" -ForegroundColor Green
