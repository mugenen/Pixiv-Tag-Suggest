(function() {
  var LCS, addScore, config, getImageTag, getMyBookmarkedTag, getMyTagLink, getOthersBookmarkedTagList, getParam, include, strcmp, textToDoc;

  config = null;

  getParam = function(config) {
    if (config.suggest === 'strict') {
      return {
        limit: 7,
        minTag: 1,
        minOuter: 2,
        maxIncludeTagRate: 8,
        minLCS: 3,
        minLCSRateLong: 0.7,
        minLCSRateShort: 0.7,
        maxLCSTagRateLong: 6,
        maxLCSTagRateShort: 2
      };
    } else {
      return {
        limit: 10,
        minTag: 1,
        minOuter: 1,
        maxIncludeTagRate: 12,
        minLCS: 3,
        minLCSRateLong: 0.7,
        minLCSRateShort: 0.7,
        maxLCSTagRateLong: 6,
        maxLCSTagRateShort: 2
      };
    }
  };

  addScore = function(hash, key, weight) {
    if (key === 'pixivTouch' || key === 'pixivMobile') return;
    if (key in hash) {
      return hash[key] += weight;
    } else {
      return hash[key] = 1;
    }
  };

  textToDoc = function(html) {
    var htmlDoc, proc, range, xsltStyleSheet;
    if (document.implementation && document.implementation.createHTMLDocument) {
      htmlDoc = document.implementation.createHTMLDocument('');
    } else {
      proc = new XSLTProcessor();
      xsltStyleSheet = new DOMParser().parseFromString(['<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">', '<xsl:output method="html" />', '<xsl:template match="/">', '<html><head><title></title></head><body></body></html>', '</xsl:template>', '</xsl:stylesheet>'].join(''), 'application/xml');
      proc.importStylesheet(xsltStyleSheet);
      htmlDoc = proc.transformToDocument(xsltStyleSheet);
    }
    range = htmlDoc.createRange();
    html = html.match(/<html[^>]*>([\s\S]*)<\/html/i)[1];
    range.selectNodeContents(htmlDoc.documentElement);
    range.deleteContents();
    htmlDoc.documentElement.appendChild(range.createContextualFragment(html));
    return htmlDoc;
  };

  LCS = function(a, b) {
    var i, j, match, sizea, sizeb, table;
    sizea = a.length + 1;
    sizeb = b.length + 1;
    table = new Array(sizea);
    for (i = 0; 0 <= sizea ? i < sizea : i > sizea; 0 <= sizea ? i++ : i--) {
      table[i] = new Array(sizeb);
    }
    for (i = 0; 0 <= sizea ? i < sizea : i > sizea; 0 <= sizea ? i++ : i--) {
      for (j = 0; 0 <= sizeb ? j < sizeb : j > sizeb; 0 <= sizeb ? j++ : j--) {
        table[i][j] = 0;
      }
    }
    for (i = 1; 1 <= sizea ? i < sizea : i > sizea; 1 <= sizea ? i++ : i--) {
      for (j = 1; 1 <= sizeb ? j < sizeb : j > sizeb; 1 <= sizeb ? j++ : j--) {
        match = a[i - 1] === b[j - 1] ? 1 : 0;
        table[i][j] = Math.max(table[i - 1][j - 1] + match, table[i - 1][j], table[i][j - 1]);
      }
    }
    return table[a.length][b.length];
  };

  strcmp = function(a, b) {
    if (a.key < b.key) return -1;
    if (a.key > b.key) return 1;
    return 0;
  };

  getMyTagLink = function() {
    var i, myTagLink, myTagSrc, tagCloud, tagName, _i, _len;
    myTagLink = {};
    tagCloud = document.getElementsByClassName('tagCloud')[0];
    if (!(tagCloud != null)) return;
    myTagSrc = tagCloud.getElementsByTagName('a');
    for (_i = 0, _len = myTagSrc.length; _i < _len; _i++) {
      i = myTagSrc[_i];
      tagName = i.childNodes[0].textContent;
      myTagLink[tagName] = i;
    }
    return myTagLink;
  };

  getImageTag = function() {
    var i, imgTagLink, imgTagList, imgTagSrc, imgTagTable, _i, _len;
    imgTagTable = document.querySelector(".bookmark_recommend_tag");
    imgTagSrc = imgTagTable.querySelectorAll("a");
    imgTagList = {};
    imgTagLink = {};
    for (_i = 0, _len = imgTagSrc.length; _i < _len; _i++) {
      i = imgTagSrc[_i];
      imgTagList[i.text] = true;
      imgTagLink[i.text] = i;
    }
    return {
      imgTagList: imgTagList,
      imgTagLink: imgTagLink
    };
  };

  getMyBookmarkedTag = function() {
    var i, onTagList, onTagSrc, _i, _len;
    onTagSrc = document.getElementById('input_tag').value.replace(/^\s*|\s*$/g, '').split(/\s+|　+/);
    onTagList = {};
    for (_i = 0, _len = onTagSrc.length; _i < _len; _i++) {
      i = onTagSrc[_i];
      if (i !== '') onTagList[i] = true;
    }
    return {
      onTagSrc: onTagSrc,
      onTagList: onTagList
    };
  };

  getOthersBookmarkedTagList = function() {
    var html, i, ot, outerTagList, outerTagSrc, xhr, _i, _len;
    xhr = new XMLHttpRequest();
    if (document.URL.match('illust')) {
      xhr.open('GET', "http://www.pixiv.net/bookmark_detail.php?illust_id=" + (document.URL.match('illust_id=([0-9]+)')[1]), false);
    } else {
      xhr.open('GET', "http://www.pixiv.net/novel/bookmark_detail.php?id=" + (document.URL.match('id=([0-9]+)')[1]), false);
    }
    xhr.send(null);
    html = textToDoc(xhr.responseText);
    outerTagSrc = html.getElementsByClassName('link_purple linkStyle');
    outerTagList = {};
    for (_i = 0, _len = outerTagSrc.length; _i < _len; _i++) {
      i = outerTagSrc[_i];
      ot = i.getElementsByTagName('a')[0].text;
      if (ot !== 'B' && ot !== 'pixivTouch' && ot !== 'pixivMobile') {
        addScore(outerTagList, ot, 1);
      }
    }
    return outerTagList;
  };

  include = function(a, b) {
    var match;
    if (a.length < b.length) {
      match = b.match(new RegExp(a.replace(/\W/g, '\\$&'), 'i'));
    } else {
      match = a.match(new RegExp(b.replace(/\W/g, '\\$&'), 'i'));
    }
    if (match != null) {
      return true;
    } else {
      return false;
    }
  };

  chrome.extension.sendRequest({
    type: 'get'
  }, function(response) {
    var auto, autoTag, imgTagLink, imgTagList, it, key, keylist, lcs, limit, maxIncludeTagRate, maxLCSTagRateLong, maxLCSTagRateShort, maxlen, minLCS, minLCSRateLong, minLCSRateShort, minOuter, minTag, minlen, mt, myTagLink, onTagList, onTagSrc, ot, outerTagList, submit, suggestedTag, tagLCS, _ref, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7;
    config = response;
    _ref = getParam(config), limit = _ref.limit, minTag = _ref.minTag, minOuter = _ref.minOuter, maxIncludeTagRate = _ref.maxIncludeTagRate, minLCS = _ref.minLCS, minLCSRateLong = _ref.minLCSRateLong, minLCSRateShort = _ref.minLCSRateShort, maxLCSTagRateLong = _ref.maxLCSTagRateLong, maxLCSTagRateShort = _ref.maxLCSTagRateShort;
    myTagLink = getMyTagLink();
    _ref2 = getImageTag(), imgTagList = _ref2.imgTagList, imgTagLink = _ref2.imgTagLink;
    _ref3 = getMyBookmarkedTag(), onTagSrc = _ref3.onTagSrc, onTagList = _ref3.onTagList;
    outerTagList = getOthersBookmarkedTagList();
    for (ot in outerTagList) {
      if (outerTagList[ot] >= minOuter) imgTagList[ot] = true;
    }
    suggestedTag = {};
    auto = '';
    autoTag = {};
    if (onTagSrc[0] === '') {
      for (it in imgTagLink) {
        for (mt in myTagLink) {
          if (it === mt) {
            if (config.auto_select === 'on') {
              if (!(it in onTagList)) {
                auto += "pixiv.tag.toggle('" + (encodeURI(mt)) + "');";
              }
              autoTag[mt] = true;
            } else {
              addScore(suggestedTag, it, 1);
              addScore(suggestedTag, it, 1);
            }
          }
        }
      }
    } else {
      for (ot in onTagList) {
        addScore(suggestedTag, ot, 1);
        addScore(suggestedTag, ot, 1);
      }
    }
    tagLCS = {};
    for (mt in myTagLink) {
      addScore(tagLCS, mt, 1);
    }
    for (it in imgTagList) {
      for (mt in myTagLink) {
        if (!(mt in autoTag)) {
          minlen = Math.min(mt.length, it.length);
          maxlen = Math.max(mt.length, it.length);
          if (it.length < minTag) continue;
          if (include(it, mt) && maxIncludeTagRate * minlen >= maxlen) {
            addScore(suggestedTag, mt, 2);
          } else {
            lcs = LCS(mt, it);
            if (lcs >= minLCS && lcs >= minLCSRateShort * minlen && lcs >= minLCSRateLong * maxlen) {
              addScore(suggestedTag, mt, 1);
            } else if (lcs > 0 && maxLCSTagRateShort * lcs >= minlen && maxLCSTagRateLong * lcs >= maxlen) {
              addScore(tagLCS, mt, lcs);
            }
          }
        }
      }
    }
    location.href = "javascript:void(function(){" + auto + "})();";
    keylist = (function() {
      var _results;
      _results = [];
      for (key in imgTagList) {
        _results.push(key);
      }
      return _results;
    })();
    chrome.extension.sendRequest({
      type: 'suggest',
      source: keylist
    }, function(response) {
      var a, addEventImageTag, addEventMyTag, addEventThisTag, div, i, imgTagTable, it, li, resultTag, rt, s, suggest, t, text, z, _i, _j, _len, _len2;
      for (_i = 0, _len = response.length; _i < _len; _i++) {
        s = response[_i];
        for (z in myTagLink) {
          if (s[0].match(new RegExp("^" + z + "$", 'i')) && !(z in autoTag)) {
            addScore(suggestedTag, z, 1);
            addScore(suggestedTag, z, 1);
            lcs = 0;
            for (it in imgTagList) {
              lcs = Math.max(LCS(z, it), lcs);
            }
            addScore(tagLCS, z, lcs);
          }
        }
      }
      resultTag = (function() {
        var _results;
        _results = [];
        for (t in suggestedTag) {
          _results.push({
            key: t,
            count: suggestedTag[t]
          });
        }
        return _results;
      })();
      if (resultTag.length >= 1) {
        resultTag.sort(function(a, b) {
          if (a.count !== b.count) {
            return b.count - a.count;
          } else if (tagLCS[a.key] !== tagLCS[b.key]) {
            return tagLCS[b.key] - tagLCS[a.key];
          } else {
            return strcmp(a, b);
          }
        });
        div = document.createElement('div');
        div.setAttribute('class', 'bookmark_recommend_tag');
        suggest = document.createElement('ul');
        suggest.setAttribute('class', 'tagCloud');
        text = document.createElement('span');
        text.appendChild(document.createTextNode('Suggest'));
        div.appendChild(text);
        div.appendChild(document.createElement('br'));
        for (_j = 0, _len2 = resultTag.length; _j < _len2; _j++) {
          i = resultTag[_j];
          if (limit <= 0) break;
          limit--;
          rt = i.key;
          li = document.createElement('li');
          a = document.createElement('a');
          li.setAttribute('class', 'level' + Math.max(7 - i.count, 1));
          a.setAttribute('href', 'javascript:void(0);');
          if (rt in onTagList) a.setAttribute('class', 'tag on');
          addEventThisTag = function(tag) {
            return a.addEventListener('click', function() {
              if (this.getAttribute('class') !== 'tag on') {
                this.setAttribute('class', 'tag on');
              } else {
                this.setAttribute('class', 'tag');
              }
              return location.href = "javascript:void(function(){pixiv.tag.toggle('" + (encodeURI(tag)) + "')})();";
            }, false);
          };
          addEventThisTag(rt);
          a.appendChild(document.createTextNode(rt));
          li.appendChild(a);
          suggest.appendChild(li);
          addEventMyTag = function(a) {
            return myTagLink[i.key].addEventListener('click', function() {
              if (a.getAttribute('class') !== 'tag on') {
                return a.setAttribute('class', 'tag on');
              } else {
                return a.setAttribute('class', 'tag');
              }
            }, false);
          };
          addEventMyTag(a);
          addEventImageTag = function(a) {
            return imgTagLink[i.key].addEventListener('click', function() {
              if (a.getAttribute('class') !== 'tag on') {
                return a.setAttribute('class', 'tag on');
              } else {
                return a.setAttribute('class', 'tag');
              }
            }, false);
          };
          if (rt in imgTagLink) addEventImageTag(a);
        }
        div.appendChild(suggest);
        imgTagTable = document.querySelector('.bookmark_recommend_tag');
        if (config.position === 'under') {
          return imgTagTable.parentNode.insertBefore(div, imgTagTable.nextSibling);
        } else {
          return imgTagTable.parentNode.insertBefore(div, imgTagTable);
        }
      }
    });
    submit = function() {
      var bookmarked;
      onTagSrc = getMyBookmarkedTag().onTagSrc;
      bookmarked = onTagSrc;
      return chrome.extension.sendRequest({
        type: 'train',
        source: keylist,
        target: bookmarked
      }, function(response) {});
    };
    if ((_ref4 = document.getElementsByClassName('btn_type03')[0]) != null) {
      _ref4.addEventListener('click', submit, false);
    }
    if ((_ref5 = document.getElementsByClassName('btn_type03')[1]) != null) {
      _ref5.addEventListener('click', submit, false);
    }
    if ((_ref6 = document.getElementsByClassName('btn_type01')[0]) != null) {
      _ref6.addEventListener('click', submit, false);
    }
    return (_ref7 = document.getElementsByClassName('btn_type01')[1]) != null ? _ref7.addEventListener('click', submit, false) : void 0;
  });

}).call(this);
