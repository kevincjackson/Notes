# PowerShell

## Description

PowerShell is fundamentally a SHELL language, for interacting with OS, though it has the power of a programming language.

## Paradigm

Everything is an object.

## Visual Studio Code

- `ctrl-p` Fuzzy open a file (doesn't work when using Vim and on code screen)
- `ctrl-o` Open a file
- `ctrl-shift-p` Command palette
- `ctrl-backtack`: Show / hide terminal, focus on terminal
- `ctrl-1`: Focus on code
- `F8` Run selection or current line (Mnemonic F8 means a taste is great)
- `F5` Run script, includes debugging (Mnemonic F5 means the whole script is alive)
- `ctrl-space`: Show snippets, suggestions
- `ctrl-,` Open settings
- `ctrl-/` Comment code

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
- `Get-Member -InputObject @() # Get collection methods` By default PowerShell gets the collection member's members.

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


## Variables

- `$useremail = john@example.com` # Variables indicated by $. Use meaningful succinct names. (Not too short, not too long.)
   - Legal starting characters are letters, numbers, and underscore `[A-Za-z_]`
   - `$` and `${}` are accessors.
- `$StrUsrEml = john@example.com` # BAD STYLE. Short cryptic variable names, and indicating types allowed, but DISCOURAGED
- `${user email}` # BAD STYLE. Spaces are allowed with braces, but DISCOURAGED
- `[double] $d = 42.0` # Declare types inside brackets.
- `[int] $x = Read-Host "Enter a number"` # Common types are `[int] [single] [double] [string]`

Escape character is BACKTICK, NOT `\`
```pwsh
$haiku = "I write, erase, rewrite`nErase again, and then`nA poppy blooms."
```

## Numbers

```pwsh
1 # Int32
1.0 # Double
[Math]::Pow(2, 8) # Powers, Gotcha 2**8 Errors!
3 /2 # 1.5
[int](1.4) # 1 Rounding is the default behavior!
[int](1.6) # 2
[int](3 / 2) # 2 
[int][Math]::Ceiling(3 / 2) # 2 Explicitly call class functions for floor and ceiling
[int][Math]::Floor(3 / 2) # 1
1e3 # 1000 Shorthand for lots of zeroes
```

## Strings

- "hello" | Get-Member # Show string methods and properties.
- `$letter = "a"; $letter.ToUpper(); $letter` # => `a`  Methods produce new strings; they don't replace the current content.
- `$letter = "a"; $letter = $letter.ToUpper()` # To replace, use assignment to the same variable.
- `"The first process is $( (gps).name[0] )"`  # Use the sub-expression operator `$()` to run shell commands INSIDE THE DOUBLE QUOTES.
- `$month, $day, $year = "1-1-2000" -split "-"` # `-split` is a TOP LEVEL ARRAY COMMAND (string is an array)
- `$date = 1,1,2000 -join "-" # `-join` is a TOP LEVEL ARRAY COMMAND (string is an array)
- `Get-ChildItem . | Where-Object { $_.Name -match "^\." }` # Show all files in the current directory start with a . (hidden files).
- `Get-ChildItem -Recurse . | Select-String -Pattern "400"` # Select-String is GREP. Highlight all the lines INSIDE THE FILES that regex match 400.

## Array / Collection

```pwsh
Get-Member -InputObject @() # Get Array methods
$xs = 0..2
$xs = 0, 1, 2
$xs = @(0, 1, 2)
$xs[0]
$xs.Count
$xs.Count -eq 0 # Check for empty list
[array]::Reverse($xs) # Reverse an array (no native command, have to use class method)
(gps).Name # PowerShell will try to UNROLL collection PROPERTY collections and METHODS for you.
(gps *word*).kill()  # PowerShell will try to UNROLL collection PROPERTY collections and METHODS for you.
```

Count vs Length

- Count is more commonly used.
- Count is an alias for length.

## ArrayList (unusual)

```pwsh
# Create
$al = [System.Collections.ArrayList] @(11, 22, 33)         # Cast
$al = [System.Collections.ArrayList]::new(@(11, 22, 33))   # Class method

# Add / remove one item
$al.Add(11) # 3 Returns index. 11, 22, 33, 11
$al.Remove(11) # Quiet return. 22, 33, 11

# Add / remove multiple
$al.AddRange(@(44,55)) # 22, 33, 11, 44, 55
$a1.RemoveRange(0, 2) # Removes by index, this remove two items # 11, 44, 55

$a1.Clear() #  @()
```

## Hash / Object

```pwsh
$count = @{ a = 3; e = 2; i = 4; o = 4; u = 2 }
$count.a 
$count["a"] 
```

No semicolons needed on multiple line definition
```pwsh
$colors = @{
   red = 0
   yellow = 1
   green = 2
}
```

Gotcha: `char`s can't access HashTables! They have to be cast to strings.
```pwsh
 $point = @{
   x = 11
   y = 22
}

foreach ($key in "xy".ToCharArray()) {
    $point[$key]
}
# Nothing displayed, actual value is  @($null, $null)


foreach ($key in "xy".ToCharArray()) {
    $point[$key.ToString()]
}
# 11, 22
```

## Top Level Operators

- These are mainly syntatic sugar, also available as methods.

```pwsh
10 / 3 -as [int] # 3 Cast
10 / 3 -is [int] # False - Test Type
9 / 3 -is [int] # True - Test Type

"2-12-2000" -replace "^2", "02" # REGEX replace

"11,22,33" -split "," # String -> Array
@(11,22,33) -join "," # Array -> String

11, 22, 33 -contains 11 # Collection membership: Array, Element -> Bool
11 -in 11, 22, 33 # Collection membership: Element, Array -> Bool
```

String Formating
```pwsh
# Templating
"On the {0} day of Christmas..." -f "first" # "On the first day of Christmas..."

# Zero padding
"{0:000000000}" -f 123 # "000000123"

# Space Padding
"{0,3}{1,-3}" -f "a", "b" # "  ab  "

# Number formatting
"{0:N}" -f 1 # "1.00"

See [this](https://learn.microsoft.com/en-us/dotnet/standard/base-types/composite-formatting#format-item-syntax) for formatting
```

## Booleans & $null

Because self enumeration, comparitors have some surprising behavior. Comparitors turn into a where clause!

```ps1
@(10, 20, 30) -gt 10 # => Returns @(20, 30)!
@(10, $null, 30) -ne $null # => Returns @(10, 30)!
```

Because of this, comparisons with `$null` are reversed. `$null` goes on the left side.

```ps1
# Good
$null -eq @() # False

# Bad
@() -eq $null # Returns $null!
```

## Loops

Imperative - foreach-in
```pwsh
$nums = 1..3
foreach ($n in $nums) {
   Write-Host $n
}
```

Imperative for
```pwsh
for ($i = 0; $i -lt 3; $i++) {
    Write-Host $i
}
```

Functional - ForEach-Object / %
```pwsh
1..3 | ForEach-Object { Write-Host $_ } # Long Form
1..3 | % { Write-Host $_ } # Short Form
```

Parallel
- `Measure-Command { 1..5 | ForEach-Object -Parallel { Write-Host $_; Start-Sleep 2 } }` # 2 seconds
- `Measure-Command { 1..10 | ForEach-Object -Parallel { Write-Host $_; Start-Sleep 2 } }`# 4 Seconds, there's a default throttle limit of 5; see next command
- `Measure-Command { 1..10 | ForEach-Object -ThrottleLimit 10 -Parallel { Write-Host $_; Start-Sleep 2 } 2 seconds
- Note - memory and namespace NOT SHARED in parallel.

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
- For common tasks, look for helpful METHODS.
   - Ex) `gps word* | stop-process` can be further shorted with  `gps word* -kill`

## Switches

- A modern, fully featured tool (not just a simple C implementation)
- Switches fall through; matches don't break!
- Automatic variable: `$_`


```pwsh
$color = 1

switch ($color) {
   1 { "green" }
   2 { "yellow" }
   3 { "red" }
   default { "unknown code" }
} 
```

Arrays get automatically enumerated

```
$colors += switch (1, 1, 2) {
   1 { "green" }
   2 { "yellow" }
   3 { "red" }
   default { "unknown code" }
}

$colors # "green", "green", "yellow"
```

Can take script blocks for matches. Notice the fall through.

```pwsh
switch (12) {
   { $_ % 3 -eq 0 } { 3 }
   { $_ % 4 -eq 0 } { 4 }
   { $_ % 5 -eq 0 } { 5 }
}

# 3, 4
```

## Functions 

Here's simple function to sum an array of numbers.
```pwsh
function Get-Sum {
   param ($Numbers)
   $sum = 0
   foreach ($num in $Numbers) {
      $sum += $num
   }
   $sum
}
```

## Scriptblocks / Lambdas

- First class: can be arguments, and send & receive arguments
- Note: functions are NOT first class!
- Are anonymous functions
- Help: `help about_Script_Blocks`

Creating
```pwsh
$add = { $args[0] + $args[1] }  # Create a scriptblock with unnamed params
$add = { param($X, $Y); $X + $Y } # Create a scriptblock with named params
```

Calling
```pwsh
&{1 + 1} # Call a scriptblock using an operator
&$sum 1 2 # Call a scriptblock using positional arguments, notice there's NO COMMA!
&$sum -X 1 -Y 2 # Call a scriptblock using the commandlet
Invoke-Command -ScriptBlock $sum -ArgumentList 1, 2
```

## Functional Translation

- Basics
   - ForEach-Object = MAP
       - `1, 2, 3 | ForEach-Object { $_ % 2 -eq 0 }` # False, True, False
   - Where-Object = FILTER
       - `1, 2, 3 | Where-Object { $_ % 2 -eq 0 }` # 2
   - NO NATIVE REDUCE
      - `gci | Measure-Object -Property length -Minimum -Maximum -Sum -Average -StandardDeviation`
      - `gci | Measure-Object -Property length -AllStats` # Same as above
   - Sort-Object = SORT
       - `22, 33, 11 | Sort-Object -Descending` # 33, 22, 11

## Object - Adding a Key       
```pwsh
# Long version - use the hash keys "name" and "expression" to add to an object.
 @{ id = 123; name = "Bob" } | Select-Object -Property *, @{ name = "dept"; expression = { "IT" } }
 
 # Short version - use hash keys "n" and "e"
  @{ id = 123; name = "Bob" } | Select-Object -Property *, @{ n = "dept"; e = { "IT" } }
```

## Object Array - Key to Array
```pwsh
$objects = @{ x = 11 }, @{ x = 22 }, @{ x = 33 }
$objects.x # 11, 22, 33   # Use period accessor
 @{ x = 11 }, @{ x = 22 }, @{ x = 33 } | % { $_.x } # Use Foreach-Object

(Get-Process).ProcessName # Requires parenthesis
```

## Bitwise Operators
`-band -bnot -bor -bxor -shr -shl`

```pwsh
0b000100 # 4
0b11111 -band 0b000100 # 4
0b000000 -bor 0b000100 # 4
0b000100 -shr 1 # 2 Shift Right
0b000100 -shl 1 # 8 Shift Left
0b1 -bxor 0b1 # 0
-bnot 0b1 # -2
```

## Scope - Concept

1. Global Scope - the same as session scope 
2. Functions - creates a new scope, have access to global / session / caller scope
3. Scripts - creates a new scope, have access to global / session / caller scope
4. Modules - module functions, do NOT have access to global / session / caller scope.
   
## Scope - In Practice

```pwsh
Get-Variable -Scope local # Show local variables
Get-Variable -Scope global # Show global variables
```

`if` braces do NOT create scope, they use global scope.
```pwsh
if ($true) {
   $x = 42
}
$x # 42
```

`for` braces, do NOT create scope - they use global scope.
```pwsh
foreach ($i in 1,2,3) {
   Write-Host $i
}

$i # 3
```
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
   - Microsoft hosted PowerShell code sharing site. <https://www.powershellgallery.com/> 
   - Install a module: `Install-Module -Name PSCalendar`
   - Unload (doesn't delete): `Remove-Module MyModule`
   - List currently loaded modules: `Get-Module`
   - List installed, but not loaded modules `Get-Module -ListAvailable`
   - `Get-Command -Module PSCalendar`
   - Search ONLINE at powershellgallery.com for a module `Find-Module *yaml*`
- Snapins: PSSnappin, deprecated system as of version 6.

## Modules - Creating Your Own

- Rename a script to MyModuleScript.psm1 and put in a folder of the same name: \MyModule\MyModule.psm1
- Install: `Install-Module -Name MyModule`
- Uninstall: `Remove-Module -Name MyModule` (Doesn't delete the code)
- Autoload: put in your Powershell module path: Example: `C:\Users\jsmith\Documents\PowerShell\Modules\MyModule\MyModule.psm1`
  
## Casting

```pwsh
[int] 7 / 3 # 2
[uri] "https://example.com" # -> System.Uri

# Hash -> PSCustomObject
$h1 = @{ a = "aaa"; b = "bbb" }  # Hashtable
$o1 = New-Object -TypeName psobject -Property $h1 # Hashtable -> PSCustomObject

# PSCustomObject -> Hash
$h2 = @{}
$o1.psobject.Properties | ForEach-Object { $h2[$_.Name] = $_.Value }

# Values -> Array
(gps).Name # PowerShell does it for you.
```

## IO

Read
```pwsh
$name = Read-Host "Name" # Input a string
$i = [int] (Read-Host "i") # Input an integer
```

Write
```pwsh
Write-Host "Hi" # Side effect message. Nothing sent to pipeline.
Write-Host "Hello" -ForegroundColor Green # Change text color.
Write-Output "Hi" # Send to the pipeline
Write-Warning "Warning..." # Warning messages, continue by default. Change behavior with $WarningPreference
Write-Information "Info..." # Info messages. Change behavior with $InformationPreference
Write-Error "Error..." # Errors, continue by default. Change behavior with $ErrorActionPreference
Write-Debug "Debug..." # Debug messages. $DebugPreference
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

- Basics for PSSession
   - Invoke: IMMEDIATELY enter and exit a remote session
   - Enter, Exit: INTERACTIVE session.
   - New, Get, Remove: create, show, and remove SESSION VARIABLES, that maintain a PERSISTENT CONNECTION
   - Connect, Disconnect, Receive: open or close a SESSION CONNECTION. Receive will get results from a disconnected session.
   - Import & Export: import module COMMANDS (advanced, awesome feature unique to PowerShell)
- Example Commands
   - `Invoke-Command -ComputerName server1 -ScriptBlock { Get-Process }` # Open AND CLOSE a remote session.
   - `Invoke-Command -ComputerName server1 -ScriptBlock { Get-Process } -AsJob` # Use `-AsJob` to save results for later (see Jobs section).
   - `Enter-PSSession -ComputerName server1` # Enter an INTERACTIVE session using Windows protocols
   - `Enter-PSSession -HostName server1` # Enter an INTERACTIVE session using SSH (multiplatform)
   - `Exit-PSSession` # Exit live session
   - `Get-PSSession` # Show sessions
   - `$mysession = New-PSSession -ComputerName SERV1 -Credential (Get-Credential)` # Make a new session variable.
   - `Remove-PSSession -Session $mysession` Remove $mysession
   - `Get-PSSession | Remove-PSSession` # Remove all sessions
   - `Import-PSSession -Session $session -Prefix rem -Module ServerManager` # Import commands from $session with the prefix "rem"
   
## Jobs

- Basics 
   - Job = Process
   - Thread-Job =  Thread
   - `-AsJob` is used with `Invoke-Command`
- `Start-Job -ScriptBlock { gps }` # Start job
- `Start-Job -Command { gps }` # Same as above
- `Receive-Job -Id 12` # Get results, results not cached
- `Receive-Job -Id 12 -Keep` # Get results, results cached
- `Start-ThreadJob -ScriptBlock { gci }` # Run job as a thread
- `Get-Job | Where-Object { -not $_.HasMoreData } | Remove-Job` # Remove old jobs
-  `Invoke-Command -HostName server1 -ScriptBlock { gps } -AsJob` # AS JOB - Save results to a job.

## Documentation

Adding a multiline comment with the keywords `.SYNOPSIS` and `.DESCRIPTION` will add documentation to your script. `help myscript.ps1` will show help.

Here's documentation for the help command.
```pwsh
.SYNOPSIS
   Displays information about PowerShell commands and concepts.
.PARAMETER ComputerName
   Default is localhost
.DESCRIPTION
   The `Get-Help` cmdlet displays information about PowerShell concepts and commands, including cmdlets, functions,
    Common Information Model (CIM) commands, workflows, providers, aliases, and scripts...
#>
```
## Pipelines

- Parameter Binding
   1. `ValueFromPipeline` - TYPE of 1st command -> TYPE of 2nd command
       - receiving command will match multiples, so typically signatures are designed with only one of each type
   3. `ValueFromPipelineByPropertyName` - PARAMETER NAME, WILL MATCH ALL NAMES

The parameter `-InputObject` is a common parameter that exists to preserve data structures; do NOT use it to be formal!

```ps1
# Expected result
100, 1, 50 | Sort-Object # 1, 50, 100

# Probably a surprise!
# The SINGLE ARRAY is compared to nothing else, and simply returned.
Sort-Object -InputObject @(100, 1, 50) # 100, 1, 50
```

 An example use case would be to get array commands: `Get-Member -InputObject @()`

      
## Pipelines - Writing functions for Pipelines

- Default to naming your parameter SINGULAR, but handling MULTIPLES.
- Do this by starting with a `process{}` block which has a `foreach` loop in. See below.
- `begin{}` and `end{}` blocks are optional, but you can use for setup, teardown, or aggregation (see $IncludeSum below).

```ps1
function Get-TestIncrement {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, 
                   ValueFromPipeline = $true,
                   Position = 0)]
        [int[]]
        $Number,

        [switch]
        $IncludeSum
    )
    begin {
        $sum = 0
    }
    process {
        foreach ($num in $Number) {
            $incremented = $num + 1
            $sum = $sum + $incremented

            $incremented
        }
    }
    end {
        if ($IncludeSum) {
            $sum
        }
    }
}

Get-TestIncrement -Number 0, 10, 100 # 1, 11, 101
Get-TestIncrement -Number 0, 10, 100 # 1, 11, 101, 113
```

## Error Handling
- Basics
   - PowerShell are designed to KEEP GOING. They show the error, log the error, and `Continue`.
   - If you need to handle an error, set errors to `Stop` (Error-> Exceptions) and use a `try catch`.
   - DON'T DO GLOBAL ERRORS, DO PER COMMAND - YOU WANT TO ANTICIPATE ERRORS!
- Code
   - `help about_Automatic_Variables` # Read more
   - `$Error` ARRAY OF ERRORS, last on top
   - `$Error[0]` Latest error
   - `-ErrorVariable myerrors` Save errors to $myerrors
   - `$ErrorActionPreference` # Global setting, don't use; do set per command.
- Examples
   - `Remove-Item temp* -ErrorAction SilentlyContinue` # Clear some files that may or may not exist
   - `New-PSSession -ComputerName $Computer -ErrorAction Stop` Interactive -  see the error
   - `try { New-PSSession -ComputerName $Computer -ErrorAction Stop } catch { Write-Warning "oops - connection error" }` # Turn an error into a warning
   - `New-PSSession -ComputerName $Computer -ErrorVariable myerror` Interactive - apture the error to a variable
   
Catch errors from commands that don't have `-ErrorAction` by WRAPPING THEM IN A TRY CATCH
```
try {
$ErrorActionPreference = 'Stop'
# ...
$ErrorActionPreference = 'Continue'
catch { $_ >> mylog.txt }
```

Log all errrors for diagnostic purposes. Good if the script is out of view.
```pwsh

# WARNING: if the preference is 'Continue', the program will NEVER reach the catch block!

$ErrorActionPreference = 'Stop'
try {
   badcommand
}
catch {
        $_ >> errors.txt
}
```

## Debugging

Print Debugging

```pwsh
Write-Host $myvar
Write-Verbose $myvar
Write-Debug $myvar
```

VSCode Debugger
- `F5` Run script, includes debugging

## Tips

- To run a `ps1` script, you can hit F5, or click the play button in the upper right.
- You can linebreak naturally linebreak on `|` if appropriate for improved formatting.
- Avoid linebreaking on backticks (too easy to break)
- Checkout <https://jdhitsolutions.com/blog/powershell-tips-tricks-and-advice/>

## Customization

- `$Profile | Format-List -force` Show the file you need to edit
- `code $profile` # Update your profile
- For color codes: <https://en.wikipedia.org/wiki/ANSI_escape_code>
- Most popular prompt customization tool: <https://ohmyposh.dev/>

A simple custom prompt
```pwsh
function prompt {
   $time = (Get-Date).ToShortTimeString()
   "$time [$env:COMPUTERNAME]:> "
}
```

My prompt
```pwsh
function prompt () {
  $commandstatus = $?
  $colorinfo = "$([char]27)[90m" 
  $colorwhite = "$([char]27)[37m" 
  $time =  (Get-Date).ToShortTimeString().Replace(' ', '').ToLower()
  $machine = $env:COMPUTERNAME
  $location = Get-Location
  $prompt = ($commandstatus ? "$([char]27)[32m" : "$([char]27)[31m") +
             "> " + "$([char]27)[37m"
  "$colorinfo$time $machine $colorwhite$location $prompt"
}
```


## Resources
- Good intro book: <https://livebook.manning.com/book/learn-powershell-in-a-month-of-lunches/>
- Book written by PowerShell's language designer: <https://www.manning.com/books/windows-powershell-in-action-third-edition>
- Interesting PowerShell blog: <https://jdhitsolutions.com/blog/>

## Style Guide

- Source: <<https://github.com/PoshCode/PowerShellPracticeAndStyle>
- lowercase for language keywords, Ex: `foreach`
- PascalCase for all public identifiers: module names, function or cmdlet names, class, enum, and attribute names, public fields or properties, global variables and constants.  
  - Ex: `ColorName`
  - Ex: `Get-PSColorName` two letter caps for modules are ok
- UPPERCASE for keywords in comments
- camelCase for variables within your functions (or modules) to distinguish private variables
- 

```ps1

function Write-Host {           
    <#
    .SYNOPSIS
        Writes customized output to a host.

    .DESCRIPTION
        The Write-Host cmdlet customizes output. You can specify the color of text by using
        the ForegroundColor parameter, and you can specify the background color by using the
        BackgroundColor parameter. The Separator parameter lets you specify a string to use to
        separate displayed objects. The particular result depends on the program that is
        hosting Windows PowerShell.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true, ValueFromRemainingArguments = $true)]
        [psobject]
        $Object,

        [switch]
        $NoNewline,

        [psobject]
        $Separator,

        [System.ConsoleColor]
        $ForegroundColor,

        [System.ConsoleColor]
        $BackgroundColor
   )
```

Start scripts like this to support pipelines

```ps1
[CmdletBinding()]
param ()
begin {
}
process {
}
end {
}
```

Braces

```ps1
if (10 -gt $ParameterOne) {
    "Greater"
} else {
    "Lesser"
}
```

Shared variables should be distinguished by using their scope name. Private variables need no scope

```ps1
$myCount = 1
$Script:PSBoundParameters
```

Four space indentation (not tab), except for lining up with a method call

```ps1
function Test-Code {
    foreach ($base in 1,2,4,8,16) {
        foreach ($exponent in 1..10) {
            [System.Math]::Pow($base,
                               $exponent)
    }
}
```

Use space for readability, except for function args

```ps1
$variable = Get-Content -Path $FilePath -Wait:($ReadCount -gt 0) -TotalCount ($ReadCount * 5)
```

Line length upto 115 characters is ok. Use splatting instead of backticks for line continuation.

```ps1
$msg = "This really, really, really, really, really, really, really, really, really, really, long line is OK!"
```
### Splatting Args

You can define a hash or an array using a traditional variable such as `$myargs`, and then switch the `$` to `@` to pass it to a function.

Example argument splatting to avoid backticks

```ps1
# Option 1: Hashtable
$Args = @{
  Path = "test.txt"
  Destination = "test2.txt"
  WhatIf = $true
}
Copy-Item @Args
```

```ps1
# Option 2: Array
$ArrayArguments = "test.txt", "test2.txt"
Copy-Item @ArrayArguments -WhatIf
```

Don't use semicolons on a hashtable

```ps1
$Options = @{
    Margin   = 2
    Padding  = 2
    FontSize = 24
}
```

Two lines surround function definitions

```ps1
function Get-Test1 {
  "Test1"
}


function Get-Test2 {
  "Test2"
}


function Get-Test3 {
  "Test3"
}

```

A group of one liners don't need spaces

```ps1
function Get-Double { param($X) $X * 2 }
function Get-Triple { param($X) $X * 3 }
function Get-Square { param($X) $X * $X }
```

Space params generously

```ps1
param (
    [Parameter(Mandatory = $true,
                ValueFromPipelineByPropertyName = $true,
                Position = 0)]
    [int16]
    $Age
)
```

Example Advanced Function

- Name use Verb-Object
- Use verbs only from `Get-Verb`
- Use PascalCase, singular nouns.
- ONLY use return for early return.  It can unexpectedly interfere with piped input.
- Leave return objects inside the Process {} block and not in Begin {} or End {} since it defeats the advantage of the pipeline.
- Always use `[CmdletBinding()]`
- Specify an OutputType attribute if the advanced function returns an object or collection of objects.

```ps1
function Get-USCitizenCapability {
    [CmdletBinding()]
    [OutputType([psobject])]
    param (
        [Parameter(Mandatory = $true,
                   ValueFromPipelineByPropertyName = $true,
                   Position = 0)]
        [int16]
        $Age
    )
    process {
        $Capabilities = @{
            MilitaryService = $false
            DrinkAlcohol = $false
            Vote = $false
        }

        if ($Age -ge 18) {
            $Capabilities['MilitaryService'] = $true
            $Capabilities['Vote'] = $true
        }

        New-Object -Property $Capabilities -TypeName psobject
    }
}
```

Comments

- Use complete sentences
- Do speak in plain language; Do NOT speak in needlessly technical or academic language
- Be concise, but complete
- Do have comments that explain reasoning; Do NOT make comments that are totally obvious. Ex: increments variable

```ps1
function Get-Example {
    <#
    .SYNOPSIS
        A brief description of the function or script.

    .DESCRIPTION
        A longer description.

    .PARAMETER FirstParameter
        Description of each of the parameters.
        Note:
        To make it easier to keep the comments synchronized with changes to the parameters,
        the preferred location for parameter documentation comments is not here,
        but within the param block, directly above each parameter.

    .PARAMETER SecondParameter
        Description of each of the parameters.

    .INPUTS
        Description of objects that can be piped to the script.

    .OUTPUTS
        Description of objects that are output by the script.

    .EXAMPLE
        Example of how to run the script.

    .LINK
        Links to further documentation.

    .NOTES
        Detail on what the script does, if this is needed.

    #>
```

Use explicit commands and arguments. Don't use aliases

```ps1
gps explorer # Bad

Get-Process -Name Explorer # Good
```

Use explicit paths, don't rely on `~` for home

```ps1
$path = ${Env:UserProfile}
```

## Best Practices

What Are You Building?

- Decide whether you are building: reusable tool or a controller (see below)
  - A tool should primarly be reusable and yield low level, unformatted data.
  - A controller is a higher level tool which yields formatted data, and does not need to be reusuable

Output

- Output only **one** type

Write-Host|Verbose|Something

- Use Write-Host for interactive scripts ONLY
- Do not use Write-Host for non-interactive scripts; do use Write-Debug/Verbose/etc
- Use Write-Progress for long running script

Function Returns

- Just leave the final expression instead of return
- In the middle of the script, you can use Write-Output
- Use `return` ONLY for early return.  This is to prevent unexpected behavior in pipes.

```ps1
function add{} {
    param($x, $y)

    # Bad: return $x + y
    # Bad: Write-Output ($x + $y)

    # Good
    $x + $y
}
```
  

Prefer simple code

```ps1
Get-Content -Path file.txt |
ForEach-Object -Process {
    Do-Something -Input $_
}
```

For Performance, you can do this

```ps1
$handle = Open-TextFile -Path file.txt

while (-not (Test-TextFile -Handle $handle)) {
    Do-Something -Input (Read-TextFile -Handle $handle)
}
```

Credentials

- Always take PSCredentials as a parameter
- Never call Get-Credential within your function. This allows users to reuse stored credentials

```ps1
param (
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $Credentials
)
```

Declare the required version of PowerShell

TODO Not sure if this still works.  Maybe an earlier version.

```ps1
# Inside script

<#PSScriptInfo
.VERSION 1.0.1
.GUID 54688e75-298c-4d4b-a2d0-1234567890ab
.AUTHOR iRon
.DESCRIPTION Your description
.COMPANYNAME
.COPYRIGHT
.TAGS PowerShell Version
.LICENSEURI https://github.com/LICENSE
.PROJECTURI https://github.com/
.ICONURI https://Icon.png
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

# Outside script
Get-PSScriptFileInfo myscript.ps1
```

## Write Award Winning PowerShell Functions and Script Modules by Mike Robbins

Workflow

- Plan your work (or plan to fail)
- Set a deadline for your code.  Everything after the deadline will be a later version.
- Prefer to write functions over scripts, because functions are reusable

Function Basics

- Running a script with a function will NOT load into global space `.\Get-Test.ps1`
- "Dot sourcing" Will: `. .\Get-Test.ps1`
- You check with this: `gci -path Function:\Get-Test`

Return 

- Do NOT use return  unless you want EARLY return.
- It messes up pipes and multiples!

Comments

- Use Write-Verbose instead of comments.
- Why comments are not seen, and often go out of date.
  
Function Naming

- Use a singular noun

Variables

- Don't use static values
- Do use variables and paramters
- Don't use Hungarian notation `$strOutFile` -> `$OutFile
- Don't reuse variables!
    - Changing $vm from a string to an object is confusing. Have $vm and $vmObject

Parameters

- Order matters! Common parameters first.
- Model after Built-In Cmdlets; do NOT model after Azure Cmdlets
  - $ComputerName is most common (not $Computer!)
  - $Path is most common (not $FilePath!)
  - Checkout Get-MrParamterCount (Mike Robbins)
- Use singular names, UNLESS IT ONLY accepts MULTIPLES, `-ComputerName`, NOT `-ComputerNames`
- Always use `[CmdletBinding()]`
- Use `[CmdletBinding()](SupportsShouldProcess)` if you're making changes
- Checkout <http://mikefrobbins.com/2015/04/17/free-ebook-on-powershell-advanced-functions/>

```ps1
[CmdletBinding()]                         # OPTION 1: Adds -Verbose, -Debug, -ErrorAction
[CmdletBinding()](SupportsShouldProcess)  # OPTION 2: Adds -WhatIf, -Confirm in addition to the above
param(
...
)
```

Parameter Validation

- For mandatory use `[Parameter(Mandatory)]`
- Default arguments DO NOT WORK with mandatory parameters

- Do allow multiples
```ps1
param (
   [string[]]
   $ComputerName
)
```

Require an argument, but use a default

```ps1
param(
   [ValidateNotNullOrEmpty()]
   [string]
   $ComputerName = $env:COMPUTERNAME
)
```
- Don't use `[ValidatePattern()]`, because user gets a confusing error.
- Do use `[[ValidateScript()]`, because  you can set a meaningful user error.

Getting Enums

```ps1
$mytype = (Get-Date).DayOfWeek
$myType.GetType().GetEnumValues()
```

Type Accelerators

- Show all: `[psobject].Assembly.GetType(“System.Management.Automation.TypeAccelerators”)::get`
- Examples:
  - `bigint` `ipaddress` `mailaddress` `switch` `xml `uri` 
- Don't write your own regex for these!

Pipeline Input

- By Value vs By Type
   - `ByValue`: Means BY TYPE!!! Most common.
   - `ByPropertyName`: Means an object with a matching property name will automagically transfer the data.
- Example:
  - Look at Start-Service for `Get-Help Start-Service -Parameter "inputobject", "name"`
  - Only two accepts pipeline 
  - `-InputObject` Accept pipeline input? Is ByValue
  - `-Name` Is ByPropertyName and ByValue
       
Error Handling

- Set `$errorAction` and use `try-catch` 

Modules

- New-Module is the wrong command! It's for in memory module
- Make a new module by renaming or `ps1` file as `.psm1`
- Modules need to live in the path of this `$env:PSModulePath -split ";"`; usually below your Documents folder

Module Manifest

- Uses Plaster
- Name and Description required for sharing sites.

Custom Formatting

- <= 4 properties defaults to Table
- > 4 properties defaults to List
