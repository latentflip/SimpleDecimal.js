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
        cleanstring = stringval.replace(/[^\d\.]/, '');
        parts = cleanstring.split('.');
        if (parts.length === 1) {
          this.precision = parts[0].length;
          this.scale = 0;
        } else {
          this.scale = parts[1].length;
          this.precision = parts[0].length + parts[1].length;
        }
        this.intval = parseInt(parts[0] + parts[1], 10);
      }
    }
    SimpleDecimal.prototype.toString = function() {
      var intlength, str;
      str = "" + this.intval;
      if (this.scale === 0) {
        return str;
      }
      if (this.precision > str.length) {
        str = new Array(this.precision - str.length + 1).join('0') + str;
      }
      intlength = str.length - this.scale;
      return str.slice(0, intlength) + '.' + str.slice(intlength, (str.length + 1) || 9e9);
    };
    SimpleDecimal.prototype.setScale = function(newScale) {
      var growth;
      growth = newScale - this.scale;
      if (growth > 0) {
        this.intval = this.intval * Math.pow(10, growth);
        this.scale = newScale;
        return this.precision = this.precision + growth;
      }
    };
    SimpleDecimal.prototype.add = function(other) {
      return DecimalMath.add(this, other);
    };
    SimpleDecimal.prototype.subtract = function(other) {
      return DecimalMath.subtract(this, other);
    };
    return SimpleDecimal;
  })();
}).call(this);
