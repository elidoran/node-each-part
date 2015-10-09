# each-part
[![Build Status](https://travis-ci.org/elidoran/node-each-part.svg?branch=master)](https://travis-ci.org/elidoran/node-each-part)
[![Dependency Status](https://gemnasium.com/elidoran/node-each-part.png)](https://gemnasium.com/elidoran/node-each-part)
[![npm version](https://badge.fury.io/js/each-part.svg)](http://badge.fury.io/js/each-part)

Transform stream which emits each part and pushes object with part.

Uses newline and carriage return for default delimiter (one or both in either order).

## Install

```sh
npm install each-part --save
```

## Usage

```coffeescript
eachLine = require 'each-part'

each = eachLine()
each.on 'part', (part) -> # do something with the part
each.on 'error', (error) -> # do something with the error...
each.on 'finish', (error) -> # all done...

# part is also passed on as an object to the next stream using objectMode:true
targetStream = require('through2') (part, _, next) ->
  # do something with the part: part.string
  console.log 'part:',part.string
  next()

someStream.pipe(each)

# can provide options to override the delimiter used:
each = eachLine delim:'|'

# can be a regular expression:
each = eachLine delim:/blah/
```

## MIT License
