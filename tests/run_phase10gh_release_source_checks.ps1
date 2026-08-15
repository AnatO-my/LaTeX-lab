param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase10gh-release-source-checks"
$reportJson = Join-Path $reportRoot "phase10gh_release_source_checks.json"
$reportMarkdown = Join-Path $reportRoot "phase10gh_release_source_checks.md"

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
    $workflowPath = ".github\workflows\release-source-checks.yml"
    $promotionPath = "docs\RELEASE_SOURCE_CHECKS_PROMOTION.md"

    $requiredFiles = @(
        $workflowPath,
        $promotionPath,
        "docs\CI_RELEASE_GATE_PLAN.md",
        "docs\GITHUB_ACTIONS_CI_CHECKLIST.md",
        "docs\BRANCH_PROTECTION_CHECKLIST.md",
        "PHASE10_CHECKPOINT_10G_10H.md",
        "tests\run_phase10gh_release_source_checks.ps1",
        "CHANGELOG.md",
        "PROJECT_STATE.md",
        "README.md"
    )

    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required Phase 10G/H file is missing."
        }
    }

    $requiredMarkers = @(
        [pscustomobject]@{ Path = $workflowPath; Pattern = "name: Release Source Checks"; Message = "Workflow name is missing." },
        [pscustomobject]@{ Path = $workflowPath; Pattern = "name: Release source checks"; Message = "Job name is missing." },
        [pscustomobject]@{ Path = $workflowPath; Pattern = "git diff --check"; Message = "Workflow must run whitespace check." },
        [pscustomobject]@{ Path = $workflowPath; Pattern = "tests\run_phase10a_release_policy.ps1"; Message = "Phase 10A guard is missing from workflow." },
        [pscustomobject]@{ Path = $workflowPath; Pattern = "tests\run_phase10f_ci_release_gate_plan.ps1"; Message = "Phase 10F guard is missing from workflow." },
        [pscustomobject]@{ Path = $workflowPath; Pattern = "tests\run_phase10gh_release_source_checks.ps1"; Message = "Phase 10G/H guard is missing from workflow." },
        [pscustomobject]@{ Path = $workflowPath; Pattern = "tests\run_phase9c_build_recipe_reliability.ps1"; Message = "Phase 9C parser is missing from workflow." },
        [pscustomobject]@{ Path = $promotionPath; Pattern = "Current branch protection should still require only:"; Message = "Promotion checklist must preserve current branch protection." },
        [pscustomobject]@{ Path = $promotionPath; Pattern = "Starter documents"; Message = "Promotion checklist must keep starter check required." },
        [pscustomobject]@{ Path = $promotionPath; Pattern = 'Promote `Release source checks` to a required status check only after:'; Message = "Promotion criteria are missing." },
        [pscustomobject]@{ Path = $promotionPath; Pattern = "Phase 10H does not change branch protection."; Message = "Phase 10H boundary is missing." },
        [pscustomobject]@{ Path = "docs\CI_RELEASE_GATE_PLAN.md"; Pattern = ".github/workflows/release-source-checks.yml"; Message = "CI release-gate plan must link the new workflow." },
        [pscustomobject]@{ Path = "docs\GITHUB_ACTIONS_CI_CHECKLIST.md"; Pattern = "docs/RELEASE_SOURCE_CHECKS_PROMOTION.md"; Message = "CI checklist must link the promotion checklist." },
        [pscustomobject]@{ Path = "docs\BRANCH_PROTECTION_CHECKLIST.md"; Pattern = "docs/RELEASE_SOURCE_CHECKS_PROMOTION.md"; Message = "Branch protection checklist must link the promotion checklist." },
        [pscustomobject]@{ Path = "PHASE10_CHECKPOINT_10G_10H.md"; Pattern = "Checkpoints 10G and 10H add the non-required Release source checks workflow"; Message = "Checkpoint 10G/H summary is missing." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "### Added (Checkpoints 10G and 10H)"; Message = "Changelog does not record 10G/H." },
        [pscustomobject]@{ Path = "PROJECT_STATE.md"; Pattern = "Checkpoints 10G and 10H add the non-required Release source checks workflow"; Message = "Project state does not record 10G/H." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/RELEASE_SOURCE_CHECKS_PROMOTION.md"; Message = "README does not link the promotion checklist." }
    )

    foreach ($marker in $requiredMarkers) {
        if (-not (Test-FileContains -Path $marker.Path -Pattern $marker.Pattern)) {
            Add-Finding $findings "fail" $marker.Path $marker.Message
        }
    }

    $workflowText = ""
    if (Test-Path -LiteralPath $workflowPath) {
        $workflowText = Get-Content -Raw -Path $workflowPath
    }

    foreach ($forbidden in @("latexmk", "mpm --install", "upload-artifact", "run_phase7c_starter_tests.ps1")) {
        if ($workflowText.Contains($forbidden)) {
            Add-Finding $findings "fail" $workflowPath "Release source checks must not run starter/PDF/MiKTeX workflow step: $forbidden"
        }
    }

    Add-Finding $findings "info" "release source checks" "Workflow is added, but branch protection is not changed by source."

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
    $lines.Add("# Phase 10G/H Release Source Checks Report")
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

    Write-Host "Phase 10G/H release source checks report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 10G/H release source checks JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 10G/H release source checks found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 10G/H release source checks passed with $warnCount warning(s) and $infoCount note(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
