param(
    [string]$Name = "latex-lab-author-kit-$(Get-Date -Format 'yyyy-MM-dd')",
    [switch]$Zip,
    [switch]$AllowDirty
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
if ($Name -notmatch '^[A-Za-z0-9][A-Za-z0-9._-]*$' -or $Name -match '\.\.') {
    throw "Name must be a non-empty, relative folder name."
}
$kitRoot = Join-Path $repoRoot "build\author-kit\$Name"

if (Test-Path $kitRoot) {
    throw "Author kit destination already exists: $kitRoot"
}

$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    $gitStatus = & $git.Source -C $repoRoot status --porcelain
    if ($LASTEXITCODE -ne 0) {
        throw "Could not inspect the repository Git state."
    }
    if ($gitStatus -and -not $AllowDirty) {
        throw "The working tree is not clean. Commit or stash changes, or use -AllowDirty for an explicitly local snapshot."
    }
    if ($gitStatus) {
        Write-Warning "Creating a local author-kit snapshot from a dirty working tree."
    }
}

function Copy-KitFile {
    param([string]$RelativePath)

    $source = Join-Path $repoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Required author-kit file is missing: $RelativePath"
    }

    $destination = Join-Path $kitRoot $RelativePath
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
    Copy-Item -LiteralPath $source -Destination $destination -Force
}

function Copy-KitDirectory {
    param([string]$RelativePath)

    $sourceDirectory = Join-Path $repoRoot $RelativePath
    if (-not (Test-Path -LiteralPath $sourceDirectory -PathType Container)) {
        throw "Required author-kit directory is missing: $RelativePath"
    }

    $destinationDirectory = Join-Path $kitRoot $RelativePath
    Get-ChildItem -LiteralPath $sourceDirectory -Force -File -Recurse | ForEach-Object {
        $relativeFile = $_.FullName.Substring($sourceDirectory.Length).TrimStart('\', '/')
        if ($relativeFile -match '(^|[\\/])build([\\/]|$)') {
            return
        }
        $destination = Join-Path $destinationDirectory $relativeFile
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $destination) | Out-Null
        Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
    }
}

$files = @(
    "README.md",
    "CONTRIBUTING.md",
    ".latexmkrc",
    "docs\AUTHOR_WORKFLOW.md",
    "docs\STARTER_INVENTORY.md",
    "docs\PUBLIC_INTERFACES.md",
    "docs\AUTHOR_KIT.md",
    "examples\physicsquiz\starter_quiz_bank.tex",
    "examples\physicsquiz\starter_versioned_quiz.tex",
    "examples\studentnotes\starter_notes.tex",
    "examples\otengineering\starter_engineering_notes.tex",
    "examples\otscience\starter_science_notes.tex",
    "examples\otbook\starter_personal_book.tex",
    "examples\vector-workbook\starter_module.tex",
    "examples\vector-workbook\starter_combined_workbook.tex",
    "examples\vector-workbook\00_common_setup.tex",
    "tests\run_phase7c_starter_tests.ps1",
    "tests\run_otbook_tests.ps1",
    "tests\otbook_class_smoke.tex",
    "tests\powershell_log_helpers.ps1"
)

try {
    New-Item -ItemType Directory -Path $kitRoot | Out-Null
    foreach ($file in $files) {
        Copy-KitFile $file
    }
    foreach ($directory in @("src\classes", "src\packages", "templates\otbook-project")) {
        Copy-KitDirectory $directory
    }

    $forbidden = Get-ChildItem -LiteralPath $kitRoot -Force -Recurse | Where-Object {
        $_.Name -in @("build", ".git", "AGENTS.md", "indent.log") -or
        $_.Name -match '\.(aux|log|fls|fdb_latexmk|out|toc|synctex\.gz)$'
    }
    if ($forbidden) {
        throw "Generated or local-only files entered the author kit: $($forbidden.FullName -join ', ')"
    }

    $kitFileCount = (Get-ChildItem -LiteralPath $kitRoot -Force -File -Recurse).Count
    Write-Host "Created author kit: $kitRoot" -ForegroundColor Green
    Write-Host "Source files: $kitFileCount" -ForegroundColor Green

    if ($Zip) {
        $zipPath = "$kitRoot.zip"
        Compress-Archive -LiteralPath $kitRoot -DestinationPath $zipPath -CompressionLevel Optimal
        $hash = (Get-FileHash -Algorithm SHA256 -LiteralPath $zipPath).Hash.ToLowerInvariant()
        Write-Host "Created zip: $zipPath" -ForegroundColor Green
        Write-Host "SHA256: $hash" -ForegroundColor Green
    }
}
catch {
    if (Test-Path $kitRoot) {
        Remove-Item -LiteralPath $kitRoot -Recurse -Force
    }
    throw
}
