getParam = (config) ->
    ###
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
    }
    ###
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
    myTagSrc = $('.tag-cloud-container span')
    if myTagSrc.length < 1
        return;
    for i in myTagSrc
        tagName = i.getAttribute('data-tag')
        myTagLink[tagName] = i;
    myTagLink

getImageTag = ->
    imgTagList = {};
    imgTagLink = {};
    imgTagSrc = $('.recommend-tag').find('span[data-tag]')
    for i in imgTagSrc
        i_tag = i.getAttribute('data-tag')
        imgTagList[i_tag] = true;
        imgTagLink[i_tag] = i;
    imgTagList: imgTagList
    imgTagLink: imgTagLink

getMyBookmarkedTag = ->
    onTagSrc = $('#input_tag').val().trim().split(/\s+|　+/);
    onTagList = {};
    for i in onTagSrc
        if i != ''
            onTagList[i] = true;
    onTagSrc: onTagSrc
    onTagList: onTagList

#画像がブックマークされているタグ
getOthersBookmarkedTagList = ->
    if document.URL.match('illust')
        url = "http://www.pixiv.net/bookmark_detail.php?illust_id=#{document.URL.match('illust_id=([0-9]+)')[1]}"
    else
        url = "http://www.pixiv.net/novel/bookmark_detail.php?id=#{document.URL.match('id=([0-9]+)')[1]}"
    xhr = $.ajax
        url: url
        async: false

    html = $(xhr.responseText);
    outerTagSrc = html.find('.tags a');
    outerTagList = {};
    for i in outerTagSrc
        ot = i.text
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

identical = (imgTagLink, myTagLink) ->
    ret = []
    for it of imgTagLink
        for mt of myTagLink
            if it == mt
                ret.push(it)
    console.log('Matched Tag', ret)
    ret

getConfigAsync = () ->
    dfd = $.Deferred()
    chrome.extension.sendMessage {type:'get'}, (response) ->
        dfd.resolve(response)
    dfd.promise()

getSuggestAsync = (config, keylist) ->
    if config.learning == 'enable'
        dfd = $.Deferred()
        chrome.extension.sendMessage {type:'suggest', source:keylist}, (response) ->
            dfd.resolve(response)
        dfd.promise()
    else
        []

addCounter = (keylist) ->
    counter = ->
        {onTagSrc} = getMyBookmarkedTag()
        bookmarked = onTagSrc
        chrome.extension.sendMessage({type:'train', source:keylist, target:bookmarked}, (response) ->);
    $('.btn_type03').click(counter)
    #小説用
    $('.btn_type01').click(counter)




partialMatch = (param) ->
    for mt of myTagLink
        if mt of autoTag
            continue
        for it of imgTagList
            minlen = Math.min(mt.length, it.length);
            maxlen = Math.max(mt.length, it.length);
            if it.length < param.minTag
                continue;
            if include(it, mt) and param.maxIncludeTagRate * minlen >= maxlen
                addScore(suggestedTag, mt, 2);
                addReason(reason, mt, "#{chrome.i18n.getMessage('include')}: #{it}")
                console.log('Partially Matched Tag', it, mt)
            else
                lcs = LCS(mt, it);
                if lcs >= param.minLCS and lcs >= param.minLCSRateShort * minlen and lcs >= param.minLCSRateLong * maxlen
                    addScore(suggestedTag, mt, 1);
                    addReason(reason, mt, "類似: #{it}")
                    console.log('Lexically Similar Tag', it, mt)
                else if lcs > 0 and param.maxLCSTagRateShort * lcs >= minlen and param.maxLCSTagRateLong * lcs >= maxlen
                    addScore(tagLCS, mt, lcs);

exactMatch = (config) ->
    if onTagSrc[0] == ''
    #完全一致
        for it in identical(imgTagLink, myTagLink)
            if config.auto_select == 'on'
                if not(it of onTagList)
                    auto += "pixiv.tag.toggle('#{encodeURI(escapeQuote(it))}');";
                autoTag[it] = true;
            else
                addScore(suggestedTag, it, 1);
                addScore(suggestedTag, it, 1);
                addReason(reason, it, "#{chrome.i18n.getMessage('match')}: #{it}")
        #ページのスクリプトの関数を実行するため．
        location.href = "javascript:void(function(){#{auto}})();";
    else
    #現在ブックマークしているタグを推薦（イラストのタグを除く）
        for ot of onTagList
            addScore(suggestedTag, ot, 1);
            addScore(suggestedTag, ot, 1);
            addReason(reason, ot, "#{chrome.i18n.getMessage('bookmarked')}: #{ot}")


addOtherBookmarkedTags = (param) ->
    for ot of outerTagList
        if outerTagList[ot] >= param.minOuter
            imgTagList[ot] = true;

addLearnedTags = (tags) ->
    for s in tags
        for z of myTagLink
            if s[0].match(new RegExp("^#{z}$", 'i')) and not(z of autoTag)
                addScore(suggestedTag, z, 1);
                addScore(suggestedTag, z, 1);
                addReason(reason, z, "#{chrome.i18n.getMessage('learn')}: #{s[2]}")

                lcs = 0
                for it of imgTagList
                    lcs = Math.max(LCS(z, it), lcs)
                addScore(tagLCS, z, lcs);

showResult = (resultTag, config, param) ->
    resultTag.sort (a, b) ->
        if a.count != b.count
            return b.count - a.count;
        else if tagLCS[a.key] != tagLCS[b.key]
            return tagLCS[b.key] - tagLCS[a.key];
        else
            return strcmp(a, b);

    div = $('<div>');
    div.attr('class', 'recommend-tag');
    text = $('<h1>');
    text.attr('class', 'title');
    text.text(chrome.i18n.getMessage('suggest'));
    div.append(text);
    suggest = $('<ul>');
    suggest.attr('class', 'list-items tag-cloud work');

    for i in resultTag
        if param.limit <= 0
            break;
        param.limit--;
                
        rt = i.key;
        li = $('<li>');
        a = $('<span>');
        a.addClass('tag c' + Math.max(7 - i.count, 1));
                
        a.attr('data-tag', rt);
        if rt of onTagList
            a.toggleClass('on selected')

        if rt of reason
            a.attr('title', reason[rt].join());

        a.text(rt);
        li.append(a);
        suggest.append(li);

    div.append(suggest);

    if $('.work-tags-container').length == 1
        imgTagTable = $('.recommend-tag').eq(0)
        if config.position == 'under'
            imgTagTable.after(div)
        else
           imgTagTable.before(div)
    else
       $('.tag-cloud-container').before(div)

addReason = (hash, key, string) ->
    if key of hash
        hash[key].push(string);
    else
        hash[key] = [string];

escapeQuote = (text) ->
    text.replace(/\\/g, "\\\\").replace(/\'/g, "\\'").replace(/\"/g, "\\\"")
    #<>は元からエスケープされている

suggestedTag = {};
auto = '';
autoTag = {};
reason = {}

myTagLink = getMyTagLink()
{imgTagList, imgTagLink} = getImageTag()
{onTagSrc, onTagList} = getMyBookmarkedTag()
outerTagList = getOthersBookmarkedTagList()

tagLCS = {}
for mt of myTagLink
    addScore(tagLCS, mt, 1);

console.log('Image Tag', imgTagList)
console.log('Bookmarked Tag', onTagList)
console.log('Other Users\' Tag', outerTagList)

getConfigAsync().done (config) ->
    param = getParam(config)

    addOtherBookmarkedTags(param)

    exactMatch(config)
    partialMatch(param)


    keylist = (key for key of imgTagList)

    if config.learning == 'enable'
        addCounter(keylist)

    $.when(getSuggestAsync(config, keylist)).done (response) ->
        console.log('Learned Tag', response)
        addLearnedTags(response)
        
        resultTag = ({key: t, count: suggestedTag[t]} for t of suggestedTag)
        if resultTag.length >= 1
            showResult(resultTag, config, param)
