$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$buildDir = Join-Path $repoRoot "build\tests"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

$positiveTests = @(
    "physicsquiz_mode_default",
    "physicsquiz_mode_student",
    "physicsquiz_mode_teacher",
    "physicsquiz_mode_solutions",
    "physicsquiz_mode_answerkey",
    "physicsquiz_content_default",
    "physicsquiz_content_student",
    "physicsquiz_content_teacher",
    "physicsquiz_content_solutions",
    "physicsquiz_content_answerkey",
    "physicsquiz_content_default_print",
    "physicsquiz_content_student_print",
    "physicsquiz_content_teacher_print",
    "physicsquiz_content_solutions_print",
    "physicsquiz_content_answerkey_print",
    "physicsquiz_presentation_default",
    "physicsquiz_presentation_colour",
    "physicsquiz_presentation_color_alias",
    "physicsquiz_presentation_print",
    "physicsquiz_version_a",
    "physicsquiz_version_b_print"
)

Push-Location $repoRoot
try {
    foreach ($name in $positiveTests) {
        $source = "tests/$name.tex"
        Write-Host "Building $name..." -ForegroundColor Cyan
        & latexmk -pdf -g "-outdir=$buildDir" $source
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $source"
        }

        $log = Join-Path $buildDir "$name.log"
        if (-not (Test-Path $log)) {
            throw "Expected log was not created: $log"
        }

        $diagnostics = Invoke-LogSelectString -Path $log -Pattern @(
            "LaTeX Warning:",
            "Overfull \\hbox",
            "Underfull \\hbox"
        )
        if ($diagnostics) {
            $diagnostics | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
            throw "Unexpected LaTeX diagnostics in $log"
        }
    }

    if (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 tests/check_physicsquiz_output_modes.py $buildDir
    }
    elseif (Get-Command python -ErrorAction SilentlyContinue) {
        & python tests/check_physicsquiz_output_modes.py $buildDir
    }
    else {
        throw "Python was not found. Install Python or make the py/python command available."
    }
    if ($LASTEXITCODE -ne 0) {
        throw "The semantic output-mode checker failed."
    }

    $expectedFailures = @(
        @{
            Name = "physicsquiz_mode_conflict"
            Message = "Conflicting primary output modes"
        },
        @{
            Name = "physicsquiz_presentation_conflict"
            Message = "Conflicting presentation modes"
        }
    )

    foreach ($test in $expectedFailures) {
        $source = "tests/$($test.Name).tex"
        Write-Host "Building expected-failure test $($test.Name)..." -ForegroundColor Yellow
        & latexmk -pdf -g "-outdir=$buildDir" $source
        if ($LASTEXITCODE -eq 0) {
            throw "$source unexpectedly compiled successfully."
        }

        $log = Join-Path $buildDir "$($test.Name).log"
        if (-not (Invoke-LogSelectString -Path $log -SimpleMatch -Pattern $test.Message -Quiet)) {
            throw "$source failed without the expected class error: $($test.Message)"
        }
        Write-Host "PASS expected failure: $($test.Name)" -ForegroundColor Green
    }

    Write-Host "All Phase 3D tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
