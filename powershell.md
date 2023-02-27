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
- `Get-Process | Get-Member -Type Properties` Shows type and information often used at the end of a pipe to show properties and methods.

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

## Comparisons

### Basics

- Uses Bash style comparitors: `-eq -ne -lt -le -gt -ge` 
- Logical operators: `-not -and -or` # Don't use the normal ones...
- There's also CASE SENSITIVE versions for strings `-ceq -cne -clt -cle -cgt -cge`. The regular versions are case insensitve.
- Wildcard comparitors: `-like -notlike` 
- Regex comparitors: `-match -notmatch`

### Basic Examples

- `$True` # True
- `$False` # False
- `(3 -gt 2) -and (2 -gt 1)` Use brackets for logical clarity.
- `"Hello1" -like "H[aeiou]llo?"` # `-like` takes the wildcards `*?[]`
- `"Hello" -match "^H.*o$"` # Match is feature rich regex engine.

### Practical Examples

- `gci | where { $_.LastWriteTime -gt (Get-Date).AddDays(-7) }` # Files written in the last week.
- `gci | where { $_.Length -gt 1MB }`  # Get files larger than 1MB
- `Get-Process -Name p*,*s*` # You could use `Where-Object` but you should FILTER AS FAR LEFT as possible.
- `Get-Process | Where-Object -FilterScript {$_.WorkingSet -gt 100MB}` # Long version
- `gps | where {$_.WorkingSet -gt 100MB}` # Shorthand version
- `gps | where WorkingSet -gt 100MB` # Super short braceless version (weird, but you may see it)

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

## Loops

Imperative Style
```pwsh
$nums = 1..3
foreach ($n in $nums) {
   Write-Host $n
}
```

Pipe Style
```pwsh
1..3 | ForEach-Object { Write-Host $_ } # Long Form
1..3 | % { Write-Host $_ } # Short Form
```

Parallel
- `Measure-Command { 1..5 | ForEach-Object -Parallel { Write-Host $_; Start-Sleep 2 } }` # 2 seconds
- `Measure-Command { 1..10 | ForEach-Object -Parallel { Write-Host $_; Start-Sleep 2 } }`# 4 Seconds, there's a default throttle limit of 5; see next command
- `Measure-Command { 1..10 | ForEach-Object -ThrottleLimit 10 -Parallel { Write-Host $_; Start-Sleep 2 } 2 seconds
- Note - memory and namespace NOT SHARED in parallel.

For
```pwsh
for ($i = 0; $i -lt 3; $i++) {
    Write-Host $i
}
```

While
```pwsh
$i = 0
while ($i -lt 3) {
    Write-Host $i
    $i++
}

# Practical Example
while ((Get-Process).Name -contains "notepad") { 
   Write-Host "Notepad is open..."; Start-Sleep 2 
}
```

Do
```pwsh
do {
    Write-Host "Looping..."
    $input = Read-Host "Finished? (Y to quit)"
} while ($input -ne "Y")
```

Tips
- Many commands take collections, so unnecessarily use `Foreach-Object`
   - Ex) Good: `gps word* | stop-process`, Bad: `gps word* | Foreach-Object { Stop-Process $_ }`


## Functional Translation

- Basics
   - Select-Object = MAP
       - `1, 2, 3 | Select-Object { $_ % 2 -eq 0 }` # False, True, False
   - Where-Object = FILTER
       - `1, 2, 3 | Where-Object { $_ % 2 -eq 0 }` # 2
   - NO NATIVE REDUCE
      - `gci | Measure-Object -Property length -Minimum -Maximum -Sum -Average -StandardDeviation`
      - `gci | Measure-Object -Property length -AllStats` # Same as above
   - Sort-Object = SORT
       - `22, 33, 11 | Sort-Object -Descending` # 33, 22, 11

- Adding a key
```pwsh
# Long version - use the hash keys "name" and "expression" to add to an object.
 @{ id = 123; name = "Bob" } | Select-Object -Property *, @{ name = "dept"; expression = { "IT" } }
 
 # Short version - use hash keys "n" and "e"
  @{ id = 123; name = "Bob" } | Select-Object -Property *, @{ n = "dept"; e = { "IT" } }
```

## Pipeline

- Parameter Binding
   1. ByValue - TYPE of 1st command -> TYPE of 2nd command
       - receiving command will match multiples, so typically signatures are designed with only one of each type
   3. ByName - PARAMETER NAME, WILL MATCH ALL NAMES

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
   - `Find-Module *yaml*` # Very important. This searches the ONLINE GALLERY at <https://www.powershellgallery.com/>
- Snapins: PSSnappin, deprecated system as of version 6.

## Casting

```pwsh
[int] 7 / 3 # 2
[uri] "https://example.com" # -> System.Uri
```

## UI

- `Get-Process | Format-Table -Property ID, Name, Responding` # Select properties to view
- `gps | ft  ID, Name, Responding` # Select properties to view # Same as above - short version
- `@{ a = 11; b = 22; c = 33 } | Format-List` # Show all properties on a new line
- `@{ a = 11; b = 22; c = 33 } | fl` # Same as above - short version
- `Get-Process | Format-Wide -Property Name -Column 8` # Table-ize a single field (with columns)
- `gps | fw -col 8` # Same as above - short version
- `Get-Process | Out-Gridview` # Windows GUI
- `gps | ogv` # Same as above, short version

## Remoting

- `Enter-PSSession -ComputerName server1` # Enter a live session using Windows protocols
- `Enter-PSSession -HostName server1` # Enter a live session using SSH (multiplatform)
- `Exit-PSSession` # Exit live session
- `Invoke-Command -ComputerName server1 -ScriptBlock { Get-Process }` # Open AND CLOSE a remote session.

## Jobs

- Basics 
   - Job = Process
   - Thread-Job =  Process
   - `-AsJob` is used with `Invoke-Command`
- `Start-Job -ScriptBlock { gps }` # Start job
- `Start-Job -Command { gps }` # Same as above
- `Receive-Job -Id 12` # Get results, results not cached
- `Receive-Job -Id 12 -Keep` # Get results, results cached
- `Start-ThreadJob -ScriptBlock { gci }` # Run job as a thread
- `Get-Job | Where-Object { -not $_.HasMoreData } | Remove-Job` # Remove old jobs
-  `Invoke-Command -HostName server1 -ScriptBlock { gps } -AsJob` # AS JOB - Save results to a job.

