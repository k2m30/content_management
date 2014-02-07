$(document).ready(function () {
    $.ajax({
        type: "GET",
        url: "/outgrader/get_redirect?url=" + location.href,
        dataType: "json",
        success: function (data){
            $(data.css).append(data.banner);
//            $('div:first').load('test.html');
        }
    })
})