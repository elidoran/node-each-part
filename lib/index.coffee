{Transform} = require 'stream'

class EachPart extends Transform
  constructor: (options) -> @reset options

  _transform: (string, encoding, next) ->

    # ensure it's a string not a buffer
    string = string.toString 'utf8'

    # split on the delim
    strings = string.split @_delim

    # if we didn't find a delim then the length is 1
    if strings.length is 1
      # save the string, combine with previously saved string if it exists
      @_string = if @_string? then @_string + string else string

    # else we found at least one delim
    else
      # if there's a stored string combine that with the first part
      if @_string?
        # combine with first part, remove first part from array
        string = @_string + strings.shift()
        # delete stored string
        delete @_string
        # push the string as an object and emit it
        @_part string

      # get last one, which doesn't have a delim after it yet, remove it from array
      tail = strings.pop()

      # if tail is '' then the last character was the delim, so, we ignore that
      # so, only store it if it has length
      if tail.length > 0 then @_string = tail

      # if there's anything left in the array then it's a part
      @_part s for s in strings

    # all done with this chunk
    next()

  # push any remaining string and we're done
  _flush: (done) -> if @_string? then @_part @_string ; done()

  _part: (string) ->
    @push string:string  # push as an object
    @emit 'part', string # emit as an event

  reset: (options) ->
    # set new options if provided, ensure objectMode:true is set
    if options?
      options.objectMode = true
      @options = options
    else
      @options = objectMode:true

    # rerun constructor to reconfigure it
    Transform.call this, @options

    # default delim is newpart or carriage return or either combo of both
    @_delim = @options.delim ? /\r\n|\n\r|\n|\r/

    # delete any stored string
    delete @_string

    # return for chaining
    return this

# export a function which creates an EachPart instance
module.exports = (options) -> new EachPart options

# export the class as a sub property on the function
module.exports.EachPart = EachPart
