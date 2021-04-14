API Notes

## Description
Anything that allows machines to communicate. It doesn't have to be a
website. It can be the back of a TV.


## Free API's
| Site | Description |
| - | - |
| <https://jsonplaceholder.typicode.com/> | Users, Comments |
| <https://swapi.co/> | Star Wars |
| <https://apilist.fun/> | List of fun API's for making a project. |
| <https://api.github.com/users/apple/> | Github user info |


## Serious API's
Charge based on usage. Consumers are tracked using their API key.


## Models
- Use custom API Models, not your programming language models, because API's represent a long term contract.
- Use non-meaningful (surrogate) keys; don't expose business (natural) keys like SSN's.
- 

## Security
- Physical: lock your server room.
- CORS: Just for your domain, certain domains, or everybody.
- Authentication: Use tokens


## HTTP Verbs
- It's OK to have practical non-resource routes on occasion. Eg) api/reloadconfig. Use HttpOptions verb instead of the standard GET, POST, etc.


## Terminology
- Action-Controller -> Method-Class
