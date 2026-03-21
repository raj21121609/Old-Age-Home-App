const express = require('express');
const router = express.Router();
const caretakerController = require('../controllers/caretakerController');

router.post('/elderly', caretakerController.addElderly);
router.put('/elderly/:id/health', caretakerController.updateHealthStatus);
router.get('/:caretaker_id/elderly', caretakerController.viewAssignedElderly);

module.exports = router;
