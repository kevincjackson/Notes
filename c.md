# C

## Philosophy
C requires the following:
1. Programmers know what they are doing.
2. Programmers state their intentions explicitly.

## Compiling
  * preprocess: substitutes library functions into your code.
  * compile: turn source code into assembly
  * assemble: turn assembly into binary
  * link: add binary from other files to your file

## CS50 Program Requirements
  1. Correctness: works
  2. Design: works well
  3. Style: code looks pretty

## Functions
Syntax
```c
    RETURN_TYPE FUNCTION_NAME(INPUT_TYPE INPUT_NAME)
    {
       // code
    }
```
All C programs need a main function.
```c
    int main(void)
    {
        printf("Hola");
    }
```

## Protocol
A protocol is a *heads_up* for the compiler.
It's required if you want to use a function before its definition.
The protocol declares the return type and input types.
```c
// This is a protocol
int square(int n);

int main(void)
{
    // Notice I can use the function even though
    // I haven't defined it yet b/c of the protocol.
    printf("%i\n", square(2));
}

// Return square of n
int square(int n)
{
    return n * n;
}
```

## Characters
Characters are really just integers which map to a lookup table and repeat (modulo) every 256.
```c
  printf("%c ", 97);
  printf("%c ", 'a');
  printf("%c ", 'a' + 256);
  printf("%c ", 'a' - 256);
  // Returns 'a a a a'
```
## Coercion
C will coerce numbers for you.

## Compiling
| Command | Result |
| - | - |
| clang myProgram.c | a.out |
| clang -o myProgram myProgram.c | myProgram (executable) |
| make myProgram | myProgram  (Convenience compiler)

## CS50 Debugging
    // set breakpoints in gutter of editor
    $ debug50 ./myProgram
    // controls appear in editor on right

## Data Types
All are dependent on the machine! the compiler is free to implement.
  * int: integer (16 or 32 bits)
  * short: integer 16 bits, ~33 thousand, 3 zeroes
  * long: integer 32 bits, ~2 billion, 9 zeroes
  * long long: integer 64 bits, ~9 quintillion 18 zeroes
  * float: fractional 32 bits, about 7 digits
  * double: fractional 64 bits, about 16 digits

## Magic Numbers & Constants
Avoid magic numbers by using constants.

`#define` is called a macro / preprocess; it's a message to the compiler
```c
    // Notice there's no semicolon!
    #define ANSWER_TO_THE_UNIVERSE 42    
```

## Arrays / Vector
    declare by indicating type, name, and quantity
    passed by *reference* (they're expensive so they're saved)
    ```c
        int myNumbers[3];
        int myNumbers[] = { 0, 1, 2 } // Special initiation syntax.
    ```
    Arrays are not assignable
    char name[64];
    name = "Kevin"  // Error Array type 'char [64]' is not assignable
    strcpy(name, "Kevin"); // Works

## Passwords
    Don'ts
        Don't store in plain text.
        Don't encrypt / decrypt passwords (two way encryption).
            Key's get stolen easily.
        Don't just hash passwords.
            Rainbow (lookup) tables exist for common passwords and hashing
            algorithms.

    Do use hash + salt / pepper.
        Salt:
            a random string added to each password, stored with the password.
        Pepper:
            a random string added to each password,
            *not* stored with the password.
            Logins have to try all the combinations of peppers only.
            Example a pepper of 'f' would require tryping 'a', 'b', 'c',
            etc until the 'f' pepper matches.

## String
    In C Strings are constants.
    To make strings mutable add a [] to the declaration
    Don't forget to include space for the '\0' at the end.

    These two are equivalent;
        char cat1[] = "cat";
        char cat2[] = { 'c', 'a', 't', '\0' };
        if (strcmp(cat1, cat2) == 0)
            puts("True");   // True

    Because strings are arrays, they're handling is a
        littler weird.

        char breakfast_foods[3][10] = {
            "bacon",
            "eggs",
            "ham"
        };

        for (int i = 0; i < 3; i++)
            printf("%s\n", breakfast_foods[i]);

## Struct
    struct account
    {
        char name[64];
        int number;
        int balance;
    };

    struct account my_account;
    strcpy(my_account.name, "Kevin"); // Note arrays not assignable!
    my_account.number = 123456789;
    my_account.balance = 1000000;

## Time
    Keys
        #include <time.h>
        time()
        localtime()
        ctime()

    time_t now;
    time(&now);

    struct tm *mylocaltime;
    mylocaltime = localtime(&now);

    printf("Epoch time: %s\n", ctime(&now));
    printf(
           "Today is %d/%d at %d:%02d\n",
           mylocaltime->tm_mon + 1,
           mylocaltime->tm_mday,
           mylocaltime->tm_hour,
           mylocaltime->tm_min
    );

#include <time.h>

## Variables
    int an_integer;
    long a_long;
    char a_char;
    float a_float;
    double a_double;

    printf("int: %lu bytes\n", sizeof(an_integer));   // int: 4 bytes
    printf("long: %lu bytes\n", sizeof(a_long));      // long: 8 bytes
    printf("char: %lu bytes\n", sizeof(a_char));      // char: 1 bytes
    printf("float: %lu bytes\n", sizeof(a_float));    // float: 4 bytes
    printf("double: %lu bytes\n", sizeof(a_double));  // double: 8 bytes

## Pointer
  A pointer is a memory address and a type to be expected in that memory address.
  It's the computers internal locker box name.
  The memory address always refers to volatile, not stored memory.
    Volatile means if the comoputer is turned off the data is lost.
  Arrays are a shortand syntax (sugar) for memory addresses.
  Always initialize to a meaningful value or set to null.
    Segmentation fault from a null reference is preferable to
    unknown effects on a the computer, including other programs.

  int n = 42;
  // Declaration
  // Three different syntaxes
  int *mypointer;   // declare a pointer
  int* mypointer;   // declare a pointer
  int * mypointer;  // declare a pointer. Note this has nothing to do with multiplication
                    // it must be the same type as what it points to
  mypointer = &n;   // & means get_memory_address_of n
  printf("mypointer address: %p\n", mypointer);  // %p format
  printf("mypointer's variable's contents: %i", *mypointer);
    // *mypointer means get the contents of this address.

    Arrays are a shortand syntax for memory addresses

    char *greeting = "hello";  // At memory address I call greeting store this...
    char greeting2[] = "hello";  // At the memory address I call greeting2, store this

    for (int i = 0; i < 5; i++)
    {
        putchar(*greeting);    // print this: * = the contents, greeting = memory address
        greeting++;            // go to the next memory address
    }                          // ++ uses the type char to know how far to go

    printf("\n");

    for (int i = 0; i < 5; i++)
    {
        putchar(greeting2[i]);   // print this:
                                 // greeting2: go to this memory address I've called greeting2
                                 // []: get the contents of
                                 // i: go this far from the beginning
    }

    return 0;

## File Pointers
Required library:
#include <stdio.h>

fopen( <filename>,  <operation> )
  Example
  FILE *fruitsfilepointer = fopen("fruits.txt", "r");
  <operations> may be read, write, or append, designated by "r", "w", "a"
  fopen may return NULL, so you need to write a condition to handle that.

fclose
    fclose(<filepointer>);
    fclose(fruitsfilepointer);

fgetc
    Requires that the file pointer has a read operation.
    This duplicates the linux program cat
        char c;
        while (c = fgetc(myfile) != EOF)
            printf("%c", c);
        // EOF is a special object defined stdio.h that identifies the end of a file
fputc
    Requires that the file pointer has write or append operation.
    fputc( <character>, <filepointer> )
    fputc('a', myfilepointer);

    Here's a program that simulates the linux copy program 'cp'
        char c;
        while (c = fgetc(myfile) != EOF)
            fputc(c, mynewfile);

fread
    fread( <buffer/memory address>, <unit size>, <unit quantity>, <file pointer> )
    Example
        // On the stack
        int array_on_the_stack[10];
        fread(array_on_the_stack, sizeof(int), 10, myfilepointer);

        // On the heap
        int *arr_on_the_heap = malloc(sizeof(int) * 10;
        fread(arr_on_the_heap, sizeof(int), 10, myfilepointer);

        // With a character
        char c;
        fread(&c, sizeof(char), 1, myfilepointer);

fwrite
    fwrite( <buffer/memory address>, <unit size>, <unit quantity>, <file pointer> )
    Example
      int arr[3] = { 10, 20, 30 };
      fwrite(arr, sizeof(int), 3, myfilepointer)

More functions:
    fgets / fputs:  work with strings
    fprintf:        similar to printf, but outputs to the file pointer
    fseek:          allows you to move rewind or fastforward in the file pointer
    ftell:          gives you the current location
    feof:           check if you're at the end of the file
    ferror:         check if there's an error

Hexadecimal
    A 16 base numbering system more friendly than binary.
    Useful for memory addresses.
    Not used for math.
    1 char = 1 byte = 2 hex = 8 bits = contains 256 possibilities

## Bitwise Operators
    int main()
{

    int one = 1;                         // 00000001
    int two = 2;                         // 00000010

    // Bitwise operations
    int two_numbers_anded = one & two;   // 00000000
    int two_numbers_ored = one | two;    // 00000011
    int two_numbers_xored = one ^ two;   // 00000011

    // Shifts do not rotate! 0's fill in from
    // the incoming direction
    int number_shifted_left = one << 1;  // 00000010
    int number_shifted_right = one >> 1; // 00000000

    int not_number = ~one;               // 11111110

    printf("two_numbers_anded: %i\n", two_numbers_anded);
    printf("two_numbers_ored: %i\n", two_numbers_ored);
    printf("two_numbers_xored: %i\n", two_numbers_xored);
    printf("number_shifted_left: %i\n", number_shifted_left);
    printf("number_shifted_right: %i\n", number_shifted_right);
    printf("not_number: %i\n", not_number);

    printf("%i\n", 225 >> 4);

## Silence Unused Variable

```
(void) x
```

## Stack versus Heap
### When To Use
| Memory | Usage |
| - | - |
| Stack | Use when the size is known and not too big. |
| Heap | Use when the size is unkown or big. |

### Gotcha
Good
```c
  char *string1 = malloc(100); // Put on HEAP
  char string2 = "string2";    // Put on STACK
```
Bad
```c
  char *string3 = "string3";   // Put on READ ONLY MEMORY (Compiler dependent)
  string3[0] = 'x';            // Segmentation fault!!!
```
*Read more on [stackoverflow](https://stackoverflow.com/questions/1011455/is-it-possible-to-modify-a-string-of-char-in-c).
