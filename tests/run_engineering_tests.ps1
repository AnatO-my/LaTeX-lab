param(
    [string]$PdfLatex = "pdflatex",
    [string]$Python = "python",
    [string]$OutputDirectory
)
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot -Parent
if (-not $OutputDirectory) {
    # A fresh output tree prevents stale PDFs from masking a failed build.
    $OutputDirectory = Join-Path $root ("build/tests/engineering-" + [guid]::NewGuid().ToString("N"))
}
& $Python (Join-Path $PSScriptRoot "check_engineering_regression.py") --root $root --engine $PdfLatex --output $OutputDirectory
if ($LASTEXITCODE -ne 0) { throw "Engineering regression suite failed (exit $LASTEXITCODE)." }

