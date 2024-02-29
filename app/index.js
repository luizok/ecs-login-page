const { countAccess } = require('./src/metrics');


const express = require('express');
const app = express();

app.use(countAccess)

app.get('/', (req, res) => {
  res.send('Hello World');
});

app.get('/health', (req, res) => {
  res.send('OK');
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
