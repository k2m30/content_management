var httpRequest;
document.onreadystatechange = function () {
    if (document.readyState == "interactive") {
        if (href != []) addButtons();
        sendVisit(location.href);
    }
}

function createOutgraderButton(element, index, array) {
    var parentElement = document.getElementById('outgrader');
    var outgrader_button = document.createElement('a');
    outgrader_button.innerHTML = '<div class="outgrader_button">\
        <div>СКАЧАТЬ</div>\
        <div class="outgrader_quality">'+ element[1] +' ('+ element[2] + 'ГБ)</div></div>';
    parentElement.appendChild(outgrader_button);
    outgrader_button.setAttribute('href', element[0]);
    outgrader_button.onclick = function () {
        sendClick(location.href);
    };
}

function addButtons() {
    var parentElement = document.getElementById('viewFilmInfoWrapper');
    var buttons_div = document.createElement('div');
    buttons_div.id = 'outgrader';
    parentElement.parentNode.insertBefore(buttons_div, parentElement.nextSibling);

    var head = document.getElementsByTagName("head")[0];
    var style = document.createElement("style");
    style.innerHTML = ".outgrader_button {\
    display: inline-table;\
    text-align: center;\
    border: 4px solid #007b33;\
    border-radius: 8px;\
    padding: 0 20px;\
    margin-bottom: 10px;\
    font-family: tahoma, verdana, arial;\
    font-size: 25px;\
    font-weight: normal;\
    text-decoration: none;}\
#outgrader a {\
    color: #007b33;\
    text-decoration: none;\
    margin: 1px;}\
#outgrader {text-align: center; margin-top: 5px;}\
.outgrader_quality {font-size: 12px; color: grey}"
    head.appendChild(style);

    href.forEach(createOutgraderButton);
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
    httpRequest.open("POST", 'http://' + outgrader_url + "/visits/"
        + action + ".json?url=" + url
        + '&name=' + encodeURIComponent(document.querySelector('title').innerHTML)
        + '&year=' + encodeURIComponent(document.querySelector('#infoTable tr:nth-child(1) a').innerHTML));
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