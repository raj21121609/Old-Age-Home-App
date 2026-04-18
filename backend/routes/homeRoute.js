const express = require('express');
const router = express.Router();
const homeController = require('../controllers/homeController');

router.post('/', homeController.addHome);
router.put('/update-image', homeController.updateHomeImage);
router.get('/', homeController.getAllHomes);

module.exports = router;
