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
buildEach = require 'each-part'

# uses newline or carriage return by default
# outputs `part` object by default, which contains `string` and `delim`
eachLine = buildEach()

eachLine.on 'part', (part, delim) ->
  # do something with the part.
  # when readableObjectMode is true, the default, then `part` is an object
  # with two properties: `string` and `delim`
  # when it's not true (you specify it as false in options) then `part` is the
  # string. The second arg is always `delim`

eachLine.on 'error', (error) -> # do something with the error...

eachLine.on 'finish', (error) -> # all done...

# part is also passed on as an object to the next stream using objectMode:true
targetStream = require('through2') (part, _, next) ->
  # do something with the part: part.string
  console.log 'part:',part.string
  next()

someStream.pipe(eachLine)

# can provide options to override the delimiter used:
eachPipe = buildEach delim:'|'

# can be a regular expression:
eachBlah = buildEach delim:/blah/


# to pass `string` to the next stream, set readableObjectMode to false:
eachLine = buildEach readableObjectMode:false
# when you do that, then:
#   1. the stream it pipes to will receive strings as chunks
#   2. the 'part' event will provide the string as the first arg, not an object
#  Note: this means the next stream will not know the delimiter found
```

## MIT License
