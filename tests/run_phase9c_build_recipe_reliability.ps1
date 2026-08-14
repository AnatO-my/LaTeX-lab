param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\phase9c-build-recipe"
$reportJson = Join-Path $reportRoot "phase9c_build_recipe_reliability.json"
$reportMarkdown = Join-Path $reportRoot "phase9c_build_recipe_reliability.md"

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
        [Parameter(Mandatory=$true)][string]$Text,
        [Parameter(Mandatory=$true)][string]$Pattern
    )

    return $Text.Contains($Pattern)
}

Push-Location $root
try {
    New-Item -ItemType Directory -Force -Path $reportRoot | Out-Null

    $findings = New-Object System.Collections.ArrayList
    $psScripts = @(Get-ChildItem -LiteralPath (Join-Path $root "tests") -Filter "*.ps1" -File | Sort-Object Name)
    $parsedScripts = 0

    foreach ($script in $psScripts) {
        $tokens = $null
        $errors = $null
        [System.Management.Automation.Language.Parser]::ParseFile($script.FullName, [ref]$tokens, [ref]$errors) | Out-Null
        if ($errors.Count -gt 0) {
            foreach ($error in $errors) {
                Add-Finding $findings "fail" $script.Name $error.Message
            }
        } else {
            $parsedScripts += 1
        }
    }

    $latexmkPath = Join-Path $root ".latexmkrc"
    if (-not (Test-Path -LiteralPath $latexmkPath)) {
        Add-Finding $findings "fail" ".latexmkrc" "The repository-level .latexmkrc file is missing."
        $latexmkText = ""
    } else {
        $latexmkText = Get-Content -Raw -Path $latexmkPath
    }

    $latexmkRequired = @(
        [pscustomobject]@{ Pattern = "use Cwd qw(abs_path);"; Message = "captures an absolute repository root before document-directory changes" },
        [pscustomobject]@{ Pattern = '$project_root = abs_path(''.'');'; Message = "uses the launch directory as the project root" },
        [pscustomobject]@{ Pattern = "src/classes"; Message = "adds project-local classes to TEXINPUTS" },
        [pscustomobject]@{ Pattern = "src/packages"; Message = "adds project-local packages to TEXINPUTS" },
        [pscustomobject]@{ Pattern = '$pdf_mode = 1;'; Message = "selects PDF output mode" },
        [pscustomobject]@{ Pattern = '$do_cd = 1;'; Message = "builds each root from its document directory" },
        [pscustomobject]@{ Pattern = "-interaction=nonstopmode"; Message = "uses non-interactive TeX runs" },
        [pscustomobject]@{ Pattern = "-file-line-error"; Message = "uses file-and-line diagnostics" }
    )

    foreach ($requirement in $latexmkRequired) {
        if (-not (Test-FileContains -Text $latexmkText -Pattern $requirement.Pattern)) {
            Add-Finding $findings "fail" ".latexmkrc" "Missing expected recipe feature: $($requirement.Message)."
        }
    }

    $gitignoreText = Get-Content -Raw -Path ".gitignore"
    foreach ($pattern in @("build/", "out/", "indent.log", "__pycache__/", "*.py[cod]")) {
        if (-not (Test-FileContains -Text $gitignoreText -Pattern $pattern)) {
            Add-Finding $findings "fail" ".gitignore" "Missing generated-output ignore pattern: $pattern"
        }
    }

    $phase9aText = Get-Content -Raw -Path "tests\run_phase9a_measurement.ps1"
    foreach ($pattern in @("IsPathRooted", "Out-Host", "Add-Member", "build\phase9a-measurement")) {
        if (-not (Test-FileContains -Text $phase9aText -Pattern $pattern)) {
            Add-Finding $findings "fail" "run_phase9a_measurement.ps1" "Missing reliability marker: $pattern"
        }
    }

    $phase9bText = Get-Content -Raw -Path "tests\run_phase9b_generated_hygiene.ps1"
    foreach ($pattern in @("FailOnVisibleGenerated", "git ls-files --others --exclude-standard", "git ls-files --others --ignored --exclude-standard", "build\phase9b-generated-hygiene")) {
        if (-not (Test-FileContains -Text $phase9bText -Pattern $pattern)) {
            Add-Finding $findings "fail" "run_phase9b_generated_hygiene.ps1" "Missing hygiene marker: $pattern"
        }
    }

    $starterText = Get-Content -Raw -Path "tests\run_phase7c_starter_tests.ps1"
    if (-not (Test-FileContains -Text $starterText -Pattern 'Join-Path $root $starter.Output')) {
        Add-Finding $findings "fail" "run_phase7c_starter_tests.ps1" "Starter output directories should resolve from the repository root."
    }

    $workflowPath = ".github\workflows\starter-build.yml"
    if (-not (Test-Path -LiteralPath $workflowPath)) {
        Add-Finding $findings "fail" $workflowPath "Starter-build GitHub Actions workflow is missing."
        $workflowText = ""
    } else {
        $workflowText = Get-Content -Raw -Path $workflowPath
    }
    foreach ($pattern in @("Invoke-DownloadWithRetry", "tests\run_phase7c_starter_tests.ps1", "Starter documents", "actions/upload-artifact@v4")) {
        if (-not (Test-FileContains -Text $workflowText -Pattern $pattern)) {
            Add-Finding $findings "fail" $workflowPath "Missing hosted workflow marker: $pattern"
        }
    }

    $latexmkLines = New-Object System.Collections.ArrayList
    foreach ($script in $psScripts) {
        $lineNumber = 0
        foreach ($line in (Get-Content -Path $script.FullName)) {
            $lineNumber += 1
            if ($line -match "latexmk") {
                [void]$latexmkLines.Add([pscustomobject]@{
                    Script = $script.Name
                    Line = $lineNumber
                    Text = $line.Trim()
                })
            }
        }
    }

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $report = New-Object psobject
    $report | Add-Member -MemberType NoteProperty -Name CreatedAt -Value (Get-Date).ToString("s")
    $report | Add-Member -MemberType NoteProperty -Name Root -Value $root
    $report | Add-Member -MemberType NoteProperty -Name ScriptCount -Value $psScripts.Count
    $report | Add-Member -MemberType NoteProperty -Name ParsedScriptCount -Value $parsedScripts
    $report | Add-Member -MemberType NoteProperty -Name LatexmkReferenceCount -Value $latexmkLines.Count
    $report | Add-Member -MemberType NoteProperty -Name FindingCount -Value $findings.Count
    $report | Add-Member -MemberType NoteProperty -Name FailCount -Value $failCount
    $report | Add-Member -MemberType NoteProperty -Name Findings -Value @($findings.ToArray())
    $report | Add-Member -MemberType NoteProperty -Name LatexmkReferences -Value @($latexmkLines.ToArray())

    $report | ConvertTo-Json -Depth 8 | Set-Content -Path $reportJson -Encoding UTF8

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Phase 9C Build Recipe Reliability Report")
    $lines.Add("")
    $lines.Add("* Created: $($report.CreatedAt)")
    $lines.Add("* PowerShell runners parsed: $parsedScripts / $($psScripts.Count)")
    $lines.Add("* latexmk references found: $($latexmkLines.Count)")
    $lines.Add("* findings: $($findings.Count)")
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
    $lines.Add("")
    $lines.Add("## latexmk References")
    $lines.Add("")
    $lines.Add("| Script | Line | Text |")
    $lines.Add("| --- | ---: | --- |")
    foreach ($item in $latexmkLines) {
        $text = $item.Text.Replace("|", "\|")
        $lines.Add("| $($item.Script) | $($item.Line) | ``$text`` |")
    }
    $lines | Set-Content -Path $reportMarkdown -Encoding UTF8

    Write-Host "Phase 9C build-recipe reliability report written to $reportMarkdown" -ForegroundColor Green
    Write-Host "Phase 9C build-recipe reliability JSON written to $reportJson" -ForegroundColor Green

    if ($failCount -gt 0) {
        throw "Phase 9C build-recipe reliability found $failCount failure(s). See $reportMarkdown."
    }

    Write-Host "All Phase 9C build-recipe reliability checks passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
