<#
.SYNOPSIS
    Test runner for the Book-specific Margin-Note Helper.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/margin-notes"
$testSource = "examples/otbook/margin_note_test.tex"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

Write-Host "Starting Margin-Note Helper Tests..." -ForegroundColor Cyan

# 1. Build Oneside (Default)
Write-Host "Step 1: Building oneside (default)..." -ForegroundColor Yellow
& latexmk -pdf -interaction=nonstopmode -output-directory="$buildDir" "$testSource"
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to build oneside test" }

# 2. Build Twoside
Write-Host "Step 2: Building twoside..." -ForegroundColor Yellow
$twosideDir = Join-Path $buildDir "twoside"
if (-not (Test-Path $twosideDir)) { New-Item -ItemType Directory -Path $twosideDir -Force | Out-Null }

# Create a temporary wrapper for twoside
$twosideSource = Join-Path $twosideDir "twoside_test.tex"
Set-Content -Path $twosideSource -Value '\PassOptionsToClass{twoside}{book}'
Add-Content -Path $twosideSource -Value (Get-Content $testSource)

& latexmk -pdf -interaction=nonstopmode -output-directory="$twosideDir" "$twosideSource"
if ($LASTEXITCODE -ne 0) { Write-Error "Failed to build twoside test" }

Write-Host "Verification: Checking logs for marginpar warnings..." -ForegroundColor Yellow
$logs = Get-ChildItem -Path $buildDir -Filter "*.log" -Recurse
foreach ($log in $logs) {
    $content = Get-Content $log.FullName
    if ($content -match "marginpar on page .* moved") {
        Write-Warning "Margin note collision/move detected in $($log.Name)"
    }
}

Write-Host "All Margin-Note Helper tests completed." -ForegroundColor Green
