<#
    Architecture refactor (docs/architecture/PLAN.md) - Phases A to C regression runner.

    Builds the fixtures added for the refactor and checks that each emits its
    marker. The fixtures prove that:

      * otsciboxes supplies all twenty semantic science boxes in a standard
        class (Phase B);
      * otboxes and otpractice do NOT define those names, so author-defined
        boxes with the same names keep compiling (Phase B);
      * the `minimal` option of otscience and otbook skips the companion
        bundle but keeps the class foundations (Phase C); and
      * \otenabletagging reports, rather than silently ignores, an engine
        where it cannot tag (Phase C);
      * otcolors supplies the palette without hyperref, capability packages
        no longer load hyperref, and ottheme still does (decision 7); and
      * \otmarks replaces the broken \marks helper in otpractice; and
      * otlayout applies the one-inch default only when geometry is not
        already loaded, and the otscience-theme preset works standalone
        (Phase D).

    It then runs the Phase 5 OT-side baseline and the otbook runner, which
    prove that existing documents are unchanged, and checks that the interface
    inventory is current.

        powershell -ExecutionPolicy Bypass -File tests\run_ot_contract_tests.ps1

    -SkipBaseline omits the Phase 5 baseline and otbook runners (iteration only).
#>

[CmdletBinding()]
param(
    [switch]$SkipBaseline
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
. (Join-Path $PSScriptRoot "powershell_log_helpers.ps1")

$documents = @(
    [pscustomobject]@{ Source = "tests\ot_sciboxes_package_smoke.tex";  Stem = "ot_sciboxes_package_smoke";  Marker = "OTREFACTOR-B:OTSCIBOXES-SMOKE" }
    [pscustomobject]@{ Source = "tests\ot_boxes_default_surface.tex";   Stem = "ot_boxes_default_surface";   Marker = "OTREFACTOR-B:DEFAULT-SURFACE" }
    [pscustomobject]@{ Source = "tests\otscience_minimal_option.tex";   Stem = "otscience_minimal_option";   Marker = "OTREFACTOR-C:OTSCIENCE-MINIMAL" }
    [pscustomobject]@{ Source = "tests\otbook_minimal_option.tex";      Stem = "otbook_minimal_option";      Marker = "OTREFACTOR-C:OTBOOK-MINIMAL" }
    [pscustomobject]@{ Source = "tests\otaccess_tagging_message.tex";   Stem = "otaccess_tagging_message";   Marker = "has no effect under this engine" }
    [pscustomobject]@{ Source = "tests\ot_colors_package_smoke.tex";    Stem = "ot_colors_package_smoke";    Marker = "OTREFACTOR-D7:OTCOLORS-SMOKE" }
    [pscustomobject]@{ Source = "tests\ot_link_policy_boundary.tex";    Stem = "ot_link_policy_boundary";    Marker = "OTREFACTOR-D7:LINK-POLICY-BOUNDARY" }
    [pscustomobject]@{ Source = "tests\ot_link_policy_optin.tex";       Stem = "ot_link_policy_optin";       Marker = "OTREFACTOR-D7:LINK-POLICY-OPTIN" }
    [pscustomobject]@{ Source = "tests\otpractice_otmarks.tex";         Stem = "otpractice_otmarks";         Marker = "OTREFACTOR-E:OTMARKS" }
    [pscustomobject]@{ Source = "tests\otlayout_default_geometry.tex";   Stem = "otlayout_default_geometry";   Marker = "OTREFACTOR-D:OTLAYOUT-DEFAULT" }
    [pscustomobject]@{ Source = "tests\otlayout_geometry_precedence.tex"; Stem = "otlayout_geometry_precedence"; Marker = "OTREFACTOR-D:GEOMETRY-PRECEDENCE" }
    [pscustomobject]@{ Source = "tests\otscience_theme_preset_smoke.tex"; Stem = "otscience_theme_preset_smoke"; Marker = "OTREFACTOR-D:OTSCIENCE-THEME" }
    [pscustomobject]@{ Source = "tests\ot_notation_neutral_loading.tex";  Stem = "ot_notation_neutral_loading";  Marker = "OTREFACTOR-E:NEUTRAL-LOADING" }
    [pscustomobject]@{ Source = "tests\ot_notation_canonical_names.tex";  Stem = "ot_notation_canonical_names";  Marker = "OTREFACTOR-E:CANONICAL-NAMES" }
    [pscustomobject]@{ Source = "tests\otemphasis_package_smoke.tex";     Stem = "otemphasis_package_smoke";     Marker = "OTREFACTOR-E:OTEMPHASIS" }
)

function Invoke-Python {
    param([string[]]$PythonArgs)
    if (Get-Command py -ErrorAction SilentlyContinue) { & py -3 @PythonArgs }
    elseif (Get-Command python -ErrorAction SilentlyContinue) { & python @PythonArgs }
    else { throw "Python was not found. Install Python or make py/python available." }
}

Push-Location $root
try {
    if (-not (Get-Command latexmk -ErrorAction SilentlyContinue)) {
        throw "latexmk was not found on PATH."
    }

    $outputDir = Join-Path $root "build\tests\architecture-refactor"
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

    foreach ($document in $documents) {
        if (-not (Test-Path $document.Source)) {
            throw "Required refactor fixture is missing: $($document.Source)"
        }

        Write-Host "Building $($document.Source)..." -ForegroundColor Cyan
        & latexmk -pdf -g -interaction=nonstopmode -halt-on-error "-outdir=$outputDir" $document.Source
        if ($LASTEXITCODE -ne 0) {
            throw "LaTeX compilation failed for $($document.Source)"
        }

        $logPath = Join-Path $outputDir "$($document.Stem).log"
        $pdfPath = Join-Path $outputDir "$($document.Stem).pdf"
        if (-not (Test-Path $pdfPath)) {
            throw "Expected PDF is missing: $pdfPath"
        }
        if (-not (Invoke-LogSelectString -Path $logPath -SimpleMatch -Pattern $document.Marker -Quiet)) {
            throw "$($document.Source) did not emit expected marker: $($document.Marker)"
        }
        Write-Host "PASS $($document.Source)" -ForegroundColor Green
    }

    Write-Host "Checking that docs\INTERFACE_INVENTORY.md is current..." -ForegroundColor Cyan
    Invoke-Python @("scripts\audit_interfaces.py", "--check")
    if ($LASTEXITCODE -ne 0) {
        throw "The interface inventory is stale. Run: py -3 scripts\audit_interfaces.py"
    }

    if (-not $SkipBaseline) {
        Write-Host "Running the Phase 5 OT-side baseline (existing documents must be unchanged)..." -ForegroundColor Cyan
        & (Join-Path $PSScriptRoot "run_ot_baseline_tests.ps1") -SkipGuard
        if ($LASTEXITCODE -ne 0) { throw "Phase 5 OT-side baseline failed." }

        Write-Host "Running the otbook runner..." -ForegroundColor Cyan
        & (Join-Path $PSScriptRoot "run_otbook_tests.ps1")
        if ($LASTEXITCODE -ne 0) { throw "otbook runner failed." }
    }

    $global:LASTEXITCODE = 0
    Write-Host "All architecture refactor tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
