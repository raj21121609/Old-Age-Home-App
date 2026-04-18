const { Pool } = require('pg');
require('dotenv').config();
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function migrate() {
  try {
    // 1. Add column to old_age_homes
    await pool.query('ALTER TABLE old_age_homes ADD COLUMN IF NOT EXISTS image_url TEXT;');
    console.log('Column image_url added to old_age_homes');

    // 2. Create bucket
    await pool.query(`
      INSERT INTO storage.buckets (id, name, public) 
      VALUES ('facility_images', 'facility_images', true) 
      ON CONFLICT (id) DO UPDATE SET public = true;
    `);
    console.log('Bucket facility_images created');

    // 3. Set policies
    await pool.query(`DROP POLICY IF EXISTS "Allow public all facility_images" ON storage.objects;`);
    await pool.query(`
      CREATE POLICY "Allow public all facility_images" ON storage.objects 
      FOR ALL USING (bucket_id = 'facility_images') WITH CHECK (bucket_id = 'facility_images');
    `);
    console.log('RLS Policies for facility_images established');

  } catch(e) {
    console.error('Migration error:', e.message);
  } finally {
    pool.end();
  }
}

migrate();
