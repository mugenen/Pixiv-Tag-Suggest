config = {};
model = new IBM_Model_1();
load = ->
    auto_select = localStorage["auto_select"];
    auto_select ?= "on";

    suggest = localStorage["suggest"];
    suggest ?= "strict";

    position = localStorage["position"];
    position ?= "under";

    learning = localStorage["learning"];
    learning ?= "enable";

    json = localStorage["model"];
    if json?
        json = JSON.parse(json);
        model.prob = json.prob;
        model.pair = json.pair;

    config =
        auto_select: auto_select,
        suggest: suggest,
        position: position,
        learning: learning

count = 0;
chrome.extension.onRequest.addListener (request, sender, sendResponse) ->
    if request.type == "get"
        sendResponse(config);
    else if request.type == "set"
        load();
        sendResponse(config);
    else if request.type == "train"
        sendResponse(null);
        if config.learning == 'enable'
            model.countOne([request.target, request.source]);
            count++;
            if count >= 2
                model.train(2, 0.3);
                count -= 2;
            localStorage["model"] = JSON.stringify(model)
    else if request.type == "suggest"
        if config.learning == 'enable'
            sendResponse(model.suggest(request.source).slice(0, 5));
    else if request.type == "reset"
        model = new IBM_Model_1();
        delete localStorage['model'];

document.body.onload = load;
