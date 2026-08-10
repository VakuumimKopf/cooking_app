const express = require('express');
const router = express.Router();
const cocktailController = require('../controllers/cocktailController');
const { cocktail } = require('../config/prisma');

router.get('/test', (req, res) => {
    res.json({ message: "Hallo"});
});

router.get('/', cocktailController.getCocktails);

router.post('/', cocktailController.createCocktail);

router.delete('/:id', cocktailController.deleteCocktail);

module.exports = router;
