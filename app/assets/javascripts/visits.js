$(function() {
    $('.tt').tooltip({
        placement: 'top',
        container: 'body'
    });

    new Morris.Line({
        // ID of the element in which to draw the chart.
        element: 'stats',
        // Chart data records -- each entry in this array corresponds to a point on
        // the chart.
        data: $('#stats').data('visits'),
        parseTime: false,
        // The name of the data record attribute that contains x-values.
        xkey: 'hour',
        // A list of names of data record attributes that contain y-values.
        ykeys: ['visits', 'downloads', 'users'],
        // Labels for the ykeys -- will be displayed when you hover over the
        // chart.
        labels: ['Посещенные страницы', 'Скачивания', 'Пользователи']
    });
});

