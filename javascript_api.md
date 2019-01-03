## Express
The most popular lightweight Javascript Nodejs server.

## Quick Setup
Installation:
```bash
# Shell
mkdir myproject
cd myproject
npm init -y
npm install express
npm install body-parser # For handling forms or JSON
npm install nodemon --save-dev # For automatic reloading
npm install cors # Allow other computers to make requests
touch server.js # Our server
sed 's/"test".*/"start": "nodemon server.js"/' package.json > temp.txt; mv temp.txt package.json
npm start
# Setup server.js using below as a guide or as desired
```


## Express Server File
Here's an annotated server file.
```js
// server.js
// Express is a lightweight server
const express = require('express');

// Initialize the express app
const app = express();

// Set the port for local development
// Once started the server will listen on http://localhost:30000
const port = 3000;

// Body Parser allows processing of web forms
// Commonly used with almost all express apps
// Body parser docs
// https://www.npmjs.com/package/body-parser
const bodyParser = require('body-parser');

// Cors allows other computers (cross-origin) to make requests
// Since this is an API this makes sense.
// Docs: https://www.npmjs.com/package/cors
const cors = require('cors');

// 'use' indicates middleware
// Enable cross origin requests
app.use(cors())

// Body parser must be told specifically what to parse
// Body Parser will process web forms
app.use(bodyParser.urlencoded({extended: false}));

// Body Parser will process JSON
app.use(bodyParser.json());

// Static refers to files which will not go through the app
// For example going to '/hello.txt'
// will load that file from project public directory.
// You do not put 'public' in the path name
// '__dirname' refers to the current directory
app.use(express.static(__dirname + '/public'));

// Custom middleware
app.use((req, res, next) => {
  console.log('custom middleware');

  // Required. Call next on custom middleware
  // or the server will hang
  next();
});

// This will respond to get requests matching something like this
// http://localhost:3000/user/james?zipcode=12345
app.get('/user/:id', (req, res) => {

  // body refers to any web form values,
  // there's none in this example
  console.log(req.body);

  // header refers to the request metadata,
  // such as 'content-type': 'application/json'
  console.log(req.headers);

  // params is a path regex
  // For http://localhost:3000/user/james?zipcode=12345
  // params is { id: 'james' }
  // It does not match after the '?'. See below
  console.log(req.params);

  // query gets the key values after '?'' in the path
  // For http://localhost:3000/user/james?zipcode=12345
  // query is { zipcode: "12345" }
  console.log(req.query);

  // Specify status if desired, defaults to 200
  // For example status 401 indicates Unauthorized
  // https://www.restapitutorial.com/httpstatuscodes.html
  res.status(401)

  // The content that is returned
  res.send("get user");

  // You can use json() instead of send() for JSON.
  res.json({ status: "OK"})
})

// Required. Actually launches the app
app.listen(port);
```

## Postman
A great web api tool. Easily for checking 'post', 'put', 'delete' requests, etc.

- Installation: download directly from the website
- Website: <https://www.getpostman.com/>
- How to use:
  - Choose your http verb 'get', 'post' + path
  - Set any queries using 'Params' or put in your request
  - Test html forms using 'Body/x-www-form-urlencoded'
  - Test JSON forms using 'Body/raw + text/JSON'
  - That's it!

## Building An API
- Build without using front end
- Use Postman
- Plan all your routes, called endpoints, and connect to front end when you're done.

## Storing Passwords Using Bcrypt
- Bcrypt is an industry standard
- Installation: `npm install bcrypt-nodejs`
- Docs: <https://www.npmjs.com/package/bcrypt-nodejs>
- Require: `const bcrypt = require('bcrypt-nodejs')`

Example Synchronous Usage:

```js
const hash = bcrypt.hashSync("password");
const valid =  bcrypt.compareSync("password", hash); // -> true | false
```
