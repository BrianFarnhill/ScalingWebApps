var express = require('express');
var router = express.Router();
var mysql = require('mysql');

var pool = mysql.createPool({
    connectionLimit : 15,
    connectTimeout  : 60 * 60 * 1000,
    acquireTimeout  : 60 * 60 * 1000,
    timeout         : 60 * 60 * 1000,
    host            : process.env.DB_SERVER,
    user            : "builder",
    password        : "WebApp2018!",
    database        : "amznreviews"
});

router.get('/', function(req, res, next) {
    req.setTimeout(0);
    pool.getConnection(function (err, connection) {
        if (err) {
            console.log('Error getting mysql pool connection: ' + err);
            if (connection) {
                connection.release();
            }
            throw err;
        }

        //connection.query("select product_title, count(*) as total_products from auto group by product_title order by total_products DESC limit 100;", function (err2, result, fields) {
        connection.query("select product_title from auto  limit 10;", function (err2, result, fields) {
            if (err2) {
                console.log('Error executing query: ' + err2);
            }
            res.json(result);
            connection.release();
        });
    });
});

module.exports = router;
