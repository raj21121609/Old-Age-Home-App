const db = require('../database/db');

exports.register = (req, res) => {
  const { name, email, password, role, old_age_home_id } = req.body;

  // Basic validation
  if (!name || !email || !password || !role) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  // Insert user
  const query = 'INSERT INTO users (name, email, password, role, old_age_home_id) VALUES (?, ?, ?, ?, ?)';
  db.run(query, [name, email, password, role, old_age_home_id || null], function(err) {
    if (err) {
      if (err.message.includes('UNIQUE constraint failed')) {
        return res.status(409).json({ error: 'Email already exists' });
      }
      return res.status(500).json({ error: 'Failed to register user' });
    }
    
    return res.status(201).json({
      message: 'Registration successful',
      user: {
        id: this.lastID,
        name,
        email,
        role,
        old_age_home_id
      }
    });
  });
};

exports.login = (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  const query = `
    SELECT u.id, u.name, u.email, u.role, u.old_age_home_id, h.name AS old_age_home_name
    FROM users u
    LEFT JOIN old_age_homes h ON u.old_age_home_id = h.id
    WHERE u.email = ? AND u.password = ?
  `;
  db.get(query, [email, password], (err, user) => {
    if (err) {
      return res.status(500).json({ error: 'Database error during login' });
    }
    
    if (!user) {
      return res.status(401).json({ error: 'Invalid email or password' });
    }

    return res.status(200).json({
      message: 'Login successful',
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        role: user.role,
        old_age_home_id: user.old_age_home_id,
        old_age_home_name: user.old_age_home_name
      }
    });
  });
};
