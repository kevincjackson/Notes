# Haskell

## Paradigm
Functional (math oriented and calculation language, not mainstream)

## Comments
```haskell
-- my comment
```
## White Space Insensitive
```haskell
5/2 == 5 / 2   -- white space insensitive
```

## Strong Typing
```hs
-- Types (Basic)
-- Haskell uses strong types with inference,
-- Haskell types are a well loved feature of the language
-- :t or :type means 'get type of'
-- :: means 'has type of'

:t True  -- True :: Bool ghci,          Bool
:t 1     -- 1 :: Num p => p,            Num (Int, Integer, Float, Double)
:t 1.1   -- 1.1 :: Fractional p => p    Fractional
:t 'a'   -- 'a' :: Char,                Char
:t "abc" -- "abc" :: [Char],            [Char]
```

## Type Variables (Not Basic)
```hs
-- Like a generics in Swift
:t head  -- head :: [a] -> a            Type Variable, 'a' can be any type
```
## Type Classes (Not Basic)
```hs
--   Provides a list of functions to define (abstract class)
--   Like protocols in Swift, interface in Java, duck type in Ruby
Eq Type Class      Defines (==) (/=)
Ord Type Class     Defines (>) (<) (>-) (<=)
Show Type Class    Defines (show) Like to_s in Ruby
Read Type Class    Defines (read) Like eval in Ruby
Enum Type Class    Defines (succ) and (pred)
Bounded Type Class Defines (minBound) and (maxBound)
Num Type Class     Acts like a number
```

## Operators for Comparison
```
1 == 2   -- False, Equality Test
1 /= 2   -- True, Inquality Test, Weird that's it's not a '!='
1 > 2    -- False
1 >= 2   -- False
1 < 2    -- True
1 <=     -- True
```

## Operators for Logic
```
True && False       -- False
True || False       -- True
not True && False   -- False. Notice not has precedence
(not True) && False -- False
not (True && False) -- True
```

## Operators for Math
```
1 + 2 --   3
1 - 2 --  -1
1 * 2 --   2
1 / 2 -- 0.5  Type inferences coerces to Float.
5 ^ 2 --  25  to the power of
```

## Operators Assignment
```
a = 3      -- Set
let a = 3  -- Set
a          -- 3, Get
```

## Strings
TODO

## Functions
```
let doubleMe x = x * 2
doubleMe 2 -- 4, Note no () are required for a call. (We're not in Lisp)
let add3 x y z = x + y + z
add3 1 2 3 -- 6  Notice there's no comma either!
```
### Function Syntaxes
The basic motivator behind these syntaxes are to make the code more readable by avoiding the use of if-else chains.

#### Pattern Matching
Use pattern matching to check the construction of arguments.
```
-- Basic Example
guessMyNumber :: Int -> String
guessMyNumber 7 = "Lucky!"
guessMyNumber i = "Nope"

-- Factorial
factorial :: Int -> Int
factorial 0 = 1
factorial i = i * factorial (i-1)
```

#### As-Patterns
Use as-patterns to create a local binding by using the `@` symbol.
```
firstLetter :: String -> String
firstLetter all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]
```

#### Guards
Use guards to check if a property of an argument is true or false.

#### Where
Use where to store the results of a calculation, and have the results be visible across the whole function pattern (including guards).

#### Let / Let-in
Use where to store the results of a calculation, but keep the results local in scope.
```
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (pivot:xs) = let smaller = [x | x <- xs, x <= pivot]
                           bigger = [x | x <- xs, x > pivot]
                       in quicksort smaller ++ [pivot] ++ quicksort bigger
```
#### Case _expr_ of _pattern_ -> _result_
Pattern matching in function definitions is
syntactic sugar for `case` expressions.
Use case expressions to pattern match anywhere in your code.

```
describeList :: [a] -> String
describeList l = case l of [] -> "Empty"
                           [x] -> "Singular"
                           xs -> "Multiple"
```

## Functor
```
--   A functor an object which defines map :: (a -> b) -> f a
--   It must transform the object
--   It must return another functor (another a mappable object)
--   [] Is an example of a functor
```

## Variables
```
doubleMeKindOf' x = x * 2 + 1 -- The ' is allowed,
DoubleMe x = x * 2 -- ERROR, Starting capital letter not ALLOWED
```

## Scope of Variables

# Conditionals and Loops
```
if 5 == 5
then "Apples"
else oranges -- else is required!
```

## Collections
```
[] -- Empty list
[1,2,3,4,5] -- Must be all the same type
[1,2,3,4,"Goose"] -- NOT ALLOWED, must be all same type
null [] -- True
length [1,2,3] -- 3
head [1,2,3,4,5] -- 1
tail [1,2,3,4,5] -- [2,3,4,5]
init [1,2,3,4,5] -- [1,2,3,4]
last [1,2,3,4,5] -- 5
[1,2] ++ [3,4] -- [1,2,3,4]
"Hello" ++ " World" -- "Hello World"
[1,2,3,4,5] !! 0 -- 1 Weird getter!
take 3 [1,2,3,4,5] -- [1,2,3]
drop 3 [1,2,3,4,5] -- [4,5]
[1..5] -- [1,2,3,4,5]
['A'..'C'] -- "ABC"
[1,3..10] -- [1,3,5,7,9], second number for steps, steps calculated for you
[5,1] -- []
[5,4,1] -- [5,4,3,2,1]
```

## List comprehensions
```hs
-- A party with list, map, and filter
-- Comes form Math
-- List comprehension abstract: [output | member <- collection, filter]
[x | x <- [], True] -- []
[x * 2 | x <- [1,2,3], x * 2 > 5] -- [6]
-- Example above
--   [1,2,3] is the collection
--   x is a member of the collection
--   double each x
--   don't include any result where x * 2 > 5 (filter)
```
### Curried Functions
All multi parameter functions in Haskell actually only take one argument.
They may return a basic type or return a function.

This returned function is said to be _partially applied_.  A partially applied function is simply one that has received some of it's arguments, but not all of them.

```
add3 :: a ->  a ->  a -> a
add3 :: a -> (a -> (a -> a)) -- Same as above
add3 x y z = x + y + z

add3 10 -- yields \(y -> (z -> 3 + y + z))
add2 = add3 10 -- The above lambda has been given the name add2
```
## Style Guide (whitespace, brackets, etc)
TODO

## Learn input and output (reading and saving data).
### Monads
```haskell
-- Monad is a type class
--   Must define >>= and return
--   (>>==) means bind or shove, think of map / transform
--   (>>==) :: m a -> (a -> m b)  -> m b
--      m is the monad, think of it has a box
--      bind unboxes a, transforms it, and puts it back in the box (monad)
--   Bind if infix x >>= y (not >>= x y )

--   return :: a -> m a   Put in a box
--
--   Normal definitions
--   BIND: TAKE SOMETHING OUT OF A BOX, CHANGE IT, PUT IT BACK IN A BOX
--   RETURN: PUT IN A BOX

-- MAYBE MONAD IS THE BOX
data Maybe a = Just a | Nothing     -- THIS IS THE BOX
return a = Just a                   -- put something in a box
Nothing >>= f = Nothing             -- take Nothing in a box, take the changer
Just a >>= f = f a

-- MONAD THINK OF A BOX WITH TWO RULES
--   HOW DO WE PUT STUFF IN THE BOX?
--   HOW DO WE DO THINKGS IF IT'S IS A BOX
```

## Learn events (for interactive programs).
TODO

## Learn patterns and regular expression handling.
TODO

## Learn debugging.
TODO

## Learn memory management: manual, reference counting (Obj-C), or automatic.
TODO

## Learn algorithms.
#### Quicksort
```
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
    let smallerAndEqual = [a | a <- xs , a <= x]
        larger = [a | a <- xs, a > x]
    in quicksort smallerAndEqual ++ [x] + quicksort larger
```

## Learn multithreading.
TODO

## Learn libraries and frameworks
TODO
