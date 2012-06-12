'use strict';

class IBM_Model_1
    constructor: ->
        @prob = {}
        @pair = {}
    add = (hash, key, num) ->
        if key of hash
            hash[key] += num;
        else
            hash[key] = num;
    class Pair
        constructor: (@target, @source) ->
            @string = "#{@target} #{@source}"
        toString: ->
            return @string
        @fromString: (string) ->
            [target, source] = string.split(' ')
            return new Pair(target, source);
    preprocess_tag: (tags) ->
    #Append 'NULLTAG' to corpus.
        if tags.length == 1 and tags[0] == ''
            tags[0] = 'NULLTAG';
        else
            tags.push('NULLTAG');
    #Capitalize
        tags = for v in tags
            v = v.toUpperCase();
    preprocess: (corpus) ->
        for i in corpus
            i[0] = @preprocess_tag(i[0]);#推薦される側いらないかも
            i[1] = @preprocess_tag(i[1]);
    count: (corpusPair) ->
        for j in corpusPair[0]
            for k in corpusPair[1]
                p = new Pair(j, k);
                add(@pair, p, 1);
    countOne:(corpusPair) ->
        corpusPair[0] = @preprocess_tag(corpusPair[0]);#推薦される側いらないかも
        corpusPair[1] = @preprocess_tag(corpusPair[1]);
        
        @count(corpusPair)
    #Count co-occurence
    countAll: (corpus) ->
        @preprocess(corpus);
        
        for i in corpus
            @count(i);
    train: (threshold = 2, prob_threshold = 0.3) ->
        pair_trimmed_size = 0;
        
        #trimming
        pair_trimmed = {};
        for i, v of @pair
            if @pair[i] >= threshold
                pair_trimmed[i] = v;
                pair_trimmed_size += 1;
        
        t = {};
    #Initialize
        for i of pair_trimmed
            t[i] = 1 / pair_trimmed_size;

        #Estimation
        for i in [0..100]
            count = {};
            total = {};
            s_total = {};
            for j of pair_trimmed
                p = Pair.fromString(j);
                add(s_total, p.target, t[p]);
            for j of pair_trimmed
                p = Pair.fromString(j);
                count[p] = t[p] * pair_trimmed[p] / s_total[p.target];
                add(total, p.source, count[p]);
            for j of pair_trimmed
                p = Pair.fromString(j);
                t[p] = count[p] / total[p.source];
        prob = {};
        for i, v of t
            p = Pair.fromString(i);
            if t[p] <= prob_threshold
                    continue;
            if prob[p.source] == undefined
                prob[p.source] = {};
            prob[p.source][p.target] = v;
        @prob = prob;
    suggest: (tags) ->
        result = {};
        source = tags.slice(0);
        source = @preprocess_tag(source);
        reason = {}
        for i in source
            if i == 'NULLTAG'
                continue;
            for j of @prob[i]
                if j == 'NULLTAG'
                    continue;
                add(result, j, this.prob[i][j])
                if j of reason
                    reason[j].push(i)
                else
                    reason[j] = [i]
        sort = [];
        for r, v of result
            sort.push([r, v, reason[r].join()]);
        sort.sort((a, b) -> b[1] - a[1])
        sort
        

module?.exports = IBM_Model_1
