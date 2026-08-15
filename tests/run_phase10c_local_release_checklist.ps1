param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase10c-local-release-checklist"
$reportJson = Join-Path $reportRoot "phase10c_local_release_checklist.json"
$reportMarkdown = Join-Path $reportRoot "phase10c_local_release_checklist.md"

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
    $requiredFiles = @(
        "docs\LOCAL_RELEASE_CHECKLIST.md",
        "docs\RELEASE_NOTES_TEMPLATE.md",
        "docs\VERSIONING_RELEASE_POLICY.md",
        "docs\PUBLIC_INTERFACES.md",
        "docs\RELEASE_PDF_CHECKLIST.md",
        "docs\AUTHOR_KIT_BUILD_CHECKLIST.md",
        "PHASE10_CHECKPOINT_10C.md",
        "tests\run_phase10c_local_release_checklist.ps1",
        "CHANGELOG.md",
        "PROJECT_STATE.md",
        "README.md"
    )

    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required Phase 10C file is missing."
        }
    }

    $requiredMarkers = @(
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "git diff --check"; Message = "Release checklist must require whitespace checking." },
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "git status --short --branch"; Message = "Release checklist must require status review." },
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "docs/RELEASE_NOTES_TEMPLATE.md"; Message = "Release checklist must point to release notes." },
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "docs/VERSIONING_RELEASE_POLICY.md"; Message = "Release checklist must point to versioning policy." },
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "tests\run_phase7c_starter_tests.ps1"; Message = "Release checklist must name starter build verification." },
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "Generated assets should be attached to a GitHub release"; Message = "Release checklist must preserve generated-asset boundary." },
        [pscustomobject]@{ Path = "PHASE10_CHECKPOINT_10C.md"; Pattern = "Checkpoint 10C adds a local release checklist"; Message = "Checkpoint 10C summary is missing." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "### Added (Checkpoint 10C)"; Message = "Changelog does not record Checkpoint 10C." },
        [pscustomobject]@{ Path = "PROJECT_STATE.md"; Pattern = "Checkpoint 10C adds a local release checklist"; Message = "Project state does not record Checkpoint 10C." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/LOCAL_RELEASE_CHECKLIST.md"; Message = "README does not link the local release checklist." }
    )

    foreach ($marker in $requiredMarkers) {
        if (-not (Test-FileContains -Path $marker.Path -Pattern $marker.Pattern)) {
            Add-Finding $findings "fail" $marker.Path $marker.Message
        }
    }

    $statusLines = @(git status --short)
    $knownLocalOnly = @(
        ".vscode\settings.json",
        "src\classes\physicsquiz.cls",
        "AGENTS.md"
    )
    $unexpectedStatus = New-Object System.Collections.ArrayList
    foreach ($line in $statusLines) {
        if ([string]::IsNullOrWhiteSpace($line)) {
            continue
        }
        $path = $line.Substring(3).Replace("/", "\")
        if ($knownLocalOnly -notcontains $path) {
            [void]$unexpectedStatus.Add($line)
        }
    }

    if ($unexpectedStatus.Count -gt 0) {
        Add-Finding $findings "warn" "git status" "Unexpected local status entries remain: $($unexpectedStatus -join '; ')"
    } else {
        Add-Finding $findings "info" "git status" "Only known local-only files are visible in ordinary status."
    }

    Add-Finding $findings "info" "release boundary" "This checklist creates no tag, version bump, release asset, or CI change."

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count
    $infoCount = @($findings | Where-Object { $_.Level -eq "info" }).Count

    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name RequiredFileCount -Value $requiredFiles.Count
    $report | Add-Member -MemberType NoteProperty -Name RequiredMarkerCount -Value $requiredMarkers.Count
    $report | Add-Member -MemberType NoteProperty -Name UnexpectedStatus -Value @($unexpectedStatus.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name FailCount -Value $failCount
    $report | Add-Member -MemberType NoteProperty -Name WarnCount -Value $warnCount
    $report | Add-Member -MemberType NoteProperty -Name InfoCount -Value $infoCount

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 10C Local Release Checklist Report")
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

    Write-Host "Phase 10C local release checklist report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 10C local release checklist JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 10C local release checklist found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 10C local release checklist checks passed with $warnCount warning(s) and $infoCount note(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
