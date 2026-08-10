<#
    Phase 5 Checkpoint 5A - OT-side regression harness.

    Phase 5 changes only the otscience/otengineering side of the ecosystem, and
    that side has had no runner: PROJECT_STATE.md records "a regression suite now
    exists for physicsquiz only.  The other three classes have compatibility
    fixtures but no runner."  Chaining the accepted physicsquiz suites therefore
    proves nothing about a Phase 5 change; it only proves the untouched side is
    still untouched.  That chain is a guard, not a proof.

    This runner supplies the proof:

      1. it runs the accepted Phase 4I/4J chain (4G -> 4F -> 4E -> 4D -> 4C ->
         3D) as the untouched-side guard;
      2. it builds every OT-side fixture and representative document; and
      3. it compares page counts, log diagnostics and - where a text extractor
         is available - rendered page text against a recorded baseline.

    Record the baseline against unmodified sources first:

        powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1 -Record

    Then every later checkpoint verifies against it:

        powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1

    -SkipGuard omits the physicsquiz chain.  It exists for iteration only; a
    checkpoint is not complete without a full run.
#>

[CmdletBinding()]
param(
    [switch]$Record,
    [switch]$SkipGuard
)

$ErrorActionPreference = "Stop"

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$testsBuildDir = Join-Path $repoRoot "build\tests"
$manifestPath = Join-Path $repoRoot "tests\ot_baseline_manifest.json"
$jobsPath = Join-Path $testsBuildDir "ot_baseline_jobs.tsv"

# Announce the resolved mode before doing anything.  The first 5A run silently
# verified when RECORD was intended, and only failed several stages later with a
# message about a missing manifest rather than a wrong invocation.  A harness
# must say what it is about to do.
$resolvedMode = if ($Record) { "RECORD" } else { "VERIFY" }
Write-Host "Mode: $resolvedMode" -ForegroundColor Magenta
if ($resolvedMode -eq "VERIFY" -and -not (Test-Path $manifestPath)) {
    Write-Host "There is no baseline manifest yet. If you meant to create one, stop now and re-run with -Record." -ForegroundColor Yellow
}

# Key            = stable manifest key, independent of build layout
# Directory      = source directory, relative to the repository root
# Stem           = file stem, without extension
# OutputRelative = build directory, relative to the repository root
$documents = @(
    # --- Palette probes -----------------------------------------------------
    # Colour VALUES are invisible to page counts and to rendered-text hashes.
    # These two fixtures print what xcolor actually resolves each OT name to,
    # so a mistyped hex digit in Checkpoint 5B or a dropped OTLight override in
    # Checkpoint 5D fails the suite instead of passing silently.
    [pscustomobject]@{ Key = "tests/ot_palette_probe_science";                  Directory = "tests"; Stem = "ot_palette_probe_science";                  OutputRelative = "build\tests" }
    [pscustomobject]@{ Key = "tests/ot_palette_probe_engineering";              Directory = "tests"; Stem = "ot_palette_probe_engineering";              OutputRelative = "build\tests" }

    # --- Phase 2 compatibility fixtures -------------------------------------
    [pscustomobject]@{ Key = "tests/otscience_boxes_compatibility";             Directory = "tests"; Stem = "otscience_boxes_compatibility";             OutputRelative = "build\tests" }
    [pscustomobject]@{ Key = "tests/studentnotes_theorem_notes_compatibility";  Directory = "tests"; Stem = "studentnotes_theorem_notes_compatibility";  OutputRelative = "build\tests" }
    [pscustomobject]@{ Key = "tests/studentnotes_namedformula_compatibility";   Directory = "tests"; Stem = "studentnotes_namedformula_compatibility";   OutputRelative = "build\tests" }
    [pscustomobject]@{ Key = "tests/studentnotes_helpers_smoke";                Directory = "tests"; Stem = "studentnotes_helpers_smoke";                OutputRelative = "build\tests" }
    [pscustomobject]@{ Key = "tests/otengineering_boxes_compatibility";         Directory = "tests"; Stem = "otengineering_boxes_compatibility";         OutputRelative = "build\tests" }
    [pscustomobject]@{ Key = "tests/otengineering_helpers_smoke";               Directory = "tests"; Stem = "otengineering_helpers_smoke";               OutputRelative = "build\tests" }

    # --- Representative documents -------------------------------------------
    [pscustomobject]@{ Key = "examples/otengineering/test";                     Directory = "examples\otengineering";  Stem = "test";   OutputRelative = "build\examples\otengineering" }
    [pscustomobject]@{ Key = "examples/studentnotes/Optics";                    Directory = "examples\studentnotes";   Stem = "Optics"; OutputRelative = "build\examples\studentnotes" }

    # --- Workbook: combined root and every standalone module ----------------
    [pscustomobject]@{ Key = "examples/vector-workbook/00_main_combined_workbook";             Directory = "examples\vector-workbook"; Stem = "00_main_combined_workbook";             OutputRelative = "build\examples\vector-workbook" }
    [pscustomobject]@{ Key = "examples/vector-workbook/01_grad_div_curl_vector_fields";        Directory = "examples\vector-workbook"; Stem = "01_grad_div_curl_vector_fields";        OutputRelative = "build\examples\vector-workbook" }
    [pscustomobject]@{ Key = "examples/vector-workbook/02_coordinate_systems_tensor_operations"; Directory = "examples\vector-workbook"; Stem = "02_coordinate_systems_tensor_operations"; OutputRelative = "build\examples\vector-workbook" }
    [pscustomobject]@{ Key = "examples/vector-workbook/03_index_delta_levicivita";             Directory = "examples\vector-workbook"; Stem = "03_index_delta_levicivita";             OutputRelative = "build\examples\vector-workbook" }
    [pscustomobject]@{ Key = "examples/vector-workbook/04_covariant_contravariant_metrics";    Directory = "examples\vector-workbook"; Stem = "04_covariant_contravariant_metrics";    OutputRelative = "build\examples\vector-workbook" }
    [pscustomobject]@{ Key = "examples/vector-workbook/05_symmetric_skew_tensors_invariants";  Directory = "examples\vector-workbook"; Stem = "05_symmetric_skew_tensors_invariants";  OutputRelative = "build\examples\vector-workbook" }
    [pscustomobject]@{ Key = "examples/vector-workbook/06_complex_numbers_hyperbolic_functions"; Directory = "examples\vector-workbook"; Stem = "06_complex_numbers_hyperbolic_functions"; OutputRelative = "build\examples\vector-workbook" }
    [pscustomobject]@{ Key = "examples/vector-workbook/07_final_mixed_practice_bank";          Directory = "examples\vector-workbook"; Stem = "07_final_mixed_practice_bank";          OutputRelative = "build\examples\vector-workbook" }
)

function Invoke-Checker {
    param([string[]]$CheckerArgs)

    if (Get-Command py -ErrorAction SilentlyContinue) {
        & py -3 @CheckerArgs
    }
    elseif (Get-Command python -ErrorAction SilentlyContinue) {
        & python @CheckerArgs
    }
    else {
        throw "Python was not found. Install Python or make py/python available."
    }
}

Push-Location $repoRoot
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    foreach ($document in $documents) {
        $source = Join-Path $document.Directory "$($document.Stem).tex"
        if (-not (Test-Path $source)) {
            throw "Required Phase 5 baseline source is missing: $source"
        }
    }

    $witness = "tests\otpractice_standalone.tex"
    if (-not (Test-Path $witness)) {
        throw "The Phase 5 cycle-witness fixture is missing: $witness"
    }

    New-Item -ItemType Directory -Force -Path $testsBuildDir | Out-Null
    foreach ($outputRelative in ($documents.OutputRelative | Sort-Object -Unique)) {
        New-Item -ItemType Directory -Force -Path (Join-Path $repoRoot $outputRelative) | Out-Null
    }

    # ---------------------------------------------------------------------
    # Untouched-side guard
    # ---------------------------------------------------------------------
    if ($SkipGuard) {
        Write-Host "SKIPPING the physicsquiz guard. This run is for iteration only;" -ForegroundColor Yellow
        Write-Host "a checkpoint is not complete without a full run." -ForegroundColor Yellow
    }
    else {
        if (-not (& kpsewhich xsim.sty)) {
            throw "xsim.sty was not found. Install xsim with MiKTeX Console before running the guard."
        }

        $phase4ijRunner = "tests\run_physicsquiz_phase4ij_tests.ps1"
        if (-not (Test-Path $phase4ijRunner)) {
            throw "The accepted Phase 4I/4J regression runner is missing: $phase4ijRunner"
        }

        # OneDrive stamps a mark-of-the-web on files it re-hydrates, and under a
        # RemoteSigned policy PowerShell then refuses to load them.  The guard
        # chains six runners, so without this check the failure surfaces deep
        # inside a nested throw and reads like a regression rather than an
        # environment problem.  Fail early, and name the remedy.
        $chainedRunners = @(
            "tests\run_physicsquiz_phase3d_tests.ps1",
            "tests\run_physicsquiz_phase4c_tests.ps1",
            "tests\run_physicsquiz_phase4d_tests.ps1",
            "tests\run_physicsquiz_phase4e_tests.ps1",
            "tests\run_physicsquiz_phase4f_tests.ps1",
            "tests\run_physicsquiz_phase4g_tests.ps1",
            "tests\run_physicsquiz_phase4ij_tests.ps1"
        )
        $blockedRunners = @()
        foreach ($chained in $chainedRunners) {
            if (-not (Test-Path $chained)) { continue }
            try {
                $zone = Get-Item -LiteralPath $chained -Stream Zone.Identifier -ErrorAction SilentlyContinue
                if ($zone) { $blockedRunners += $chained }
            }
            catch {
                # No alternate-data-stream support: nothing to check.
            }
        }
        if ($blockedRunners.Count -gt 0) {
            Write-Host "These chained runners carry a mark-of-the-web, so PowerShell will refuse to load them:" -ForegroundColor Red
            $blockedRunners | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
            throw "Unblock them first:  Get-ChildItem .\tests\*.ps1 | Unblock-File"
        }

        Write-Host "Running the accepted Phase 4I/4J regression suite as the untouched-side guard..." -ForegroundColor Cyan
        try {
            & $phase4ijRunner
        }
        catch {
            throw "The Phase 4I/4J regression suite failed: $($_.Exception.Message)"
        }
        $global:LASTEXITCODE = 0
    }

    # ---------------------------------------------------------------------
    # OT-side builds
    # ---------------------------------------------------------------------
    $jobLines = New-Object System.Collections.Generic.List[string]

    foreach ($document in $documents) {
        $source = Join-Path $document.Directory "$($document.Stem).tex"
        $outDir = Join-Path $repoRoot $document.OutputRelative

        Write-Host "Building $($document.Key)..." -ForegroundColor Cyan
        & latexmk -pdf -g "-outdir=$outDir" $source
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $source"
        }

        $log = Join-Path $outDir "$($document.Stem).log"
        $pdf = Join-Path $outDir "$($document.Stem).pdf"
        $synctex = Join-Path $outDir "$($document.Stem).synctex.gz"
        foreach ($artifact in @($log, $pdf, $synctex)) {
            if (-not (Test-Path $artifact)) {
                throw "Expected build artifact was not created: $artifact"
            }
        }

        $jobLines.Add("$($document.Key)`t$log`t$pdf")
    }

    # Verify the harness, not only the document: a palette probe that silently
    # emitted nothing would bake an empty baseline into the manifest and then
    # agree with itself forever.
    $expectedMarkers = @{
        "ot_palette_probe_science"     = 10
        "ot_palette_probe_engineering" = 8
    }
    foreach ($stem in $expectedMarkers.Keys) {
        $log = Join-Path $testsBuildDir "$stem.log"
        $found = @(Select-String -Path $log -SimpleMatch "OT-PALETTE:").Count
        if ($found -ne $expectedMarkers[$stem]) {
            throw "$stem emitted $found OT-PALETTE markers, expected $($expectedMarkers[$stem]). The palette probe is not measuring what it claims to."
        }
        Write-Host "Palette probe $stem reported $found colours." -ForegroundColor Green
    }

    # UTF-8 without a byte-order mark: the checker reads this file as plain
    # UTF-8, and a BOM would corrupt the first manifest key.
    [System.IO.File]::WriteAllLines(
        $jobsPath,
        $jobLines,
        (New-Object System.Text.UTF8Encoding($false))
    )

    # ---------------------------------------------------------------------
    # Baseline record or verify
    # ---------------------------------------------------------------------
    if ($Record) {
        Write-Host "Recording the OT rendering baseline..." -ForegroundColor Cyan
        Invoke-Checker -CheckerArgs @("tests\check_ot_baseline.py", "record", $manifestPath, $jobsPath)
        if ($LASTEXITCODE -ne 0) {
            throw "Recording the OT baseline failed."
        }
    }
    else {
        Write-Host "Verifying the OT rendering baseline..." -ForegroundColor Cyan
        Invoke-Checker -CheckerArgs @("tests\check_ot_baseline.py", "verify", $manifestPath, $jobsPath)
        if ($LASTEXITCODE -ne 0) {
            throw "The OT rendering baseline changed."
        }
    }

    # ---------------------------------------------------------------------
    # Expected failures
    #
    # The loop below is the accepted form from
    # run_physicsquiz_phase4e_tests.ps1, reproduced unchanged.
    #
    # otpractice_standalone is the Phase 5 cycle witness.  It fails TODAY
    # because otpractice.sty borrows otscibox and the OT palette from
    # otscience.cls and so cannot be loaded on its own.  Checkpoint 5C moves
    # this entry out of $expectedFailures and into $documents: that move is
    # the machine-checkable moment the circular dependency is broken.
    # ---------------------------------------------------------------------
    $expectedFailures = @(
        @{ Name = "otpractice_standalone"; Marker = "Environment otscibox undefined" }
    )

    foreach ($test in $expectedFailures) {
        $source = "tests\$($test.Name).tex"
        Write-Host "Building expected-failure test $($test.Name)..." -ForegroundColor Yellow
        & latexmk -pdf -g "-outdir=$testsBuildDir" $source
        if ($LASTEXITCODE -eq 0) {
            throw "$source unexpectedly compiled successfully."
        }

        $log = Join-Path $testsBuildDir "$($test.Name).log"
        if (-not (Select-String -Path $log -SimpleMatch $test.Marker -Quiet)) {
            throw "$source failed without the expected validation marker: $($test.Marker)"
        }
        Write-Host "PASS expected failure: $($test.Name)" -ForegroundColor Green
    }

    $global:LASTEXITCODE = 0
    if ($Record) {
        Write-Host "OT Phase 5 baseline recorded." -ForegroundColor Green
    }
    else {
        Write-Host "All OT Phase 5 tests passed." -ForegroundColor Green
    }
}
finally {
    Pop-Location
}
