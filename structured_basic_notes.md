# Structured Basic Notes

## Who



## What

Beginner's All purpose Symbolic Instruction Code. A beginner friendly programming language. 

1st Gen BASIC (Unstructured): Dartmouth BASIC, MSC BASIC, GW-BASIC 

2nd Gen BASIC (Structured, Procedural): VAX Basic, SuperBASIC, True BASIC, QuickBASIC, BBC BASIC, Pick BASIC, PowerBASIC, Liberty BASIC

3rd Gen BASIC (Object-oriented, Event-driven): Visual Basic, Xojo, StarOffice Basic, BlitzMax, PureBasic

## Where



## When



## Why


## How

Rules (from TrueBasic)

- Statements always begin with a keyword.
- Comments begin with a `!`
- Blank lines have no effects.
- Only Types are Strings and Numbers (Floating Point), and String Variables (not constant)
- Variables can be up to 31 characters, including underscores.
- String variables are indicated with a $ afterword, such as `firstname$` 
- Relational operators: '=  <> ><  >  >= =<  < <= =<'
- Programs must end with `end`
- All variables are global by default!
- Subroutine variables are global.
- Variables in functions marked as `local` are private.
- External subroutines use private variables, except for the parameters, which are always global.

### Keywords

`REM` `!` Comment line

`PRINT X, Y, Z` Print x, y, z in 16 character columns.

`PRINT X; Y; Z` Print and concatenate x, y, and z.

`LET X=11` Use a variable.

`INPUT` Get input interactively.

`DIM A(2,3)` Declare a array (in this case a two dimensional array).

`MAT XS = 0` Operates on all elements of an array.

`MORE DATA` Conditional check for more data
`END DATA` Conditional check for end of data
`RESTORE` Resets the data to the beginning

`PRINT "Hello" ; "World!"` Print. Semi-colon adds space between items.

`RANDOMIZE` Change random seed.

`RND` Generates an fp number between 0 and 1

`STOP` Terminate program

`OPEN CLOSE ERASE RESET` File commands: Open, close, ptr to beginning, ptr to end of file.

### Loops

```basic
DO UNTIL c
   ! code
LOOP

DO
    ! code
LOOP UNTIL c

DO WHILE c
    ! code
LOOP

DO 
    ! code
LOOP WHILE c
```

Branching
```basic
IF c THEN s ! single line, else not required.

IF c THEN
    s1
ELSE 
    s2
END IF

SELECT CASE dice
    CASE 1, 3, 5
        ! code
    CASE ELSE
        ! code
END SELECT
```

### Read Data Example

```basic
! read part of the program
do while more data
    read x, y
    print "total"; x + y
loop

! data last
data 1, 2
data 10, 20
data 100, 200

print "bye"
end
```

### Subroutines

Syntax
```basic
SUB s (out, ..., in, ...)
    statements
END SUB
```

Example
```basic
SUB box (area, perimeter, width, height)
    let perimeter = 2 * (width + height)
    let area = width * height
END SUB

call box (a, p, 3, 5)

print "area: "; a
print "perimeter: "; p

end
```

### Functions

```basic
! Single line
DEF ROLL_DIE =  int(rnd * 6) + 1

! Single line with arg
DEF ROLL_N(X) = int(rnd * X) + 1

! Multi line
! The return value is assigned by assigning
! to the function name
DEF TAKE_SECOND(X,Y)
    LET TAKE_SECOND = Y
END DEF

! You need to declare variables as local
! otherwise they'll be global.
DEF F(X)
    LOCAL i, j
    ...
END DEF
```
