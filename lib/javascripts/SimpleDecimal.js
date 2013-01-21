(function() {
  this.DecimalMath = {
    matchScales: function(a, b) {
      if (a.scale === b.scale) {
        return a.scale;
      } else if (a.scale > b.scale) {
        b.setScale(a.scale);
        return a.scale;
      } else {
        a.setScale(b.scale);
        return b.scale;
      }
    },
    add: function(a, b) {
      var ans;
      ans = new SimpleDecimal();
      ans.scale = this.matchScales(a, b);
      ans.intval = a.intval + b.intval;
      return ans;
    },
    subtract: function(a, b) {
      var ans;
      ans = new SimpleDecimal();
      ans.scale = this.matchScales(a, b);
      ans.intval = a.intval - b.intval;
      return ans;
    }
  };
  this.SimpleDecimal = (function() {
    function SimpleDecimal(stringval) {
      var cleanstring, parts;
      if (stringval) {
        cleanstring = parseFloat(stringval).toString();
        parts = cleanstring.split('.');
        if (parts.length === 1) {
          this.scale = 0;
        } else {
          this.scale = parts[1].length;
        }
        this.intval = parseInt(parts[0] + parts[1], 10);
      }
    }
    SimpleDecimal.prototype.valueOf = function() {
      return this.toFloat();
    };
    SimpleDecimal.prototype.toJSON = function() {
      return this.toString();
    };
    SimpleDecimal.prototype.toString = function() {
      return this.toFloat().toFixed(this.scale);
    };
    SimpleDecimal.prototype.toFloat = function() {
      return this.intval * Math.pow(10, -1 * this.scale);
    };
    SimpleDecimal.prototype.setScale = function(newScale) {
      var growth;
      growth = newScale - this.scale;
      if (growth > 0) {
        this.intval = this.intval * Math.pow(10, growth);
        return this.scale = newScale;
      }
    };
    SimpleDecimal.prototype.isNegative = function() {
      return this.intval < 0;
    };
    SimpleDecimal.prototype.isPositive = function() {
      return !this.isNegative();
    };
    SimpleDecimal.prototype.add = function(other) {
      return DecimalMath.add(this, other);
    };
    SimpleDecimal.prototype.subtract = function(other) {
      return DecimalMath.subtract(this, other);
    };
    SimpleDecimal.prototype.invert = function() {
      return DecimalMath.subtract(new SimpleDecimal('0'), this);
    };
    SimpleDecimal.prototype.clone = function() {
      return DecimalMath.add(new SimpleDecimal('0'), this);
    };
    SimpleDecimal.prototype.abs = function() {
      if (this.isNegative()) {
        return this.invert();
      }
      return this.clone();
    };
    return SimpleDecimal;
  })();
}).call(this);
