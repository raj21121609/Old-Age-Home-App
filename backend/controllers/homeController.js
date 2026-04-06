const db = require('../database/db');

exports.addHome = (req, res) => {
  const { name, location, district, residents } = req.body;

  if (!name || !location) {
    return res.status(400).json({ error: 'Name and location are required' });
  }

  const query = 'INSERT INTO old_age_homes (name, location, district, residents_count) VALUES (?, ?, ?, ?)';
  db.run(query, [name, location, district || '', residents || 0], function(err) {
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
  const query = 'SELECT * FROM old_age_homes';
  db.all(query, [], (err, rows) => {
    if (err) {
      return res.status(500).json({ error: 'Failed to fetch old age homes' });
    }
    return res.status(200).json(rows);
  });
};
