param(
    [switch]$FailOnVisibleGenerated
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase9b-generated-hygiene"
$reportJson = Join-Path $reportRoot "phase9b_generated_hygiene.json"
$reportMarkdown = Join-Path $reportRoot "phase9b_generated_hygiene.md"

$generatedExtensions = @(
    ".aux",
    ".bbl",
    ".bcf",
    ".blg",
    ".fdb_latexmk",
    ".fls",
    ".lof",
    ".log",
    ".lot",
    ".nav",
    ".out",
    ".pdf",
    ".run.xml",
    ".snm",
    ".synctex.gz",
    ".toc",
    ".vrb",
    ".xdv"
)

function ConvertTo-RepoPath {
    param([Parameter(Mandatory=$true)][string]$Path)
    $Path.Replace("\", "/")
}

function Test-GeneratedPath {
    param([Parameter(Mandatory=$true)][string]$Path)

    $repoPath = ConvertTo-RepoPath -Path $Path
    $lowerPath = $repoPath.ToLowerInvariant()
    $leaf = [System.IO.Path]::GetFileName($repoPath).ToLowerInvariant()

    if ($lowerPath.StartsWith("build/") -or $lowerPath.StartsWith("out/")) {
        return $true
    }

    if ($lowerPath -match "(^|/)__pycache__($|/)") {
        return $true
    }

    if ($leaf -eq "indent.log") {
        return $true
    }

    foreach ($extension in $generatedExtensions) {
        if ($lowerPath.EndsWith($extension)) {
            return $true
        }
    }

    return $false
}

function Get-ExtensionSummary {
    param([string[]]$Paths)

    @(
        $Paths |
            ForEach-Object {
                $path = ConvertTo-RepoPath -Path $_
                if ($path.ToLowerInvariant() -match "\.synctex\.gz$") {
                    ".synctex.gz"
                } else {
                    $extension = [System.IO.Path]::GetExtension($path)
                    if ([string]::IsNullOrWhiteSpace($extension)) {
                        "[no extension]"
                    } else {
                        $extension.ToLowerInvariant()
                    }
                }
            } |
            Group-Object |
            Sort-Object Name |
            ForEach-Object {
                [pscustomobject]@{
                    Extension = $_.Name
                    Count = $_.Count
                }
            }
    )
}

function Get-TopDirectorySummary {
    param([string[]]$Paths)

    @(
        $Paths |
            ForEach-Object {
                $path = ConvertTo-RepoPath -Path $_
                $parts = $path.Split("/")
                if ($parts.Count -gt 0 -and -not [string]::IsNullOrWhiteSpace($parts[0])) {
                    $parts[0]
                } else {
                    "[root]"
                }
            } |
            Group-Object |
            Sort-Object Name |
            ForEach-Object {
                [pscustomobject]@{
                    Directory = $_.Name
                    Count = $_.Count
                }
            }
    )
}

function Get-BuildInventory {
    $buildPath = Join-Path $root "build"
    if (-not (Test-Path -LiteralPath $buildPath)) {
        return [pscustomobject]@{
            Exists = $false
            FileCount = 0
            TotalBytes = 0
        }
    }

    $files = @(Get-ChildItem -LiteralPath $buildPath -Recurse -File -ErrorAction SilentlyContinue)
    return [pscustomobject]@{
        Exists = $true
        FileCount = $files.Count
        TotalBytes = [int64](($files | Measure-Object -Property Length -Sum).Sum)
    }
}

Push-Location $root
try {
    New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

    $trackedPaths = @(git ls-files | ForEach-Object { ConvertTo-RepoPath -Path $_ })
    $trackedGenerated = @($trackedPaths | Where-Object { Test-GeneratedPath -Path $_ })

    $untrackedPaths = @(git ls-files --others --exclude-standard | ForEach-Object { ConvertTo-RepoPath -Path $_ })
    $visibleGenerated = @($untrackedPaths | Where-Object { Test-GeneratedPath -Path $_ })

    $ignoredPaths = @(git ls-files --others --ignored --exclude-standard | ForEach-Object { ConvertTo-RepoPath -Path $_ })
    $buildInventory = Get-BuildInventory

    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name FailOnVisibleGenerated -Value $FailOnVisibleGenerated.IsPresent
    $report | Add-Member -MemberType NoteProperty -Name TrackedGeneratedCount -Value $trackedGenerated.Count
    $report | Add-Member -MemberType NoteProperty -Name VisibleGeneratedCount -Value $visibleGenerated.Count
    $report | Add-Member -MemberType NoteProperty -Name IgnoredGeneratedCount -Value $ignoredPaths.Count
    $report | Add-Member -MemberType NoteProperty -Name BuildInventory -Value $buildInventory
    $report | Add-Member -MemberType NoteProperty -Name TrackedGenerated -Value $trackedGenerated
    $report | Add-Member -MemberType NoteProperty -Name VisibleGenerated -Value $visibleGenerated
    $report | Add-Member -MemberType NoteProperty -Name IgnoredExtensionSummary -Value (Get-ExtensionSummary -Paths $ignoredPaths)
    $report | Add-Member -MemberType NoteProperty -Name IgnoredTopDirectorySummary -Value (Get-TopDirectorySummary -Paths $ignoredPaths)

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 9B Generated File Hygiene Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* Tracked generated-looking files: $($trackedGenerated.Count)")
    $lines.Add("* Visible untracked generated-looking files: $($visibleGenerated.Count)")
    $lines.Add("* Ignored generated files: $($ignoredPaths.Count)")
    $lines.Add("* Build files: $($buildInventory.FileCount)")
    $lines.Add("* Build bytes: $($buildInventory.TotalBytes)")
    $lines.Add("")
    $lines.Add("## Visible Generated-Looking Files")
    $lines.Add("")
    if ($visibleGenerated.Count -eq 0) {
        $lines.Add("None.")
    } else {
        foreach ($path in $visibleGenerated) {
            $lines.Add('* `' + $path + '`')
        }
    }
    $lines.Add("")
    $lines.Add("## Tracked Generated-Looking Files")
    $lines.Add("")
    if ($trackedGenerated.Count -eq 0) {
        $lines.Add("None.")
    } else {
        foreach ($path in $trackedGenerated) {
            $lines.Add('* `' + $path + '`')
        }
    }
    $lines.Add("")
    $lines.Add("## Ignored Generated Files By Top Directory")
    $lines.Add("")
    $lines.Add("| Directory | Count |")
    $lines.Add("| --- | ---: |")
    foreach ($item in $report.IgnoredTopDirectorySummary) {
        $lines.Add("| $($item.Directory) | $($item.Count) |")
    }
    $lines.Add("")
    $lines.Add("## Ignored Generated Files By Extension")
    $lines.Add("")
    $lines.Add("| Extension | Count |")
    $lines.Add("| --- | ---: |")
    foreach ($item in $report.IgnoredExtensionSummary) {
        $lines.Add("| $($item.Extension) | $($item.Count) |")
    }
    $lines | Set-Content -Path $reportMarkdown -Encoding UTF8

    if ($visibleGenerated.Count -gt 0) {
        Write-Host "WARN visible generated-looking files were found:" -ForegroundColor Yellow
        foreach ($path in $visibleGenerated) {
            Write-Host "  $path" -ForegroundColor Yellow
        }
    }

    Write-Host "Phase 9B generated-file hygiene report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 9B generated-file hygiene JSON written to $reportJson" -ForegroundColor Green

    if ($FailOnVisibleGenerated -and $visibleGenerated.Count -gt 0) {
        throw "Visible generated-looking files were found. See $reportMarkdown."
    }

    Write-Host "All Phase 9B generated-file hygiene checks completed." -ForegroundColor Green
}
finally {
    Pop-Location
}
