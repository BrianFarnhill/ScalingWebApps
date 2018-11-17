var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var redis = require('redis');
var client = redis.createClient(6379, process.env.REDIS_ADDRESS, {
    no_ready_check: true
 });


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

    var cacheKey = 'TestData';
    client.get(cacheKey, function(err4, result) {
        if (result) {
            if (err4) { console.log('Redis error: ' + err4); }
            res.header('Cache-Control', 'private, no-cache, no-store, must-revalidate');
            res.header('Expires', '-1');
            res.header('Pragma', 'no-cache');
            res.send(result);
        } else {
            pool.getConnection(function (err, connection) {
                if (err) {
                    console.log('Error getting mysql pool connection: ' + err);
                    if (connection) {
                        connection.release();
                    }
                    throw err;
                }
        
                connection.query("select titles.product_title, titles.product_id, pids.total_reviews from auto titles right join (select product_id, count(product_id) as total_reviews from auto group by product_id order by total_reviews DESC limit 25) pids on titles.product_id = pids.product_id group by product_id, product_title order by pids.total_reviews DESC;", function (err2, result, fields) {
                    if (err2) {
                        console.log('Error executing query: ' + err2);
                    }

                    client.set(cacheKey, JSON.stringify(result), 'EX', 60, redis.print);
                    res.header('Cache-Control', 'private, no-cache, no-store, must-revalidate');
                    res.header('Expires', '-1');
                    res.header('Pragma', 'no-cache');
                    res.json(result);
                    connection.release();
                });
            });
        }
    });
});

module.exports = router;
