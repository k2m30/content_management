var httpRequest;
document.onreadystatechange = function () {
    if (document.readyState == "interactive") {
        if (href) addButton();
        sendVisit(location.href);
    }
}
function addButton() {
    var element = document.getElementById('viewFilmInfoWrapper');
    var outgrader_button = document.createElement('div');
    outgrader_button.setAttribute('style', 'width: 25%; margin:8px auto; white-space: nowrap; \
  text-align: center; border:4px solid #007b33; border-radius:8px;')
    outgrader_button.id = 'outgrader_button';
    outgrader_button.innerHTML = '<h1>\
  <a style="color: #007b33">СКАЧАТЬ</a>\
  </h1>';
    element.parentNode.insertBefore(outgrader_button, element.nextSibling);
    var links = document.getElementById('outgrader_button').getElementsByTagName('a');
//    links[0].setAttribute('href', href);
    links[0].onclick = function () {
        sendClick(location.href);
    };
}

function sendRequest(action, url) {
    if (window.XMLHttpRequest) { // Mozilla, Safari, ...
        httpRequest = new XMLHttpRequest();
    } else if (window.ActiveXObject) { // IE
        try {
            httpRequest = new ActiveXObject("Msxml2.XMLHTTP");
        }
        catch (e) {
            try {
                httpRequest = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch (e) {
            }
        }
    }
    if (!httpRequest) {
        return false;
    }
    httpRequest.open("POST", 'http://' + outgrader_url + "/visits/" + action + ".json?url=" + url);
    console.log('created');
    httpRequest.onreadystatechange = function () {
        if (httpRequest.readyState != 4 || httpRequest.status != 200) return;
        console.log("Success: " + httpRequest.responseText);
    };
    httpRequest.send();
    return true;
}

function sendClick(url) {
    sendRequest("send_click", url)
}

function sendVisit(url) {
    sendRequest("send_visit", url)
}