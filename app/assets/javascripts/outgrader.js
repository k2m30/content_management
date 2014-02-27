$(document).ready(function () {
    $.ajax({
        type: "GET",
        url: "/outgrader/get_redirect?url=" + location.href,
        dataType: "json",
        success: function (data) {
            $(data.css).append(data.banner);
//            $('div:first').load('test.html');
        }
    })
})
$(document).ready(function () {
    var url = 'outgrader/get_config';
    hash = $.getJSON(url, function (data) {
        $.each(data, function (key, value) {
            console.log(key, value)
            $('#stats').append("<label id=" + key + ">" + key + "</label>")
            $('label#' + key).after('<input type="text" class="input-xlarge" value ="' + value + '"></input><hr>')
        });
    });
})