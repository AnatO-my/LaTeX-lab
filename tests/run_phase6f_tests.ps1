param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$source = Join-Path $root "examples\physicsquiz\PHY104_versioned_paper.tex"
$bankSource = Join-Path $root "examples\physicsquiz\banks\phy104_full_question_bank.tex"
$generatedDir = Join-Path $root "build\tests\phase6f_versioned"
$generatedBankDir = Join-Path $generatedDir "banks"
$buildDir = Join-Path $root "build\tests\phase6f_versioned\out"
$copyA = Join-Path $generatedDir "PHY104_versioned_paper_A.tex"
$copyB = Join-Path $generatedDir "PHY104_versioned_paper_B.tex"

Push-Location $root
try {
    $phase6eRunner = "tests\run_phase6e_tests.ps1"
    if (-not (Test-Path $phase6eRunner)) {
        throw "The Phase 6E runner is missing: $phase6eRunner"
    }

    Write-Host "Running the Phase 6E checkpoint..." -ForegroundColor Cyan
    try {
        & $phase6eRunner
    }
    catch {
        throw "The Phase 6E checkpoint failed: $($_.Exception.Message)"
    }

    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    if (-not (Test-Path $source)) {
        throw "Required versioned-paper example is missing: $source"
    }
    if (-not (Test-Path $bankSource)) {
        throw "Required PHY104 question bank is missing: $bankSource"
    }

    $expectedGeneratedRoot = Join-Path $root "build\tests\phase6f_versioned"
    if (([System.IO.Path]::GetFullPath($generatedDir)) -ne ([System.IO.Path]::GetFullPath($expectedGeneratedRoot))) {
        throw "Refusing to clean unexpected generated directory: $generatedDir"
    }
    if (Test-Path $generatedDir) {
        Remove-Item -LiteralPath $generatedDir -Recurse -Force
    }

    New-Item -ItemType Directory -Force -Path $generatedDir | Out-Null
    New-Item -ItemType Directory -Force -Path $generatedBankDir | Out-Null
    New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
    Copy-Item -Path $bankSource -Destination $generatedBankDir -Force

    $content = Get-Content -Raw -Path $source
    $contentA = $content -replace "\\quizuseversion\{[A-Za-z0-9-]+\}", "\quizuseversion{A}"
    $contentB = $content -replace "\\quizuseversion\{[A-Za-z0-9-]+\}", "\quizuseversion{B}"
    Set-Content -Path $copyA -Value $contentA -Encoding UTF8
    Set-Content -Path $copyB -Value $contentB -Encoding UTF8

    foreach ($copy in @($copyA, $copyB)) {
        $name = [System.IO.Path]::GetFileNameWithoutExtension($copy)
        Write-Host "Building generated versioned paper $name..." -ForegroundColor Cyan
        & latexmk -pdf -interaction=nonstopmode -halt-on-error "-outdir=$buildDir" $copy
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $copy"
        }
        foreach ($extension in @("log", "pdf", "synctex.gz")) {
            $artifact = Join-Path $buildDir "$name.$extension"
            if (-not (Test-Path $artifact)) {
                throw "Expected build artifact was not created: $artifact"
            }
        }
    }

    $pdfA = Join-Path $buildDir "PHY104_versioned_paper_A.pdf"
    $pdfB = Join-Path $buildDir "PHY104_versioned_paper_B.pdf"
    $sizeA = (Get-Item $pdfA).Length
    $sizeB = (Get-Item $pdfB).Length
    if ($sizeA -eq $sizeB) {
        throw "Generated versioned PDFs have identical byte sizes; expected a weak visual-output difference."
    }

    $checkerArgs = @(
        "tests\check_physicsquiz_versioned_visual.py",
        (Join-Path $buildDir "PHY104_versioned_paper_A.log"),
        (Join-Path $buildDir "PHY104_versioned_paper_B.log")
    )
    if (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 @checkerArgs
    }
    elseif (Get-Command python -ErrorAction SilentlyContinue) {
        & python @checkerArgs
    }
    else {
        throw "Python was not found. Install Python or make py/python available."
    }
    if ($LASTEXITCODE -ne 0) {
        throw "The Phase 6F versioned-paper checker failed."
    }

    $global:LASTEXITCODE = 0
    Write-Host "All Phase 6F tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
