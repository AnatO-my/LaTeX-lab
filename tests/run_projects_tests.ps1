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
& $Python (Join-Path $PSScriptRoot "check_projects.py") --root $root --engine $PdfLatex --output $OutputDirectory
if ($LASTEXITCODE -ne 0) { throw "Project package tests failed (exit $LASTEXITCODE)." }

