## node-datadog

A node module for interacting with the DataDog API.


### Sending Events

```js
var DataDog = require('datadog');

var dd = new DataDog('API_KEY', 'APPLICATION_KEY');

dd.postEvent({
   title: 'Events, events, events',
   text: 'Testing events.'
});
```


### Sending Counters

```js
var DataDog = require('datadog');

var dd = new DataDog('API_KEY', 'APPLICATION_KEY');

dd.postSeries({
    "series": [{
        "metric": "test.ddagent.series",
        "points": [
            [Date.now()/1000, 1]
        ],
        "type": "counter",
        "tags": ["test", "test-series"]
    }]
})
```

### Sending Gauges

```js
var DataDog = require('datadog');

var dd = new DataDog('API_KEY', 'APPLICATION_KEY');

dd.postSeries({
    "series": [{
        "metric": "test.ddagent.series",
        "points": [
            [Date.now()/1000, 1]
        ],
        "type": "gauge",
        "tags": ["test", "test-series"]
    }]
})
```
