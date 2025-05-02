const express = require('express');
const mysql = require('mysql2/promise');
const redis = require('redis');

const app = express();
const port = 3000;

// MySQL connection configuration
const dbConfig = {
  host: process.env.DB_HOST || 'db',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'mysecretpassword',
  database: process.env.DB_NAME || 'nodejs_app',
  port: process.env.DB_PORT || 3306,
};

// Redis connection configuration
const redisClient = redis.createClient({
  url: `redis://${process.env.REDIS_HOST || 'redis'}:${process.env.REDIS_PORT || 6379}`,
});

// Handle Redis connection errors
redisClient.on('error', (err) => console.error('Redis Client Error', err));

// Connect to Redis
(async () => {
  await redisClient.connect();
})();

// Retry logic for MySQL connection
async function connectWithRetry() {
  const maxRetries = 10;
  const retryInterval = 5000; // 5 seconds
  let retries = 0;

  while (retries < maxRetries) {
    try {
      const connection = await mysql.createConnection(dbConfig);
      console.log('Connected to MySQL');
      return connection;
    } catch (err) {
      console.error(`MySQL connection attempt ${retries + 1} failed:`, err.message);
      retries++;
      if (retries === maxRetries) {
        throw new Error('Max retries reached. Could not connect to MySQL.');
      }
      await new Promise((resolve) => setTimeout(resolve, retryInterval));
    }
  }
}

// Initialize MySQL table
async function initializeDatabase() {
  const connection = await connectWithRetry();
  try {
    await connection.execute(`
      CREATE TABLE IF NOT EXISTS visits (
        id INT AUTO_INCREMENT PRIMARY KEY,
        count INT NOT NULL
      )
    `);
    // Insert initial count if not exists
    const [rows] = await connection.execute('SELECT * FROM visits WHERE id = 1');
    if (rows.length === 0) {
      await connection.execute('INSERT INTO visits (id, count) VALUES (1, 0)');
    }
  } finally {
    await connection.end();
  }
}

// Route to display visit count
app.get('/', async (req, res) => {
  try {
    // Check Redis cache
    const cachedCount = await redisClient.get('visit_count');
    if (cachedCount) {
      return res.send(`hello summonerr Welcome to the leauge of draven | It Works perfectly :)  ! Page visits (cached): ${cachedCount}`);
    }

    // Fetch from MySQL
    const connection = await connectWithRetry();
    try {
      const [rows] = await connection.execute('SELECT count FROM visits WHERE id = 1');
      let count = rows[0].count;

      // Increment count
      count += 1;
      await connection.execute('UPDATE visits SET count = ? WHERE id = 1', [count]);

      // Cache the new count in Redis for 10 seconds
      await redisClient.setEx('visit_count', 10, count.toString());

      res.send(`hello summoner Welcome to the leauge of draven ! Page visits: ${count}`);
    } finally {
      await connection.end();
    }
  } catch (err) {
    console.error(err);
    res.status(500).send('Internal Server Error');
  }
});

// Start the server
app.listen(port, async () => {
  try {
    await initializeDatabase();
    console.log(`Example app listening at http://localhost:${port}`);
  } catch (err) {
    console.error('Failed to initialize database:', err);
    process.exit(1);
  }
});



