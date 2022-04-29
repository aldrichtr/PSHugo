
Function Get-HugoContent {
    <#
    .SYNOPSIS
        Get a list of hugo content files.
    .DESCRIPTION
        Get hugo content files from the current hugo site.  First, the function
        will look for the root of the site (either at the current directory, or
        starting at the provided 'Path').  Next, the function will gather all
        the files in the content directory based on:
        - the Format (markdown by default)
        - the Section (all content by default, or Section can be one or more hugo
        content Sections)
        - Index pages (an exclusion filter.  If set will only return index
        pages)
    .EXAMPLE
        PS C:\hugo-website> $pages = Get-HugoContent
    .EXAMPLE
        PS C:\hugo-website> $indexes = Get-HugoContent -Index
    .EXAMPLE
        PS C:\hugo-website> $about_index = Get-HugoContent -Section 'about' -Index
    #>
    [CmdletBinding()]
    param(
        # Optionally give a path (current directory by default)
        [Parameter(
            ValueFromPipeline = $true
        )]
        [Alias('PSPath')]
        [string]$Path = (Get-Location).ToString(),

        # Format of content files
        [Parameter(
        )]
        [ValidateSet(
            'markdown',
            'org',
            'html',
            'asciidoc',
            'pandoc'
        )]
        [string[]]$Format = @('markdown'),

        # The content Section
        [Parameter(
        )]
        [string[]]$Section,

        # If set, will only return the index files
        # combine with Section to get the index file for a specific Section
        [Parameter(
        )]
        [switch]$Index
    )
    begin {
        Write-Debug "Begin $($MyInvocation.MyCommand.Name)"
        $extention_map = @{
            'markdown' = @('*.md')
            'org'      = @('*.org')
            'html'     = @('*.htm', '*.html')
            'asciidoc' = @('*.ad', '*.adoc')
            'pandoc'   = @('*.pdc', '*.pandoc')
        }
    }
    process {
        try {
            $site_root = Resolve-HugoRoot $Path
        } catch {
            throw "$Path is not a hugo project"
        }

        $find_options = @{
            Recurse = $true
            Path    = "$site_root\content"
            Include = @()
        }

        if ($PSBoundParameters['Section']) {
            $find_options.Path = @() # reset and change to array
            foreach ($s in $Section) {
                $find_options.Path += "$site_root\content\$s"
            }
        }

        foreach ($f in $Format) {
            $find_options.Include += $extention_map[$f]
        }

        if ($Index) {
            $find_options.Include += "*index*"
        }
        Write-Verbose "Getting hugo content from $($find_options.Path -join '; ')"
        Write-Verbose " filtered by $($find_options.Include -join '; ')"
    }
    end {
        Get-ChildItem @find_options | Foreach-Object { $_ | Get-HugoContentInfo }
    }
}
