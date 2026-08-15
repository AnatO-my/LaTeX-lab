param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase10d-release-asset-manifest"
$reportJson = Join-Path $reportRoot "phase10d_release_asset_manifest.json"
$reportMarkdown = Join-Path $reportRoot "phase10d_release_asset_manifest.md"

function Add-Finding {
    param(
        [Parameter(Mandatory=$true)]$Findings,
        [Parameter(Mandatory=$true)][string]$Level,
        [Parameter(Mandatory=$true)][string]$Area,
        [Parameter(Mandatory=$true)][string]$Message
    )

    [void]$Findings.Add([pscustomobject]@{
        Level = $Level
        Area = $Area
        Message = $Message
    })
}

function Test-FileContains {
    param(
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$Pattern
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return $false
    }

    $text = Get-Content -Raw -Path $Path
    return $text.Contains($Pattern)
}

Push-Location $root
try {
    New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

    $findings = New-Object System.Collections.ArrayList
    $manifestPath = "docs\RELEASE_ASSET_MANIFEST_TEMPLATE.md"

    $requiredFiles = @(
        $manifestPath,
        "docs\LOCAL_RELEASE_CHECKLIST.md",
        "docs\RELEASE_PDF_CHECKLIST.md",
        "docs\AUTHOR_KIT_BUILD_CHECKLIST.md",
        "docs\RELEASE_NOTES_TEMPLATE.md",
        "docs\VERSIONING_RELEASE_POLICY.md",
        "PHASE10_CHECKPOINT_10D.md",
        "tests\run_phase10d_release_asset_manifest.ps1",
        "CHANGELOG.md",
        "PROJECT_STATE.md",
        "README.md"
    )

    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required Phase 10D file is missing."
        }
    }

    $requiredMarkers = @(
        [pscustomobject]@{ Path = $manifestPath; Pattern = "Use this template when a release needs downloadable PDFs or an author-kit zip."; Message = "Manifest purpose is missing." },
        [pscustomobject]@{ Path = $manifestPath; Pattern = "it does not make assets mandatory for every release"; Message = "Optional-asset boundary is missing." },
        [pscustomobject]@{ Path = $manifestPath; Pattern = "Release assets are built from a committed source state."; Message = "Committed-source rule is missing." },
        [pscustomobject]@{ Path = $manifestPath; Pattern = "powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1"; Message = "Starter verification command is missing." },
        [pscustomobject]@{ Path = $manifestPath; Pattern = 'Record the result in `docs/RELEASE_NOTES_TEMPLATE.md`.'; Message = "Release-notes link is missing." },
        [pscustomobject]@{ Path = $manifestPath; Pattern = "sha256:<hash>"; Message = "Hash marker is missing." },
        [pscustomobject]@{ Path = $manifestPath; Pattern = "No tag, version bump, generated PDF, zip, or GitHub release is created by this"; Message = "No-release-action boundary is missing." },
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "docs/RELEASE_ASSET_MANIFEST_TEMPLATE.md"; Message = "Local release checklist does not link the asset manifest template." },
        [pscustomobject]@{ Path = "PHASE10_CHECKPOINT_10D.md"; Pattern = "Checkpoint 10D adds a release-asset manifest template"; Message = "Checkpoint 10D summary is missing." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "### Added (Checkpoint 10D)"; Message = "Changelog does not record Checkpoint 10D." },
        [pscustomobject]@{ Path = "PROJECT_STATE.md"; Pattern = "Checkpoint 10D adds a release-asset manifest template"; Message = "Project state does not record Checkpoint 10D." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/RELEASE_ASSET_MANIFEST_TEMPLATE.md"; Message = "README does not link the asset manifest template." }
    )

    foreach ($marker in $requiredMarkers) {
        if (-not (Test-FileContains -Path $marker.Path -Pattern $marker.Pattern)) {
            Add-Finding $findings "fail" $marker.Path $marker.Message
        }
    }

    $assetIds = @(
        "starter-pdfs",
        "starter-quiz-bank-pdf",
        "starter-versioned-quiz-pdf",
        "starter-student-notes-pdf",
        "starter-engineering-notes-pdf",
        "starter-science-notes-pdf",
        "starter-workbook-module-pdf",
        "starter-combined-workbook-pdf",
        "author-kit"
    )

    $manifestText = ""
    if (Test-Path -LiteralPath $manifestPath) {
        $manifestText = Get-Content -Raw -Path $manifestPath
    }

    foreach ($assetId in $assetIds) {
        $pattern = "| $assetId |"
        if (-not $manifestText.Contains($pattern)) {
            Add-Finding $findings "fail" $manifestPath "Missing planned release asset id: $assetId"
        }
    }

    Add-Finding $findings "info" "asset boundary" "The manifest is source-only and creates no release asset."
    Add-Finding $findings "info" "planned assets" "Tracked $($assetIds.Count) planned release asset id(s)."

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count
    $infoCount = @($findings | Where-Object { $_.Level -eq "info" }).Count

    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name RequiredFileCount -Value $requiredFiles.Count
    $report | Add-Member -MemberType NoteProperty -Name RequiredMarkerCount -Value $requiredMarkers.Count
    $report | Add-Member -MemberType NoteProperty -Name PlannedAssetCount -Value $assetIds.Count
    $report | Add-Member -MemberType NoteProperty -Name PlannedAssetIds -Value @($assetIds)
    $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name FailCount -Value $failCount
    $report | Add-Member -MemberType NoteProperty -Name WarnCount -Value $warnCount
    $report | Add-Member -MemberType NoteProperty -Name InfoCount -Value $infoCount

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 10D Release Asset Manifest Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* required files: $($report.RequiredFileCount)")
    $lines.Add("* required markers: $($report.RequiredMarkerCount)")
    $lines.Add("* planned assets: $($report.PlannedAssetCount)")
    $lines.Add("* findings: $($findings.Count)")
    $lines.Add("* warnings: $warnCount")
    $lines.Add("* failures: $failCount")
    $lines.Add("")
    $lines.Add("## Findings")
    $lines.Add("")
    if ($findings.Count -eq 0) {
        $lines.Add("None.")
    } else {
        $lines.Add("| Level | Area | Message |")
        $lines.Add("| --- | --- | --- |")
        foreach ($finding in $findings) {
            $message = $finding.Message.Replace("|", "\|")
            $lines.Add("| $($finding.Level) | $($finding.Area) | $message |")
        }
    }
    $lines | Set-Content -Path $reportMarkdown -Encoding UTF8

    Write-Host "Phase 10D release asset manifest report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 10D release asset manifest JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 10D release asset manifest found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 10D release asset manifest checks passed with $warnCount warning(s) and $infoCount note(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
