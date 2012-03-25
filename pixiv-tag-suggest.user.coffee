config = null;

getParam = (config) ->
    if config.suggest == 'strict'
        limit: 7
        minTag: 1
        minOuter: 2
        maxIncludeTagRate: 8
        minLCS: 3
        minLCSRateLong: 0.7
        minLCSRateShort: 0.7
        maxLCSTagRateLong: 6
        maxLCSTagRateShort: 2
    else
        limit: 10
        minTag: 1
        minOuter: 1
        maxIncludeTagRate: 12
        minLCS: 3
        minLCSRateLong: 0.7
        minLCSRateShort: 0.7
        maxLCSTagRateLong: 6
        maxLCSTagRateShort: 2

addScore = (hash, key, weight) ->
    if key == 'pixivTouch' or key == 'pixivMobile'
        return;
    if key of hash
        hash[key] += weight;
    else
        hash[key] = 1;

textToDoc = (html) ->
#ほぼコピペ: http://d.hatena.ne.jp/furyu-tei/20100612/1276275088
    if document.implementation and document.implementation.createHTMLDocument
            htmlDoc = document.implementation.createHTMLDocument('');
    else
        proc = new XSLTProcessor();
        xsltStyleSheet = new DOMParser().parseFromString([
            '<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">'
            ,    '<xsl:output method="html" />'
            ,    '<xsl:template match="/">'
            ,        '<html><head><title></title></head><body></body></html>'
            ,    '</xsl:template>'
            ,'</xsl:stylesheet>'
        ].join(''), 'application/xml');
        proc.importStylesheet(xsltStyleSheet);
        htmlDoc = proc.transformToDocument(xsltStyleSheet);

    range = htmlDoc.createRange();

    html = html.match(/<html[^>]*>([\s\S]*)<\/html/i)[1];
    range.selectNodeContents(htmlDoc.documentElement);
    range.deleteContents();

    htmlDoc.documentElement.appendChild(range.createContextualFragment(html));
    htmlDoc

#Longest Common SubSequence
LCS = (a, b) ->
    sizea = a.length + 1;
    sizeb = b.length + 1;
    table = new Array(sizea);
    for i in [0...sizea]
        table[i] = new Array(sizeb);
    for i in [0...sizea]
        for j in [0...sizeb]
            table[i][j] = 0;

    for i in [1...sizea]
        for j in [1...sizeb]
            match = if a[i - 1] == b[j - 1] then 1 else 0;
            table[i][j] = Math.max(table[i - 1][j - 1] + match, table[i - 1][j], table[i][j - 1]);
    
    table[a.length][b.length];

#文字列比較
strcmp = (a, b) ->
    if a.key < b.key
        return -1;
    if a.key > b.key
        return 1;
    return 0;

getMyTagLink = ->
    myTagLink = {}
    tagCloud = document.getElementsByClassName('tagCloud')[0];
    if not(tagCloud?)
        return;

    myTagSrc = tagCloud.getElementsByTagName('a');
    for i in myTagSrc
        tagName = i.childNodes[0].textContent
        myTagLink[tagName] = i;
    myTagLink

getImageTag = ->
    imgTagList = {};
    imgTagLink = {};
    imgTagTable = document.querySelectorAll(".bookmark_recommend_tag");
    if imgTagTable.length != 1#画像のタグが空でないとき
        imgTagSrc = imgTagTable[0].querySelectorAll("a");
        for i in imgTagSrc
            imgTagList[i.text] = true;
            imgTagLink[i.text] = i;
    imgTagList: imgTagList
    imgTagLink: imgTagLink

getMyBookmarkedTag = ->
    onTagSrc = document.getElementById('input_tag').value.replace(/^\s*|\s*$/g, '').split(/\s+|　+/);
    onTagList = {};
    for i in onTagSrc
        if i != ''
            onTagList[i] = true;
    onTagSrc: onTagSrc
    onTagList: onTagList

#画像がブックマークされているタグ
getOthersBookmarkedTagList = ->
    xhr = new XMLHttpRequest();
    if document.URL.match('illust')
        xhr.open('GET', "http://www.pixiv.net/bookmark_detail.php?illust_id=#{document.URL.match('illust_id=([0-9]+)')[1]}", false);
    else
        xhr.open('GET', "http://www.pixiv.net/novel/bookmark_detail.php?id=#{document.URL.match('id=([0-9]+)')[1]}", false);

    xhr.send(null);
    html = textToDoc(xhr.responseText);
    outerTagSrc = html.getElementsByClassName('link_purple linkStyle');
    outerTagList = {};
    for i in outerTagSrc
        ot = i.getElementsByTagName('a')[0].text;
        if ot != 'B' and ot != 'pixivTouch' and ot != 'pixivMobile'
            addScore(outerTagList, ot, 1);
    outerTagList

include = (a, b) ->
    if a.length < b.length
    #エスケープ．参考: http://subtech.g.hatena.ne.jp/cho45/20090513/1242199703
        match = b.match(new RegExp(a.replace(/\W/g,'\\$&'), 'i'));
    else
        match = a.match(new RegExp(b.replace(/\W/g,'\\$&'), 'i'));
    if match? then true else false

chrome.extension.sendRequest {type:'get'}, (response) ->
    config = response;

    {
        limit,#サジェストするタグの最大数
        #類似文字列判定用パラメータ
        minTag,#処理対象にする画像と他の人のタグの長さの下限
        minOuter,#対象とする他の人がブックマークしているタグの頻度の下限
        maxIncludeTagRate,#短い側のタグが含まれている長い側のタグの文字数が短い側の何倍かの上限
        #LCS用パラメータ
        minLCS,#最長共通部分文字列(LCS)の下限
        minLCSRateLong,#長い側のタグに占める共通部分文字列の割合の下限
        minLCSRateShort,#短い側のタグに占める共通部分文字列の割合の下限
        maxLCSTagRateLong,#LCSが含まれている長い側のタグの文字数がLCSの何倍かの上限
        maxLCSTagRateShort,#LCSが含まれている短い側のタグの文字数がLCSの何倍かの上限
    } = getParam(config)

    myTagLink = getMyTagLink()

    {imgTagList, imgTagLink} = getImageTag()

    {onTagSrc, onTagList} = getMyBookmarkedTag()

    outerTagList = getOthersBookmarkedTagList()
    for ot of outerTagList
        if outerTagList[ot] >= minOuter
            imgTagList[ot] = true;

    suggestedTag = {};
    auto = '';
    autoTag = {};

    if onTagSrc[0] == ''
    #完全一致
        for it of imgTagLink
            for mt of myTagLink
                if it == mt
                    if config.auto_select == 'on'
                        if not(it of onTagList)
                            auto += "pixiv.tag.toggle('#{encodeURI(mt)}');";
                        autoTag[mt] = true;
                    else
                        addScore(suggestedTag, it, 1);
                        addScore(suggestedTag, it, 1);
    else
    #現在ブックマークしているタグを推薦（イラストのタグを除く）
        for ot of onTagList
            addScore(suggestedTag, ot, 1);
            addScore(suggestedTag, ot, 1);

    tagLCS = {}
    for mt of myTagLink
        addScore(tagLCS, mt, 1);
    #部分一致
    for it of imgTagList
        for mt of myTagLink
            if not(mt of autoTag)
                minlen = Math.min(mt.length, it.length);
                maxlen = Math.max(mt.length, it.length);
                if it.length < minTag
                    continue;
                if include(it, mt) and maxIncludeTagRate * minlen >= maxlen
                    addScore(suggestedTag, mt, 2);
                else
                    lcs = LCS(mt, it);
                    if lcs >= minLCS and lcs >= minLCSRateShort * minlen and lcs >= minLCSRateLong * maxlen
                        addScore(suggestedTag, mt, 1);
                    else if lcs > 0 and maxLCSTagRateShort * lcs >= minlen and maxLCSTagRateLong * lcs >= maxlen
                        addScore(tagLCS, mt, lcs);

    #ページのスクリプトの関数を実行するため．
    location.href = "javascript:void(function(){#{auto}})();";


    keylist = (key for key of imgTagList)

    chrome.extension.sendRequest {type:'suggest', source:keylist}, (response) ->
        for s in response
            for z of myTagLink
                if s[0].match(new RegExp("^#{z}$", 'i')) and not(z of autoTag)
                    addScore(suggestedTag, z, 1);
                    addScore(suggestedTag, z, 1);

                    lcs = 0
                    for it of imgTagList
                        lcs = Math.max(LCS(z, it), lcs)
                    addScore(tagLCS, z, lcs);

        resultTag = ({key: t, count: suggestedTag[t]} for t of suggestedTag)
        if resultTag.length >= 1
            resultTag.sort (a, b) ->
                if a.count != b.count
                    return b.count - a.count;
                else if tagLCS[a.key] != tagLCS[b.key]
                    return tagLCS[b.key] - tagLCS[a.key];
                else
                    return strcmp(a, b);
            
            div = document.createElement('div');
            div.setAttribute('class', 'bookmark_recommend_tag');
            suggest = document.createElement('ul');
            suggest.setAttribute('class', 'tagCloud');
            text = document.createElement('span');
            text.appendChild(document.createTextNode('Suggest'));
            div.appendChild(text);
            div.appendChild(document.createElement('br'));

            for i in resultTag
                if limit <= 0
                    break;
                limit--;
                
                rt = i.key;
                li = document.createElement('li');
                a = document.createElement('a');
                li.setAttribute('class', 'level' + Math.max(7 - i.count, 1));
                
                a.setAttribute('href', 'javascript:void(0);');
                if rt of onTagList
                    a.setAttribute('class', 'tag on');

                addEventThisTag = (tag) ->
                    a.addEventListener('click', ->
                        if this.getAttribute('class') != 'tag on'
                            this.setAttribute('class', 'tag on');
                        else
                            this.setAttribute('class', 'tag');
                        location.href = "javascript:void(function(){pixiv.tag.toggle('#{encodeURI(tag)}')})();";
                    ,false)

                addEventThisTag(rt);
                
                a.appendChild(document.createTextNode(rt));
                li.appendChild(a);
                suggest.appendChild(li);

                addEventMyTag = (a) ->
                    myTagLink[i.key].addEventListener 'click', ->
                        if a.getAttribute('class') != 'tag on'
                            a.setAttribute('class', 'tag on');
                        else
                            a.setAttribute('class', 'tag');
                    , false
                
                addEventMyTag(a);

                addEventImageTag = (a) ->
                    imgTagLink[i.key].addEventListener 'click', ->
                        if a.getAttribute('class') != 'tag on'
                            a.setAttribute('class', 'tag on');
                        else
                            a.setAttribute('class', 'tag');
                    , false
                if rt of imgTagLink
                    addEventImageTag(a);

            div.appendChild(suggest);

            imgTagTable = document.querySelector('.bookmark_recommend_tag')
            if config.position == 'under'
                imgTagTable.parentNode.insertBefore(div, imgTagTable.nextSibling);
            else
                imgTagTable.parentNode.insertBefore(div, imgTagTable);

    submit = ->
        {onTagSrc} = getMyBookmarkedTag()
        bookmarked = onTagSrc
        chrome.extension.sendRequest({type:'train', source:keylist, target:bookmarked}, (response) ->);
    document.getElementsByClassName('btn_type03')[0]?.addEventListener('click', submit, false);
    document.getElementsByClassName('btn_type03')[1]?.addEventListener('click', submit, false);
    #小説用
    document.getElementsByClassName('btn_type01')[0]?.addEventListener('click', submit, false);
    document.getElementsByClassName('btn_type01')[1]?.addEventListener('click', submit, false);
