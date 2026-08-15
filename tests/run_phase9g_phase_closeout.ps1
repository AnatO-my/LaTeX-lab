param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase9g-closeout"
$reportJson = Join-Path $reportRoot "phase9g_closeout.json"
$reportMarkdown = Join-Path $reportRoot "phase9g_closeout.md"

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
        "PHASE9_CHECKPOINT_9A.md",
        "PHASE9_CHECKPOINT_9B.md",
        "PHASE9_CHECKPOINT_9C.md",
        "PHASE9_CHECKPOINT_9D.md",
        "PHASE9_CHECKPOINT_9E.md",
        "PHASE9_CHECKPOINT_9F.md",
        "PHASE9_CHECKPOINT_9G.md",
        "docs\BUILD_MEASUREMENT_BASELINE.md",
        "docs\GENERATED_FILE_HYGIENE.md",
        "docs\BUILD_RECIPE_RELIABILITY.md",
        "docs\STARTER_SUITE_TIMING.md",
        "docs\TIKZ_DOTGRID_AUDIT.md",
        "docs\DOTGRID_MODERNIZATION.md",
        "docs\PHASE9_CLOSEOUT.md",
        "tests\run_phase9a_measurement.ps1",
        "tests\run_phase9b_generated_hygiene.ps1",
        "tests\run_phase9c_build_recipe_reliability.ps1",
        "tests\run_phase9d_starter_timing.ps1",
        "tests\run_phase9e_tikz_dotgrid_audit.ps1",
        "tests\run_phase9f_dotgrid_modernization.ps1",
        "tests\run_phase9g_phase_closeout.ps1"
    )

    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required Phase 9 closeout file is missing."
        }
    }

    $requiredMarkers = @(
        [pscustomobject]@{ Path = "PHASE9_CHECKPOINT_9A.md"; Pattern = "All Phase 9A measurements passed in 15.75 seconds."; Message = "Phase 9A measurement result is not recorded." },
        [pscustomobject]@{ Path = "PHASE9_CHECKPOINT_9B.md"; Pattern = "visible untracked generated-looking files | 0"; Message = "Phase 9B hygiene result is not recorded." },
        [pscustomobject]@{ Path = "PHASE9_CHECKPOINT_9C.md"; Pattern = "All Phase 9C build-recipe reliability checks passed."; Message = "Phase 9C reliability result is not recorded." },
        [pscustomobject]@{ Path = "PHASE9_CHECKPOINT_9D.md"; Pattern = "All Phase 9D starter timing checks passed in 13.64 seconds."; Message = "Phase 9D timing result is not recorded." },
        [pscustomobject]@{ Path = "PHASE9_CHECKPOINT_9E.md"; Pattern = "All Phase 9E TikZ/dot-grid audit checks passed with 0 warning(s) and 3 note(s)."; Message = "Phase 9E audit result is not recorded." },
        [pscustomobject]@{ Path = "PHASE9_CHECKPOINT_9F.md"; Pattern = "All Phase 9F dot-grid modernization checks passed."; Message = "Phase 9F modernization result is not recorded." },
        [pscustomobject]@{ Path = "docs\DOTGRID_MODERNIZATION.md"; Pattern = "\setdotgridbackgroundimage{assets/dot-grid-a4.pdf}"; Message = "Dot-grid image/PDF author example is missing." },
        [pscustomobject]@{ Path = "docs\PHASE9_CLOSEOUT.md"; Pattern = "Phase 9 is complete"; Message = "Phase 9 closeout statement is missing." },
        [pscustomobject]@{ Path = "PROJECT_STATE.md"; Pattern = "completed on 14 August 2026"; Message = "Project state does not mark Phase 9 complete." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "### Closed (Checkpoint 9G)"; Message = "Changelog does not record Phase 9 closure." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/PHASE9_CLOSEOUT.md"; Message = "README does not link the Phase 9 closeout guide." }
    )

    foreach ($marker in $requiredMarkers) {
        if (-not (Test-FileContains -Path $marker.Path -Pattern $marker.Pattern)) {
            Add-Finding $findings "fail" $marker.Path $marker.Message
        }
    }

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
    $lines.Add("# Phase 9G Closeout Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* required files: $($requiredFiles.Count)")
    $lines.Add("* required markers: $($requiredMarkers.Count)")
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

    Write-Host "Phase 9G closeout report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 9G closeout JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 9G closeout found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 9G closeout checks passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
