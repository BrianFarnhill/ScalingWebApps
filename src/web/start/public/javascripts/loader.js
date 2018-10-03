$(document).ready(function() {
    $.getJSON('/data', function(result) {
        var html = '';
        $.each(result.data, function (key, val) {
            html += '<p>ID: ' + val.ID + '; Name: ' + val.Name + '</p>'
        })
        $('#DynamicData').html(html);
    });
});
