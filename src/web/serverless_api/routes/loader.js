var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.send(`$(document).ready(function() {
        $.ajaxSetup({ cache: false });
        
        $.getJSON('` + process.env.API_URL + `/latest', function(result) {
            var html = '';
            $.each(result.Items, function (key, val) {
                html += '<tr><th scope="row">' + val.product_title.S + '</th><td>' + val.product_id.S + '</td><td>' + val.total_reviews.N + '</td></tr>'
            })
            $('#DynamicData').html(html);
        });
    });
    `);
});

module.exports = router;
