var resetData, restoreOptions, saveOptions;

saveOptions = function() {
  var saveOption, status;
  saveOption = function(name) {
    var select;
    select = document.getElementById(name);
    return localStorage[name] = select.children[select.selectedIndex].value;
  };
  saveOption('auto_select');
  saveOption('suggest');
  saveOption('position');
  saveOption('learning');
  chrome.extension.sendRequest({
    type: 'set'
  }, function(response) {});
  status = document.getElementById('status');
  status.innerHTML = 'Options Saved.';
  return setTimeout(function() {
    return status.innerHTML = '';
  }, 1000);
};

restoreOptions = function() {
  var selectOption;
  selectOption = function(name) {
    var child, option, select, _i, _len, _ref, _results;
    option = localStorage[name];
    if (option != null) {
      select = document.getElementById(name);
      _ref = select.children;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        if (child.value === option) {
          child.selected = 'true';
          break;
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    }
  };
  selectOption('auto_select');
  selectOption('suggest');
  selectOption('position');
  return selectOption('learning');
};

resetData = function() {
  return chrome.extension.sendRequest({
    type: 'reset'
  }, function(response) {});
};

document.body.onload = restoreOptions;
