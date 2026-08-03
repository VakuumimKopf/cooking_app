const { connect } = require('../app');
const prisma = require('../config/prisma');

const createCocktail = async (cocktailData) => {
    return await prisma.Cocktail.create({
        data: {
            name: cocktailData.name,
            taste: cocktailData.taste,
            rating: cocktailData.rating,
            ingredients: {
                create: cocktailData.ingredients.map((ing) => ({
                    amount: ing.amount,
                    item: {
                        connect: { id: ing.itemId }
                    }
                }))
            }
        },
        include: {
            ingredients: {
                include: {
                    item: true
                }
            }
        } 
    });  
};

const getAllCocktails = async () => {
    return await prisma.Cocktail.findMany({
        include: {
            ingredients: {
                include: { item: true}
            }
        }
    });
};

module.exports = {
    createCocktail,
    getAllCocktails
}