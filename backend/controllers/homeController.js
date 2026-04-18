const db = require('../database/db_postgres');

exports.addHome = async (req, res) => {
  const { name, location, district, image_url } = req.body;

  if (!name || !location) {
    return res.status(400).json({ error: 'Name and location are required' });
  }

  try {
    const query = 'INSERT INTO old_age_homes (name, location, district, residents_count, image_url) VALUES ($1, $2, $3, 0, $4)';
    const result = await db.run(query, [name, location, district || '', image_url || null]);
    return res.status(201).json({
      message: 'Old age home added successfully',
      homeId: result.lastID,
      image_url: image_url || null
    });
  } catch (err) {
    return res.status(500).json({ error: 'Failed to add old age home' });
  }
};

exports.getAllHomes = async (req, res) => {
  try {
    const query = `
      SELECT h.*, 
      (SELECT COUNT(*) FROM elderly e WHERE e.old_age_home_id = h.id) as actual_residents_count 
      FROM old_age_homes h
    `;
    const rows = await db.all(query);
    return res.status(200).json(rows);
  } catch (err) {
    return res.status(500).json({ error: 'Failed to fetch old age homes' });
  }
};

exports.updateHomeImage = async (req, res) => {
  const { homeId, image_url } = req.body;
  if (!homeId || !image_url) {
    return res.status(400).json({ error: 'homeId and image_url are required' });
  }

  try {
    const query = 'UPDATE old_age_homes SET image_url = $1 WHERE id = $2';
    await db.run(query, [image_url, homeId]);
    return res.status(200).json({ message: 'Home image updated successfully' });
  } catch (err) {
    return res.status(500).json({ error: 'Failed to update home image' });
  }
};
