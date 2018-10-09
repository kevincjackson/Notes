## Modules
### Solution 1: Inline
Code lives in the html.  
Drawbacks:  
* Code can't be reused without copying and pasting.
* Order dependent.
* Collisions.

```js
<html>
  <body>
    <script>
      // JS CODE
    </script>
  </body>
</html>
```

### Solution 2: Scripts
Code is separated into files.  
Drawbacks:
* Order dependent.
* Collisions.

```js
<script type="text/javascript" src="./script1.js"></script>
<script type="text/javascript" src="./script2.js"></script>
<script type="text/javascript" src="./script3.js"></script>
```

### Solution 3: IIFE
Use function scope to hide code.  
Drawbacks:
* Order dependent.
* Not very pretty.

```js
var myApp = (function() {
    var private_stuff = { not_shared: "secret" }; // invisible
    var public_stuff = { shared: "Hello!" };
    return public_stuff;
})();
myApp.shared // "Hello!"
myApp.not_shared // undefined
```

### Solution 4: Browserify
A command line utility which bundles your code into one file.  
Drawbacks:
* Still a little requires an extra step from the command line.  

```js
// foo.js
module.exports = function foo() {
  return "foo"
};

// index.js
var foo = require("./foo");
```
```bash
$ browserify index.js foo.js -o bundle.js
```

### Solution 5: Webpack and ES6 Native Import and Export
Webpack replaces browserify using a config file.  
Drawbacks:
* Not fully supported natively.
* Import Webpack if not supported.

#### Export Selected Variables
```js
// sayings.js
export const welcome = () => "hi";
export const goodbye = () => "bye";

// File 2
import { welcome, goodbye } from './sayings'
```

#### Export One Thing Only
```js
// add.js
export default const add = (a, b) => a + b;

// File 2
import add from './add'
```

## ES6 Features
### Arrow Functions
New syntax is provided for functions.
Re-binds `this` to the Class.
#### Concise Syntax Arrow Function
No `return` required.
```js
const add = (a, b) => a + b;
```
#### Arrow Function With {}
`return` required.
```js
const add = (a, b) => { return a + b };
```
#### Normal Function Definition
Same as the above two.
```js
var add = function (a, b) {
  return a + b;
}
```
### Const and Let
`const` cannot be **reassigned**.
```js
const x = 0;
x = 5; // Error!
```
`let` is scoped to the `{}`. Note this unlike the mathematical, or Scheme concept of `let`.
```js
if (true) {
  let x = 11;
}
x; // Error!
```
### Destructuring Assignment
Quickly assign variables using a new syntax
#### Array Destructuring Assignment  
```js
const [a, b, c] = [11, 22, 33]; // Assigns a, b, and c.
a // 11
b // 22
c // 33
```
#### Object Destructuring Assignment
You *must* use the same key name.
```js
const reindeer = { name: "Rudolph", position: 1 };
const { name, position } = reindeer; // Assigns name and position
name; // "Rudolph"
position; // 1
```
### Dynamic Object Keys
Expressions in the key are evaluated. You must use `[]` to force the evaluation.
```js
obj = { ["a" + "b"]: "a" + "b" };
// Object { ab: "ab" }
```
The value will be assigned the variable value if no value is given.
```js
const x = 11;
const y = 22;
const obj = { x, y };  // Object { x: 11, y: 22 }
```
### Template Strings
```js
const name = "Santa";
`${name}` // "Santa"
```
### Default Arguments
```js
const add = (a=0, b=0) => a + b;
add(); // 0
```

### Symbols
```js
Symbols create unique objects.
let x = Symbol('1');
let y = Symbol('1');
x === y; // false
```
