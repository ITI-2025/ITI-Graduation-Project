require('dotenv').config();

// Import connections
const db = require('./config/mysql');
// const redisClient = require('./config/redis');

const express = require('express');
const app = express();
const port = 3000;

// Import routes
const routes = require('./routes/index');
app.use('/', routes);

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
