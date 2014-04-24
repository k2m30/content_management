var name_css = 'title';
var year_css = '#infoTable tr:nth-child(1) a';
var r;
document.onreadystatechange = function () {
    if (document.readyState == 'interactive') {
        executeIt();
    }
}
if (((document.readyState == 'complete') || (document.readyState == 'interactive') ) && !isExecuted) executeIt();

function createOutgraderButton(href) {
    var outgrader_button = document.getElementById('outgrader');
    outgrader_button.innerHTML = '<a class="outgrader_button" target="_blank" href="' + href + '">Скачайте этот файл в сети провайдера</a>';
    outgrader_button.onclick = function () {
        sendClick(location.href, name_css, year_css);
    };
}

function addButton() {
    var parentElement = document.getElementById('viewFilmInfoWrapper');
    var buttons_div = document.createElement('div');
    buttons_div.id = 'outgrader';
    parentElement.parentNode.insertBefore(buttons_div, parentElement.nextSibling);

    var head = document.getElementsByTagName('head')[0];
    var style = document.createElement('style');
    style.innerHTML = '.outgrader_button {\
    -webkit-box-shadow: rgba(255, 255, 255, 0.2) 0px 1px 0px 0px inset, rgba(0, 0, 0, 0.0470588) 0px 1px 2px 0px;\
    -webkit-transition-delay: 0s;\
    -webkit-transition-duration: 0.1s;\
    -webkit-transition-property: background-position;\
    -webkit-transition-timing-function: linear;\
    background-color: rgb(47, 150, 180);\
    background-image: linear-gradient(rgb(91, 192, 222), rgb(47, 150, 180));\
    background-position: 0px -15px;\
    background-repeat: repeat-x;\
    border-bottom-color: rgba(0, 0, 0, 0.247059);\
    border-bottom-left-radius: 4px;\
    border-bottom-right-radius: 4px;\
    border-bottom-style: solid;\
    border-bottom-width: 1px;\
    border-left-color: rgba(0, 0, 0, 0.0980392);\
    border-left-style: solid;\
    border-left-width: 1px;\
    border-right-color: rgba(0, 0, 0, 0.0980392);\
    border-right-style: solid;\
    border-right-width: 1px;\
    border-top-color: rgba(0, 0, 0, 0.0980392);\
    border-top-left-radius: 4px;\
    border-top-right-radius: 4px;\
    border-top-style: solid;\
    border-top-width: 1px;\
    box-shadow: rgba(255, 255, 255, 0.2) 0px 1px 0px 0px inset, rgba(0, 0, 0, 0.0470588) 0px 1px 2px 0px;\
    color: rgb(255, 255, 255);\
    cursor: pointer;\
    display: inline-block;\
    font-family: \"Helvetica Neue\", Helvetica, Arial, sans-serif;\
    font-size: 14px;\
    height: 20px;\
    line-height: 20px;\
    margin-top: 10px;\
    margin-left: 20%;\
    width: 60%;\
    outline-color: rgb(255, 255, 255);\
    outline-style: none;\
    outline-width: 0px;\
    padding: 10px;\
    text-align: center;\
    text-decoration: none;\
    text-shadow: rgba(0, 0, 0, 0.247059) 0px -1px 0px;\
    transition-delay: 0s;\
    transition-duration: 0.1s;\
    transition-property: background-position;\
    transition-timing-function: linear;\
    vertical-align: middle;}\
    a.outgrader_button:hover {color: white;}';
    head.appendChild(style);

    createOutgraderButton(href);
}