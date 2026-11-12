<#
    Run every active LaTeX-lab test suite.

    Each suite runs in its own PowerShell process, so one failure does not
    stop the others. A summary table is printed at the end, and the script
    exits non-zero if any suite failed.

        powershell -ExecutionPolicy Bypass -File tests\run_all_tests.ps1
        powershell -ExecutionPolicy Bypass -File tests\run_all_tests.ps1 -List
        powershell -ExecutionPolicy Bypass -File tests\run_all_tests.ps1 -Only starters,otbook
        powershell -ExecutionPolicy Bypass -File tests\run_all_tests.ps1 -Skip lualatex,spong-repro

    Suite names are listed with -List. Retired runners in tests\history\ are
    never run. The build-measurement tool (run_build_measurement.ps1) is a
    timing report, not a test, and is not included.
#>
[CmdletBinding()]
param(
    [string[]]$Only = @(),
    [string[]]$Skip = @(),
    [switch]$List
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot

# Under `powershell -File`, "-Only a,b" arrives as the single string "a,b";
# split on commas so both calling styles work.
$Only = @($Only | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })
$Skip = @($Skip | ForEach-Object { $_ -split "," } | ForEach-Object { $_.Trim() } | Where-Object { $_ })

# Name, script, extra arguments, group
$suites = @(
    [pscustomobject]@{ Name = "release-policy";     Script = "run_release_policy_guard.ps1";          Args = @();                Group = "guards" }
    [pscustomobject]@{ Name = "build-recipe";       Script = "run_build_recipe_guard.ps1";            Args = @();                Group = "guards" }
    [pscustomobject]@{ Name = "generated-files";    Script = "run_generated_file_guard.ps1";          Args = @();                Group = "guards" }
    [pscustomobject]@{ Name = "manual-references";  Script = "run_manual_author_reference_guard.ps1"; Args = @();                Group = "guards" }
    [pscustomobject]@{ Name = "starters";           Script = "run_starter_tests.ps1";                 Args = @();                Group = "documents" }
    [pscustomobject]@{ Name = "physicsquiz";        Script = "run_physicsquiz_tests.ps1";             Args = @();                Group = "classes" }
    [pscustomobject]@{ Name = "ot-baseline";        Script = "run_ot_baseline_tests.ps1";             Args = @("-SkipGuard");    Group = "classes" }
    [pscustomobject]@{ Name = "ot-contracts";       Script = "run_ot_contract_tests.ps1";             Args = @("-SkipBaseline"); Group = "classes" }
    [pscustomobject]@{ Name = "otbook";             Script = "run_otbook_tests.ps1";                  Args = @();                Group = "classes" }
    [pscustomobject]@{ Name = "engineering";        Script = "run_engineering_tests.ps1";             Args = @();                Group = "classes" }
    [pscustomobject]@{ Name = "eee-report";         Script = "run_eee_report_tests.ps1";              Args = @();                Group = "classes" }
    [pscustomobject]@{ Name = "projects";           Script = "run_projects_tests.ps1";                Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "forms";              Script = "run_forms_tests.ps1";                   Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "access";             Script = "run_access_tests.ps1";                  Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "bib-index";          Script = "run_bib_index_tests.ps1";               Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "circuits";           Script = "run_circuit_tests.ps1";                 Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "code";               Script = "run_code_tests.ps1";                    Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "margin-notes";       Script = "run_margin_note_tests.ps1";             Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "nomenclature";       Script = "run_nomenclature_tests.ps1";            Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "plots";              Script = "run_plot_tests.ps1";                    Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "profiles";           Script = "run_profile_tests.ps1";                 Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "repro";              Script = "run_repro_tests.ps1";                   Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "theorem-policy";     Script = "run_theorem_policy_tests.ps1";          Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "standalone-figures"; Script = "run_standalone_figure_tests.ps1";       Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "dotgrid";            Script = "run_dotgrid_tests.ps1";                 Args = @();                Group = "packages" }
    [pscustomobject]@{ Name = "lualatex";           Script = "run_lualatex_tests.ps1";                Args = @();                Group = "engines" }
    [pscustomobject]@{ Name = "spong-repro";        Script = "run_spong_repro.ps1";                   Args = @();                Group = "examples" }
    [pscustomobject]@{ Name = "author-kit";         Script = "run_author_kit_tests.ps1";              Args = @();                Group = "release" }
)

if ($List) {
    $suites | Format-Table Name, Group, Script, @{ Label = "Args"; Expression = { $_.Args -join " " } } -AutoSize
    return
}

$known = @($suites | ForEach-Object { $_.Name })
foreach ($name in @($Only + $Skip)) {
    if ($known -notcontains $name) {
        throw "Unknown suite '$name'. Run with -List to see suite names."
    }
}

$selected = @($suites | Where-Object {
    (($Only.Count -eq 0) -or ($Only -contains $_.Name)) -and ($Skip -notcontains $_.Name)
})

$results = New-Object System.Collections.ArrayList
Push-Location $root
try {
    foreach ($suite in $selected) {
        $scriptPath = Join-Path $PSScriptRoot $suite.Script
        Write-Host ""
        Write-Host "=== $($suite.Name) ($($suite.Script)) ===" -ForegroundColor Cyan
        $started = Get-Date
        if (-not (Test-Path -LiteralPath $scriptPath)) {
            $status = "MISSING"
            $exitCode = -1
        } else {
            $arguments = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", $scriptPath) + $suite.Args
            & powershell @arguments
            $exitCode = $LASTEXITCODE
            $status = if ($exitCode -eq 0) { "PASS" } else { "FAIL" }
        }
        $seconds = [math]::Round(((Get-Date) - $started).TotalSeconds, 1)
        [void]$results.Add([pscustomobject]@{ Suite = $suite.Name; Group = $suite.Group; Status = $status; Seconds = $seconds; ExitCode = $exitCode })
    }
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
$results | Format-Table Suite, Group, Status, Seconds -AutoSize | Out-String | Write-Host

$failed = @($results | Where-Object { $_.Status -ne "PASS" })
if ($failed.Count -gt 0) {
    Write-Host "$($failed.Count) of $($results.Count) suite(s) failed: $(($failed | ForEach-Object { $_.Suite }) -join ', ')" -ForegroundColor Red
    exit 1
}
Write-Host "All $($results.Count) suite(s) passed." -ForegroundColor Green
exit 0
