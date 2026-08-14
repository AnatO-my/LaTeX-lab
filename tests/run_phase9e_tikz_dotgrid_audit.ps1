param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase9e-tikz-dotgrid-audit"
$reportJson = Join-Path $reportRoot "phase9e_tikz_dotgrid_audit.json"
$reportMarkdown = Join-Path $reportRoot "phase9e_tikz_dotgrid_audit.md"

function Get-RepoText {
    param(
        [Parameter(Mandatory=$true)][string]$Path
    )

    return Get-Content -Raw -Path (Join-Path $root $Path)
}

function Count-RegexMatches {
    param(
        [Parameter(Mandatory=$true)][string]$Text,
        [Parameter(Mandatory=$true)][string]$Pattern
    )

    return ([regex]::Matches($Text, $Pattern)).Count
}

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

Push-Location $root
try {
    New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

    $findings = New-Object System.Collections.ArrayList
    $requiredFiles = @(
        "src\classes\studentnotes.cls",
        "src\packages\otfigures.sty",
        "src\classes\otscience.cls",
        "src\legacy\otscience.sty",
        "examples\studentnotes\Optics.tex",
        "tests\studentnotes_helpers_smoke.tex"
    )

    foreach ($path in $requiredFiles) {
        if (-not (Test-Path -LiteralPath (Join-Path $root $path))) {
            Add-Finding $findings "fail" $path "Required audit target is missing."
        }
    }

    if (@($findings | Where-Object { $_.Level -eq "fail" }).Count -eq 0) {
        $studentNotes = Get-RepoText "src\classes\studentnotes.cls"
        $otFigures = Get-RepoText "src\packages\otfigures.sty"
        $opticsExample = Get-RepoText "examples\studentnotes\Optics.tex"
        $helpersSmoke = Get-RepoText "tests\studentnotes_helpers_smoke.tex"

        $dotGridXCount = 43
        $dotGridYCount = 60
        $dotGridDotsPerPage = $dotGridXCount * $dotGridYCount

        $dotGridChecks = [ordered]@{
            PublicCommand = $studentNotes.Contains("\newcommand{\usedotgrid}{\dotgridbackground}")
            ImplementationCommand = $studentNotes.Contains("\newcommand{\dotgridbackground}")
            UsesShipoutBackground = $studentNotes.Contains("\AddToShipoutPictureBG")
            UsesOverlayTikZ = $studentNotes.Contains("remember picture,overlay")
            XLoopPresent = $studentNotes.Contains("\foreach \x in {0,0.5,...,21}")
            YLoopPresent = $studentNotes.Contains("\foreach \y in {0,0.5,...,29.7}")
            RepresentativeExampleKeepsGridCommented = $opticsExample.Contains("% \usedotgrid")
            SmokeTestExercisesGrid = $helpersSmoke.Contains("\usedotgrid")
        }

        foreach ($entry in $dotGridChecks.GetEnumerator()) {
            if (-not $entry.Value) {
                Add-Finding $findings "fail" "studentnotes dot-grid" "Missing expected marker: $($entry.Key)."
            }
        }

        $dotGridInstallCount = Count-RegexMatches $studentNotes "\\AddToShipoutPictureBG"
        if ($dotGridInstallCount -ne 1) {
            Add-Finding $findings "warn" "studentnotes dot-grid" "Expected one shipout background installer; found $dotGridInstallCount."
        }

        $usedotgridDefinition = Count-RegexMatches $studentNotes "\\newcommand\{\\usedotgrid\}"
        if ($usedotgridDefinition -ne 1) {
            Add-Finding $findings "fail" "studentnotes dot-grid" "Expected one public \usedotgrid definition; found $usedotgridDefinition."
        }

        Add-Finding $findings "info" "studentnotes dot-grid" "Estimated dot-grid drawing load is $dotGridDotsPerPage dots per page ($dotGridXCount by $dotGridYCount)."
        Add-Finding $findings "info" "studentnotes dot-grid" "The representative Optics example keeps \usedotgrid commented, so the default example avoids the page-background cost."
        Add-Finding $findings "info" "studentnotes dot-grid" "The smoke test exercises \usedotgrid once to keep the public helper covered."

        $figureMacros = @(
            "cartesianaxes",
            "vectorfigure",
            "cylfigure",
            "sphfigure",
            "stresselement",
            "fieldgrid"
        )
        $figureRecords = New-Object System.Collections.ArrayList
        foreach ($macro in $figureMacros) {
            $definitionPattern = "\\newcommand\{\\$macro\}"
            $definitionCount = Count-RegexMatches $otFigures $definitionPattern
            $usagePattern = "\\$macro(?![A-Za-z])"
            $usageMatches = Select-String -Path @(
                "examples\*.tex",
                "examples\*\*.tex",
                "tests\*.tex"
            ) -Pattern $usagePattern -ErrorAction SilentlyContinue
            $usageCount = @($usageMatches).Count

            if ($definitionCount -ne 1) {
                Add-Finding $findings "fail" "otfigures" "Expected one definition for \$macro; found $definitionCount."
            }

            [void]$figureRecords.Add([pscustomobject]@{
                Macro = "\$macro"
                DefinitionCount = $definitionCount
                UsageCount = $usageCount
            })
        }

        $tikzLoadFiles = New-Object System.Collections.ArrayList
        foreach ($file in (Get-ChildItem -Path @("src", "examples", "tests") -Include "*.cls", "*.sty", "*.tex" -Recurse -File)) {
            $text = Get-Content -Raw -Path $file.FullName
            $relativePath = $file.FullName.Substring($root.Length + 1)
            $packageLoads = Count-RegexMatches $text "\\RequirePackage\{tikz\}|\\usepackage\{tikz\}"
            $libraryLoads = Count-RegexMatches $text "\\usetikzlibrary"
            $tikzPictures = Count-RegexMatches $text "\\begin\{tikzpicture\}"
            $publicFigureUses = 0
            foreach ($macro in $figureMacros) {
                $publicFigureUses += Count-RegexMatches $text "\\$macro(?![A-Za-z])"
            }

            if (($packageLoads + $libraryLoads + $tikzPictures + $publicFigureUses) -gt 0) {
                [void]$tikzLoadFiles.Add([pscustomobject]@{
                    Path = $relativePath
                    PackageLoads = $packageLoads
                    LibraryLoads = $libraryLoads
                    TikzPictures = $tikzPictures
                    PublicFigureUses = $publicFigureUses
                })
            }
        }

        $tikzPictureTotal = (($tikzLoadFiles | ForEach-Object { [int]$_.TikzPictures }) | Measure-Object -Sum).Sum
        if ($tikzPictureTotal -lt 1) {
            Add-Finding $findings "fail" "TikZ inventory" "No tikzpicture environments were found."
        }

        $report = New-Object psobject
        $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
        $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
        $report | Add-Member -MemberType NoteProperty -Name DotGridDotsPerPage -Value $dotGridDotsPerPage
        $report | Add-Member -MemberType NoteProperty -Name DotGridXCount -Value $dotGridXCount
        $report | Add-Member -MemberType NoteProperty -Name DotGridYCount -Value $dotGridYCount
        $report | Add-Member -MemberType NoteProperty -Name DotGridChecks -Value $dotGridChecks
        $report | Add-Member -MemberType NoteProperty -Name FigureMacros -Value @($figureRecords.ToArray())
        $report | Add-Member -MemberType NoteProperty -Name TikzInventory -Value @($tikzLoadFiles.ToArray())
        $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    } else {
        $report = New-Object psobject
        $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
        $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
        $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    }

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count
    $infoCount = @($findings | Where-Object { $_.Level -eq "info" }).Count

    $report | Add-Member -MemberType NoteProperty -Name FailCount -Value $failCount
    $report | Add-Member -MemberType NoteProperty -Name WarnCount -Value $warnCount
    $report | Add-Member -MemberType NoteProperty -Name InfoCount -Value $infoCount

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 9E TikZ And Dot-Grid Audit Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* Dot-grid estimate: $($report.DotGridDotsPerPage) dots per page")
    $lines.Add("* findings: $($findings.Count)")
    $lines.Add("* warnings: $warnCount")
    $lines.Add("* failures: $failCount")
    $lines.Add("")
    $lines.Add("## Dot-Grid Checks")
    $lines.Add("")
    $lines.Add("| Check | Present |")
    $lines.Add("| --- | --- |")
    if ($report.PSObject.Properties.Name -contains "DotGridChecks") {
        foreach ($entry in $report.DotGridChecks.GetEnumerator()) {
            $lines.Add("| $($entry.Key) | $($entry.Value) |")
        }
    }
    $lines.Add("")
    $lines.Add("## Reusable Figure Macros")
    $lines.Add("")
    $lines.Add("| Macro | Definitions | Uses |")
    $lines.Add("| --- | ---: | ---: |")
    if ($report.PSObject.Properties.Name -contains "FigureMacros") {
        foreach ($item in $report.FigureMacros) {
            $lines.Add("| ``$($item.Macro)`` | $($item.DefinitionCount) | $($item.UsageCount) |")
        }
    }
    $lines.Add("")
    $lines.Add("## TikZ Inventory")
    $lines.Add("")
    $lines.Add("| Path | Package loads | Library loads | tikzpicture | Public figure uses |")
    $lines.Add("| --- | ---: | ---: | ---: | ---: |")
    if ($report.PSObject.Properties.Name -contains "TikzInventory") {
        foreach ($item in ($report.TikzInventory | Sort-Object Path)) {
            $lines.Add("| $($item.Path) | $($item.PackageLoads) | $($item.LibraryLoads) | $($item.TikzPictures) | $($item.PublicFigureUses) |")
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

    Write-Host "Phase 9E TikZ/dot-grid audit report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 9E TikZ/dot-grid audit JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 9E TikZ/dot-grid audit found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 9E TikZ/dot-grid audit checks passed with $warnCount warning(s) and $infoCount note(s)." -ForegroundColor Green
}
finally {
    Pop-Location
}
