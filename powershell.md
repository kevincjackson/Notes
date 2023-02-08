# PowerShell

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
