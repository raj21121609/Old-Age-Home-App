const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');

router.post('/users', adminController.createUser);
router.delete('/users/:id', adminController.deleteUser);
router.get('/all', adminController.viewAllData);
router.put('/elderly/:elderly_id/assign', adminController.assignCaretaker);

module.exports = router;
