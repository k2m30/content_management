function sendRequest(action, url, name_css, year_css) {
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
        + '&name=' + encodeURIComponent(document.querySelector(name_css).innerHTML)
        + '&year=' + encodeURIComponent(document.querySelector(year_css).innerHTML));
    r.onreadystatechange = function () {
        if (r.readyState != 4 || r.status != 200) return;
        console.log('Success: ' + r.responseText);
    };
    r.send();
    return true;
}

function sendClick(url, name_css, year_css) {
    sendRequest('send_click', url, name_css, year_css)
}

function sendVisit(url, name_css, year_css) {
    sendRequest('send_visit', url, name_css, year_css)
}

function executeIt(){
    isExecuted = true;
    if (href != null) addButton();
    sendVisit(location.href, name_css, year_css);
}

var r = null;
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
if (r) {
    r.open('get', 'http://redirector.unet.by/outgrader/get_redirect.js?url=' + location.href);
    r.onreadystatechange = function () {
        if (r.readyState != 4 || r.status != 200) return;
        eval(r.responseText);
    };
    r.send();
}
