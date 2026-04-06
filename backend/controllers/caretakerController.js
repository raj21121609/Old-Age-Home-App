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
  
  // First get the old_age_home_id of this caretaker
  db.get('SELECT old_age_home_id FROM users WHERE id = ?', [caretaker_id], (err, user) => {
    if (err || !user) return res.status(404).json({ error: 'Caretaker not found' });
    
    // Show all elderly persons belonging to the same home
    const query = 'SELECT * FROM elderly WHERE old_age_home_id = ? OR caretaker_id = ?';
    db.all(query, [user.old_age_home_id, caretaker_id], (err, rows) => {
      if (err) return res.status(500).json({ error: 'Failed to fetch elderly data' });
      res.json({ elderly: rows });
    });
  });
};

exports.addDailyReport = (req, res) => {
  const {
    elderly_id,
    date,
    breakfast,
    lunch,
    dinner,
    medicine_given,
    medicine_time,
    physical_activity,
    bathing,
    clothes_changed,
    mood,
    issues,
    photo_path
  } = req.body;

  if (!elderly_id || !date) {
    return res.status(400).json({ error: 'elderly_id and date are required' });
  }

  const query = `
    INSERT INTO daily_reports (
      elderly_id, date, breakfast, lunch, dinner, 
      medicine_given, medicine_time, physical_activity, 
      bathing, clothes_changed, mood, issues, photo_path
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `;

  const params = [
    elderly_id, date, breakfast ? 1 : 0, lunch ? 1 : 0, dinner ? 1 : 0,
    medicine_given ? 1 : 0, medicine_time, physical_activity,
    bathing ? 1 : 0, clothes_changed ? 1 : 0, mood, issues, photo_path
  ];

  db.run(query, params, function(err) {
    if (err) {
      console.error('Error adding daily report:', err.message);
      return res.status(500).json({ error: 'Failed to add daily report' });
    }
    
    // Also update health status in elderly table
    const statusQuery = 'UPDATE elderly SET health_status = ? WHERE id = ?';
    const status = issues && issues.trim().length > 0 ? 'attention' : 'good';
    db.run(statusQuery, [status, elderly_id]);

    res.status(201).json({ message: 'Daily report added successfully', id: this.lastID });
  });
};
