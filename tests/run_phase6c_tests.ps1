param()

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $PSScriptRoot
$checker = "tests\check_physicsquiz_namespace.py"

function Get-Phase6PythonRunner {
    $candidates = @()

    $py = Get-Command py -ErrorAction SilentlyContinue
    if ($py) {
        $candidates += [pscustomobject]@{
            Command = $py.Source
            Args = @("-3")
        }
    }

    $python = Get-Command python -ErrorAction SilentlyContinue
    if ($python) {
        $candidates += [pscustomobject]@{
            Command = $python.Source
            Args = @()
        }
    }

    $localPython = Join-Path $env:LOCALAPPDATA "Programs\Python\Python313\python.exe"
    if (Test-Path $localPython) {
        $candidates += [pscustomobject]@{
            Command = $localPython
            Args = @()
        }
    }

    foreach ($candidate in $candidates) {
        try {
            $probeArgs = @($candidate.Args) + @("--version")
            $null = & $candidate.Command @probeArgs 2>&1
            if ($LASTEXITCODE -eq 0) {
                return $candidate
            }
        }
        catch {
            continue
        }
    }

    throw "Python was not found. Install Python or make py -3 / python available on PATH."
}

Push-Location $root
try {
    $phase6bRunner = "tests\run_phase6b_tests.ps1"
    if (-not (Test-Path $phase6bRunner)) {
        throw "The Phase 6B runner is missing: $phase6bRunner"
    }

    Write-Host "Running the Phase 6B capability checkpoint..." -ForegroundColor Cyan
    try {
        & $phase6bRunner
    }
    catch {
        throw "The Phase 6B checkpoint failed: $($_.Exception.Message)"
    }

    if (-not (Test-Path $checker)) {
        throw "Required Phase 6C namespace checker is missing: $checker"
    }

    Write-Host "Checking the Phase 6C physicsquiz namespace boundary..." -ForegroundColor Cyan
    $python = Get-Phase6PythonRunner
    $pythonArgs = @($python.Args) + @($checker)
    $output = & $python.Command @pythonArgs 2>&1
    $exitCode = $LASTEXITCODE
    $output | ForEach-Object { Write-Host $_ }

    if ($exitCode -ne 0) {
        throw "The Phase 6C namespace checker failed."
    }

    foreach ($marker in @(
            "PQ6C-NAMESPACE:EXPL3-BOUNDS=OK",
            "PQ6C-NAMESPACE:INTERNALS=OK",
            "PQ6C-NAMESPACE:PUBLIC-WRAPPERS=OK",
            "PQ6C-NAMESPACE:KEYS=OK",
            "PQ6C-NAMESPACE:LEGACY-BRIDGE=OK",
            "PQ6C-NAMESPACE:CAPABILITY-MARKERS=OK"
        )) {
        if ($output -notcontains $marker) {
            throw "Missing Phase 6C marker: $marker"
        }
    }

    Write-Host "All Phase 6C tests passed." -ForegroundColor Green
}
finally {
    Pop-Location
}
