param(
    [string]$PdfLatex = "pdflatex",
    [string]$Python = "python",
    [string]$OutputDirectory
)
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
if (-not $OutputDirectory) {
    # A fresh output tree prevents stale PDFs from masking a failed build.
    $OutputDirectory = Join-Path $root ("build/tests/forms-" + [guid]::NewGuid().ToString("N"))
}
# Prefer the Windows py launcher (as the other runners do) unless -Python is given;
# a bare `python` may resolve to the Microsoft Store stub, which exits at once.
$pythonArgs = @()
if (-not $PSBoundParameters.ContainsKey("Python") -and (Get-Command py -ErrorAction SilentlyContinue)) {
    $Python = "py"
    $pythonArgs = @("-3")
}
& $Python @pythonArgs (Join-Path $PSScriptRoot "check_engineering_regression.py") --root $root --engine $PdfLatex --output $OutputDirectory --forms-only
if ($LASTEXITCODE -ne 0) { throw "Forms regression suite failed (exit $LASTEXITCODE)." }

