
function Get-HugoSection {
    <#
    .SYNOPSIS
        Deterimine the section of the given content by it's relation to the 'content' directory
    #>
    [CmdletBinding()]
    param(
        # The path to the file
        [Parameter(
            ValueFromPipeline
        )]
        [Alias('PSPath')]
        [string]$Path
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"
    }
    process {
        if ($PSBoundParameters['Path']) {
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
            Write-Debug "Content root: $content_root"
            $rel_path = $file.FullName -replace [regex]::Escape($content_root) , ''
            Write-Debug "relative path is $rel_path"
            # the rel_path has the first directory separator still on it, so when we split it
            # into parts, the first one is blank
            # /path/to/file = @( '', 'path', 'to', 'file')
            # so we want to take the next one, at index 1
            $section = ($rel_path -split [regex]::Escape([IO.Path]::DirectorySeparatorChar))[1]
        } else {
            $hugo_root = Resolve-HugoRoot
            $content_root = Join-Path $hugo_root 'content' -Resolve
            Write-Debug "Content root: $content_root"
            $section = Get-ChildItem -Path $content_root -Directory | Select-Object 'Name' -ExpandProperty 'Name'
        }
    }
    end {
        $section
    }
}
