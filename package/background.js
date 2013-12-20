var config, count, load, model;

config = {};

model = new IBM_Model_1();

load = function() {
  var auto_select, json, learning, position, suggest;
  auto_select = localStorage["auto_select"];
  if (auto_select == null) auto_select = "on";
  suggest = localStorage["suggest"];
  if (suggest == null) suggest = "strict";
  position = localStorage["position"];
  if (position == null) position = "under";
  learning = localStorage["learning"];
  if (learning == null) learning = "enable";
  json = localStorage["model"];
  if (json != null) {
    json = JSON.parse(json);
    model.prob = json.prob;
    model.pair = json.pair;
  }
  return config = {
    auto_select: auto_select,
    suggest: suggest,
    position: position,
    learning: learning
  };
};

count = 0;

chrome.extension.onMessage.addListener(function(request, sender, sendResponse) {
  console.log(request);
  if (request.type === "get") {
    return sendResponse(config);
  } else if (request.type === "set") {
    load();
    return sendResponse(config);
  } else if (request.type === "train") {
    sendResponse(null);
    if (config.learning === 'enable') {
      model.countOne([request.target, request.source]);
      count++;
      if (count >= 2) {
        model.train(2, 0.3);
        count -= 2;
      }
      return localStorage["model"] = JSON.stringify(model);
    }
  } else if (request.type === "suggest") {
    if (config.learning === 'enable') {
      return sendResponse(model.suggest(request.source).slice(0, 5));
    }
  } else if (request.type === "reset") {
    model = new IBM_Model_1();
    return delete localStorage['model'];
  }
});

load();
