import pkg from 'pg';
import dotenv from 'dotenv';

dotenv.config();

const { Pool } = pkg;

console.log("🚀 Starting DB test...");

const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
});

async function testDB() {
    try {
        console.log("⏳ Connecting to DB...");
        const res = await pool.query("SELECT NOW()");
        console.log("✅ DB Connected:", res.rows[0]);
    } catch (err) {
        console.error("❌ DB Connection Failed:", err);
    } finally {
        await pool.end();
        console.log("🔚 Done");
    }
}

testDB();