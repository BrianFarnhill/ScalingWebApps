$(document).ready(function() {
    $.ajaxSetup({ cache: false });
    
    $.getJSON('/data', function(result) {
        var html = '';
        $.each(result, function (key, val) {
            html += '<tr><th scope="row">' + val.product_title + '</th><td>' + val.product_id + '</td><td>' + val.total_reviews + '</td></tr>'
        })
        $('#DynamicData').html(html);
    });
});
