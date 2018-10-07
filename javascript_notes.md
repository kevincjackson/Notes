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
* Not fully supported yet.

```js
// File 1
export const foo = () => { "foo" };
// or
export default const foo = () => { "foo" };

// File 2
import { foo } from './foo'
// or
import add from './foo'
```
