<#
    Release policy guard.

    Replaces the Phase 10 checkpoint guards (10A, 10B, 10C, 10D, 10E, 10F,
    10G/10H), which are kept for reference in tests\history\. Those guards
    verified that each checkpoint had been recorded; this guard verifies the
    release rules that remain in force, against the consolidated documents:

      * docs\release\RELEASE_PROCESS.md and its templates exist and keep the
        whitespace, status, asset-boundary and verification rules;
      * the release-notes template and asset manifest keep their required
        markers and planned asset ids;
      * the hosted workflows keep their boundaries (release source checks do
        not build PDFs or install MiKTeX packages);
      * no active root build.lua was added; and
      * every class and package still declares itself with \Provides...

        powershell -ExecutionPolicy Bypass -File tests\run_release_policy_guard.ps1

    A report is written under build\release-policy-guard\. The script throws
    (non-zero exit) when any check fails.
#>
param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$reportRoot = Join-Path $root "build\release-policy-guard"
$reportMarkdown = Join-Path $reportRoot "release_policy_guard.md"

function Add-Finding {
    param(
        [Parameter(Mandatory=$true)]$Findings,
        [Parameter(Mandatory=$true)][string]$Level,
        [Parameter(Mandatory=$true)][string]$Area,
        [Parameter(Mandatory=$true)][string]$Message
    )
    [void]$Findings.Add([pscustomobject]@{ Level = $Level; Area = $Area; Message = $Message })
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

    $process = "docs\release\RELEASE_PROCESS.md"
    $notesTemplate = "docs\release\templates\RELEASE_NOTES_TEMPLATE.md"
    $assetManifest = "docs\release\templates\RELEASE_ASSET_MANIFEST_TEMPLATE.md"
    $releaseWorkflow = ".github\workflows\release-source-checks.yml"
    $starterWorkflow = ".github\workflows\starter-build.yml"

    $requiredFiles = @(
        $process,
        $notesTemplate,
        $assetManifest,
        "docs\PUBLIC_INTERFACES.md",
        "docs\AUTHOR_KIT.md",
        "docs\GITHUB_WORKFLOW.md",
        $releaseWorkflow,
        $starterWorkflow,
        "CHANGELOG.md",
        "PROJECT_STATE.md",
        "README.md"
    )
    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file)) {
            Add-Finding $findings "fail" $file "Required release file is missing."
        }
    }

    $requiredMarkers = @(
        [pscustomobject]@{ Path = $process; Pattern = "Generated PDFs, author kits, and preview zips remain release assets."; Message = "Release process must keep the generated-asset boundary." },
        [pscustomobject]@{ Path = $process; Pattern = "v0.1.0"; Message = "Release process must keep the first release label." },
        [pscustomobject]@{ Path = $process; Pattern = "git diff --check"; Message = "Release checklist must require whitespace checking." },
        [pscustomobject]@{ Path = $process; Pattern = "git status --short --branch"; Message = "Release checklist must require status review." },
        [pscustomobject]@{ Path = $process; Pattern = "docs/release/templates/RELEASE_NOTES_TEMPLATE.md"; Message = "Release checklist must point to the release-notes template." },
        [pscustomobject]@{ Path = $process; Pattern = "docs/release/templates/RELEASE_ASSET_MANIFEST_TEMPLATE.md"; Message = "Release checklist must point to the asset manifest template." },
        [pscustomobject]@{ Path = $process; Pattern = "Generated assets should be attached to a GitHub release"; Message = "Release checklist must keep the generated-asset rule." },
        [pscustomobject]@{ Path = $process; Pattern = "PowerShell runners remain the source of truth for existing tests"; Message = "l3build section must keep the runner boundary." },
        [pscustomobject]@{ Path = $process; Pattern = ".github/workflows/release-source-checks.yml"; Message = "CI section must link the release-source workflow." },
        [pscustomobject]@{ Path = $starterWorkflow; Pattern = "MiKTeX package install failed for"; Message = "Starter workflow must report MiKTeX package-install failures." },
        [pscustomobject]@{ Path = "README.md"; Pattern = "docs/release/RELEASE_PROCESS.md"; Message = "README must link the release process." }
    )
    foreach ($marker in $requiredMarkers) {
        if (-not (Test-FileContains -Path $marker.Path -Pattern $marker.Pattern)) {
            Add-Finding $findings "fail" $marker.Path $marker.Message
        }
    }

    $templateMarkers = @(
        'Label: v0.1.0',
        'Source commit:',
        'Release type: patch | minor | major',
        'No public-interface changes.',
        '`git diff --check`',
        'Generated PDFs, author kits, and preview zips are release assets.',
        'No release assets.',
        'No author action required.',
        'docs/release/RELEASE_PROCESS.md',
        'docs/PUBLIC_INTERFACES.md'
    )
    foreach ($marker in $templateMarkers) {
        if (-not (Test-FileContains -Path $notesTemplate -Pattern $marker)) {
            Add-Finding $findings "fail" $notesTemplate "Missing release-note marker: $marker"
        }
    }

    $assetIds = @(
        "starter-pdfs",
        "starter-quiz-bank-pdf",
        "starter-versioned-quiz-pdf",
        "starter-student-notes-pdf",
        "starter-engineering-notes-pdf",
        "starter-science-notes-pdf",
        "starter-workbook-module-pdf",
        "starter-combined-workbook-pdf",
        "author-kit"
    )
    foreach ($assetId in $assetIds) {
        if (-not (Test-FileContains -Path $assetManifest -Pattern "| $assetId |")) {
            Add-Finding $findings "fail" $assetManifest "Missing planned release asset id: $assetId"
        }
    }

    $workflowText = ""
    if (Test-Path -LiteralPath $releaseWorkflow) {
        $workflowText = Get-Content -Raw -Path $releaseWorkflow
    }
    foreach ($forbidden in @("latexmk", "mpm --install", "upload-artifact", "run_starter_tests.ps1", "run_phase7c_starter_tests.ps1")) {
        if ($workflowText.Contains($forbidden)) {
            Add-Finding $findings "fail" $releaseWorkflow "Release source checks must not run starter/PDF/MiKTeX workflow step: $forbidden"
        }
    }

    if (Test-Path -LiteralPath (Join-Path $root "build.lua")) {
        Add-Finding $findings "fail" "build.lua" "No active root build.lua may be added without a release-process decision."
    }

    $provideCount = 0
    foreach ($file in (Get-ChildItem -Path "src" -Include "*.cls", "*.sty" -Recurse -File)) {
        $text = Get-Content -Raw -Path $file.FullName
        if ($text -match "\\Provides(Class|Package)") {
            $provideCount += 1
        } else {
            Add-Finding $findings "fail" $file.FullName.Substring($root.Length + 1) "Missing \Provides declaration."
        }
    }
    if ($provideCount -lt 10) {
        Add-Finding $findings "fail" "src" "Expected at least 10 class/package declarations; found $provideCount."
    }
    Add-Finding $findings "info" "version inventory" "Found $provideCount class/package declarations."

    $failCount = @($findings | Where-Object { $_.Level -eq "fail" }).Count
    $warnCount = @($findings | Where-Object { $_.Level -eq "warn" }).Count

    $lines = New-Object System.Collections.Generic.List[string]
    $lines.Add("# Release Policy Guard Report")
    $lines.Add("")
    $lines.Add("* Created: $((Get-Date).ToString('s'))")
    $lines.Add("* failures: $failCount")
    $lines.Add("* warnings: $warnCount")
    $lines.Add("")
    $lines.Add("| Level | Area | Message |")
    $lines.Add("| --- | --- | --- |")
    foreach ($finding in $findings) {
        $lines.Add("| $($finding.Level) | $($finding.Area) | $($finding.Message) |")
    }
    Set-Content -Path $reportMarkdown -Value $lines -Encoding UTF8

    foreach ($finding in $findings) {
        $color = if ($finding.Level -eq "fail") { "Red" } elseif ($finding.Level -eq "warn") { "Yellow" } else { "Gray" }
        Write-Host "[$($finding.Level)] $($finding.Area): $($finding.Message)" -ForegroundColor $color
    }
    if ($failCount -gt 0) {
        throw "Release policy guard found $failCount failure(s). Report: $reportMarkdown"
    }
    $global:LASTEXITCODE = 0
    Write-Host "Release policy guard passed. Report: $reportMarkdown" -ForegroundColor Green
}
finally {
    Pop-Location
}
