const { Pool } = require('pg');
require('dotenv').config();

// Check for required environment variables
if (!process.env.DATABASE_URL) {
  console.error('CRITICAL ERROR: DATABASE_URL is not defined in .env');
  process.exit(1);
}

// PostgreSQL connection pool Configuration
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: {
    rejectUnauthorized: false // Required for Supabase/Render connections
  }
});

pool.on('connect', () => {
  console.log('Connected to Supabase (PostgreSQL).');
});

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

// Helper to mimic SQLite's db.all (return rows)
const all = async (query, params = []) => {
  const result = await pool.query(query, params);
  return result.rows;
};

// Helper to mimic SQLite's db.get (return first row)
const get = async (query, params = []) => {
  const result = await pool.query(query, params);
  return result.rows[0];
};

// Helper to mimic SQLite's db.run (return metadata)
const run = async (query, params = []) => {
  const result = await pool.query(query, params);
  return { changes: result.rowCount, lastID: null }; // lastID is handled differently in PG (usually via RETURNING id)
};

module.exports = {
  pool,
  all,
  get,
  run,
  query: (text, params) => pool.query(text, params)
};
