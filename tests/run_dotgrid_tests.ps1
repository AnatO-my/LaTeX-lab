param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase9f-dotgrid-modernization"
$reportJson = Join-Path $reportRoot "phase9f_dotgrid_modernization.json"
$reportMarkdown = Join-Path $reportRoot "phase9f_dotgrid_modernization.md"
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

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

function Test-TextContains {
    param(
        [Parameter(Mandatory=$true)][string]$Text,
        [Parameter(Mandatory=$true)][string]$Pattern
    )

    return $Text.Contains($Pattern)
}

function Invoke-DotGridBuild {
    param(
        [Parameter(Mandatory=$true)][string]$Source,
        [string[]]$Markers = @()
    )

    $stem = [System.IO.Path]::GetFileNameWithoutExtension($Source)
    $outputDir = Join-Path $root "build\phase9f-dotgrid-modernization"

    & latexmk -pdf -g "-outdir=$outputDir" $Source | Out-Host
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $Source"
    }

    $logPath = Join-Path $outputDir "$stem.log"
    $pdfPath = Join-Path $outputDir "$stem.pdf"
    if (-not (Test-Path -LiteralPath $logPath)) {
        throw "Expected log was not created: $logPath"
    }
    if (-not (Test-Path -LiteralPath $pdfPath)) {
        throw "Expected PDF was not created: $pdfPath"
    }

    foreach ($marker in $Markers) {
        if (-not (Invoke-LogSelectString -Path $logPath -SimpleMatch -Pattern $marker -Quiet)) {
            throw "$Source did not emit expected marker: $marker"
        }
    }

    return [pscustomobject]@{
        Source = $Source
        Log = $logPath
        Pdf = $pdfPath
        Status = "pass"
    }
}

Push-Location $root
try {
    New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

    $findings = New-Object System.Collections.ArrayList
    $builds = New-Object System.Collections.ArrayList
    $classPath = "src\classes\studentnotes.cls"
    $fallbackFixture = "tests\studentnotes_dotgrid_image_fallback.tex"
    $existingFixture = "tests\studentnotes_helpers_smoke.tex"

    foreach ($required in @($classPath, $fallbackFixture, $existingFixture)) {
        if (-not (Test-Path -LiteralPath $required)) {
            Add-Finding $findings "fail" $required "Required Phase 9F file is missing."
        }
    }

    if (@($findings | Where-Object { $_.Level -eq "fail" }).Count -eq 0) {
        $classText = Get-Content -Raw -Path $classPath
        $fixtureText = Get-Content -Raw -Path $fallbackFixture

        $requiredClassMarkers = @(
            "\newif\ifstudentnotes@dotgrid@enabled",
            "\newif\ifstudentnotes@dotgrid@useimage",
            "\newcommand{\setdotgridbackgroundimage}",
            "\newcommand{\studentnotes@tikzdotgridbackground}",
            "\newcommand{\studentnotes@imagedotgridbackground}",
            "\IfFileExists{\studentnotes@dotgridimage}",
            "\includegraphics[width=\paperwidth,height=\paperheight]",
            "falling back to TikZ dot grid",
            "Dot-grid background is already enabled"
        )

        foreach ($marker in $requiredClassMarkers) {
            if (-not (Test-TextContains -Text $classText -Pattern $marker)) {
                Add-Finding $findings "fail" $classPath "Missing modernization marker: $marker"
            }
        }

        $usedotgridCount = ([regex]::Matches($fixtureText, "\\usedotgrid")).Count
        if ($usedotgridCount -lt 2) {
            Add-Finding $findings "fail" $fallbackFixture "The fallback fixture should call \usedotgrid at least twice."
        }
        foreach ($marker in @("\setdotgridbackgroundimage", "OT9F-DOTGRID:IMAGE-FALLBACK", "OT9F-DOTGRID:REPEATED-CALL")) {
            if (-not (Test-TextContains -Text $fixtureText -Pattern $marker)) {
                Add-Finding $findings "fail" $fallbackFixture "Missing fixture marker: $marker"
            }
        }
    }

    if (@($findings | Where-Object { $_.Level -eq "fail" }).Count -eq 0) {
        if (Get-Command latexmk -ErrorAction SilentlyContinue) {
            [void]$builds.Add((Invoke-DotGridBuild -Source $existingFixture -Markers @()))
            [void]$builds.Add((Invoke-DotGridBuild -Source $fallbackFixture -Markers @(
                "OT9F-DOTGRID:IMAGE-FALLBACK",
                "OT9F-DOTGRID:REPEATED-CALL"
            )))
        } else {
            Add-Finding $findings "info" "latexmk" "latexmk was not found on PATH; compile verification should be run in the normal MiKTeX PowerShell environment."
        }
    }

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count
    $infoCount = @($findings | Where-Object { $_.Level -eq "info" }).Count

    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name CompileVerification -Value ($(if (Get-Command latexmk -ErrorAction SilentlyContinue) { "run" } else { "skipped" }))
    $report | Add-Member -MemberType NoteProperty -Name Builds -Value @($builds.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name FailCount -Value $failCount
    $report | Add-Member -MemberType NoteProperty -Name WarnCount -Value $warnCount
    $report | Add-Member -MemberType NoteProperty -Name InfoCount -Value $infoCount

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 9F Dot-Grid Modernization Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* Compile verification: $($report.CompileVerification)")
    $lines.Add("* findings: $($findings.Count)")
    $lines.Add("* warnings: $warnCount")
    $lines.Add("* failures: $failCount")
    $lines.Add("")
    $lines.Add("## Builds")
    $lines.Add("")
    if ($builds.Count -eq 0) {
        $lines.Add("No TeX builds were run in this environment.")
    } else {
        $lines.Add("| Source | Status |")
        $lines.Add("| --- | --- |")
        foreach ($build in $builds) {
            $lines.Add("| $($build.Source) | $($build.Status) |")
        }
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

    Write-Host "Phase 9F dot-grid modernization report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 9F dot-grid modernization JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 9F dot-grid modernization found $failCount failure(s). See $reportMarkdown."
    }

    if ($report.CompileVerification -eq "run") {
        Write-Host "All Phase 9F dot-grid modernization checks passed." -ForegroundColor Green
    } else {
        Write-Host "All Phase 9F source checks passed; run again in normal MiKTeX PowerShell for compile verification." -ForegroundColor Yellow
    }
}
finally {
    Pop-Location
}
