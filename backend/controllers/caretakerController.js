const db = require('../database/db');

exports.addElderly = (req, res) => {
  const { name, age, health_status, caretaker_id } = req.body;
  if (!name || !age || !caretaker_id) {
    return res.status(400).json({ error: 'Name, age, and caretaker_id are required' });
  }

  const query = 'INSERT INTO elderly (name, age, health_status, caretaker_id) VALUES (?, ?, ?, ?)';
  db.run(query, [name, age, health_status || 'Good', caretaker_id], function(err) {
    if (err) return res.status(500).json({ error: 'Failed to add elderly person' });
    res.status(201).json({ message: 'Elderly added successfully', id: this.lastID });
  });
};

exports.updateHealthStatus = (req, res) => {
  const { id } = req.params;
  const { health_status, health_report } = req.body;
  
  if (!health_status) return res.status(400).json({ error: 'health_status is required' });

  const query = 'UPDATE elderly SET health_status = ? WHERE id = ?';
  db.run(query, [health_status, id], function(err) {
    if (err) return res.status(500).json({ error: 'Failed to update health status' });
    if (this.changes === 0) return res.status(404).json({ error: 'Elderly not found' });
    
    // Insert into reports table if health_report is provided
    if (health_report) {
      const reportQuery = 'INSERT INTO reports (elderly_id, health_report, date) VALUES (?, ?, ?)';
      db.run(reportQuery, [id, health_report, new Date().toISOString()]);
    }
    
    res.json({ message: 'Health status updated successfully' });
  });
};

exports.viewAssignedElderly = (req, res) => {
  const { caretaker_id } = req.params;
  const query = 'SELECT * FROM elderly WHERE caretaker_id = ?';
  db.all(query, [caretaker_id], (err, rows) => {
    if (err) return res.status(500).json({ error: 'Failed to fetch elderly data' });
    res.json({ elderly: rows });
  });
};
