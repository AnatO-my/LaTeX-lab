param([string]$PdfLatex = 'pdflatex', [string]$Biber = 'biber', [string]$OutputDirectory)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
if (-not $OutputDirectory) { $OutputDirectory = Join-Path $root ('build/tests/eee-report-' + [guid]::NewGuid().ToString('N')) }
New-Item -ItemType Directory -Force $OutputDirectory | Out-Null
Copy-Item -LiteralPath (Join-Path $root 'examples/otengineering/eee_report_references.bib') -Destination $OutputDirectory
$oldInputs = $env:TEXINPUTS
$env:TEXINPUTS = "$root/src/classes;$root/src/packages;$root/examples/otengineering;$oldInputs;"
try {
    foreach ($start in 1,0) {
        $name = "eee-report-$start"
        $source = Join-Path $OutputDirectory "$name.tex"
        $example = Get-Content (Join-Path $root 'examples/otengineering/eee_report_example.tex') -Raw
        $example = $example.Replace('\begin{document}', "\oteeereportsetup{table-start=$start,figure-start=$start,plate-start=$start}`n\begin{document}")
        Set-Content $source $example
        & $PdfLatex -interaction=nonstopmode -halt-on-error -no-shell-escape "-output-directory=$OutputDirectory" $source | Out-Null
        if ($LASTEXITCODE) { throw "Initial compile failed: $name" }
        & $Biber "--input-directory=$OutputDirectory" "--output-directory=$OutputDirectory" $name | Out-Null
        if ($LASTEXITCODE) { throw "Bibliography failed: $name" }
        1..2 | ForEach-Object {
            & $PdfLatex -interaction=nonstopmode -halt-on-error -no-shell-escape "-output-directory=$OutputDirectory" $source | Out-Null
            if ($LASTEXITCODE) { throw "Compile failed: $name" }
        }
        $aux = Get-Content (Join-Path $OutputDirectory "$name.aux") -Raw
        foreach ($label in 'tab:performance','fig:overview','plate:prototype') {
            if (-not $aux.Contains("\newlabel{$label}{{1.$start}")) { throw "Wrong ordinal for $label" }
        }
        $log = Get-Content (Join-Path $OutputDirectory "$name.log") -Raw
        if ($log -match 'There were undefined references|destination with the same identifier') { throw "Unresolved references or duplicate destinations: $name" }
    }
} finally { $env:TEXINPUTS = $oldInputs }
Write-Host 'EEE report numbering, references and bibliography checks passed.'
