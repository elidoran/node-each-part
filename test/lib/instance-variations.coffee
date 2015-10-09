assert = require 'assert'

describe 'test require each-part', ->

  describe 'without arguments', ->

    it 'should return builder function', ->

      eachPart = require '../../lib'

      assert.equal typeof(eachPart), 'function', 'eachPart should be a Function'

  describe 'with empty arguments', ->

    it 'should return an EachPart class instance', ->

      eachPart = require('../../lib')()

      assert.notEqual typeof(eachPart), 'function', 'eachPart should be a class instance'

  describe 'with options argument', ->

    it 'should create an EachPart class instance with string', ->

      testOptions = delim:'blah'

      eachPart = (require '../../lib') testOptions

      assert.deepEqual eachPart.options, testOptions

  describe 'with destructuring for class', ->

    it 'should extract exported class', ->

      {EachPart} = require '../../lib'

      assert EachPart
