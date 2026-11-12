Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$manualPath = "examples\manual\ot_author_workbook_manual.tex"
$checkpointPath = "docs\AUTHOR_WORKBOOK_MANUAL_CHECKPOINT.md"

$requiredFiles = @(
    "src/classes/physicsquiz.cls",
    "src/classes/studentnotes.cls",
    "src/classes/otscience.cls",
    "src/classes/otengineering.cls",
    "src/packages/otcore.sty",
    "src/packages/ottheme.sty",
    "src/packages/otboxes.sty",
    "src/packages/otmath.sty",
    "src/packages/otnotation.sty",
    "src/packages/ottensors.sty",
    "src/packages/otphysics.sty",
    "src/packages/otcoordinates.sty",
    "src/packages/otpractice.sty",
    "src/packages/otfigures.sty",
    "src/legacy/otscience.sty"
)

$requiredManualMarkers = @(
    "\section{Start Here}",
    "\subsection{Decision Guide}",
    "\subsection{Class Comparison}",
    "\subsection{Package Comparison}",
    "\section{Dependency Catalog}",
    "\section{Do Not Use Directly Unless}",
    "\section{physicsquiz.cls}",
    "\section{studentnotes.cls}",
    "\section{otscience.cls}",
    "\section{otengineering.cls}",
    "\section{Shared Packages}",
    "\section{Legacy and Compatibility Appendix}",
    "Do not use \pkg{src/legacy/otscience.sty} for new documents",
    "\section{Ambiguous, Internal, or Unsafe to Present as Public}",
    "\section{Source-Reference Appendix}",
    "\subsection{Line-Reference Method}"
)

function Add-Finding {
    param(
        [System.Collections.ArrayList]$Findings,
        [string]$Level,
        [string]$Path,
        [string]$Message
    )

    [void]$Findings.Add([pscustomobject]@{
        Level = $Level
        Path = $Path
        Message = $Message
    })
}

$findings = New-Object System.Collections.ArrayList

if (-not (Test-Path -LiteralPath $manualPath)) {
    Add-Finding $findings "fail" $manualPath "Manual source is missing."
}

if (-not (Test-Path -LiteralPath $checkpointPath)) {
    Add-Finding $findings "fail" $checkpointPath "Checkpoint document is missing."
}

if ($findings.Count -eq 0) {
    $manualText = Get-Content -Raw -Path $manualPath

    foreach ($marker in $requiredManualMarkers) {
        if ($manualText -notlike "*$marker*") {
            Add-Finding $findings "fail" $manualPath "Required manual marker is missing: $marker"
        }
    }

    foreach ($file in $requiredFiles) {
        $windowsPath = $file -replace "/", "\"
        if (-not (Test-Path -LiteralPath $windowsPath)) {
            Add-Finding $findings "fail" $file "Required inspected source file is missing."
            continue
        }
        if ($manualText -notlike "*$file*") {
            Add-Finding $findings "fail" $manualPath "Manual does not name inspected file: $file"
        }
    }

    $sourceRefPattern = "\{(src/(?:classes|packages|legacy)/[^}]+)\}\{([0-9]+)\}"
    $matches = [regex]::Matches($manualText, $sourceRefPattern)
    if ($matches.Count -lt 150) {
        Add-Finding $findings "fail" $manualPath "Manual has too few source references for a comprehensive catalog: $($matches.Count)"
    }

    foreach ($match in $matches) {
        $sourcePath = $match.Groups[1].Value
        $lineNumber = [int]$match.Groups[2].Value
        $windowsPath = $sourcePath -replace "/", "\"

        if (-not (Test-Path -LiteralPath $windowsPath)) {
            Add-Finding $findings "fail" $sourcePath "Source reference points to a missing file."
            continue
        }

        $lines = Get-Content -Path $windowsPath
        if ($lineNumber -lt 1 -or $lineNumber -gt $lines.Count) {
            Add-Finding $findings "fail" $sourcePath "Line reference $lineNumber is outside the file length $($lines.Count)."
            continue
        }

        if ([string]::IsNullOrWhiteSpace($lines[$lineNumber - 1])) {
            Add-Finding $findings "warn" $sourcePath "Line reference $lineNumber points to a blank line."
        }
    }

    $checkpointText = Get-Content -Raw -Path $checkpointPath -ErrorAction SilentlyContinue
    foreach ($marker in @("Included", "Excluded", "Still needs review", "Verification", "Generated-file hygiene")) {
        if ($checkpointText -notlike "*$marker*") {
            Add-Finding $findings "fail" $checkpointPath "Checkpoint is missing required marker: $marker"
        }
    }
}

$failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
$warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count

foreach ($finding in $findings) {
    $color = if ($finding.Level -eq "fail") { "Red" } elseif ($finding.Level -eq "warn") { "Yellow" } else { "Gray" }
    Write-Host "[$($finding.Level)] $($finding.Path): $($finding.Message)" -ForegroundColor $color
}

if ($failCount -gt 0) {
    throw "Author workbook manual guard found $failCount failure(s) and $warnCount warning(s)."
}

Write-Host "Author workbook manual guard passed with $warnCount warning(s) and $($matches.Count) source references checked." -ForegroundColor Green
