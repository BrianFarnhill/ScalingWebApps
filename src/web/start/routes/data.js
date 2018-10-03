var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
    res.json({
        data: [
            {
                ID: 1,
                Name: "hello"
            },
            {
                ID: 2,
                Name: "world"
            },
            {
                ID: 3,
                Name: "Brian"
            },
            {
                ID: 4,
                Name: "was"
            },
            {
                ID: 5,
                Name: "here"
            }
        ]
    });
});

module.exports = router;
