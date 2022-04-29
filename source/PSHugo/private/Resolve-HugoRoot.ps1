
Function Resolve-HugoRoot {
    <#
    .SYNOPSIS
        Recursively search up the directory to find the root of the site
    #>
    [CmdletBinding()]
    param(
        # Optionally give another directory to start in
        [Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateScript(
            {
                if (-Not ($_ | Test-Path)) {
                    throw "$_ does not exist"
                }
                return $true
            }
        )]
        [Alias('PSPath')]
        [string]$Path = (Get-Location).ToString(),

        # Optionally limit how many levels to check
        [Parameter(
        )]
        [int]$Depth = 4
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"
        $site_found = $false
    }
    process {
        if ($Path -is [string]) {
            $location = Get-Item $Path
            if ($location -is [System.IO.FileInfo]) {
                $location = $location.Directory
            }

        } elseif ($Path -is [System.IO.DirectoryInfo]) {
            $location = $Path
        } elseif ($Path -is [System.IO.FileInfo]) {
            $location = $Path.Directory
        } else {
            Write-Error "$Path is not a valid location"
        }
        Write-Debug "Starting in $($location.GetType()) $location"
        Write-Verbose "Looking for site root with a maximum depth of $Depth"

        for ($i = 0; $i -lt $Depth; $i++) {
            if (Test-HugoSite $location) {
                Write-Verbose "hugo site found at level $i '$($location.Name)'"
                $site_found = $true
                break
            } else {
                $location = $location.Parent
                Write-Debug "Not found at depth $Depth, looking in $($location.Name)"
            }
        }
        if ( -Not $site_found) {
            throw "Site root not found in $Depth levels"
        }
    }
    end {
        $location
    }
}
