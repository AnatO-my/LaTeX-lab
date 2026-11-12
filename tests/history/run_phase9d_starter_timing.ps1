param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase9d-starter-timing"
$reportJson = Join-Path $reportRoot "phase9d_starter_timing.json"
$reportMarkdown = Join-Path $reportRoot "phase9d_starter_timing.md"
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

$starters = @(
    [pscustomobject]@{
        Name = "physicsquiz-bank"
        Source = "examples\physicsquiz\starter_quiz_bank.tex"
        Output = "build\examples\physicsquiz"
        Stem = "starter_quiz_bank"
        Area = "physicsquiz"
        LaterAudit = "question-bank starter"
        Markers = @(
            "OT7C-STARTER:PHYSICSQUIZ-BANK",
            "PQ4D-SELECT:starter-units-001",
            "PQ4D-SELECT:starter-waves-001"
        )
    },
    [pscustomobject]@{
        Name = "physicsquiz-versioned"
        Source = "examples\physicsquiz\starter_versioned_quiz.tex"
        Output = "build\examples\physicsquiz"
        Stem = "starter_versioned_quiz"
        Area = "physicsquiz"
        LaterAudit = "versioned quiz starter"
        Markers = @(
            "OT7C-STARTER:PHYSICSQUIZ-VERSIONED",
            "PQ4J-VERSION:A",
            "PQ4D-SELECT:starter-version-units-001",
            "PQ4D-SELECT:starter-version-waves-001"
        )
    },
    [pscustomobject]@{
        Name = "studentnotes"
        Source = "examples\studentnotes\starter_notes.tex"
        Output = "build\examples\studentnotes"
        Stem = "starter_notes"
        Area = "studentnotes"
        LaterAudit = "dot-grid background candidate"
        Markers = @("OT7C-STARTER:STUDENTNOTES")
    },
    [pscustomobject]@{
        Name = "otengineering"
        Source = "examples\otengineering\starter_engineering_notes.tex"
        Output = "build\examples\otengineering"
        Stem = "starter_engineering_notes"
        Area = "otengineering"
        LaterAudit = "box and page-furniture candidate"
        Markers = @("OT7C-STARTER:OTENGINEERING")
    },
    [pscustomobject]@{
        Name = "otscience"
        Source = "examples\otscience\starter_science_notes.tex"
        Output = "build\examples\otscience"
        Stem = "starter_science_notes"
        Area = "otscience"
        LaterAudit = "box and TikZ-adjacent candidate"
        Markers = @("OT7C-STARTER:OTSCIENCE")
    },
    [pscustomobject]@{
        Name = "vector-module"
        Source = "examples\vector-workbook\starter_module.tex"
        Output = "build\examples\vector-workbook"
        Stem = "starter_module"
        Area = "vector-workbook"
        LaterAudit = "TikZ/vector-workbook candidate"
        Markers = @("OT7C-STARTER:VECTOR-WORKBOOK")
    },
    [pscustomobject]@{
        Name = "vector-combined"
        Source = "examples\vector-workbook\starter_combined_workbook.tex"
        Output = "build\examples\vector-workbook"
        Stem = "starter_combined_workbook"
        Area = "vector-workbook"
        LaterAudit = "combined workbook and TikZ candidate"
        Markers = @(
            "OT7J-STARTER:VECTOR-WORKBOOK-COMBINED",
            "OT7C-STARTER:VECTOR-WORKBOOK"
        )
    }
)

function Invoke-TimedStarter {
    param(
        [Parameter(Mandatory=$true)]$Starter
    )

    $outputDir = Join-Path $root $Starter.Output
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

    $arguments = @(
        "-pdf",
        "-interaction=nonstopmode",
        "-halt-on-error",
        "-outdir=$outputDir",
        $Starter.Source
    )
    if ($Force) {
        $arguments = @("-g") + $arguments
    }

    Write-Host "Timing starter $($Starter.Name)..." -ForegroundColor Cyan
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    $status = "pass"
    $message = ""

    try {
        & latexmk @arguments | Out-Host
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $($Starter.Source)"
        }

        $logPath = Join-Path $outputDir "$($Starter.Stem).log"
        $pdfPath = Join-Path $outputDir "$($Starter.Stem).pdf"
        if (-not (Test-Path -LiteralPath $logPath)) {
            throw "Expected starter log is missing: $logPath"
        }
        if (-not (Test-Path -LiteralPath $pdfPath)) {
            throw "Expected starter PDF is missing: $pdfPath"
        }

        foreach ($marker in $Starter.Markers) {
            if (-not (Invoke-LogSelectString -Path $logPath -SimpleMatch -Pattern $marker -Quiet)) {
                throw "$($Starter.Source) did not emit expected marker: $marker"
            }
        }
    } catch {
        $status = "fail"
        $message = $_.Exception.Message
    } finally {
        $timer.Stop()
    }

    $result = [pscustomobject]@{
        Name = $Starter.Name
        Area = $Starter.Area
        Source = $Starter.Source
        Stem = $Starter.Stem
        LaterAudit = $Starter.LaterAudit
        Status = $status
        Seconds = [math]::Round($timer.Elapsed.TotalSeconds, 2)
        Message = $message
    }

    if ($status -ne "pass") {
        $result
        throw "Phase 9D starter timing failed at $($Starter.Name): $message"
    }

    return $result
}

Push-Location $root
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    foreach ($starter in $starters) {
        if (-not (Test-Path -LiteralPath $starter.Source)) {
            throw "Required starter is missing: $($starter.Source)"
        }
    }

    New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

    $results = New-Object System.Collections.Generic.List[object]
    foreach ($starter in $starters) {
        $results.Add((Invoke-TimedStarter -Starter $starter))
    }

    $resultRecords = @($results.ToArray())
    $totalSeconds = [math]::Round((($resultRecords | ForEach-Object { [double]$_.Seconds } | Measure-Object -Sum).Sum), 2)
    $slowest = @($resultRecords | Sort-Object Seconds -Descending | Select-Object -First 1)

    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name Force -Value $Force.IsPresent
    $report | Add-Member -MemberType NoteProperty -Name TotalSeconds -Value $totalSeconds
    $report | Add-Member -MemberType NoteProperty -Name SlowestStarter -Value $slowest
    $report | Add-Member -MemberType NoteProperty -Name Results -Value $resultRecords

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 9D Starter Timing Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* Force rebuild: $($Force.IsPresent)")
    $lines.Add("* Total starter seconds: $totalSeconds")
    if ($slowest.Count -gt 0) {
        $lines.Add("* Slowest starter: $($slowest[0].Name) at $($slowest[0].Seconds)s")
    }
    $lines.Add("")
    $lines.Add("| Starter | Area | Status | Seconds | Later audit |")
    $lines.Add("| --- | --- | --- | ---: | --- |")
    foreach ($result in $resultRecords) {
        $lines.Add("| $($result.Name) | $($result.Area) | $($result.Status) | $($result.Seconds) | $($result.LaterAudit) |")
    }
    $lines | Set-Content -Path $reportMarkdown -Encoding UTF8

    Write-Host "Phase 9D starter timing report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 9D starter timing JSON written to $reportJson" -ForegroundColor Green
    Write-Host "All Phase 9D starter timing checks passed in $totalSeconds seconds." -ForegroundColor Green
}
finally {
    Pop-Location
}
