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

## Array

```pwsh
$xs = 0..2
$xs = 0, 1, 2
$xs = @(0, 1, 2)
$xs[0]
$xs.Count

```

## Hash

```pwsh
$count = @{ a = 3; e = 2; i = 4; o = 4; u = 2 }
$count.a 
$count["a"] 
```
