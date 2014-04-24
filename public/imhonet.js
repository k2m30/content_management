function addButton() {
    var original_button = document.querySelectorAll('a.btn.use-way.btn-inverse.btn-theme.is-masked')[1];
    var outgrader_button = document.createElement('a');
    outgrader_button.setAttribute('title', 'Скачать');
    outgrader_button.setAttribute('target', 'blank');
    outgrader_button.setAttribute('class', 'btn use-way btn-inverse btn-theme is-masked');
    outgrader_button.innerHTML = "<i class='icon icon-str-bottom'></i>";
    outgrader_button.setAttribute('data-content', 'Скачать в сети провайдера');
    outgrader_button.setAttribute('href', href);
    outgrader_button.onclick = function () {
        sendClick(location.href);
    };
    original_button.parentNode.insertBefore(outgrader_button, original_button);
}