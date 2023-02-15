# PowerShell

## Description

PowerShell is fundamentally a SHELL language, for interacting with OS, thought it has the power of a programming language.

## Visual Studio Code

- `ctrl-<backtick>` Open / close console
- `ctrl-'` Maximize panel
- `ctrl-,` Open settings
- `ctrl-p` Open file
- `ctrl-shift-p` Command palette

## Versions

- Version 5: Default with Windows 10, blue background, launch with `powershell.exe`
- Version 7: New cross platform version, black background, launch with `pwsh.exe`
- `$PSVersionTable` Show version

## Glossary

- Command - a generic term for the below
   - cmdlet - a PowerShell command written in .NET, a term unique to MicroSoft
   - function - a command written in PowerShell
   - 3rd party app (ie. bash, awk, wc, etc)

## Help

Find commands
- `Get-Help csv`
- `help csv` # Alias for above
- `help about` # Foundational topics
- `help about*array*` # Learn about arrays
- `help about_commonparameters` # A good one to start with
- `Get-Alias` Show all aliases
- `Get-Command -noun csv` # Use Get-Command for specific filtering.
- `Get-Command -verb invoke`

Get command help
- `Get-Help Import-Csv` # Man page
- `Get-Help Import-Csv -Examples`  # Examples
- `Get-Help Import-Csv -Online`  # Opens a browser
- `Get-Help Get-Item -Parameter path` # Parameter help
- `Get-Alias -Definition Get-Item` # Show alias


## Running Commands

- Commands are always VERB-NOUN # There's a few oddballs like New
- `Get-Verb` # Try to use standard verbs like New, Remove, Get, & Set
- Get-Process -Name p* #
- `Get-Alias [[-Name] <System.String[]>]`# Double [[]] in the signature indicates a required positional command

## Comments

```pwsh
# My Comment

<# My 
   Multiline
   Comment
#>
```

## Array / Collection

```pwsh
$xs = 0..2
$xs = 0, 1, 2
$xs = @(0, 1, 2)
$xs[0]
$xs.Count

```

## Hash / Object

```pwsh
$count = @{ a = 3; e = 2; i = 4; o = 4; u = 2 }
$count.a 
$count["a"] 
```

## Functional Translation

- Basics
   - Select-Object = MAP
       - `1, 2, 3 | Select-Object { $_ % 2 -eq 0 }` # False, True, False
   - Where-Object = FILTER
       - `1, 2, 3 | Where-Object { $_ % 2 -eq 0 }` # 2
   - NO NATIVE REDUCE
   - Sort-Object = SORT
       - `22, 33, 11 | Sort-Object -Descending` # 33, 22, 11


## PSProvider

An adapter which makes different data stores look like a disk drive.

- `Get-PSProvider` # Shows a list of data stores

## PSDrive

A temporary and persistent mapped network drive (over a PSProvider).

- `Get-PSDrive` # Shows a list of mapped "drives".
- `New-PSDrive -Name "MyApp" -PSProvider "FileSystem" -Root "C:\Users\kjackson\MyApp\"`

## Common Shell Commands
- `Get-Process`
- `Get-Service`
- `Stop-Process -Name Excel`
- `Get-Content myfile.txt` # Same as cat
- `@{ "a" = "apple" } | ConvertTo-Html` # HTML converter for table like objects
- `Compare-Object  -ReferenceObject (Get-Content .\atemp.txt) -DifferenceObject (Get-Content .\btemp.txt)` # Diff, weak with text files, can't recognize edits
- `Get-ChildItem | Out-File results.txt` # Same as `ls > results.txt`, note `>` also works!
- `dir | Out-GridView` # Creates a neat little Excel like view.
- `Dir | ConvertTo-Csv` # Convert is for a temporary stream
- `Dir | Export-Csv temp.csv` # Export is for files
- `Remove-Item -WhatIf *temp*` # Use WhatIf flag to preview changes.
- `Remove-Item -Confirm *temp*` # Use Confirm flag to interactively approve updates.

## Modules

- Modules: modern system for sharing code, path based
   - PowerShellGet is a package (module) manager.
   - <https://www.powershellgallery.com/> # Microsoft hosted PowerShell code sharing site.
   - `PSModulePath` environment variable like is like a Unix path
   - `(Get-Content Env:/PSModulePath) -split ':'` See paths
   - `Install-Module -Name PSCalendar` 
   - `Get-Command -Module PSCalendar`
- Snapins: PSSnappin, deprecated system as of version 6.

