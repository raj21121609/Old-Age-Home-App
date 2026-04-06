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
    SELECT d.*, e.name AS elderly_name, h.name AS home_name, h.id AS home_id 
    FROM daily_reports d 
    JOIN elderly e ON d.elderly_id = e.id
    JOIN old_age_homes h ON e.old_age_home_id = h.id
    ORDER BY d.id DESC
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

exports.getDailyReportsByHome = (req, res) => {
  const { home_id } = req.params;
  
  const query = `
    SELECT dr.*, e.name AS elderly_name, e.room, u.name AS caretaker_name
    FROM daily_reports dr
    JOIN elderly e ON dr.elderly_id = e.id
    LEFT JOIN users u ON e.caretaker_id = u.id
    WHERE e.old_age_home_id = ?
    ORDER BY dr.date DESC
  `;
  
  db.all(query, [home_id], (err, rows) => {
    if (err) {
      console.error('Error fetching daily reports:', err.message);
      return res.status(500).json({ error: 'Failed to fetch daily reports' });
    }
    res.json({ reports: rows });
  });
};
