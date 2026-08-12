$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$buildDir = Join-Path $repoRoot "build\tests"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

Push-Location $repoRoot
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    if (-not (& kpsewhich xsim.sty)) {
        throw "xsim.sty was not found. Install xsim with MiKTeX Console before running Phase 4C."
    }

    $phase3Runner = "tests\run_physicsquiz_phase3d_tests.ps1"
    if (-not (Test-Path $phase3Runner)) {
        throw "The Phase 3D regression runner is missing: $phase3Runner"
    }

    Write-Host "Running the established Phase 3D regression suite..." -ForegroundColor Cyan
    try {
        & $phase3Runner
    }
    catch {
        throw "The Phase 3D regression suite failed: $($_.Exception.Message)"
    }

    $positiveTests = @(
        "physicsquiz_xsim_default",
        "physicsquiz_xsim_student",
        "physicsquiz_xsim_teacher",
        "physicsquiz_xsim_solutions",
        "physicsquiz_xsim_answerkey",
        "physicsquiz_xsim_one_column",
        "physicsquiz_xsim_optional_outcome"
    )

    foreach ($name in $positiveTests) {
        $source = "tests\$name.tex"
        Write-Host "Building $name..." -ForegroundColor Cyan
        & latexmk -pdf -g "-outdir=$buildDir" $source
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $source"
        }

        $log = Join-Path $buildDir "$name.log"
        $pdf = Join-Path $buildDir "$name.pdf"
        $synctex = Join-Path $buildDir "$name.synctex.gz"
        foreach ($artifact in @($log, $pdf, $synctex)) {
            if (-not (Test-Path $artifact)) {
                throw "Expected build artifact was not created: $artifact"
            }
        }

        $diagnostics = Invoke-LogSelectString -Path $log -SimpleMatch -Pattern @(
            "LaTeX Warning:",
            "Package xsim Warning:",
            "Overfull \hbox",
            "Underfull \hbox"
        )
        if ($diagnostics) {
            $diagnostics | ForEach-Object { Write-Host $_.Line -ForegroundColor Red }
            throw "Unexpected LaTeX diagnostics in $log"
        }
    }

    if (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 tests\check_physicsquiz_xsim_facade.py $buildDir
    }
    elseif (Get-Command python -ErrorAction SilentlyContinue) {
        & python tests\check_physicsquiz_xsim_facade.py $buildDir
    }
    else {
        throw "Python was not found. Install Python or make py/python available."
    }
    if ($LASTEXITCODE -ne 0) {
        throw "The Phase 4C semantic checker failed."
    }

    $oneColumnLog = Join-Path $buildDir "physicsquiz_xsim_one_column.log"
    foreach ($marker in @("PQ4C-CONTENT:QUESTIONS", "PQ4C-CONTENT:REFERENCE", "PQ4C-COUNT:4", "PQ4C-TOTAL:8")) {
        if (-not (Invoke-LogSelectString -Path $oneColumnLog -SimpleMatch -Pattern $marker -Quiet)) {
            throw "The one-column test is missing marker: $marker"
        }
    }

    $optionalOutcomeLog = Join-Path $buildDir "physicsquiz_xsim_optional_outcome.log"
    foreach ($marker in @("PQ4C-COUNT:1", "PQ4C-TOTAL:1.5", "PQ4C-ANSWER:optional-outcome=D", "PQ4C-OUTCOME:optional-outcome=NONE")) {
        if (-not (Invoke-LogSelectString -Path $optionalOutcomeLog -SimpleMatch -Pattern $marker -Quiet)) {
            throw "The optional-outcome test is missing marker: $marker"
        }
    }

    $expectedFailures = @(
        @{ Name = "physicsquiz_xsim_missing_id";          Marker = "PQ4C-VALIDATION:MISSING-id" },
        @{ Name = "physicsquiz_xsim_duplicate_id";        Marker = "PQ4C-VALIDATION:DUPLICATE-ID:duplicate-id" },
        @{ Name = "physicsquiz_xsim_missing_metadata";    Marker = "PQ4C-VALIDATION:MISSING-correct" },
        @{ Name = "physicsquiz_xsim_missing_solution";    Marker = "PQ4C-VALIDATION:MISSING-SOLUTION:missing-solution" },
        @{ Name = "physicsquiz_xsim_invalid_id";          Marker = "PQ4C-VALIDATION:INVALID-ID:Invalid_ID" },
        @{ Name = "physicsquiz_xsim_invalid_marks";       Marker = "PQ4C-VALIDATION:INVALID-MARKS:zero" },
        @{ Name = "physicsquiz_xsim_invalid_correct";     Marker = "PQ4C-VALIDATION:INVALID-CORRECT:AA" },
        @{ Name = "physicsquiz_xsim_duplicate_solution";  Marker = "PQ4C-VALIDATION:DUPLICATE-SOLUTION:duplicate-solution" },
        @{ Name = "physicsquiz_xsim_orphan_solution";     Marker = "PQ4C-VALIDATION:ORPHAN-SOLUTION" },
        @{ Name = "physicsquiz_xsim_nonadjacent_solution"; Marker = "PQ4C-VALIDATION:MISSING-SOLUTION:first-question" }
    )

    foreach ($test in $expectedFailures) {
        $source = "tests\$($test.Name).tex"
        Write-Host "Building expected-failure test $($test.Name)..." -ForegroundColor Yellow
        & latexmk -pdf -g "-outdir=$buildDir" $source
        if ($LASTEXITCODE -eq 0) {
            throw "$source unexpectedly compiled successfully."
        }

        $log = Join-Path $buildDir "$($test.Name).log"
        if (-not (Invoke-LogSelectString -Path $log -SimpleMatch -Pattern $test.Marker -Quiet)) {
            throw "$source failed without the expected validation marker: $($test.Marker)"
        }
        Write-Host "PASS expected failure: $($test.Name)" -ForegroundColor Green
    }

    # Expected-failure latexmk runs deliberately leave a non-zero native exit
    # code.  Clear it so a future wrapper cannot misread this successful suite.
    $global:LASTEXITCODE = 0
    Write-Host "All Phase 4C tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
