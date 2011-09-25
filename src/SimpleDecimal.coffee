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
      cleanstring = stringval.replace(/[^\d\.]/, '')
      parts = cleanstring.split '.'
      if parts.length == 1
        @precision = parts[0].length
        @scale = 0
      else
        @scale = parts[1].length
        @precision = parts[0].length + parts[1].length

      @intval = parseInt (parts[0] + parts[1]), 10
  
  toString: ->
    str = "#{@intval}"

    return str if @scale == 0

    if @precision > str.length
      str = new Array(@precision-str.length+1).join('0')+str
    
    intlength = str.length - @scale
    str[0...intlength] + '.' + str[intlength..str.length]

  setScale: (newScale) ->
    growth = newScale - @scale
    if growth > 0
      @intval = @intval * Math.pow(10,growth)
      @scale = newScale
      @precision = @precision + growth

  add: (other) ->
    DecimalMath.add(@, other)
  subtract: (other) ->
    DecimalMath.subtract(@, other)
