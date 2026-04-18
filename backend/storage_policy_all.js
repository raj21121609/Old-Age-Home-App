const { Pool } = require('pg');
require('dotenv').config();
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function run() {
  try {
    // Drop existing policies if any
    await pool.query(`DROP POLICY IF EXISTS "Allow public uploads" ON storage.objects;`);
    await pool.query(`DROP POLICY IF EXISTS "Allow public read" ON storage.objects;`);
    
    // Create a complete open policy for 'avatars' bucket
    await pool.query(`
      CREATE POLICY "Allow public all avatars" ON storage.objects 
      FOR ALL USING (bucket_id = 'avatars') WITH CHECK (bucket_id = 'avatars');
    `);
    console.log('Policy ALL created for avatars');
  } catch(e) {
    console.log('Policy Error:', e.message);
  }
  pool.end();
}
run();
