<#
.SYNOPSIS
    Test runner for Build Profiles.
#>

$ErrorActionPreference = "Stop"
$root = Get-Location
$buildDir = Join-Path $root "build/tests/profiles"
$testSource = "examples/otbook/profile_example.tex"

if (-not (Test-Path $buildDir)) {
    New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

# Set TEXINPUTS explicitly
$env:TEXINPUTS = "$root/src/classes;$root/src/packages;" + $env:TEXINPUTS

Write-Host "Starting Build Profile Tests..." -ForegroundColor Cyan

# 1. Full Mode (Default)
Write-Host "Step 1: Building Full Mode (Default)..." -ForegroundColor Yellow
& pdflatex -interaction=nonstopmode -output-directory="$buildDir" -jobname="profile_full" "$testSource"

# 2. Student Mode
Write-Host "Step 2: Building Student Mode (Hiding Solutions)..." -ForegroundColor Yellow
& pdflatex -interaction=nonstopmode -output-directory="$buildDir" -jobname="profile_student" "\PassOptionsToPackage{mode=student}{otprofiles}\input{$testSource}"

# 3. Print Mode with Watermark
Write-Host "Step 3: Building Print Mode with Watermark..." -ForegroundColor Yellow
& pdflatex -interaction=nonstopmode -output-directory="$buildDir" -jobname="profile_print" "\PassOptionsToPackage{print=true, watermark=true}{otprofiles}\input{$testSource}"

# 4. Draft Mode
Write-Host "Step 4: Building Draft Mode..." -ForegroundColor Yellow
& pdflatex -interaction=nonstopmode -output-directory="$buildDir" -jobname="profile_draft" "\PassOptionsToPackage{mode=draft}{otprofiles}\input{$testSource}"

# Verification
Write-Host "Step 5: Verifying output..." -ForegroundColor Yellow

$files = @("profile_full.pdf", "profile_student.pdf", "profile_print.pdf", "profile_draft.pdf")
foreach ($f in $files) {
    $p = Join-Path $buildDir $f
    if (Test-Path $p) {
        Write-Host "SUCCESS: $f generated." -ForegroundColor Green
    } else {
        Write-Error "FAILURE: $f not found."
    }
}

Write-Host "Build Profile tests completed." -ForegroundColor Green
