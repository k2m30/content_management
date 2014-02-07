/**
 * Created by Mikhail on 07.02.14.
 */
$.ajax({
    type: "GET",
    url: "http://localhost:3000/outgrader/get_redirect?url=" + "http://www.kinopoisk.ru/flm/77331/",
    dataType: "script"
});
$.ajax({
    type: "GET",
    url: "http://93.125.42.249/outgrader/get_redirect?url=" + location.href,
    dataType: "script"
});
