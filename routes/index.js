const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.send('Hello from Node.js app with MySQL and Redis!');
});

module.exports = router;
