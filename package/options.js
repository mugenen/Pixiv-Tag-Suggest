
$(function() {
  var i18n, resetData, restoreOptions, saveOptions;
  saveOptions = function() {
    var saveOption, status;
    saveOption = function(name) {
      return localStorage[name] = $("#" + name).val();
    };
    saveOption('auto_select');
    saveOption('suggest');
    saveOption('position');
    saveOption('learning');
    chrome.extension.sendMessage({
      type: 'set'
    }, function(response) {});
    status = $('#status');
    status.text(chrome.i18n.getMessage('optionOptionsSaved'));
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
  i18n = function() {
    return $('[data-i18n]').each(function() {
      var t;
      t = $(this);
      return t.text(chrome.i18n.getMessage(t.data('i18n')));
    });
  };
  i18n();
  restoreOptions();
  $("#reset").click(function() {
    return resetData();
  });
  return $("#save").click(function() {
    return saveOptions();
  });
});
