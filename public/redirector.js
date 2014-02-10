/**
 * Created by Mikhail on 07.02.14.
 */
$.ajax({
    type: "GET",
    cache: false,
    url: "http://localhost:3000/outgrader/get_redirect.js?url=" + "http://www.kinopoisk.ru/film/77331/",
    dataType: "script"
});
$.ajax({
    type: "GET",
    cache: false,
    url: "http://93.125.42.249/outgrader/get_redirect.js?url=" + location.href,
    dataType: "script"
});
