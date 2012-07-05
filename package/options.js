
$(function() {
  var resetData, restoreOptions, saveOptions;
  saveOptions = function() {
    var saveOption, status;
    saveOption = function(name) {
      return localStorage[name] = $("#" + name).val();
    };
    saveOption('auto_select');
    saveOption('suggest');
    saveOption('position');
    saveOption('learning');
    chrome.extension.sendRequest({
      type: 'set'
    }, function(response) {});
    status = $('#status');
    status.text('Options Saved.');
    return setTimeout(function() {
      return status.text('');
    }, 1000);
  };
  restoreOptions = function() {
    var selectOption;
    selectOption = function(name) {
      var option;
      option = localStorage[name];
      if (option != null) return $("#" + name).val(option);
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
  restoreOptions();
  $("#reset").click(function() {
    return resetData();
  });
  return $("#save").click(function() {
    return saveOptions();
  });
});
