const Database = require('better-sqlite3');
const { Pool } = require('pg');
const path = require('path');
require('dotenv').config();

const sqliteDbPath = path.resolve(__dirname, 'database.sqlite');
const db = new Database(sqliteDbPath);

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function migrate() {
  console.log('Starting migration...');

  const tables = ['old_age_homes', 'users', 'elderly', 'reports', 'daily_reports'];

  try {
    for (const table of tables) {
      console.log(`Migrating table: ${table}...`);

      // 1. Fetch data from SQLite
      const rows = db.prepare(`SELECT * FROM ${table}`).all();

      if (rows.length === 0) {
        console.log(`Table ${table} is empty. Skipping.`);
        continue;
      }

      // 2. Clear existing data in Postgres (optional, but safer for a fresh start)
      // await pool.query(`TRUNCATE TABLE ${table} RESTART IDENTITY CASCADE`);

      // 3. Insert into Postgres
      const keys = Object.keys(rows[0]);
      const columns = keys.join(', ');
      const placeholders = keys.map((_, i) => `$${i + 1}`).join(', ');

      const insertQuery = `INSERT INTO ${table} (${columns}) VALUES (${placeholders}) ON CONFLICT (id) DO NOTHING`;

      for (const row of rows) {
        await pool.query(insertQuery, keys.map(k => row[k]));
      }

      // 4. Reset sequences (Since we inserted IDs manually, SERIAL needs to be updated)
      console.log(`Resetting sequence for ${table}...`);
      await pool.query(`SELECT setval(pg_get_serial_sequence('${table}', 'id'), MAX(id)) FROM ${table}`);

      console.log(`Finished migrating ${table}.`);
    }

    console.log('MIGRATION COMPLETED SUCCESSFULLY!');
  } catch (err) {
    console.error('MIGRATION FAILED:', err.message);
  } finally {
    await pool.end();
    db.close();
  }
}

migrate();

