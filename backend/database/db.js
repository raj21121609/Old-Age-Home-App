const sqlite3 = require('sqlite3').verbose();
const path = require('path');

// Connect to SQLite DB
const dbPath = path.resolve(__dirname, 'database.sqlite');
const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Error connecting to SQLite database:', err.message);
  } else {
    console.log('Connected to the SQLite database.');

    // Create tables
    db.serialize(() => {
      // Old Age Homes table
      db.run(`CREATE TABLE IF NOT EXISTS old_age_homes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        location TEXT,
        district TEXT,
        residents_count INTEGER DEFAULT 0,
        status TEXT DEFAULT 'active'
      )`);

      // Users table (updated to include old_age_home_id)
      db.run(`CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        role TEXT CHECK(role IN ('admin', 'government', 'caretaker')),
        status TEXT DEFAULT 'pending',
        old_age_home_id INTEGER,
        FOREIGN KEY (old_age_home_id) REFERENCES old_age_homes(id)
      )`);

      // Migration: Add old_age_home_id if it's missing (SQLite only)
      db.run(`ALTER TABLE users ADD COLUMN old_age_home_id INTEGER`, (err) => {
        if (err) {
          // If the column already exists, this will error (which we can ignore)
          if (!err.message.includes('duplicate column name')) {
             console.log('Note: users table already has old_age_home_id or encountered other issue:', err.message);
          }
        } else {
          console.log('Successfully migrated users table with old_age_home_id column.');
        }
      });

      // Elderly table
      db.run(`CREATE TABLE IF NOT EXISTS elderly (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        health_status TEXT,
        caretaker_id INTEGER,
        FOREIGN KEY (caretaker_id) REFERENCES users(id)
      )`);

      // Reports table
      db.run(`CREATE TABLE IF NOT EXISTS reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        elderly_id INTEGER,
        health_report TEXT,
        date TEXT,
        FOREIGN KEY (elderly_id) REFERENCES elderly(id)
      )`);

      console.log('Database tables ensured.');
    });
  }
});

module.exports = db;
