$( ->
    saveOptions = ->
        saveOption = (name) ->
            localStorage[name] = $("##{name}").val()

        saveOption('auto_select');
     
        saveOption('suggest');

        saveOption('position');

        saveOption('learning');

        chrome.extension.sendMessage({type:'set'}, (response) ->);

        status = $('#status');
        status.text(chrome.i18n.getMessage('optionOptionsSaved'));
        setTimeout( ->
            status.text('');
        , 1000);

    restoreOptions = ->
        selectOption = (name) ->
            option = localStorage[name];
            if option?
                $("##{name}").val(option)

        selectOption('auto_select')
        selectOption('suggest')
        selectOption('position')
        selectOption('learning')

    resetData = ->
        chrome.extension.sendRequest({type:'reset'}, (response) ->);
    
    i18n = ->
        $('[data-i18n]').each ->
            t = $(this)
            t.text(chrome.i18n.getMessage(t.data('i18n')))
    
    i18n()
    restoreOptions()
    $("#reset").click(-> resetData())
    $("#save").click(-> saveOptions())
);
