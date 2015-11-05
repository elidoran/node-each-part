assert   = require 'assert'
eachLine = require '../../lib'
through  = require 'through2'
strung   = require 'strung'

describe 'test eachLine *as builder function*', ->

  describe 'with no delim', ->

    it 'should emit only the original string', (done) ->

      testString = 'some string'
      source = strung testString
      each = eachLine()
      each.on 'error', done
      each.on 'finish', done
      thru = through.obj (part, _, next) -> assert.equal part.string, testString
      each.on 'part', (part) -> assert.equal part.string, testString

      source.pipe(each).pipe thru

  # # #
  # TODO: combine the following tests into a loop
  # # #

  describe 'with a newline in the middle', ->

    it 'should emit two strings', (done) ->

      testString = 'some string\nfor testing'
      results = [ 'some string', 'for testing' ]
      eachIndex = 0
      thruIndex = 0
      source = strung testString
      each = eachLine()
      each.on 'error', done
      each.on 'finish', done
      each.on 'part', (part) ->
        assert.equal part.string, results[eachIndex]
        eachIndex++
      thru = through.obj (part, _, next) ->
        assert.equal part.string, results[thruIndex]
        thruIndex++
      source.pipe(each).pipe thru

  describe 'with a carriage return in the middle', ->

    it 'should emit two strings', (done) ->

      testString = 'some string\rfor testing'
      results = [ 'some string', 'for testing' ]
      eachIndex = 0
      thruIndex = 0
      source = strung testString
      each = eachLine()
      each.on 'error', done
      each.on 'finish', done
      each.on 'part', (part) ->
        assert.equal part.string, results[eachIndex]
        eachIndex++
      thru = through.obj (part, _, next) ->
        assert.equal part.string, results[thruIndex]
        thruIndex++
      source.pipe(each).pipe thru

  describe 'with a carriage return then a newline in the middle', ->

    it 'should emit two strings', (done) ->

      testString = 'some string\r\nfor testing'
      results = [ 'some string', 'for testing' ]
      eachIndex = 0
      thruIndex = 0
      source = strung testString
      each = eachLine()
      each.on 'error', done
      each.on 'finish', done
      each.on 'part', (part) ->
        assert.equal part.string, results[eachIndex]
        eachIndex++
      thru = through.obj (part, _, next) ->
        assert.equal part.string, results[thruIndex]
        thruIndex++
      source.pipe(each).pipe thru

  describe 'with a newline then a carriage return in the middle', ->

    it 'should emit two strings', (done) ->

      testString = 'some string\n\rfor testing'
      results = [ 'some string', 'for testing' ]
      eachIndex = 0
      thruIndex = 0
      source = strung testString
      each = eachLine()
      each.on 'error', done
      each.on 'finish', done
      each.on 'part', (part) ->
        assert.equal part.string, results[eachIndex]
        eachIndex++
      thru = through.obj (part, _, next) ->
        assert.equal part.string, results[thruIndex]
        thruIndex++
      source.pipe(each).pipe thru

  describe 'with a newline at the end', ->

    it 'should emit one string', (done) ->

      testString = 'some string\n'
      result = 'some string'
      source = strung testString
      each = eachLine()
      each.on 'error', done
      each.on 'finish', done
      each.on 'part', (part) -> assert.equal part.string, result
      thru = through.obj (part, _, next) ->
        assert.equal part.string, result
        next()
      source.pipe(each).pipe thru
