# Manage hugo from PowerShell

## Overview

  Hugo is a great utility and has everything you need to manage your website
  built into the one hugo command.  This module provides some functions to
  integrate hugo into other scripts and automate some of its features.

## Content Management

- [ ] Get-HugoContent - Collect a list of hugo content files matching criteria
  - [ ]  Get a list of files in the content directory, optionally filter by name, frontmatter, etc.
  - [X] Filter by Type
  - [X] Filter index files
  - [ ] Filter by front matter

``` PowerShell
$drafts = Get-HugoContent -Draft
```

- [X] Get-HugoFrontMatter - Get the front matter from file(s)
      More of a "plumbing" command, returns an object of the front matter in a file.
  - [X] YAML format (requires ConvertFrom-Yaml in powershell-yaml)
  - [ ] TOML format (Need to find a good toml parser module (ConvertFrom-Ini)
      doesnt currently read hierarchy)
  - [X] JSON format (Need to find a more reliable way to grab just the json part)
  - [^] ORG format Kindof implemented, it's janky though.(Need an orgmode parser module)
- [x] Get-HugoSection - Get either all of the sections or the section of the supplied content file

- [ ] New-HugoContent - Create hugo content
   While `hugo new type/file-name.ext` works great, this provides convenience
   by converting a string to a file name.

   ``` powershell
   New-HugoContent -Type "post" -Title "A long filename I wanted to write about"
   # creates 'content/post/a-long-filename-i-wanted-to-write-about.md'
   ```

- [ ] Set-HugoContent - Add, change, or remove metadata on content
   Change the draft status, add tags, etc to the front matter of a file

## Site Management

- [ ] Install-HugoTheme - Add a theme to the current site
   given a theme repository url, add it as a submodule, run `npm install` in
   the theme directory, and update the config file to use the new theme.
- [ ] Build-HugoSite - Run hugo in the site specified.  Optionally build drafts, expired, future etc.

## Server Management

- [ ] Invoke-HugoServer - Run the server

## Supporting functions

- [x] Resolve-HugoRoot - find the root directory of a hugo site
   Useful if a command is done outside of a hugo project or in a sub directory
- [x] Test-HugoSite - Test whether *this* folder is a hugo site
   looks for a 'content' directory, a 'layouts' directory, and a config file
   with a 'baseURL line.  It's a bit fragile but there's no one true test
   like some other systems (git has a '.git' directory for example)
