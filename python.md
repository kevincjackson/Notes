# Python
## Language Paradigm
* Object Oriented
* Weak Typing
* Scripting Language (not compiled)

## Basics
### Comments
Single line
```py
# Here's a comment
```
Multiline
```py
"""
Here's a multiline comment.
"""
```
### Whitespace
* Very important, ruthlessly enforced
* Indenting replaces braces

Right
```py
def greet():
    return "Hello!"
```
Wrong
```py
def greet():
return "Hello!" # IndentationError: expected an indented block
```
### Nothingness
```py
x = None
```
### True / False
```py
is_valid = True
is_valid = False
```

### Variables
**You must initialize variables.**  
You do **not** declare variable types.

Correct
```py
x = 42
```

Incorrect
```py
# This needs to be initialized.
x  # NameError: name 'x' is not defined
```
### Numbers

```py
x = 0
```
### Strings
```py
person = "Santa"
```
### Functions
Basic Example
```py
def add(x, y):
    return x + Y
```
With Code Comments
```py
def add(x, y):
    """Function to add two values
    """
    return x + Y
```
Functions are first class
```py
def greet:
    return 'Hello!'

greet # <function greet 0x1036c8268>
greet() # 'Hello!'

```
### Conditionals
If-elif-else version
```py
if 2 + 2 == 4:
    print("That's true.")
elif 2 + 2 == 5:
    print("That's close")
else:
    print("That's not true")
```
Ternary
```py
print("Yes") if 2 + 2 == 4 else print("No")
```
`Case`
* Does **not** exist in Python.
* Use `if-elif-else` or a dictionary.

### Booleans
```py
is_valid = True and False # False
is_valid = True or False # True
is_valid = not True # True
```

### Loops
Loop through a list.
```py
for i in [0, 1, 2]:
    print(i)
```

### Collections
#### List / Array
```py
numbers = [1, 2, 3]
```
Mix and match is OK
```py
numbers = [1, "apple", True]
```
#### Dictionary / Hash
```py
highscores = { "BigDog": 1000000, "BigCat": 900000 }
```
#### Tuple
```py
status = (200, 'OK')
status[0] # 200
status[1] # 'OK'
```

# TODO
## Intermediate
    -Learn input and output (reading and saving data).
    -Learn events (for interactive programs).
    -Learn patterns and regular expression handling.
    -Learn debugging.

## Advanced Topics.
    -Learn memory management: manual, reference counting (Obj-C), or automatic.
    -Learn algorithms.
    -Learn multithreading.
    -Learn libraries and frameworks - (don't reinvent the wheel.)
