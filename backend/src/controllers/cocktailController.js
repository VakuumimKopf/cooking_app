const { cocktail } = require('../config/prisma');
const cocktailModel = require('../models/cocktailModel');

const getCocktails = async (req, res, next) => {
    try {
        const rawCocktails = await cocktailModel.getAllCocktails();

        const formattedCocktails = rawCocktails.map(cocktail => ({
            id: cocktail.id,
            name: cocktail.name,
            taste: cocktail.taste,
            rating: cocktail.rating,
            createdAt: cocktail.createdAt,
            ingredients: cocktail.ingredients.map(ing => ({
                id: ing.item.id,
                name: ing.item.name,
                amount: ing.amount
            }))
        }));

        return res.json(formattedCocktails);
    } catch (error) {
        next(error)
    }
};

const getCocktailById = async (req, res, next) => {
    try {
        const { id } = req.params;

        const cocktail = await cocktailModel.getCocktailById(id);

        if (!cocktail) {
            return res.status(404).json({ 
                error: `Cocktail mit ID ${id} wurde nicht gefunden.` 
            });
        }

        const formattedCocktail = {
            id: cocktail.id,
            name: cocktail.name,
            taste: cocktail.taste,
            rating: cocktail.rating,
            ingredients: cocktail.ingredients.map(ing => ({
                id: ing.item.id,
                name: ing.item.name,
                amount: ing.amount
            }))
        };

        return res.json(formattedCocktail);
    } catch (error) {
        next(error)
    }
};

const createCocktail = async (req, res, next) => {
    try {
        const { name, taste, rating, ingredients} = req.body;

        // Sicherheits-Checks

        const newCocktail = await cocktailModel.createCocktail({ name, taste, rating, ingredients});
        return res.status(201).json(newCocktail);
    } catch (error) {
        next(error);
    }
};

const deleteCocktail = async (req, res, next) => {
    try {
        const { id } = req.params;
        const deletedCocktail = await cocktailModel.deleteCocktail(id);

        return res.status(204).send();
    } catch (error) {
        next(error);
    }
};

const putCocktail = async (req, res, next) => {
  try {
    const { id } = req.params;

    // 🔍 Debug-Log: Schau in dein Backend-Terminal, was hier ausgegeben wird!
    console.log("Empfangene Daten im Controller:", req.body);

    const updatedCocktail = await cocktailModel.updateCocktail(id, req.body);

    // Formatierte Rückgabe für das Frontend
    return res.status(200).json({
      id: updatedCocktail.id,
      name: updatedCocktail.name,
      taste: updatedCocktail.taste,
      rating: updatedCocktail.rating,
      createdAt: updatedCocktail.createdAt,
      ingredients: updatedCocktail.ingredients.map(ing => ({
        id: ing.item.id,
        name: ing.item.name,
        amount: ing.amount
      }))
    });

  } catch (error) {
    next(error);
  }
};

module.exports = {
    getCocktails,
    getCocktailById,
    createCocktail,
    deleteCocktail,
    putCocktail,
}