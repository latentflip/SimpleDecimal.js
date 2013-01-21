@DecimalMath =
  matchScales: (a,b) ->
    if a.scale == b.scale
      return a.scale
    else if a.scale > b.scale
      b.setScale a.scale
      return a.scale
    else
      a.setScale b.scale
      return b.scale

  add: (a,b) ->
    ans = new SimpleDecimal()
    ans.scale = @matchScales(a,b)
    ans.intval = a.intval + b.intval
    ans
  subtract: (a,b) ->
    ans = new SimpleDecimal()
    ans.scale = @matchScales(a,b)
    ans.intval = a.intval - b.intval
    ans

class @SimpleDecimal
  constructor: (stringval) ->
    if stringval
      cleanstring = parseFloat(stringval).toString()
      parts = cleanstring.split '.'
      if parts.length == 1
        @scale = 0
      else
        @scale = parts[1].length

      @intval = parseInt (parts[0] + parts[1]), 10
  
  valueOf: ->
    @toFloat()
  toJSON: ->
    @toString()
  toString: ->
    @toFloat().toFixed(@scale)
  toFloat: ->
    @intval * Math.pow(10, -1 * @scale)

  setScale: (newScale) ->
    growth = newScale - @scale
    if growth > 0
      @intval = @intval * Math.pow(10,growth)
      @scale = newScale

  isNegative: () ->
    @intval < 0
  isPositive: () ->
    !@isNegative()
  add: (other) ->
    DecimalMath.add(@, other)
  subtract: (other) ->
    DecimalMath.subtract(@, other)

  invert: ->
    DecimalMath.subtract(new SimpleDecimal('0'), @)
  clone: ->
    DecimalMath.add(new SimpleDecimal('0'), @)
  abs: ->
    return @invert() if @isNegative()
    return @clone()
