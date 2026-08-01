const recipeModel = require('../models/recipeModel');

// 1. Alle Rezepte holen
const getRecipes = async (req, res, next) => {
  try {
    const recipes = await recipeModel.getAllRecipes();
    return res.json(recipes); // Schickt das Array als JSON zurück
  } catch (error) {
    next(error); // Reicht Fehler an die errorHandler-Middleware weiter
  }
};

// 2. Ein neues Rezept erstellen
const createRecipe = async (req, res, next) => {
  try {
    const { name, ingredients, category, rating } = req.body;

    // Einfacher Sicherheits-Check
    if (!name) {
      return res.status(400).json({ error: 'Ein Rezept braucht mindestens einen Titel!' });
    }

    const newRecipe = await recipeModel.insertRecipe({ name, ingredients, category, rating});
    return res.status(201).json(newRecipe);
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getRecipes,
  createRecipe
};