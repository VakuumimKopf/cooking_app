const express = require('express');
const router = express.Router();
const itemController = require('../controllers/itemController');

router.get('/test', (req, res) => {
    res.json({ message: "Hallo"});
});

router.get('/', itemController.getItems);

router.post('/', itemController.createItem);

module.exports = router;
