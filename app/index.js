const { putMetricData } = require('./src/metrics');


const express = require('express');
const app = express();

app.get('/', putMetricData, (req, res) => {
  console.log('Got a request');
  res.send('Hello World');
});

app.get('/health', (req, res) => {
  res.send('OK');
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
