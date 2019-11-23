var express = require('express');
var router = express.Router();
const { Pool } = require('pg')
var redis = require('redis');
var client = redis.createClient(6379, process.env.REDIS_ADDRESS, {
    no_ready_check: true
 });

const pool = new Pool({
    host: process.env.DB_SERVER,
    user: 'Administrator',
    password: 'WebApp2018!',
    database: 'amznreviews',
    max: 15,
    idleTimeoutMillis: 60 * 60 * 1000,
    connectionTimeoutMillis: 60 * 60 * 1000,
  })

pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err)
})

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
            pool.query("select titles.product_title, titles.product_id, pids.total_reviews from auto titles right join (select product_id, count(product_id) as total_reviews from auto group by product_id order by total_reviews DESC limit 25) pids on titles.product_id = pids.product_id group by titles.product_id, product_title, pids.total_reviews order by pids.total_reviews DESC;", null, (error, result) => {
                if (error) {
                    console.log('Error getting postgres pool connection: ' + error);
                }
                client.set(cacheKey, JSON.stringify(result), 'EX', 60, redis.print);
                res.header('Cache-Control', 'private, no-cache, no-store, must-revalidate');
                res.header('Expires', '-1');
                res.header('Pragma', 'no-cache');
                res.json(result);
            })
        }
    });

    
});

module.exports = router;
