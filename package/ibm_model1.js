'use strict';
var IBM_Model_1 = function() {
  var add = function(hash, key, num) {
    if(key in hash) {
      hash[key] += num;
    } else {
      hash[key] = num;
    }
  };
  this.prob = {}
  this.pair = {}
  var Pair = function(target, source) {
    this.target = target;
    this.source = source;
    this.string = this.target + ' ' + this.source;
  }
  Pair.prototype.toString = function(){return this.string};
  Pair.fromString = function(string){
    var temp = string.split(' ');
    var target = temp[0];
    var source = temp[1];
    return new Pair(target, source);
  };

  this.preprocess_tag = function(tags) {
  //Capitalize
    for(var j = 0; j < tags.length; j++) {
      tags[j] = tags[j].toUpperCase();
    }
  //Append 'NULLTAG' to corpus.
    if(tags.length == 1 && tags[0] == '') {
        tags[0] = 'NULLTAG';
    } else {
        tags.push('NULLTAG');
    }
  };
  this.preprocess = function(corpus) {
    for(var i = 0; i < corpus.length; i++) {
      this.preprocess_tag(corpus[i][0]);
      this.preprocess_tag(corpus[i][1]);
    }
  };
  
  this.count = function(corpusPair) {
    for(var j = 0; j < corpusPair[0].length; j++) {
      for(var k = 0; k < corpusPair[1].length; k++) {
        var p = new Pair(corpusPair[0][j], corpusPair[1][k]);
        add(this.pair, p, 1);
      }
    }
  };
  this.countOne = function(corpusPair) {
    this.preprocess_tag(corpusPair[0]);
    this.preprocess_tag(corpusPair[1]);
    
    this.count(corpusPair)
  };
  //Count co-occurence
  this.countAll = function(corpus) {
    this.preprocess(corpus);
    
    for(var i = 0; i < corpus.length; i++) {
      this.count(corpus[i]);
    }
  };
  this.train = function(corpus) {
    var pair_trimmed_size = 0;
    
    //trimming
    var pair_trimmed = {};
    for(var i in this.pair) {
      if(this.pair[i] >= 2) {
        pair_trimmed[i] = this.pair[i];
        pair_trimmed_size += 1;
      }
    }
    
    var t = {};
  //Initialize
    for(var i in pair_trimmed) {
      t[i] = 1 / pair_trimmed_size;
    }

    //Estimation
    for(var i = 0; i < 100; i++) {
      var count = {};
      var total = {};
      var s_total = {};
      for(var j in pair_trimmed) {
        var p = Pair.fromString(j);
        add(s_total, p.target, t[p]);
      }
      for(var j in pair_trimmed) {
        var p = Pair.fromString(j);
        count[p] = t[p] * pair_trimmed[p] / s_total[p.target];
        add(total, p.source, count[p]);
      }
      for(var j in pair_trimmed) {
        var p = Pair.fromString(j);
        t[p] = count[p] / total[p.source];
      }
    }
    var prob = {};
    for(var i in t) {
      var p = Pair.fromString(i);
      if(t[p] <= 0.1) {
          continue;
      }
      if(prob[p.source] === undefined) {
        prob[p.source] = {};
      } 
      prob[p.source][p.target] = t[i];
    }
    this.prob = prob;
  };
  this.suggest = function(tags) {
    var result = {};
    var source = tags.slice(0);
    this.preprocess_tag(source);
    for(var i = 0; i < source.length; i++) {
      if(source[i] == 'NULLTAG') {
          continue;
      }
      for(var j in this.prob[source[i]]) {
        if(j == 'NULLTAG') {
            continue;
        }
        add(result, j, this.prob[source[i]][j])
      }
    }
    var sort = [];
    for(var r in result) {
      sort.push([r, result[r]]);
    }
    sort.sort(function(a, b) {return b[1] - a[1]});
    return sort;
  };
};
