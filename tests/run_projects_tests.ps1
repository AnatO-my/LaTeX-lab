param(
    [string]$PdfLatex = "pdflatex",
    [string]$Python = "python",
    [string]$OutputDirectory
)
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
if (-not $OutputDirectory) {
    $OutputDirectory = Join-Path $root ("build/tests/projects-" + [guid]::NewGuid().ToString("N"))
}
# Prefer the Windows py launcher (as the other runners do) unless -Python is given;
# a bare `python` may resolve to the Microsoft Store stub, which exits at once.
$pythonArgs = @()
if (-not $PSBoundParameters.ContainsKey("Python") -and (Get-Command py -ErrorAction SilentlyContinue)) {
    $Python = "py"
    $pythonArgs = @("-3")
}
& $Python @pythonArgs (Join-Path $PSScriptRoot "check_projects.py") --root $root --engine $PdfLatex --output $OutputDirectory
if ($LASTEXITCODE -ne 0) { throw "Project package tests failed (exit $LASTEXITCODE)." }

