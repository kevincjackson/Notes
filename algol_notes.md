# Algol Notes

## Who

ACM and GAMM, associations of American and European progammers.

## What

Algorithm Language. Paradigm: Structured. 

## Where

America and Europe

## When

Algol had 3 major versions Algol-58, Algol-60, and Algol-68. Algol-60 was the most popular version. The numbers indicate the year, such as 1958.

## Why

To develop a machine independent language that would be desirable for the expression of algorithms. 

## How

- Types are REAL, INTEGER, BOOLEAN
- Labels are used instead of line numbers.
- Labels, procedures, and strings are not first-class citizens.
- Variables must be declared.
- The language specification does not include IO (a major detriment to portability, and major reason for development Pascal). The committee was unable to agree on allowing side effects.
- Statements are **separated** by semicolons, not terminated. So only the middle statements have semicolons.
- No line numbers (from BASIC), but blocks separated by `begin` and `end`. Note Dartmouth Algol uses line numbers just for editing.
- Assignment `sum := x + y` because `:=` resembles the arrow `<-`
- Procedures are meant to replace the need for having subroutines and functions from BASIC. They have local scope and declare all types of the inputs and output.
- Procedures are defined by setting the procedure name equal to a value (as opposed to a return keyword).
- Arguments are passed by call-by-value or call-by-name (the default).
- Control structures: `goto`, `if-then-else`, `for`, `switch`

### Keywords

```algol
array       begin       boolean     comment
do          else        end         false
for         goto        if          integer
label       own         procedure   real
step        string      switch      then
true        until       value       while
```
## Keywords by Purpose

- comment: `comment`
- bools: `true false`
- types: `array boolean integer real string`
- control: `begin-end for-step-until-while-do if-then-else switch goto label`
- procedures: `procedure value own`


### Examples

if
```algol
if c1 then s1 else if c2 then s2 else s3;
```

for
```algol
for i := 1 step s until n do s1;
for i := 1 while c1 do s1;
```

procedure
```algol
procedure Absmax(a) Size:(n, m) Result:(y) Subscripts:(i, k);
    value n, m; array a; integer n, m, i, k; real y;

comment The absolute greatest element of the matrix a, of size n by m is transferred to y,
and the subscripts of this element tp i and k.

begin
    integer p, q;
    y := 0; i := k := 1;
    for p := 1 step 1 until n do
        for q := 1 step 1 until m do
            if abs(a[p, q]) > y then
                begin y := abs(a[p, q]);
                    i := p; k := q
                end
end Absmax
```