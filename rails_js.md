# Rails <-> Javascript
## JSON
Javascript Object Notation, JSON, is a popular, compact, human readable data format specified by Douglas Crockford in the early 2000's.  

## JSON Vesus XML
JSON and XML comprise the two main data formats for the web.
JSON is more compact and works well for serialization (moving data).
XML is more customizable and works well for configuration.

### Valid JSON Types
```json
1
3.14
"Hello"
true
false
null
```
### Valid JSON Collections
Note that unlike Javascript, object keys **must** be surrounded by double quotes.
```json
[1, 3.14, "Hello", true, false, null]
{"myMessage": "Hello"}
```
### Sample JSON File
```json
{
  "myObject": 
    {
      "myString": "Hello",
      "myFloat": 3.14,
      "myBoolean": true,
      "mySecondBoolean": false,
      "myNestedArray": [0, 1, 2],
      "myNestedObject": {"a": "apple"},
      "myNullObject": null
    }
}
```
### JSON Methods in Javascript
#### Basic Usage
```js
    // Convert javascript to json.
    // javascript -> json
    // JSON.stringify( javascript )
    JSON.stringify( [1, 3.14, "Hello", true, false, null] )
      // yields "[1,3.14,\"Hello\",true,false,null]"
      
    // Converson json to javascript
    // json -> javascript
    // JSON.parse( json )
    JSON.parse( "[1,3.14,\"Hello\",true,false,null]" )
      //yields [1, 3.14, "Hello", true, false, null]
```
#### Advanced Usage Signatures
```js
  // filter maybe an array of keys which will be included (others ignored)
  // filter may also be a function which does the same as above
  // indentation may be an integer, or a string
  JSON.stringify( js, filter, indentation)

  // reviver may be a function which modifies the JSON
  JSON.parse( json, reviver )

  
  // Note that in the following example a JS date gets "revived" as a string
  myDate = new Date( 2018, 1, 1 )   // Thu Feb 01 2018 00:00:00 GMT-0800 (PST)
  myJSON = JSON.stringify( date1 ) //  "\"2018-02-01T08:00:00.000Z\""
  JSON.parse( myJSON )             // "2018-02-01T08:00:00.000Z"

  // In this version a reviver function is passed
  JSON.parse( myJSON, function(key, value) {
    return new Date( value );
  })
  myDate = new Date( 2018, 1, 1 )   // Thu Feb 01 2018 00:00:00 GMT-0800 (PST)
  myJSON = JSON.stringify( date1 ) //  "\"2018-02-01T08:00:00.000Z\""
  roundTrippedDate = JSON.parse( myJSON, function(key, value) {
    return new Date( value );
  })
  myDate.getTime() === roundTrippedDate.getTime() // true
  // Sidenote getTime() is used because javascript does not compare dates as expected.
```

