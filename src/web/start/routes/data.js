var express = require('express');
var router = express.Router();
var mysql = require('mysql');

router.get('/', function(req, res, next) {
    var con = mysql.createConnection({
        host: process.env.DB_SERVER,
        user: "builder",
        password: "WebApp2018!",
        database: "amznreviews"
      });

      con.connect(function(err) {
        if (err) throw err;
        con.query("select product_title, count(*) as total_products from auto group by product_title order by total_products DESC limit 100;", function (err, result, fields) {
          if (err) throw err;
          res.json(result);
        });
      });
});

module.exports = router;
