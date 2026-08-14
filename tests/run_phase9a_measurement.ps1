param(
    [switch]$StartersOnly
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$measurementRoot = Join-Path $root "build\phase9a-measurement"
$reportJson = Join-Path $measurementRoot "phase9a_measurement.json"
$reportMarkdown = Join-Path $measurementRoot "phase9a_measurement.md"

function Get-FileInventory {
    param(
        [Parameter(Mandatory=$true)][string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return [pscustomobject]@{
            Exists = $false
            FileCount = 0
            TotalBytes = 0
            ByExtension = @()
        }
    }

    $files = @(Get-ChildItem -LiteralPath $Path -Recurse -File -ErrorAction SilentlyContinue)
    $byExtension = @(
        $files |
            Group-Object {
                if ([string]::IsNullOrWhiteSpace($_.Extension)) {
                    "[no extension]"
                } else {
                    $_.Extension.ToLowerInvariant()
                }
            } |
            Sort-Object Name |
            ForEach-Object {
                [pscustomobject]@{
                    Extension = $_.Name
                    Count = $_.Count
                    Bytes = [int64](($_.Group | Measure-Object -Property Length -Sum).Sum)
                }
            }
    )

    [pscustomobject]@{
        Exists = $true
        FileCount = $files.Count
        TotalBytes = [int64](($files | Measure-Object -Property Length -Sum).Sum)
        ByExtension = $byExtension
    }
}

function Invoke-TimedStep {
    param(
        [Parameter(Mandatory=$true)][string]$Name,
        [Parameter(Mandatory=$true)][string]$Description,
        [Parameter(Mandatory=$true)][scriptblock]$Action
    )

    Write-Host "Measuring $Name..." -ForegroundColor Cyan
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    $status = "pass"
    $message = ""

    try {
        & $Action | Out-Host
    } catch {
        $status = "fail"
        $message = $_.Exception.Message
    } finally {
        $timer.Stop()
    }

    $result = [pscustomobject]@{
        Name = $Name
        Description = $Description
        Status = $status
        Seconds = [math]::Round($timer.Elapsed.TotalSeconds, 2)
        Message = $message
    }

    if ($status -ne "pass") {
        $result
        throw "Phase 9A measurement failed at ${Name}: $message"
    }

    $result
}

function Invoke-LatexmkBuild {
    param(
        [Parameter(Mandatory=$true)][string]$Source,
        [Parameter(Mandatory=$true)][string]$Output,
        [Parameter(Mandatory=$true)][string]$Stem
    )

    if (-not (Test-Path -LiteralPath $Source)) {
        throw "Required source is missing: $Source"
    }

    $outputPath = $Output
    if (-not [System.IO.Path]::IsPathRooted($outputPath)) {
        $outputPath = Join-Path $root $outputPath
    }

    New-Item -ItemType Directory -Force -Path $outputPath | Out-Null
    & latexmk -pdf -interaction=nonstopmode -halt-on-error "-outdir=$outputPath" $Source
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $Source"
    }

    $pdfPath = Join-Path $outputPath "$Stem.pdf"
    if (-not (Test-Path -LiteralPath $pdfPath)) {
        throw "Expected PDF was not created: $pdfPath"
    }
}

Push-Location $root
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    New-Item -ItemType Directory -Force -Path $measurementRoot | Out-Null

    $inventoryBefore = Get-FileInventory -Path (Join-Path $root "build")
    $results = New-Object System.Collections.Generic.List[object]

    $results.Add((Invoke-TimedStep `
        -Name "phase7c-starter-suite" `
        -Description "Builds all seven copyable starter documents through the existing starter runner." `
        -Action {
            & powershell -NoProfile -ExecutionPolicy Bypass -File "tests\run_phase7c_starter_tests.ps1"
            if ($LASTEXITCODE -ne 0) {
                throw "Phase 7C starter runner failed with exit code $LASTEXITCODE."
            }
        }))

    if (-not $StartersOnly) {
        $representativeTargets = @(
            [pscustomobject]@{
                Name = "physicsquiz-structured"
                Description = "Builds the complete structured PHY104 quiz revision."
                Source = "examples\physicsquiz\PHY104_structured_revision.tex"
                Output = "build\phase9a-measurement\physicsquiz-structured"
                Stem = "PHY104_structured_revision"
            },
            [pscustomobject]@{
                Name = "studentnotes-optics"
                Description = "Builds the representative StudentNotes optics document."
                Source = "examples\studentnotes\Optics.tex"
                Output = "build\phase9a-measurement\studentnotes-optics"
                Stem = "Optics"
            },
            [pscustomobject]@{
                Name = "otengineering-representative"
                Description = "Builds the representative OTEngineering notebook."
                Source = "examples\otengineering\test.tex"
                Output = "build\phase9a-measurement\otengineering-representative"
                Stem = "test"
            },
            [pscustomobject]@{
                Name = "vector-workbook-combined"
                Description = "Builds the combined vector workbook root."
                Source = "examples\vector-workbook\00_main_combined_workbook.tex"
                Output = "build\phase9a-measurement\vector-workbook-combined"
                Stem = "00_main_combined_workbook"
            }
        )

        foreach ($target in $representativeTargets) {
            $results.Add((Invoke-TimedStep `
                -Name $target.Name `
                -Description $target.Description `
                -Action {
                    Invoke-LatexmkBuild -Source $target.Source -Output $target.Output -Stem $target.Stem
                }))
        }
    }

    $inventoryAfter = Get-FileInventory -Path (Join-Path $root "build")
    $totalSeconds = [math]::Round((($results | ForEach-Object { [double]$_.Seconds } | Measure-Object -Sum).Sum), 2)

    $report = [pscustomobject]@{
        CreatedAt = (Get-Date).ToString("s")
        Root = $root
        StartersOnly = [bool]$StartersOnly
        TotalSeconds = $totalSeconds
        Results = @($results)
        BuildInventoryBefore = $inventoryBefore
        BuildInventoryAfter = $inventoryAfter
    }

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 9A Measurement Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* Total measured seconds: $totalSeconds")
    $lines.Add("* Starters only: $([bool]$StartersOnly)")
    $lines.Add("")
    $lines.Add("| Target | Status | Seconds |")
    $lines.Add("| --- | --- | ---: |")
    foreach ($result in $results) {
        $lines.Add("| $($result.Name) | $($result.Status) | $($result.Seconds) |")
    }
    $lines.Add("")
    $lines.Add("## Build Inventory")
    $lines.Add("")
    $lines.Add("| Moment | Files | Bytes |")
    $lines.Add("| --- | ---: | ---: |")
    $lines.Add("| Before | $($inventoryBefore.FileCount) | $($inventoryBefore.TotalBytes) |")
    $lines.Add("| After | $($inventoryAfter.FileCount) | $($inventoryAfter.TotalBytes) |")
    $lines | Set-Content -Path $reportMarkdown -Encoding UTF8

    Write-Host "Phase 9A measurement report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 9A measurement JSON written to $reportJson" -ForegroundColor Green
    Write-Host "All Phase 9A measurements passed in $totalSeconds seconds." -ForegroundColor Green
}
finally {
    Pop-Location
}
