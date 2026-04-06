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
          db.all('SELECT d.*, e.name AS elderly_name, h.name AS home_name, h.id AS home_id FROM daily_reports d JOIN elderly e ON d.elderly_id = e.id JOIN old_age_homes h ON e.old_age_home_id = h.id ORDER BY d.id DESC', [], (err, dailyReports) => {
            if (err) return res.status(500).json({ error: 'Error fetching daily reports' });
            data.daily_reports = dailyReports;
            res.json(data);
          });
        });
      });
    });
  });
};

exports.addResident = (req, res) => {
  const { name, age, gender, room, medical_conditions, emergency_contact, admission_date, old_age_home_id } = req.body;
  
  if (!name || !age || !old_age_home_id) {
    return res.status(400).json({ error: 'Name, age, and old_age_home_id are required' });
  }

  const query = `
    INSERT INTO elderly (name, age, gender, room, medical_conditions, emergency_contact, admission_date, old_age_home_id)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  
  db.run(query, [name, age, gender, room, medical_conditions, emergency_contact, admission_date, old_age_home_id], function(err) {
    if (err) {
      console.error('Error adding resident:', err.message);
      return res.status(500).json({ error: 'Failed to add resident' });
    }
    res.status(201).json({ message: 'Resident added successfully', id: this.lastID });
  });
};

exports.getResidentsByHome = (req, res) => {
  const { home_id } = req.params;
  
  const query = 'SELECT * FROM elderly WHERE old_age_home_id = ?';
  db.all(query, [home_id], (err, rows) => {
    if (err) {
      console.error('Error fetching residents:', err.message);
      return res.status(500).json({ error: 'Failed to fetch residents' });
    }
    res.json({ residents: rows });
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
