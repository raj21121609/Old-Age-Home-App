const express = require('express');
const router = express.Router();
const indexController = require('../controllers/indexController');
const authRoute = require('./authRoute');
const caretakerRoute = require('./caretakerRoute');
const governmentRoute = require('./governmentRoute');
const adminRoute = require('./adminRoute');

// Root route
router.get('/', indexController.getRoot);

// API routes
router.use('/api/auth', authRoute);
router.use('/api/caretaker', caretakerRoute);
router.use('/api/government', governmentRoute);
router.use('/api/admin', adminRoute);

module.exports = router;
