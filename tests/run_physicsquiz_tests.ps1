<#
    physicsquiz test suite.

    One entry point for every physicsquiz regression check. It runs the two
    accepted chains, each of which calls the earlier steps itself:

      * run_physicsquiz_phase4ij_tests.ps1 -> 4g -> 4f -> 4e -> 4d -> 4c -> 3d
        (output modes, structured bank, selection, random selection,
        migration pilot, full migration, option shuffling, version manifest)
      * run_phase6f_tests.ps1 -> 6e -> 6d -> 6c -> 6b -> 6a
        (modern interface examples, capability markers, decimal marks,
        author messages, versioned paper)

    The per-phase scripts remain as the internal steps of this suite; run
    them directly only when iterating on one phase.

        powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_tests.ps1
#>
param()

$ErrorActionPreference = "Stop"

$steps = @(
    "run_physicsquiz_phase4ij_tests.ps1",
    "run_phase6f_tests.ps1"
)

foreach ($step in $steps) {
    $path = Join-Path $PSScriptRoot $step
    if (-not (Test-Path -LiteralPath $path)) {
        throw "physicsquiz suite step is missing: $path"
    }
    Write-Host "physicsquiz suite: $step" -ForegroundColor Cyan
    & $path
    if ($LASTEXITCODE -ne 0) {
        throw "physicsquiz suite step failed: $step"
    }
}

$global:LASTEXITCODE = 0
Write-Host "All physicsquiz tests passed." -ForegroundColor Green
