describe "SimpleDecimal", ->
  assert_equal = (a,b) ->
    expect(a).toEqual(b)
  assert = (a) ->
    expect(true).toEqual(a)
  assert_decimal = (d,s) ->
    expect(d.toString()).toEqual(s)
  _d = (s) ->
    new SimpleDecimal(s)

  beforeEach ->
    @d = _d('123.45')
    @d2 = _d('234.56')

  it "should work for regular numbers", ->
    assert_equal @d.intval, 12345
    assert_equal @d.scale, 2
    assert_equal @d.precision, 5
    assert_equal @d.toString(), '123.45'
  
  it "should work for small numbers", ->
    @d = _d('0.00001')
    assert_equal @d.intval, 1
    assert_equal @d.scale, 5
    assert_equal @d.precision, 6
    assert_decimal @d, '0.00001'

  it "should work for integers only", ->
    @d = _d('12345')
    assert_equal @d.intval, 12345
    assert_equal @d.scale, 0
    assert_equal @d.precision, 5
    assert_decimal @d, '12345'

  it "should work for weird numbers", ->
    assert_decimal _d('0000.0001'), '0.0001'
    assert_decimal _d('.0001'), '0.0001'
    assert_decimal _d('123.0001'), '123.0001'

  it "should work for negative numbers", ->
    assert_decimal _d('-123'), '-123'
    assert_decimal _d('-123.00'), '-123'
    assert_decimal _d('-0000.0001'), '-0.0001'
    assert_decimal _d('-.0001'), '-0.0001'
    assert_decimal _d('-123.0001'), '-123.0001'

  it "should increase scale", ->
    @d.setScale(5)
    assert_equal @d.intval, 12345000
    assert_equal @d.scale, 5
    assert_equal @d.precision, 8

  it "should add two of different lengths", ->
    ans = @d.add _d('0.0001')
    assert_equal ans.intval, 1234501
    assert_equal ans.scale, 4
    assert_decimal ans, '123.4501'

  it "should add small numbers", ->
    a = _d('0.00002')
    b = _d('100.0000001')
    assert_decimal a.add(b), '100.0000201'

  it "should add two that increase precision", ->
    ans = @d.add _d('123')
    assert_decimal ans, '246.45'

  it "should subtract two of different lengths", ->
    ans = @d.subtract _d('0.0001')
    assert_equal ans.intval, 1234499
    assert_equal ans.scale, 4
    assert_decimal ans, '123.4499'

  it "should result in a negative", ->
    assert_decimal _d('100.12').subtract(_d('200.00')), '-99.88'

  it "should add positive to negatives", ->
    assert_decimal _d('-123.45').add(_d('100.1')), '-23.35'
    assert_decimal _d('-123.45').add(_d('150.123')), '26.673'

  it "should add negatives to positives", ->
    assert_decimal _d('123.45').add(_d('-100.1')), '23.35'
    assert_decimal _d('123.45').add(_d('-150.123')), '-26.673'

  it "should subtract positive from negatives", ->
    assert_decimal _d('-123.45').subtract(_d('100.1')), '-223.55'
    assert_decimal _d('-123.45').subtract(_d('150.123')), '-273.573'

  it "should subtract negatives from positives", ->
    assert_decimal _d('123.45').subtract(_d('-100.1')), '223.55'
    assert_decimal _d('123.45').subtract(_d('-150.123')), '273.573'
    
  it "should repeat a lot", ->
    for i in [1..100000]
      do (i) ->
        _d('2.34').add _d('1.23')
    
  it "should abs numbers", ->
    assert_decimal _d('-123.45').abs(), '123.45'
    assert_decimal _d('123.45').abs(), '123.45'

  it "should invert numbers", ->
    assert_decimal _d('123.45').invert(), '-123.45'
    assert_decimal _d('-123.45').invert(), '123.45'
  
  it "should convert to floats", ->
    assert_equal _d('123.45').toFloat(), 123.45
