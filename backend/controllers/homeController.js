const db = require('../database/db');

exports.addHome = (req, res) => {
  const { name, location, district } = req.body;

  if (!name || !location) {
    return res.status(400).json({ error: 'Name and location are required' });
  }

  const query = 'INSERT INTO old_age_homes (name, location, district, residents_count) VALUES (?, ?, ?, 0)';
  db.run(query, [name, location, district || ''], function(err) {
    if (err) {
      return res.status(500).json({ error: 'Failed to add old age home' });
    }
    return res.status(201).json({
      message: 'Old age home added successfully',
      homeId: this.lastID
    });
  });
};

exports.getAllHomes = (req, res) => {
  const query = `
    SELECT h.*, 
    (SELECT COUNT(*) FROM elderly e WHERE e.old_age_home_id = h.id) as actual_residents_count 
    FROM old_age_homes h
  `;
  db.all(query, [], (err, rows) => {
    if (err) {
      return res.status(500).json({ error: 'Failed to fetch old age homes' });
    }
    return res.status(200).json(rows);
  });
};
