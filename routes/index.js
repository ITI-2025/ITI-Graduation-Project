const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send('Hello from Node.js app with MySQL and Redis!');
});

const db = require('../config/mysql');

router.get('/db', (req, res) => {
    db.query('SELECT NOW() AS now', (err, results) => {
        if (err) return res.status(500).send('Database error');
        res.send(`Database time: ${results[0].now}`);
    });
});

const redisClient = require('../config/redis');
router.get('/cache', async (req, res) => {
  await redisClient.set('timestamp', new Date().toISOString());
  const value = await redisClient.get('timestamp');
  res.send(`Redis cached time: ${value}`);
});

module.exports = router;
