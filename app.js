var express = require('express');
var app = express();

var DataDog = require('./node-datadog');
var api_key = "your api key";
var app_key = "your app key";
var dd = new DataDog(api_key, app_key);

app.get('/', function (req, res) {
    console.log(req.query);
    var temp = req.query['t'];
    var humid = req.query['h'];

    dd.postSeries({
        "series": [
            {
                "metric": "arduino.temperature",
                "points": [
                    [Date.now()/1000, req.query['t']]
                ],
                "type": "gauge",
                "tags": ["arduino", "temperature"]
            },
            {
                "metric": "arduino.humidity",
                "points": [
                    [Date.now()/1000, req.query['h']]
                ],
                "type": "gauge",
                "tags": ["arduino", "humidity"]
            }
        ]
    });

});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});
