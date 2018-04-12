# Character Sets
Are simply lookup tables for glyphs. Don't worry if conventions seem weird at first. There's nothing to understand - they're just magic numbers.
## History
### ASCII
* From the C days
* Uses 7 of 8 bits
* 0-32 (decimal) Non printing characters
* 33-127 (decimal) Printing characters
* octal 33 is `ESC`
* `7f` is the last hex.
### ANSI / Code Pages
* After a free-for-all regarding the last bit of the 8 bits,
  the standard becomes ANSI *code pages*. 
* Still only a regional solution. Even large countries such as Russia 
  use different pages. 
* Computers also needed to have the required code page on their local computer.
* Using two pages at the same time is difficult.
### Unicode
* A gigantic lookup table for *everyone*.
* Up to 6 bytes, not 2 (a common misconception)
* Magic numbers are called *code points*.
* `U+` indicates Unicode and <hex> is the magic number. (eg `U+1F7A`) 

#### Unicode Encodings
* Byte order is indicated by the Unicde Byte Order Mark: `FE FF` or `FF FE`, also called low or high Endian. 
* UTF-8: Unicode Transformation Format-8 is  **the modern standard**. Code points 0-127, only use one byte, which makes it look like the old systems, above that 2+ bytes are used. Clueless systems and programs in English still work with it.
* UCS-2: Universal Character Set that uses 2 bytes.
* UTF-7: like, UTF-8 but byte order is consistent.
* UCS-4: uses 4 bytes.
#### Other Popular Encodings
* Latin-1 /  ISO-8859-1: useful for Western European languages.
* Windows-1252: The Windows 9x encoding for Western European Languages.

## Ruby Methods
### Encoding
```ruby
    puts Encoding.constants # => see a list of encodings.
    "Hi".encode(UTF_8) # => "Hi" (Defaults to UTF-8) 
    "Hi".force_encoding Encoding -> Encoding, fix mis-encoded strings.
    "abc".encoding # => "#<Encoding:UTF-8" (Encoding Object)
```

## Source Material
* https://www.joelonsoftware.com/2003/10/08/the-absolute-minimum-every-software-developer-absolutely-positively-must-know-about-unicode-and-character-sets-no-excuses/
* http://kunststube.net/encoding/

