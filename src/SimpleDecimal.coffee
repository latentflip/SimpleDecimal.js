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
        @precision = parts[0].length
        @scale = 0
      else
        @scale = parts[1].length
        @precision = parts[0].length + parts[1].length

      @intval = parseInt (parts[0] + parts[1]), 10
      @precision = @precision - 1 if @isNegative()
  
  toString: ->
    str = "#{@intval}"
    return str if @scale == 0

    str = str[1...str.length] if @isNegative()

    if @precision > str.length
      str = new Array(@precision-str.length+1).join('0')+str
    
    intlength = str.length - @scale
    str = str[0...intlength] + '.' + str[intlength..str.length]
    str = '-'+str if @isNegative()
    str
  toFloat: ->
    parseFloat(@toString())

  setScale: (newScale) ->
    growth = newScale - @scale
    if growth > 0
      @intval = @intval * Math.pow(10,growth)
      @scale = newScale
      @precision = @precision + growth

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
