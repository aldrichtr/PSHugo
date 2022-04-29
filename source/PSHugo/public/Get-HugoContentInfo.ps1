
function Get-HugoContentInfo {
    <#
    .SYNOPSIS
        Get information about the given Hugo Content file
    #>
    [CmdletBinding()]
    param(
        # The path to the file
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [Alias('PSPath')]
        [string]$Path
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"
    }
    process {
        try {
            if ($Path -is [string]) {
                $file = Get-Item $Path
            } elseif ($Path -is [System.IO.FileInfo]) {
                $file = $Path
            }
        } catch {
            Write-Error "Could not resolve path '$Path'`n$_"
        }
        $hugo_root = Resolve-HugoRoot $file
        $content_root = Join-Path $hugo_root 'content' -Resolve

        $fm = Get-HugoFrontMatter $file
        $info = [PSCustomObject]@{
            PSTypeName = 'Hugo.Content.FileInfo'
            section = (Get-HugoSection $file)
        }

        $fm | Get-Member -MemberType NoteProperty | Foreach-Object {
            $n = $_.Name
            $info | Add-Member -NotePropertyName $n -NotePropertyValue $fm.$n
        }

        $info | Add-Member -NotePropertyName 'path' -NotePropertyValue $file.FullName
        $info | Add-Member -NotePropertyName 'file' -NotePropertyValue $file.Name
        if ($null -eq $info.slug) {
            $info | Add-Member -NotePropertyName 'slug' -NotePropertyValue $file.BaseName
        }
    }
    end {
        $info
    }

}
