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
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

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
    # otengineering fails the suite instead of passing silently.
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
        throw "The Phase 5 practice-package smoke fixture is missing: $witness"
    }
    $themeSmoke = "tests\ot_theme_package_smoke.tex"
    if (-not (Test-Path $themeSmoke)) {
        throw "The Phase 5 theme-package smoke fixture is missing: $themeSmoke"
    }
    $boxSmoke = "tests\ot_boxes_package_smoke.tex"
    if (-not (Test-Path $boxSmoke)) {
        throw "The Phase 5 box-package smoke fixture is missing: $boxSmoke"
    }
    $coreSmoke = "tests\ot_core_package_smoke.tex"
    if (-not (Test-Path $coreSmoke)) {
        throw "The Phase 5 core-package smoke fixture is missing: $coreSmoke"
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
        $found = @(Invoke-LogSelectString -Path $log -SimpleMatch -Pattern "OT-PALETTE:").Count
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
    # Checkpoint 5B standalone package smoke
    #
    # The rendering baseline proves that documents using otscience and
    # otengineering did not change.  This smoke proves the new capability:
    # otnotation, otmath and otfigures can now load without relying on
    # otscience.cls to define the OT palette first.
    # ---------------------------------------------------------------------
    Write-Host "Building Checkpoint 5B standalone theme-package smoke..." -ForegroundColor Cyan
    & latexmk -pdf -g "-outdir=$testsBuildDir" $themeSmoke
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $themeSmoke"
    }

    $themeSmokeStem = "ot_theme_package_smoke"
    $themeSmokeLog = Join-Path $testsBuildDir "$themeSmokeStem.log"
    $themeSmokePdf = Join-Path $testsBuildDir "$themeSmokeStem.pdf"
    $themeSmokeSynctex = Join-Path $testsBuildDir "$themeSmokeStem.synctex.gz"
    foreach ($artifact in @($themeSmokeLog, $themeSmokePdf, $themeSmokeSynctex)) {
        if (-not (Test-Path $artifact)) {
            throw "Expected build artifact was not created: $artifact"
        }
    }

    foreach ($marker in @("OT5B-SMOKE:OTNOTATION", "OT5B-SMOKE:OTMATH", "OT5B-SMOKE:OTFIGURES")) {
        if (-not (Invoke-LogSelectString -Path $themeSmokeLog -SimpleMatch -Pattern $marker -Quiet)) {
            throw "$themeSmoke failed to emit expected marker: $marker"
        }
    }
    Write-Host "PASS Checkpoint 5B standalone theme-package smoke." -ForegroundColor Green

    # ---------------------------------------------------------------------
    # Checkpoint 5C standalone box-package smoke
    # ---------------------------------------------------------------------
    Write-Host "Building Checkpoint 5C standalone box-package smoke..." -ForegroundColor Cyan
    & latexmk -pdf -g "-outdir=$testsBuildDir" $boxSmoke
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $boxSmoke"
    }

    $boxSmokeStem = "ot_boxes_package_smoke"
    $boxSmokeLog = Join-Path $testsBuildDir "$boxSmokeStem.log"
    $boxSmokePdf = Join-Path $testsBuildDir "$boxSmokeStem.pdf"
    $boxSmokeSynctex = Join-Path $testsBuildDir "$boxSmokeStem.synctex.gz"
    foreach ($artifact in @($boxSmokeLog, $boxSmokePdf, $boxSmokeSynctex)) {
        if (-not (Test-Path $artifact)) {
            throw "Expected build artifact was not created: $artifact"
        }
    }
    if (-not (Invoke-LogSelectString -Path $boxSmokeLog -SimpleMatch -Pattern "OT5C-SMOKE:OTBOXES" -Quiet)) {
        throw "$boxSmoke failed to emit expected marker: OT5C-SMOKE:OTBOXES"
    }
    Write-Host "PASS Checkpoint 5C standalone box-package smoke." -ForegroundColor Green

    # ---------------------------------------------------------------------
    # Checkpoint 5C standalone practice-package smoke
    #
    # Checkpoint 5A carried otpractice_standalone as an expected failure because
    # otpractice.sty borrowed otscibox from otscience.cls.  Now otpractice loads
    # otboxes directly, so this fixture must compile successfully.
    # ---------------------------------------------------------------------
    Write-Host "Building Checkpoint 5C standalone practice-package smoke..." -ForegroundColor Cyan
    & latexmk -pdf -g "-outdir=$testsBuildDir" $witness
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $witness"
    }

    $practiceSmokeStem = "otpractice_standalone"
    $practiceSmokeLog = Join-Path $testsBuildDir "$practiceSmokeStem.log"
    $practiceSmokePdf = Join-Path $testsBuildDir "$practiceSmokeStem.pdf"
    $practiceSmokeSynctex = Join-Path $testsBuildDir "$practiceSmokeStem.synctex.gz"
    foreach ($artifact in @($practiceSmokeLog, $practiceSmokePdf, $practiceSmokeSynctex)) {
        if (-not (Test-Path $artifact)) {
            throw "Expected build artifact was not created: $artifact"
        }
    }
    if (-not (Invoke-LogSelectString -Path $practiceSmokeLog -SimpleMatch -Pattern "OT5C-SMOKE:OTPRACTICE" -Quiet)) {
        throw "$witness failed to emit expected marker: OT5C-SMOKE:OTPRACTICE"
    }
    Write-Host "PASS Checkpoint 5C standalone practice-package smoke." -ForegroundColor Green

    # ---------------------------------------------------------------------
    # Checkpoint 5E standalone core-package smoke
    #
    # The baseline proves existing class documents still render the same.  This
    # smoke proves the extracted class-facing setup helpers can load and execute
    # outside either OT class.
    # ---------------------------------------------------------------------
    Write-Host "Building Checkpoint 5E standalone core-package smoke..." -ForegroundColor Cyan
    & latexmk -pdf -g "-outdir=$testsBuildDir" $coreSmoke
    if ($LASTEXITCODE -ne 0) {
        throw "LaTeX compilation failed for $coreSmoke"
    }

    $coreSmokeStem = "ot_core_package_smoke"
    $coreSmokeLog = Join-Path $testsBuildDir "$coreSmokeStem.log"
    $coreSmokePdf = Join-Path $testsBuildDir "$coreSmokeStem.pdf"
    $coreSmokeSynctex = Join-Path $testsBuildDir "$coreSmokeStem.synctex.gz"
    foreach ($artifact in @($coreSmokeLog, $coreSmokePdf, $coreSmokeSynctex)) {
        if (-not (Test-Path $artifact)) {
            throw "Expected build artifact was not created: $artifact"
        }
    }
    if (-not (Invoke-LogSelectString -Path $coreSmokeLog -SimpleMatch -Pattern "OT5E-SMOKE:OTCORE" -Quiet)) {
        throw "$coreSmoke failed to emit expected marker: OT5E-SMOKE:OTCORE"
    }
    Write-Host "PASS Checkpoint 5E standalone core-package smoke." -ForegroundColor Green

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
