param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase10e-l3build-pilot"
$reportJson = Join-Path $reportRoot "phase10e_l3build_pilot.json"
$reportMarkdown = Join-Path $reportRoot "phase10e_l3build_pilot.md"

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
        ".github\workflows\starter-build.yml",
        "docs\L3BUILD_PILOT.md",
        "docs\GITHUB_ACTIONS_CI_CHECKLIST.md",
        "docs\LOCAL_RELEASE_CHECKLIST.md",
        "docs\VERSIONING_RELEASE_POLICY.md",
        "PHASE10_CHECKPOINT_10E.md",
        "tests\run_phase10e_l3build_pilot.ps1",
        "CHANGELOG.md",
        "PROJECT_STATE.md",
        "README.md"
    )

    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required Phase 10E file is missing."
        }
    }

    $requiredMarkers = @(
        [pscustomobject]@{ Path = "docs\L3BUILD_PILOT.md"; Pattern = 'Checkpoint 10E does not add an active root `build.lua`.'; Message = "Pilot must avoid active root build.lua adoption." },
        [pscustomobject]@{ Path = "docs\L3BUILD_PILOT.md"; Pattern = "PowerShell runners remain the source of truth for existing tests"; Message = "Pilot must preserve existing runners." },
        [pscustomobject]@{ Path = "docs\L3BUILD_PILOT.md"; Pattern = 'no release requires `l3build check`'; Message = "Pilot must keep l3build out of release requirements." },
        [pscustomobject]@{ Path = "docs\L3BUILD_PILOT.md"; Pattern = "tests/l3build-proof/"; Message = "Pilot must name the candidate proof folder." },
        [pscustomobject]@{ Path = "docs\L3BUILD_PILOT.md"; Pattern = 'Adopt `l3build` only when all of these are true'; Message = "Adoption conditions are missing." },
        [pscustomobject]@{ Path = "docs\L3BUILD_PILOT.md"; Pattern = 'Do not adopt `l3build` if'; Message = "Rejection conditions are missing." },
        [pscustomobject]@{ Path = "docs\L3BUILD_PILOT.md"; Pattern = 'It creates no active `build.lua`, no `.lvt` or `.tlg` fixtures'; Message = "Phase 10E boundary is missing." },
        [pscustomobject]@{ Path = ".github\workflows\starter-build.yml"; Pattern = '"amscls"'; Message = "Starter workflow must install amscls for amsthm.sty." },
        [pscustomobject]@{ Path = ".github\workflows\starter-build.yml"; Pattern = "MiKTeX package install failed for"; Message = "Starter workflow must fail loudly on package install errors." },
        [pscustomobject]@{ Path = "docs\GITHUB_ACTIONS_CI_CHECKLIST.md"; Pattern = '`amsthm.sty`'; Message = "CI checklist must record the hosted amsthm dependency failure." },
        [pscustomobject]@{ Path = "docs\GITHUB_ACTIONS_CI_CHECKLIST.md"; Pattern = '`amscls` provides `amsthm.sty`'; Message = "CI checklist must record the amscls package reason." },
        [pscustomobject]@{ Path = "docs\LOCAL_RELEASE_CHECKLIST.md"; Pattern = "docs/L3BUILD_PILOT.md"; Message = "Local release checklist does not link the l3build pilot." },
        [pscustomobject]@{ Path = "PHASE10_CHECKPOINT_10E.md"; Pattern = "Checkpoint 10E adds an l3build pilot decision record"; Message = "Checkpoint 10E summary is missing." },
        [pscustomobject]@{ Path = "PHASE10_CHECKPOINT_10E.md"; Pattern = "Hosted Starter CI Follow-up"; Message = "Checkpoint 10E CI follow-up is missing." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "### Added (Checkpoint 10E)"; Message = "Changelog does not record Checkpoint 10E." },
        [pscustomobject]@{ Path = "CHANGELOG.md"; Pattern = "### Changed (Hosted Starter CI Follow-up)"; Message = "Changelog does not record the hosted starter CI follow-up." },
        [pscustomobject]@{ Path = "PROJECT_STATE.md"; Pattern = "Checkpoint 10E adds an l3build pilot decision record"; Message = "Project state does not record Checkpoint 10E." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/L3BUILD_PILOT.md"; Message = "README does not link the l3build pilot." }
    )

    foreach ($marker in $requiredMarkers) {
        if (-not (Test-FileContains -Path $marker.Path -Pattern $marker.Pattern)) {
            Add-Finding $findings "fail" $marker.Path $marker.Message
        }
    }

    $rootBuildLua = Join-Path $root "build.lua"
    if (Test-Path -LiteralPath $rootBuildLua) {
        Add-Finding $findings "fail" "build.lua" "Phase 10E must not add an active root build.lua."
    }

    $proofBuildLua = Join-Path $root "tests\l3build-proof\build.lua"
    if (Test-Path -LiteralPath $proofBuildLua) {
        Add-Finding $findings "warn" "tests\l3build-proof\build.lua" "A proof build.lua exists; confirm this was an intentional post-10E adoption step."
    }

    $l3buildCommand = Get-Command l3build -ErrorAction SilentlyContinue
    if ($null -eq $l3buildCommand) {
        Add-Finding $findings "warn" "l3build availability" "l3build is not visible on PATH in this shell; Phase 10E records the pilot but does not require the tool."
    } else {
        Add-Finding $findings "info" "l3build availability" "l3build is visible at $($l3buildCommand.Source)."
    }

    Add-Finding $findings "info" "adoption boundary" "This pilot creates no root build.lua, .lvt, .tlg, release tag, version bump, asset, or CI requirement."

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count
    $infoCount = @($findings | Where-Object { $_.Level -eq "info" }).Count

    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name RequiredFileCount -Value $requiredFiles.Count
    $report | Add-Member -MemberType NoteProperty -Name RequiredMarkerCount -Value $requiredMarkers.Count
    $report | Add-Member -MemberType NoteProperty -Name L3BuildAvailable -Value ($null -ne $l3buildCommand)
    $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name FailCount -Value $failCount
    $report | Add-Member -MemberType NoteProperty -Name WarnCount -Value $warnCount
    $report | Add-Member -MemberType NoteProperty -Name InfoCount -Value $infoCount

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 10E l3build Pilot Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* required files: $($report.RequiredFileCount)")
    $lines.Add("* required markers: $($report.RequiredMarkerCount)")
    $lines.Add("* l3build available: $($report.L3BuildAvailable)")
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

    Write-Host "Phase 10E l3build pilot report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 10E l3build pilot JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 10E l3build pilot found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 10E l3build pilot checks passed with $warnCount warning(s) and $infoCount note(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
