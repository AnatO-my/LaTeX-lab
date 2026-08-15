param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase10f-ci-release-gate-plan"
$reportJson = Join-Path $reportRoot "phase10f_ci_release_gate_plan.json"
$reportMarkdown = Join-Path $reportRoot "phase10f_ci_release_gate_plan.md"

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
    $planPath = "docs\CI_RELEASE_GATE_PLAN.md"

    $requiredFiles = @(
        $planPath,
        "docs\GITHUB_ACTIONS_CI_CHECKLIST.md",
        "docs\LOCAL_RELEASE_CHECKLIST.md",
        "docs\BRANCH_PROTECTION_CHECKLIST.md",
        "PHASE10_CHECKPOINT_10F.md",
        "tests\run_phase10f_ci_release_gate_plan.ps1",
        "CHANGELOG.md",
        "PROJECT_STATE.md",
        "README.md"
    )

    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required Phase 10F file is missing."
        }
    }

    $requiredMarkers = @(
        [pscustomobject]@{ Path = $planPath; Pattern = "This plan describes how hosted CI should grow from the current starter check"; Message = "Plan purpose is missing." },
        [pscustomobject]@{ Path = $planPath; Pattern = "Starter documents"; Message = "Current required starter gate is missing." },
        [pscustomobject]@{ Path = $planPath; Pattern = "Level 1 - Starter Gate"; Message = "Level 1 gate is missing." },
        [pscustomobject]@{ Path = $planPath; Pattern = "Level 2 - Release Source Gate"; Message = "Level 2 gate is missing." },
        [pscustomobject]@{ Path = $planPath; Pattern = "Level 3 - Targeted Regression Gate"; Message = "Level 3 gate is missing." },
        [pscustomobject]@{ Path = $planPath; Pattern = "Level 4 - Release Asset Gate"; Message = "Level 4 gate is missing." },
        [pscustomobject]@{ Path = $planPath; Pattern = "tests\run_phase10a_release_policy.ps1"; Message = "Release policy guard is missing from Level 2." },
        [pscustomobject]@{ Path = $planPath; Pattern = "tests\run_phase10e_l3build_pilot.ps1"; Message = "l3build pilot guard is missing from Level 2." },
        [pscustomobject]@{ Path = $planPath; Pattern = "tests\run_phase9c_build_recipe_reliability.ps1"; Message = "Build recipe reliability guard is missing from Level 2." },
        [pscustomobject]@{ Path = $planPath; Pattern = "tests\run_ot_phase5_tests.ps1"; Message = "OT regression candidate is missing from Level 3." },
        [pscustomobject]@{ Path = $planPath; Pattern = "Do not add a new required status check immediately."; Message = "Branch-protection caution is missing." },
        [pscustomobject]@{ Path = $planPath; Pattern = "Release source checks"; Message = "Future required check name is missing." },
        [pscustomobject]@{ Path = $planPath; Pattern = "Phase 10F creates no new GitHub Actions workflow"; Message = "Phase 10F boundary is missing." },
        [pscustomobject]@{ Path = "docs\GITHUB_ACTIONS_CI_CHECKLIST.md"; Pattern = "docs/CI_RELEASE_GATE_PLAN.md"; Message = "CI checklist does not link the release-gate plan." },
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "docs/CI_RELEASE_GATE_PLAN.md"; Message = "Local release checklist does not link the release-gate plan." },
        [pscustomobject]@{ Path = "PHASE10_CHECKPOINT_10F.md"; Pattern = "Checkpoint 10F adds a broader CI release-gate plan"; Message = "Checkpoint 10F summary is missing." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "### Added (Checkpoint 10F)"; Message = "Changelog does not record Checkpoint 10F." },
        [pscustomobject]@{ Path = "PROJECT_STATE.md"; Pattern = "Checkpoint 10F adds a broader CI release-gate plan"; Message = "Project state does not record Checkpoint 10F." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/CI_RELEASE_GATE_PLAN.md"; Message = "README does not link the CI release-gate plan." }
    )

    foreach ($marker in $requiredMarkers) {
        if (-not (Test-FileContains -Path $marker.Path -Pattern $marker.Pattern)) {
            Add-Finding $findings "fail" $marker.Path $marker.Message
        }
    }

    $unexpectedWorkflow = ".github\workflows\release-source-checks.yml"
    if (Test-Path -LiteralPath $unexpectedWorkflow) {
        Add-Finding $findings "warn" $unexpectedWorkflow "A release-source workflow exists; confirm this is a post-10F implementation step."
    }

    Add-Finding $findings "info" "release gate" "Phase 10F plans broader CI without adding a new required workflow."

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
    $lines.Add("# Phase 10F CI Release Gate Plan Report")
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

    Write-Host "Phase 10F CI release-gate plan report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 10F CI release-gate plan JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 10F CI release-gate plan found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 10F CI release-gate plan checks passed with $warnCount warning(s) and $infoCount note(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
