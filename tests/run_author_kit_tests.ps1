param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$kitName = "author-kit-check"
$kitRoot = Join-Path $root "build\author-kit\$kitName"

if (Test-Path $kitRoot) {
    Remove-Item -LiteralPath $kitRoot -Recurse -Force
}

Push-Location $root
try {
    & "scripts\new-author-kit.ps1" -Name $kitName -AllowDirty
    if ($LASTEXITCODE -ne 0) {
        throw "Author-kit generator failed."
    }

    foreach ($path in @(
            "src\classes\otbook.cls",
            "src\packages\otcore.sty",
            "examples\otbook\starter_personal_book.tex",
            "templates\otbook-project\.latexmkrc",
            "tests\run_otbook_tests.ps1",
            "tests\otbook_class_smoke.tex"
        )) {
        if (-not (Test-Path (Join-Path $kitRoot $path))) {
            throw "Required file is missing from generated author kit: $path"
        }
    }

    $forbidden = Get-ChildItem -LiteralPath $kitRoot -Force -Recurse | Where-Object {
        $_.Name -in @("build", ".git", "AGENTS.md", "indent.log") -or
        $_.Name -match '\.(aux|log|fls|fdb_latexmk|out|toc|synctex\.gz)$'
    }
    if ($forbidden) {
        throw "Generated author kit contains forbidden files: $($forbidden.FullName -join ', ')"
    }

    $global:LASTEXITCODE = 0
    Write-Host "Author-kit generator checks passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
