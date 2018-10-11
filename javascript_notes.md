## NPM

### Node Package Manager Key Concepts

| Question | Answer                                                                |
| -------- | --------------------------------------------------------------------- |
| Who?     | Original Author: Isaac Z. Schlueter                                   |
| What?    | Share (download) Javascript code easily. Also used to automate tasks. |
| Where?   | <https://www.npmjs.com/>                                              |
| Why?     | Makes code management a lot easier than doing it yourself.            |
| When?    | Started 2010.                                                         |
| How?     | `npm install DESIRED_CODE` for installing.                            |
| How?     | `npm run TASK` for task running.                                      |

### Cheatsheet

```bash
npm init       # Answer questions
npm init --y   # Ignore questions
npm install CODE              # Install for the project
npm install --save   CODE     # Install for the project. (Same as above)
npm install --global CODE     # Install on the machine, not just for project.
npm install --save-dev  # Useful for developing only, not needed for production.
```

### Node Cheatsheet

Node is an implementation of CommonJS, a project to liberate JS from the browser,
and onto desktop, servers, etc. It uses `require` statements as opposed to
`webpack`, a more modern program which uses `import` / `export` statements but fully implemented.

```bash
node script.js # Interpret js without the browser.
npm install nodemon # Install node monitor.
nodemon script.js  # Interpret and loop as above.
browserify script1.js script2.js > bundle.js  # Bundle javascript files.
```

## Modules

### Overview

| Concept                                                                 | Name               | Tools                           |
| ----------------------------------------------------------------------- | ------------------ | ------------------------------- |
| Manually download and manage css, and js yourself.                      | Old School         | All You                         |
| Code is downloaded for you.                                             | Package Management | `yarn`, `npm`                   |
| Multiple JS files are bundled into one file.                            | Bundling           | `webpack`, `browserify`         |
| Automatically common tasks, such as the above.                          | Task Running       | `npm run TASK`, `gulp`, `grunt` |
| Convert modern code into older code for older browsers (usual use case) | Transpiling        | `babel`                         |

### Solution 1: Inline

Code lives in the html.  
Drawbacks:

- Code can't be reused without copying and pasting.
- Order dependent.
- Collisions.

```js
<html>
  <body>
    <script>// JS CODE</script>
  </body>
</html>
```

### Solution 2: Scripts

Code is separated into files.  
Drawbacks:

- Order dependent.
- Collisions.

```js
<script type="text/javascript" src="./script1.js"></script>
<script type="text/javascript" src="./script2.js"></script>
<script type="text/javascript" src="./script3.js"></script>
```

### Solution 3: IIFE

Use function scope to hide code.  
Drawbacks:

- Order dependent.
- Not very pretty.

```js
var myApp = (function() {
  var private_stuff = { not_shared: "secret" }; // invisible
  var public_stuff = { shared: "Hello!" };
  return public_stuff;
})();
myApp.shared; // "Hello!"
myApp.not_shared; // undefined
```

### Solution 4: Browserify

A command line utility which bundles your code into one file.  
Drawbacks:

- Still a little requires an extra step from the command line.

```js
// foo.js
module.exports = function foo() {
  return "foo";
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

- Not fully supported natively.
- Import Webpack if not supported.

#### Export Selected Variables

```js
// sayings.js
export const welcome = () => "hi";
export const goodbye = () => "bye";

// File 2
import { welcome, goodbye } from "./sayings";
```

#### Export One Thing Only

```js
// add.js
export default const add = (a, b) => a + b;

// File 2
import add from './add'
```

#### Setting Up Webpack

```bash
# npm is required
$ npm init -y

# Install webpack and it's command line app
$ npm install webpack webpack-cli webpack-dev-server --save-dev

# Example running webpack
#   webpack
#     --entry UNBUNDLED.js
#     --output BUNDLED.js
#     --mode=(development|production)  minify option
$ ./node_modules/.bin/webpack index.js --mode=development
```

Update `index.html`.

```html
<script src="dist/main.js"></script>
```

Setup config file: `webpack.config.js` in root to automate the above.

```
module.exports = {
  mode: 'development',
  entry: './index.js',
  output: {
    filename: 'main.js',
    publicPath: 'dist',
  },
};
```

Updating is easier now....

```bash
$ ./node_modules/.bin/webpack
```

But better with task runners to **package.json**.
Note that **node** knows the location of executables, so no `./node_modules/.bin` is necessary.

```json
"scripts": {
  "test": "echo \"Error: no test specified\" && exit 1",
  "build": "webpack --progress -p",
  "watch": "webpack --progress --watch",
  "server": "webpack-dev-server --open"
},
```

Usage

```bash
$ npm run build # Minified (production) build.
$ npm run watch # JS auto updates, but you need to manually refresh the page.
$ npm run server # JS auto updates, and page reloads.
```

With transpiling:

```bash
$ npm install @babel/core @babel/preset-env babel-loader --save-dev
```

```js
// webpack.config.js
module.exports = {
  mode: "development",
  entry: "./index.js",
  output: {
    filename: "main.js",
    publicPath: "dist"
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env"]
          }
        }
      }
    ]
  }
};
```

#### Credit

Amazing article for getting up to speed!

<https://medium.com/the-node-js-collection/modern-javascript-explained-for-dinosaurs-f695e9747b70>

### Tools Change Fast!

2017 Top Tools (2 per category).
See [StateofJS](https://stateofjs.com/) for current trends.

| Item              | Tool             |
| ----------------- | ---------------- |
| Front End         | React, None      |
| State             | Rest, Redux      |
| Back End          | Express, Koa     |
| Testing           | Mocha, Jasmine   |
| CSS               | SASS, CSS        |
| Build             | NPM, Webpack     |
| Mobile            | Native, Electron |
| Package Mananager | Yard, NPM        |
| Utilities         | lodash, jQuery   |
| Editor            | VSCode, Atom     |
| Linter            | eslint, prettier |

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
const add = (a, b) => {
  return a + b;
};
```

#### Normal Function Definition

Same as the above two.

```js
var add = function(a, b) {
  return a + b;
};
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
a; // 11
b; // 22
c; // 33
```

#### Object Destructuring Assignment

You _must_ use the same key name.

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
const obj = { x, y }; // Object { x: 11, y: 22 }
```

### Template Strings

```js
const name = "Santa";
`${name}`; // "Santa"
```

### Default Arguments

```js
const add = (a = 0, b = 0) => a + b;
add(); // 0
```

### Symbols

```js
Symbols create unique objects.
let x = Symbol('1');
let y = Symbol('1');
x === y; // false
```

## Promises and Async Await

The following two are synonymous.  
Async allows you to write async code in a synchronous fashion.

### Promise

```js
fetch("https://jsonplaceholder.typicode.com/users")
  .then(response => response.json())
  .then(users => console.log(users));
```

### Async Await

```js
async function getUsers() {
  const response = await fetch("https://jsonplaceholder.typicode.com/users");
  const users = await response.json();
  console.log(users);
}
```

These two examples are the same as above with error handling.

### Promise With Catch

```js
fetch("https://jsonplaceholder.typicode.com/users")
  .then(response => response.json())
  .then(users => console.log(users))
  .catch("Error");
```

### Async Await With Try-Catch

```js
async function getUsers() {
  try {
    const response = await fetch("https://jsonplaceholder.typicode.com/users");
    const users = await response.json();
    console.log(users);
  } catch (error) {
    console.log("Error");
  }
}
```
