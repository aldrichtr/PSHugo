
Function Get-HugoFrontMatter {
    <#
    .SYNOPSIS
        Return a hashtable of the front matter in the file specified
    #>
    [CmdletBinding()]
    param(
        # Path to the file to read
        [Parameter(
            Mandatory = $true,
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
        [string]
        $Path,

        # Format of front matter.  One of 'toml', 'yaml', 'json', 'org'
        [Parameter(
            Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateSet('toml', 'yaml', 'json', 'org')]
        [string]
        $Format = 'yaml'
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"
        $yaml_content = '(?sm)---(.*?)---'
        $toml_content = '(?sm)+++(.*?)+++'

        $org_key = '^#\+(\w+):\s+(.+)$'
        $org_key_list = '^#\+(\w+)\[\]:\s+(.*)'
    }
    process {
        $file_contents = Get-Content $Path -Raw
        Write-Verbose "Parsing $Format from $Path"
        switch ($Format) {
            'yaml' {
                $null = $file_contents -match $yaml_content
                if ($Matches.Count -gt 0) {
                    Write-Verbose "yaml front matter $($Matches.1)"
                    $front_matter = $Matches.1 | ConvertFrom-Yaml
                    $Matches.clear()
                }
            }
            'toml' {
                $null = $file_contents -match $toml_content
                if ($Matches.Count -gt 0) {
                    Write-Verbose "toml front matter $($Matches.1)"
                    $front_matter = $Matches.1 | ConvertFrom-Ini
                    $Matches.clear()
                }
            }
            'org' {
                $front_matter = @{}
                foreach ($line in ($file_contents -split '\n')) {
                    Write-Verbose "Checking $line"
                    $null = $line -match $org_key
                    if ($Matches.Count -gt 0) {
                        Write-Verbose "matched org key $Matches"
                        $front_matter[$Matches.1] = $Matches.2
                        $Matches.Clear()
                    }

                    $null = $line -match $org_key_list
                    if ($Matches.Count -gt 0) {
                        Write-Verbose "matched org key list"
                        $front_matter[$Matches.1] = ($Matches.2 -split " ")
                        $Matches.Clear()
                    }

                }
            }
        }

        $front_matter['PSTypeName'] = 'Hugo.Content.FrontMatter'
    }
    end {
        ([PSCustomObject]$front_matter)
    }
}
