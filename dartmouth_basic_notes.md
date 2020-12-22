# Darmouth Basic

## Who

Two Dartmouth College Professors` John G. Kemeny and Thomas E. Kurtz.

## What

Beginner's All purpose Symbolic Instruction Code. A beginner friendly, imperative, compiled programming language. The grandfather of all BASIC's.

## Where

Dartmouth University in Hanover, New Hampshire.

## When

1964 - 1979.

Kemeny and Kurtz released SBASIC (Structured BASIC) in 1975 and later left Dartmouth to promote an SBASIC variant called True Basic.

In the 1980's the most popular BASIC became Microsoft BASIC. 

Most variations of BASIC or based on the fourth version of Dartmouth BASIC.

## Why

To provide programming literacy to students outside of Science, Technology, Engineering, Math (STEM) for Darmouth University.

At first the Kemeny and Kurtz wanted to write a cut-down version of Fortran or Algol, but because of all the idiosyncracies, opted to write a new language instead.

## How

### Download

<http://dtss.dartmouth.edu/#download>

### Overview

First generation BASIC, such as Dartmouth BASIC, typically supports only two data types (strings and floating point numbers), arrays, and for loops. There is only a single global scope.

### Rules from the original manual

- Variables can be named one letter + an optional number, ex `A` or `A1`
- Math operators: `+ - * / ^`
- Number functions: `EXP(X) LOG(X) SQR(X) RND(X) ABS(X) INT(X)`
- Trig functions: `SIN(X) COS(X) TAN(X) ATN(X)`
- Functions can be named with FN + one letter, such as `FNA(X) FNB(X) FNC(X) ...`

### Keywords

`REM` Comment line

`LET X=11` Use a variable.

`INPUT` Get input interactively.

`DIM A(2,3)` Declare a array (in this case a two dimensional array).

`MAT A = 0` Operates on all elements of an array.

`PRINT "Hello" ; "World!"` Print. Semi-colon adds space between items.

`END` Terminate program

A standard loop.
```basic
FOR I = 1 TO 10 
    REM yourcode
NEXT I
``` 

 `GOTO 100` Transfer control to the line 100.

Subroutine: Transfer control to line until you hit a `RETURN` call. 
 ```basic
100 GOSUB 200 
110 REM yourcode continues
199 END

200 REM MySubroutine
210 REM Do stuff 
220 RETURN
```

 `IF X = "" THEN 100` Branching. Note there's no else statement.`IF` is used like a guard and can't evaluate expressions after `THEN`; it can only transfer programs to a line number.   

 `DEF FNA(x)= 2 * x` Define a single line function

 `DATA 11, 22, 33, 44, 55` Early programs couldn't read external input, so data was provided hardcoded internally.

 `READ` Read reads the data from `DATA` one element at a time.

### Example: Average a Sum of Numbers

```basic
4 REM       Declare and initalize a variable
5 LET S = 0 

07 REM      MAT indicates an array
08 REM      INPUT keeps getting input until 
09 REM           it gets an empty line
10 MAT INPUT XS 
19 REM      NUM is a function which gets the size from INPUT
20 LET N = NUM 

29 REM      Escape condition
29 REM      Notice there's no named subroutines.
29 REM      You use line numbers instead.
30 IF N = 0 THEN 99 

39 REM      Loop through array
40 FOR I = 1 TO N 
45   LET S = S + XS(I) 
50 NEXT I 

59 REM      Report
60 PRINT S/N 

69 REM      Program control by line number.   
70 GO TO 5

98 REM      Note this must be on it's own line
98 REM      because the IF line only takes line numbers
99 END
```

###  Example: Guessing Game

```basic
100 REM GUESSING GAME
110
120 PRINT "GUESS THE NUMBER BETWEEN 1 AND 100."
130
140 LET X = INT(100*RND(0)+1)
150 LET N = 0
160 PRINT "YOUR GUESS";
170 INPUT G
180 LET N = N+1
190 IF G = X THEN 300
200 IF G < X THEN 250
210 PRINT "TOO LARGE, GUESS AGAIN"
220 GOTO 160
230
250 PRINT "TOO SMALL, GUESS AGAIN"
260 GOTO 160
270
300 PRINT "YOU GUESSED IT, IN"; N; "TRIES"
310 PRINT "ANOTHER GAME (YES = 1, NO = 0)";
320 INPUT A
330 IF A = 1 THEN 140
340 PRINT "THANKS FOR PLAYING"
350 END
```

### How to Use Read, for Modularity

Instead of this:

```basic
LET A = 1
LET B = 2
LET C = 3
```

Write this

```basic
READ A, B, C
DATA 1, 2, 3
```s