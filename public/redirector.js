var httpRequest = new XMLHttpRequest();
httpRequest.open('get', 'http://redirector.unet.by/outgrader/get_redirect.js?url=' + location.href);
httpRequest.onreadystatechange = function () {
    if (httpRequest.readyState != 4 || httpRequest.status != 200) return;
    console.log('Success: ' + httpRequest.responseText);
};
httpRequest.send();