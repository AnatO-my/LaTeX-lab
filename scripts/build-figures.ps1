<#
.SYNOPSIS
    Builds standalone TikZ figures into cropped PDFs.

.DESCRIPTION
    Searches for .tex files in the specified directory (or examples/figures by default)
    and compiles them using latexmk with the standalone class logic.
#>

param(
    [string]$SourceDir = "examples/figures",
    [string]$OutputDir = "build/figures"
)

$ErrorActionPreference = "Stop"

$root = Get-Location
$fullSourceDir = Join-Path $root $SourceDir
$fullOutputDir = Join-Path $root $OutputDir

if (-not (Test-Path $fullSourceDir)) {
    Write-Error "Source directory not found: $fullSourceDir"
}

if (-not (Test-Path $fullOutputDir)) {
    New-Item -ItemType Directory -Path $fullOutputDir -Force | Out-Null
}

$files = Get-ChildItem -Path $fullSourceDir -Filter "*.tex"

Write-Host "Found $($files.Count) figure(s) in $SourceDir" -ForegroundColor Cyan

foreach ($file in $files) {
    Write-Host "Building $($file.Name)..." -ForegroundColor Yellow

    # We use -pdf and -cd to build the figure
    # Standalone class handles the cropping
    $jobName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

    # Run latexmk
    # We point output to the build directory
    & latexmk -pdf -interaction=nonstopmode -output-directory="$fullOutputDir" "$($file.FullName)"

    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to build $($file.Name)"
    }
}

Write-Host "Build complete. Assets are in $OutputDir" -ForegroundColor Green
