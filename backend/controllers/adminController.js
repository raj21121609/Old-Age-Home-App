const db = require('../database/db');

exports.createUser = (req, res) => {
  const { name, email, password, role } = req.body;
  if (!name || !email || !password || !role) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  // Auto approve admin and government users natively.
  const status = role === 'caretaker' ? 'pending' : 'approved';

  const query = 'INSERT INTO users (name, email, password, role, status) VALUES (?, ?, ?, ?, ?)';
  db.run(query, [name, email, password, role, status], function(err) {
    if (err) return res.status(500).json({ error: 'Failed to create user' });
    res.status(201).json({ message: 'User created', id: this.lastID });
  });
};

exports.deleteUser = (req, res) => {
  const { id } = req.params;
  const query = 'DELETE FROM users WHERE id = ?';
  db.run(query, [id], function(err) {
    if (err) return res.status(500).json({ error: 'Failed to delete user' });
    if (this.changes === 0) return res.status(404).json({ error: 'User not found' });
    res.json({ message: 'User deleted successfully' });
  });
};

exports.viewAllData = (req, res) => {
  const data = {};
  db.all('SELECT * FROM users', [], (err, users) => {
    if (err) return res.status(500).json({ error: 'Error fetching users' });
    data.users = users;
    db.all('SELECT * FROM elderly', [], (err, elderly) => {
      if (err) return res.status(500).json({ error: 'Error fetching elderly' });
      data.elderly = elderly;
      db.all('SELECT * FROM reports', [], (err, reports) => {
        if (err) return res.status(500).json({ error: 'Error fetching reports' });
        data.reports = reports;
        db.all('SELECT * FROM old_age_homes', [], (err, homes) => {
          if (err) return res.status(500).json({ error: 'Error fetching homes' });
          data.homes = homes;
          res.json(data);
        });
      });
    });
  });
};

exports.assignCaretaker = (req, res) => {
  const { elderly_id } = req.params;
  const { caretaker_id } = req.body;
  
  if (!caretaker_id) return res.status(400).json({ error: 'caretaker_id is required' });

  // Verify caretaker exists
  db.get('SELECT id FROM users WHERE id = ? AND role = "caretaker"', [caretaker_id], (err, user) => {
    if (err || !user) return res.status(404).json({ error: 'Caretaker not found' });

    const query = 'UPDATE elderly SET caretaker_id = ? WHERE id = ?';
    db.run(query, [caretaker_id, elderly_id], function(err) {
      if (err) return res.status(500).json({ error: 'Failed to assign caretaker' });
      if (this.changes === 0) return res.status(404).json({ error: 'Elderly not found' });
      res.json({ message: 'Caretaker assigned successfully' });
    });
  });
};
