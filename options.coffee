$( ->
    saveOptions = ->
        saveOption = (name) ->
            localStorage[name] = $("##{name}").val()

        saveOption('auto_select');
     
        saveOption('suggest');

        saveOption('position');

        saveOption('learning');

        chrome.extension.sendRequest({type:'set'}, (response) ->);

        status = $('#status');
        status.text('Options Saved.');
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
    
    restoreOptions()
    $("#reset").click(-> resetData())
    $("#save").click(-> saveOptions())
);
