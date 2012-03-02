saveOptions = ->
    saveOption = (name) ->
        select = document.getElementById(name);
        localStorage[name] = select.children[select.selectedIndex].value;

    saveOption('auto_select');
 
    saveOption('suggest');

    saveOption('position');

    saveOption('learning');

    chrome.extension.sendRequest({type:'set'}, (response) ->);

    status = document.getElementById('status');
    status.innerHTML = 'Options Saved.';
    setTimeout( ->
        status.innerHTML = '';
    , 1000);

restoreOptions = ->
    selectOption = (name) ->
        option = localStorage[name];
        if option?
            select = document.getElementById(name);
            for child in select.children
                if child.value == option
                    child.selected = 'true';
                    break;

    selectOption('auto_select')
    selectOption('suggest')
    selectOption('position')
    selectOption('learning')

resetData = ->
    chrome.extension.sendRequest({type:'reset'}, (response) ->);

document.body.onload = restoreOptions;
