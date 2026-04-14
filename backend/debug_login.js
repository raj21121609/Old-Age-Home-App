const db = require('./database/db_postgres');

async function testLogin() {
  console.log('Testing login query...');
  const email = 'admin@example.com'; // Adjust to a known email from your migration
  const password = 'password123';   // Adjust to a known password

  try {
    const query = `
      SELECT u.id, u.name, u.email, u.role, u.old_age_home_id, h.name AS old_age_home_name
      FROM users u
      LEFT JOIN old_age_homes h ON u.old_age_home_id = h.id
      WHERE u.email = $1 AND u.password = $2
    `;
    const user = await db.get(query, [email, password]);
    console.log('User found:', user);
  } catch (err) {
    console.error('Login query failed with error:', err.message);
    console.error(err.stack);
  } finally {
    process.exit();
  }
}

testLogin();
