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

module.exports = {
    getCocktails,
    createCocktail
}