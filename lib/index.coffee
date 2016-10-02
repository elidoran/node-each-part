{Transform} = require 'stream'
buildSearch = require 'stream-search-helper'

class EachPart extends Transform
  constructor: (options) -> @reset options

  _addString: (string) ->
    @_string = if @_string? then @_string + string else string

  _withString: (string) ->
    result = if @_string? then @_string + string else string
    delete @_string
    return result

  _transform: (string, encoding, next) ->

    # ensure it's a string not a buffer
    string = string.toString 'utf8'

    # search string with delim
    results = @_search string

    for result in results
      # a `string` result should be stored
      if result.string? then @_addString result.string

      # a `before` result should be added to stored string and passed to @_part
      # the `delim` result should be passed with @_part for informational purposes
      else if result.before? then @_part @_withString(result.before), result.delim

    # all done with this chunk
    next()

  # push any remaining string and we're done
  _flush: (done) ->
    string = @_withString @_search.end()?.string
    if string?.length > 0 then @_part string
    done()

  _part: (string, delim) ->
    part = # if object mode is on, then create an object, else use string
      if @options.readableObjectMode then string:string, delim:delim
      else string
    @push part
    @emit 'part', part, delim # emit as an event

  reset: (options) ->
    # set new options if provided, ensure objectMode:true is set
    if options?
      # only set it to true if it hasn't been specified already
      unless options.readableObjectMode? then options.readableObjectMode = true
      @options = options
    else
      @options = readableObjectMode:true

    # rerun constructor to reconfigure it
    Transform.call this, @options

    # default delim is newline or carriage return or either combo of both
    @options.delim ?= /\r\n|\n\r|\n|\r/
    # default min needed to match delim is 2 for the newline/carriage return combo
    @options.min   ?= 2

    @_search = buildSearch @options

    # delete any stored string
    delete @_string

    # return for chaining
    return this

# export a function which creates an EachPart instance
module.exports = (options) -> new EachPart options

# export the class as a sub property on the function
module.exports.EachPart = EachPart
