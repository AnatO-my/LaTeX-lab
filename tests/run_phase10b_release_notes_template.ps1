param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase10b-release-notes-template"
$reportJson = Join-Path $reportRoot "phase10b_release_notes_template.json"
$reportMarkdown = Join-Path $reportRoot "phase10b_release_notes_template.md"

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
    $templatePath = "docs\RELEASE_NOTES_TEMPLATE.md"
    $requiredFiles = @(
        $templatePath,
        "PHASE10_CHECKPOINT_10B.md",
        "tests\run_phase10b_release_notes_template.ps1",
        "CHANGELOG.md",
        "PROJECT_STATE.md",
        "README.md"
    )

    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required Phase 10B file is missing."
        }
    }

    $requiredTemplateSections = @(
        '# Release Notes Template',
        '## Release',
        '## Summary',
        '## Highlights',
        '## Public Interface Changes',
        '## Verification',
        '## Release Assets',
        '## Upgrade Notes',
        '## Known Limitations',
        '## Links'
    )

    foreach ($section in $requiredTemplateSections) {
        if (-not (Test-FileContains -Path $templatePath -Pattern $section)) {
            Add-Finding $findings "fail" $templatePath "Missing release-note section: $section"
        }
    }

    $requiredTemplateMarkers = @(
        'Label: v0.1.0',
        'Source commit:',
        'Release type: patch | minor | major',
        'No public-interface changes.',
        '`git diff --check`',
        'Generated PDFs, author kits, and preview zips are release assets.',
        'No release assets.',
        'No author action required.',
        'docs/VERSIONING_RELEASE_POLICY.md',
        'docs/PUBLIC_INTERFACES.md'
    )

    foreach ($marker in $requiredTemplateMarkers) {
        if (-not (Test-FileContains -Path $templatePath -Pattern $marker)) {
            Add-Finding $findings "fail" $templatePath "Missing release-note marker: $marker"
        }
    }

    $requiredRecordMarkers = @(
        [pscustomobject]@{ Path = "PHASE10_CHECKPOINT_10B.md"; Pattern = "Checkpoint 10B adds the first release-notes template"; Message = "Checkpoint 10B summary is missing." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "### Added (Checkpoint 10B)"; Message = "Changelog does not record Checkpoint 10B." },
        [pscustomobject]@{ Path = "PROJECT_STATE.md"; Pattern = "Checkpoint 10B adds the first release-notes template"; Message = "Project state does not record Checkpoint 10B." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/RELEASE_NOTES_TEMPLATE.md"; Message = "README does not link the release notes template." }
    )

    foreach ($record in $requiredRecordMarkers) {
        if (-not (Test-FileContains -Path $record.Path -Pattern $record.Pattern)) {
            Add-Finding $findings "fail" $record.Path $record.Message
        }
    }

    Add-Finding $findings "info" "release notes" "Template is policy-only and creates no release tag or asset."

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count
    $infoCount = @($findings | Where-Object { $_.Level -eq "info" }).Count

    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name RequiredSectionCount -Value $requiredTemplateSections.Count
    $report | Add-Member -MemberType NoteProperty -Name RequiredMarkerCount -Value ($requiredTemplateMarkers.Count + $requiredRecordMarkers.Count)
    $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name FailCount -Value $failCount
    $report | Add-Member -MemberType NoteProperty -Name WarnCount -Value $warnCount
    $report | Add-Member -MemberType NoteProperty -Name InfoCount -Value $infoCount

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 10B Release Notes Template Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* required template sections: $($report.RequiredSectionCount)")
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

    Write-Host "Phase 10B release notes template report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 10B release notes template JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 10B release notes template found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 10B release notes template checks passed with $infoCount note(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
