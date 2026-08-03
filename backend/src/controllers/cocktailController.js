const cocktailModel = require('../models/cocktailModel');

const getCocktails = async (req, res, next) => {
    try {
        const cocktails = await cocktailModel.getAllCocktails();
        return res.json(cocktails);
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