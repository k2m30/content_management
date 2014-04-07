$(function () {
    $('.tt').tooltip({
        placement: 'top',
        container: 'body'
    });

    if (document.querySelector('#hourly_stats')!=null) {
        new Morris.Line({
            // ID of the element in which to draw the chart.
            element: 'hourly_stats',
            // Chart data records -- each entry in this array corresponds to a point on
            // the chart.
            data: $('#hourly_stats').data('visits'),
            parseTime: false,
            // The name of the data record attribute that contains x-values.
            xkey: 'hour',
            // A list of names of data record attributes that contain y-values.
            ykeys: ['visits', 'downloads', 'users'],
            // Labels for the ykeys -- will be displayed when you hover over the
            // chart.
            labels: ['Посещенные страницы', 'Скачивания', 'Пользователи']
        });

        new Morris.Line({
            // ID of the element in which to draw the chart.
            element: 'daily_stats',
            // Chart data records -- each entry in this array corresponds to a point on
            // the chart.
            data: $('#daily_stats').data('visits'),
            parseTime: false,
            // The name of the data record attribute that contains x-values.
            xkey: 'day',
            // A list of names of data record attributes that contain y-values.
            ykeys: ['visits', 'downloads', 'users'],
            // Labels for the ykeys -- will be displayed when you hover over the
            // chart.
            labels: ['Посещенные страницы', 'Скачивания', 'Пользователи']
        });

        new Morris.Line({
            // ID of the element in which to draw the chart.
            element: 'weekly_stats',
            // Chart data records -- each entry in this array corresponds to a point on
            // the chart.
            data: $('#weekly_stats').data('visits'),
            parseTime: false,
            // The name of the data record attribute that contains x-values.
            xkey: 'week',
            // A list of names of data record attributes that contain y-values.
            ykeys: ['visits', 'downloads', 'users'],
            // Labels for the ykeys -- will be displayed when you hover over the
            // chart.
            labels: ['Посещенные страницы', 'Скачивания', 'Пользователи']
        });
    }
});

