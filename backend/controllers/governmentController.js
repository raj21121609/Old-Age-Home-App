const db = require('../database/db');

exports.viewAllElderly = (req, res) => {
  const query = 'SELECT * FROM elderly';
  db.all(query, [], (err, rows) => {
    if (err) return res.status(500).json({ error: 'Failed to retrieve elderly data' });
    res.json({ elderly: rows });
  });
};

exports.viewReports = (req, res) => {
  const query = `
    SELECT r.id, r.health_report, r.date, e.name AS elderly_name 
    FROM reports r 
    JOIN elderly e ON r.elderly_id = e.id
  `;
  db.all(query, [], (err, rows) => {
    if (err) return res.status(500).json({ error: 'Failed to retrieve reports' });
    res.json({ reports: rows });
  });
};

exports.approveRejectHome = (req, res) => {
  const { id } = req.params; // Caretaker (Home) user ID
  const { status } = req.body; // 'approved' or 'rejected'
  
  if (!['approved', 'rejected'].includes(status)) {
    return res.status(400).json({ error: 'Status must be approved or rejected' });
  }

  const query = 'UPDATE users SET status = ? WHERE id = ? AND role = "caretaker"';
  db.run(query, [status, id], function(err) {
    if (err) return res.status(500).json({ error: 'Failed to update home status' });
    if (this.changes === 0) return res.status(404).json({ error: 'Caretaker (Home) not found' });
    res.json({ message: `Home status updated to ${status}` });
  });
};
