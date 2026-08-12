$ErrorActionPreference = "Stop"

function Invoke-LogSelectString {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string[]]$Pattern,

        [switch]$SimpleMatch,
        [switch]$Quiet,
        [int]$Attempts = 20,
        [int]$DelayMilliseconds = 250
    )

    for ($attempt = 1; $attempt -le $Attempts; $attempt++) {
        try {
            $parameters = @{
                Path    = $Path
                Pattern = $Pattern
            }
            if ($SimpleMatch) {
                $parameters.SimpleMatch = $true
            }
            if ($Quiet) {
                $parameters.Quiet = $true
            }
            return Select-String @parameters
        }
        catch [System.IO.IOException], [System.UnauthorizedAccessException] {
            if ($attempt -eq $Attempts) {
                throw
            }
            Start-Sleep -Milliseconds $DelayMilliseconds
        }
    }
}
