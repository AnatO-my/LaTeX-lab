param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase10a-release-policy"
$reportJson = Join-Path $reportRoot "phase10a_release_policy.json"
$reportMarkdown = Join-Path $reportRoot "phase10a_release_policy.md"

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
        "docs\VERSIONING_RELEASE_POLICY.md",
        "PHASE10_CHECKPOINT_10A.md",
        "tests\run_phase10a_release_policy.ps1",
        "CHANGELOG.md",
        "PROJECT_STATE.md",
        "README.md"
    )

    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required Phase 10A file is missing."
        }
    }

    $requiredMarkers = @(
        [pscustomobject]@{ Path = "docs\VERSIONING_RELEASE_POLICY.md"; Pattern = "Phase 10A does not change these values."; Message = "Policy must preserve current source versions." },
        [pscustomobject]@{ Path = "docs\VERSIONING_RELEASE_POLICY.md"; Pattern = "Generated PDFs, author kits, and preview zips remain release assets."; Message = "Generated-asset release rule is missing." },
        [pscustomobject]@{ Path = "docs\VERSIONING_RELEASE_POLICY.md"; Pattern = "v0.1.0"; Message = "Repository release-label examples are missing." },
        [pscustomobject]@{ Path = "PHASE10_CHECKPOINT_10A.md"; Pattern = "Checkpoint 10A opens Phase 10"; Message = "Checkpoint does not open Phase 10." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "## Phase 10"; Message = "Changelog does not record Phase 10." },
        [pscustomobject]@{ Path = "PROJECT_STATE.md"; Pattern = "Checkpoint 10A opens Phase 10"; Message = "Project state does not record Checkpoint 10A." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/VERSIONING_RELEASE_POLICY.md"; Message = "README does not link the versioning policy." }
    )

    foreach ($marker in $requiredMarkers) {
        if (-not (Test-FileContains -Path $marker.Path -Pattern $marker.Pattern)) {
            Add-Finding $findings "fail" $marker.Path $marker.Message
        }
    }

    $provideRecords = New-Object System.Collections.ArrayList
    foreach ($file in (Get-ChildItem -Path "src" -Include "*.cls", "*.sty" -Recurse -File | Sort-Object FullName)) {
        $lineNumber = 0
        foreach ($line in (Get-Content -Path $file.FullName)) {
            $lineNumber += 1
            if ($line -match "^\s*\\Provides(Class|Package)") {
                [void]$provideRecords.Add([pscustomobject]@{
                    Path = $file.FullName.Substring($root.Length + 1)
                    Line = $lineNumber
                    Declaration = $line.Trim()
                    HasSemanticVersion = [bool]($line -match " v[0-9]+\.[0-9]+")
                })
            }
        }
    }

    if ($provideRecords.Count -lt 10) {
        Add-Finding $findings "fail" "src" "Expected at least 10 class/package declarations; found $($provideRecords.Count)."
    }

    $semanticCount = @($provideRecords | Where-Object { $_.HasSemanticVersion }).Count
    Add-Finding $findings "info" "version inventory" "Found $($provideRecords.Count) Provides declarations; $semanticCount include semantic version text."

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count
    $infoCount = @($findings | Where-Object { $_.Level -eq "info" }).Count

    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name ProvidesDeclarationCount -Value $provideRecords.Count
    $report | Add-Member -MemberType NoteProperty -Name SemanticVersionDeclarationCount -Value $semanticCount
    $report | Add-Member -MemberType NoteProperty -Name ProvidesDeclarations -Value @($provideRecords.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name FailCount -Value $failCount
    $report | Add-Member -MemberType NoteProperty -Name WarnCount -Value $warnCount
    $report | Add-Member -MemberType NoteProperty -Name InfoCount -Value $infoCount

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 10A Release Policy Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* Provides declarations: $($report.ProvidesDeclarationCount)")
    $lines.Add("* Semantic version declarations: $($report.SemanticVersionDeclarationCount)")
    $lines.Add("* findings: $($findings.Count)")
    $lines.Add("* warnings: $warnCount")
    $lines.Add("* failures: $failCount")
    $lines.Add("")
    $lines.Add("## Provides Declarations")
    $lines.Add("")
    $lines.Add("| Path | Line | Semantic version | Declaration |")
    $lines.Add("| --- | ---: | --- | --- |")
    foreach ($record in $provideRecords) {
        $declaration = $record.Declaration.Replace("|", "\|")
        $lines.Add("| $($record.Path) | $($record.Line) | $($record.HasSemanticVersion) | ``$declaration`` |")
    }
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

    Write-Host "Phase 10A release policy report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 10A release policy JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 10A release policy found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 10A release policy checks passed with $infoCount note(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
