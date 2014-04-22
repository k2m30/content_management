var httpRequest;
document.onreadystatechange = function () {
    if (document.readyState == 'interactive') {
        if (href != null) addButton();
        sendVisit(location.href);
    }
}

function addButton() {
    original_button = document.querySelectorAll('a.btn.use-way.btn-inverse.btn-theme.is-masked')[1]
    outgrader_button = original_button.cloneNode(true);
    outgrader_button.setAttribute('data-content', 'Скачать в сети провайдера');
    outgrader_button.setAttribute('href', href);
    outgrader_button.onclick = function () {
        sendClick(location.href);
    };
    original_button.parentNode.insertBefore(outgrader_button, original_button);
}

function sendRequest(action, url) {
    if (window.XMLHttpRequest) { // Mozilla, Safari, ...
        r = new XMLHttpRequest();
    } else if (window.ActiveXObject) { // IE
        try {
            r = new ActiveXObject('Msxml2.XMLHTTP');
        }
        catch (e) {
            try {
                r = new ActiveXObject('Microsoft.XMLHTTP');
            }
            catch (e) {
            }
        }
    }
    if (!r) {
        return false;
    }
    r.open('POST', 'http://' + redirector_url + '/visits/'
        + action + '.json?url=' + url
        + '&name=' + encodeURIComponent(document.querySelector('h1.m-elementprimary-title').innerHTML)
        + '&year=' + encodeURIComponent(document.querySelector('.m-elementdescription-info div:first-child p:first-child span+span').innerHTML));
    r.onreadystatechange = function () {
        if (r.readyState != 4 || r.status != 200) return;
        console.log('Success: ' + r.responseText);
    };
    r.send();
    return true;
}

function sendClick(url) {
    sendRequest('send_click', url)
}

function sendVisit(url) {
    sendRequest('send_visit', url)
}