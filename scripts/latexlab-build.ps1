param(
    [Parameter(Mandatory = $true)]
    [string]$Root,

    [Parameter(Mandatory = $true)]
    [string]$BuildDir,

    [Parameter(Mandatory = $true)]
    [string]$OutputDir
)

$ErrorActionPreference = "Stop"

# ------------------------------------------------------------
# Resolve LaTeX-Lab root
# ------------------------------------------------------------

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

$ClassesDir  = Join-Path $RepoRoot "src\classes"
$PackagesDir = Join-Path $RepoRoot "src\packages"

# ------------------------------------------------------------
# Ensure destinations exist
# ------------------------------------------------------------

New-Item `
    -ItemType Directory `
    -Force `
    -Path $BuildDir |
    Out-Null

New-Item `
    -ItemType Directory `
    -Force `
    -Path $OutputDir |
    Out-Null

# ------------------------------------------------------------
# Make LaTeX-Lab classes/packages discoverable
# ------------------------------------------------------------

$LaTeXLabInputs = "$ClassesDir;$PackagesDir"

if ([string]::IsNullOrWhiteSpace($env:TEXINPUTS)) {
    # Trailing semicolon preserves MiKTeX's normal search path.
    $env:TEXINPUTS = "$LaTeXLabInputs;"
}
else {
    $env:TEXINPUTS = "$LaTeXLabInputs;$env:TEXINPUTS"
}

# ------------------------------------------------------------
# Compile
# ------------------------------------------------------------

Write-Host ""
Write-Host "LaTeX-Lab build"
Write-Host "Root:   $Root"
Write-Host "Build:  $BuildDir"
Write-Host "Output: $OutputDir"
Write-Host ""

& latexmk `
    -cd `
    -pdf `
    -synctex=1 `
    -interaction=nonstopmode `
    -file-line-error `
    -halt-on-error `
    "-outdir=$BuildDir" `
    "-out2dir=$OutputDir" `
    "$Root"

if ($LASTEXITCODE -ne 0) {
    Write-Error "LaTeX build failed: $Root"
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "Build successful."