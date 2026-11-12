$ErrorActionPreference = "Stop"

$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$DistDir  = Join-Path $RepoRoot "dist"

New-Item -ItemType Directory -Force -Path $DistDir | Out-Null

$Documents = @(
    @{
        Root = "examples/otengineering/main.tex"
        Name = "otengineering"
    },
    @{
        Root = "examples/physicsquiz/main.tex"
        Name = "physicsquiz"
    },
    @{
        Root = "examples/studentnotes/main.tex"
        Name = "studentnotes"
    },
    @{
        Root = "examples/vector-workbook/main.tex"
        Name = "vector-workbook"
    }
)

$Jobs = @()

foreach ($Document in $Documents) {

    $Jobs += Start-Job `
        -ArgumentList $RepoRoot, $Document.Root, $Document.Name `
        -ScriptBlock {

        param(
            $RepoRoot,
            $RelativeRoot,
            $Name
        )

        $RootFile = Join-Path $RepoRoot $RelativeRoot

        $OutputDirectory = Join-Path `
            $RepoRoot `
            ("build\batch\" + $Name)

        New-Item `
            -ItemType Directory `
            -Force `
            -Path $OutputDirectory |
            Out-Null

        $env:TEXINPUTS = `
            "$RepoRoot\src\classes;$RepoRoot\src\packages;"

        & latexmk `
            -pdf `
            -synctex=1 `
            -interaction=nonstopmode `
            -file-line-error `
            -halt-on-error `
            "-outdir=$OutputDirectory" `
            "$RootFile"

        if ($LASTEXITCODE -ne 0) {
            throw "Compilation failed: $RelativeRoot"
        }

        $RootName = [System.IO.Path]::GetFileNameWithoutExtension(
            $RootFile
        )

        [PSCustomObject]@{
            Name = $Name
            PDF  = Join-Path $OutputDirectory "$RootName.pdf"
        }
    }
}

$Results = $Jobs |
    Wait-Job |
    Receive-Job

$Jobs |
    Remove-Job

foreach ($Result in $Results) {

    $Destination = Join-Path `
        $DistDir `
        ($Result.Name + ".pdf")

    Copy-Item `
        $Result.PDF `
        $Destination `
        -Force

    Write-Host "Created: $Destination"
}

Write-Host ""
Write-Host "All LaTeX documents built successfully."