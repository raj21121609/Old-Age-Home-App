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
      // Users table
      db.run(`CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        role TEXT CHECK(role IN ('admin', 'government', 'caretaker')),
        status TEXT DEFAULT 'pending'
      )`);

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
