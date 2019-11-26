const { Client } = require('pg')
const response = require("cfn-response")

function postResponse(event, context, status, data){
    return new Promise((resolve, reject) => {
        setTimeout(() => response.send(event, context, status, data), 5000)
    });
}

exports.handler = async (event, context) => { 
    console.log(JSON.stringify(event));

    if (event.RequestType === 'Delete') {
        await postResponse(event, context, "SUCCESS", {})
        return
    }

    const client = new Client()
    await client.connect()

    const res1 = await client.query('CREATE EXTENSION aws_s3 CASCADE;')
    console.log(res1)
    const res2 = await client.query('CREATE TABLE auto (marketplace char(2) DEFAULT NULL, customer_id varchar(12) DEFAULT NULL, review_id varchar(14) DEFAULT NULL, product_id varchar(14) DEFAULT NULL, product_parent varchar(14) DEFAULT NULL, product_title text DEFAULT NULL, product_category varchar(50) DEFAULT NULL, star_rating int DEFAULT NULL, helpful_votes int DEFAULT NULL, total_votes int DEFAULT NULL, vine char(1) DEFAULT NULL, verified_purchase char(1) DEFAULT NULL, review_headline text DEFAULT NULL, review_body text DEFAULT NULL, review_date date DEFAULT NULL, PRIMARY KEY (product_id, review_id) );')
    console.log(res2)
    const res3 = await client.query("SELECT aws_s3.table_import_from_s3('auto', '', 'DELIMITER E''\\t''', aws_commons.create_s3_uri('hawkea-lab-test2', 'auto250k','ap-southeast-2') );")
    console.log(res3)
    await client.end()

    await postResponse(event, context, "SUCCESS", {})
}
