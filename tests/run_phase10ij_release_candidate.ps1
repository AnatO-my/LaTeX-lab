param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase10ij-release-candidate"
$reportJson = Join-Path $reportRoot "phase10ij_release_candidate.json"
$reportMarkdown = Join-Path $reportRoot "phase10ij_release_candidate.md"

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
    $targetedPath = "docs\TARGETED_REGRESSION_GATE_PLAN.md"
    $dryRunPath = "docs\RELEASE_CANDIDATE_DRY_RUN.md"

    $requiredFiles = @(
        $targetedPath,
        $dryRunPath,
        "docs\CI_RELEASE_GATE_PLAN.md",
        "docs\LOCAL_RELEASE_CHECKLIST.md",
        "docs\RELEASE_NOTES_TEMPLATE.md",
        "docs\RELEASE_ASSET_MANIFEST_TEMPLATE.md",
        "PHASE10_CHECKPOINT_10I_10J.md",
        "tests\run_phase10ij_release_candidate.ps1",
        "CHANGELOG.md",
        "PROJECT_STATE.md",
        "README.md"
    )

    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required Phase 10I/J file is missing."
        }
    }

    $requiredMarkers = @(
        [pscustomobject]@{ Path = $targetedPath; Pattern = "Targeted Regression Checks"; Message = "Targeted regression workflow name is missing." },
        [pscustomobject]@{ Path = $targetedPath; Pattern = "tests\run_phase6f_tests.ps1"; Message = "Phase 6F targeted regression candidate is missing." },
        [pscustomobject]@{ Path = $targetedPath; Pattern = "tests\run_ot_phase5_tests.ps1"; Message = "Phase 5 targeted regression candidate is missing." },
        [pscustomobject]@{ Path = $targetedPath; Pattern = "Do not add targeted regression checks to branch protection yet."; Message = "Targeted regression branch-protection boundary is missing." },
        [pscustomobject]@{ Path = $targetedPath; Pattern = "Phase 10I creates no targeted regression workflow"; Message = "Phase 10I boundary is missing." },
        [pscustomobject]@{ Path = $dryRunPath; Pattern = "v0.1.0-rc-dry-run"; Message = "Dry-run candidate label is missing." },
        [pscustomobject]@{ Path = $dryRunPath; Pattern = "Do not create this as a Git tag."; Message = "Dry-run no-tag boundary is missing." },
        [pscustomobject]@{ Path = $dryRunPath; Pattern = "tests\run_phase10ij_release_candidate.ps1"; Message = "Dry-run command chain does not include the 10I/J guard." },
        [pscustomobject]@{ Path = $dryRunPath; Pattern = "docs/RELEASE_NOTES_TEMPLATE.md"; Message = "Dry-run release-notes link is missing." },
        [pscustomobject]@{ Path = $dryRunPath; Pattern = "docs/RELEASE_ASSET_MANIFEST_TEMPLATE.md"; Message = "Dry-run asset-manifest link is missing." },
        [pscustomobject]@{ Path = $dryRunPath; Pattern = "Phase 10J creates no Git tag"; Message = "Phase 10J boundary is missing." },
        [pscustomobject]@{ Path = "docs\CI_RELEASE_GATE_PLAN.md"; Pattern = "docs/TARGETED_REGRESSION_GATE_PLAN.md"; Message = "CI release-gate plan must link the targeted regression plan." },
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "docs/RELEASE_CANDIDATE_DRY_RUN.md"; Message = "Local release checklist must link the release-candidate dry run." },
        [pscustomobject]@{ Path = "PHASE10_CHECKPOINT_10I_10J.md"; Pattern = "Checkpoints 10I and 10J add targeted regression planning and a release-candidate dry run"; Message = "Checkpoint 10I/J summary is missing." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "### Added (Checkpoints 10I and 10J)"; Message = "Changelog does not record 10I/J." },
        [pscustomobject]@{ Path = "PROJECT_STATE.md"; Pattern = "Checkpoints 10I and 10J add targeted regression planning and a release-candidate dry run"; Message = "Project state does not record 10I/J." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/RELEASE_CANDIDATE_DRY_RUN.md"; Message = "README does not link the release-candidate dry run." }
    )

    foreach ($marker in $requiredMarkers) {
        if (-not (Test-FileContains -Path $marker.Path -Pattern $marker.Pattern)) {
            Add-Finding $findings "fail" $marker.Path $marker.Message
        }
    }

    foreach ($unexpected in @(".github\workflows\targeted-regression-checks.yml", "build.lua")) {
        if (Test-Path -LiteralPath $unexpected) {
            Add-Finding $findings "warn" $unexpected "Unexpected implementation artifact exists for a planning-only checkpoint."
        }
    }

    Add-Finding $findings "info" "release candidate" "Phase 10I/J records plans and a dry run without publishing a release."

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count
    $infoCount = @($findings | Where-Object { $_.Level -eq "info" }).Count

    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name RequiredFileCount -Value $requiredFiles.Count
    $report | Add-Member -MemberType NoteProperty -Name RequiredMarkerCount -Value $requiredMarkers.Count
    $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name FailCount -Value $failCount
    $report | Add-Member -MemberType NoteProperty -Name WarnCount -Value $warnCount
    $report | Add-Member -MemberType NoteProperty -Name InfoCount -Value $infoCount

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 10I/J Release Candidate Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* required files: $($report.RequiredFileCount)")
    $lines.Add("* required markers: $($report.RequiredMarkerCount)")
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

    Write-Host "Phase 10I/J release candidate report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 10I/J release candidate JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 10I/J release candidate found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 10I/J release candidate checks passed with $warnCount warning(s) and $infoCount note(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
