const express = require('express');
const cors = require('cors');
const routes = require('./routes/index');
const db = require('./database/db'); // Require db to ensure connection and table creation

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 5000;

// Set up CORS
app.use(cors());

// Enable JSON parsing
app.use(express.json());

// Set up routes
app.use('/', routes);

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
