const express = require('express');
const router = express.Router();
const cocktailController = require('../controllers/cocktailController');

router.get('/test', (req, res) => {
    res.json({ message: "Hallo"});
});

router.get('/', cocktailController.getCocktails);

router.post('/', cocktailController.createCocktail);

module.exports = router;
