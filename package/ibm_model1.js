'use strict';
var IBM_Model_1;

IBM_Model_1 = (function() {
  var Pair, add;

  function IBM_Model_1() {
    this.prob = {};
    this.pair = {};
  }

  add = function(hash, key, num) {
    if (key in hash) {
      return hash[key] += num;
    } else {
      return hash[key] = num;
    }
  };

  Pair = (function() {

    function Pair(target, source) {
      this.target = target;
      this.source = source;
      this.string = "" + this.target + " " + this.source;
    }

    Pair.prototype.toString = function() {
      return this.string;
    };

    Pair.fromString = function(string) {
      var source, target, _ref;
      _ref = string.split(' '), target = _ref[0], source = _ref[1];
      return new Pair(target, source);
    };

    return Pair;

  })();

  IBM_Model_1.prototype.preprocess_tag = function(tags) {
    var v;
    if (tags.length === 1 && tags[0] === '') {
      tags[0] = 'NULLTAG';
    } else {
      tags.push('NULLTAG');
    }
    return tags = (function() {
      var _i, _len, _results;
      _results = [];
      for (_i = 0, _len = tags.length; _i < _len; _i++) {
        v = tags[_i];
        _results.push(v = v.toUpperCase());
      }
      return _results;
    })();
  };

  IBM_Model_1.prototype.preprocess = function(corpus) {
    var i, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = corpus.length; _i < _len; _i++) {
      i = corpus[_i];
      i[0] = this.preprocess_tag(i[0]);
      _results.push(i[1] = this.preprocess_tag(i[1]));
    }
    return _results;
  };

  IBM_Model_1.prototype.count = function(corpusPair) {
    var j, k, p, _i, _len, _ref, _results;
    _ref = corpusPair[0];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      j = _ref[_i];
      _results.push((function() {
        var _j, _len2, _ref2, _results2;
        _ref2 = corpusPair[1];
        _results2 = [];
        for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
          k = _ref2[_j];
          p = new Pair(j, k);
          _results2.push(add(this.pair, p, 1));
        }
        return _results2;
      }).call(this));
    }
    return _results;
  };

  IBM_Model_1.prototype.countOne = function(corpusPair) {
    corpusPair[0] = this.preprocess_tag(corpusPair[0]);
    corpusPair[1] = this.preprocess_tag(corpusPair[1]);
    return this.count(corpusPair);
  };

  IBM_Model_1.prototype.countAll = function(corpus) {
    var i, _i, _len, _results;
    this.preprocess(corpus);
    _results = [];
    for (_i = 0, _len = corpus.length; _i < _len; _i++) {
      i = corpus[_i];
      _results.push(this.count(i));
    }
    return _results;
  };

  IBM_Model_1.prototype.train = function(threshold, prob_threshold) {
    var count, i, j, p, pair_trimmed, pair_trimmed_size, prob, s_total, t, total, v, _ref;
    if (threshold == null) threshold = 2;
    if (prob_threshold == null) prob_threshold = 0.3;
    pair_trimmed_size = 0;
    pair_trimmed = {};
    _ref = this.pair;
    for (i in _ref) {
      v = _ref[i];
      if (this.pair[i] >= threshold) {
        pair_trimmed[i] = v;
        pair_trimmed_size += 1;
      }
    }
    t = {};
    for (i in pair_trimmed) {
      t[i] = 1 / pair_trimmed_size;
    }
    for (i = 0; i <= 100; i++) {
      count = {};
      total = {};
      s_total = {};
      for (j in pair_trimmed) {
        p = Pair.fromString(j);
        add(s_total, p.target, t[p]);
      }
      for (j in pair_trimmed) {
        p = Pair.fromString(j);
        count[p] = t[p] * pair_trimmed[p] / s_total[p.target];
        add(total, p.source, count[p]);
      }
      for (j in pair_trimmed) {
        p = Pair.fromString(j);
        t[p] = count[p] / total[p.source];
      }
    }
    prob = {};
    for (i in t) {
      v = t[i];
      p = Pair.fromString(i);
      if (t[p] <= prob_threshold) continue;
      if (prob[p.source] === void 0) prob[p.source] = {};
      prob[p.source][p.target] = v;
    }
    return this.prob = prob;
  };

  IBM_Model_1.prototype.suggest = function(tags) {
    var i, j, r, reason, result, sort, source, v, _i, _len;
    result = {};
    source = tags.slice(0);
    source = this.preprocess_tag(source);
    reason = {};
    for (_i = 0, _len = source.length; _i < _len; _i++) {
      i = source[_i];
      if (i === 'NULLTAG') continue;
      for (j in this.prob[i]) {
        if (j === 'NULLTAG') continue;
        add(result, j, this.prob[i][j]);
        if (j in reason) {
          reason[j].push(i);
        } else {
          reason[j] = [i];
        }
      }
    }
    sort = [];
    for (r in result) {
      v = result[r];
      sort.push([r, v, reason[r].join()]);
    }
    sort.sort(function(a, b) {
      return b[1] - a[1];
    });
    return sort;
  };

  IBM_Model_1.prototype.clean = function(threshold) {
    var i, v, _ref, _results;
    if (threshold == null) threshold = 2;
    _ref = this.pair;
    _results = [];
    for (i in _ref) {
      v = _ref[i];
      if (v < threshold) {
        _results.push(delete this.pair[i]);
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  return IBM_Model_1;

}).call(this);

if (typeof module !== "undefined" && module !== null) module.exports = IBM_Model_1;
