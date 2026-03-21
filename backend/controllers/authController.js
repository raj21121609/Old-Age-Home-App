const db = require('../database/db');

exports.register = (req, res) => {
  const { name, email, password, role } = req.body;

  // Basic validation
  if (!name || !email || !password || !role) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  // Check if role is valid
  const validRoles = ['admin', 'government', 'caretaker'];
  if (!validRoles.includes(role)) {
    return res.status(400).json({ error: 'Invalid role' });
  }

  // Ensure email doesn't already exist
  db.get('SELECT email FROM users WHERE email = ?', [email], (err, row) => {
    if (err) {
      return res.status(500).json({ error: 'Database error while checking email' });
    }
    if (row) {
      return res.status(409).json({ error: 'Email already exists' });
    }

    // Insert user
    const query = 'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)';
    db.run(query, [name, email, password, role], function(err) {
      if (err) {
        return res.status(500).json({ error: 'Failed to register user' });
      }
      
      return res.status(201).json({
        message: 'Registration successful',
        user: {
          id: this.lastID,
          name,
          email,
          role
        }
      });
    });
  });
};

exports.login = (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'Email and password are required' });
  }

  const query = 'SELECT id, name, email, role FROM users WHERE email = ? AND password = ?';
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
        role: user.role
      }
    });
  });
};
