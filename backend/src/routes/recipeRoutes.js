const express = require('express');
const router = express.Router();
const recipeController = require('../controllers/recipeController');

router.get('/test', (req, res) => {
    res.json({ message: "Hallo"});
});

router.get('/', recipeController.getRecipes);

router.post('/', recipeController.createRecipe);

module.exports = router;
