
Function Test-HugoSite {
    <#
    .SYNOPSIS
        Test for a hugo site in the given directory
    .DESCRIPTION
        To validate that the directory is a hugo site, validate that:
        - there is a 'content' directory
        - there is a 'layouts' directory
        - there is a 'config.[toml|json|yaml]' file -or- 'config/_default/config.[toml|json|yaml]'
        - the config file has a line that contains 'baseURL'
    #>
    [CmdletBinding()]
    param(    # Optionally give another directory to start in
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
        [string]$Path = (Get-Location).ToString()
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"
        $directory_list = @('archetypes', 'content', 'layouts')
        $isHugo = $false
    }
    process {
        #region Path
        if ($Path -is [string]) {
            $location = Get-Item $Path
            if ($location -is [System.IO.FileInfo]) {
                $location = $location.Directory
            }
        }
        elseif ($Path -is [System.IO.DirectoryInfo]) {
            $location = $Path
        }
        elseif ($Path -is [System.IO.FileInfo]) {
            $location = $Path.Directory
        }
        Write-Debug "  Path $Path is $($Path.GetType())"
        Write-Debug "  Looking in $($location.GetType()) $($location.FullName) for hugo site information"

        #endregion Path
        #region Directories
        foreach ($dir in $directory_list) {
            if (Test-Path (Join-Path $location "$dir")) {
                Write-Verbose "$dir found"
                $isHugo = $true
            } else {
                Write-Debug "  Not a Hugo site, couldn't find a '$dir' directory"
                $isHugo = $false
            }
        }
        #endregion Directories

        #region Config files
        $config_options = @{
            Path    = @( $location, (Join-Path $location "config\_default"))
            Include = @("config.toml", "config.yaml", "config.json")
            File    = $true
            Depth   = 0
            ErrorAction = 'SilentlyContinue'
        }
        $config_files = Get-ChildItem @config_options


        if ($config_files.Count -gt 0) {
            if ( Select-String $config_files[0] -Pattern "baseURL" ) {
                Write-Verbose "BaseURL found in $($config_files[0].BaseName)"
                $isHugo = $true
            } else {
                Write-Debug "  Not a Hugo site, baseURL not found in $($config_files[0].BaseName)"
                $isHugo = $false
            }
        } else {
            Write-Debug "  Not a Hugo site, couldn't find a config file"
            $isHugo = $false
        }
        #endregion Config files
    }
    end {
        Write-Debug "End $($MyInvocation.MyCommand.Name)"
        return $isHugo
    }
}
