const { connect } = require('../app');
const prisma = require('../config/prisma');

const createCocktail = async (cocktailData) => {
  const { name, taste, rating, ingredients } = cocktailData;

  return await prisma.cocktail.create({
    data: {
      name,
      taste,
      rating: parseFloat(rating),
      ingredients: {
        create: ingredients.map((ing) => {
          const targetItemId = ing.itemId ?? ing.item_id ?? ing.id;

          // 1. Wenn eine gültige ID übergeben wurde -> bestehendes Item verknüpfen
          if (targetItemId !== null && targetItemId !== undefined) {
            return {
              amount: String(ing.amount),
              item: {
                connect: { id: Number(targetItemId) }
              }
            };
          }

          // 2. Wenn itemId null/undefined ist -> Neues Item anlegen
          if (!ing.name) {
            throw new Error(
              "Wenn 'itemId' null ist, muss die Zutat einen 'name' besitzen."
            );
          }

          return {
            amount: String(ing.amount),
            item: {
              create: {
                name: ing.name
              }
            }
          };
        })
      }
    },
    include: {
      ingredients: {
        include: { item: true }
      }
    }
  });
};

const getAllCocktails = async () => {
    return await prisma.Cocktail.findMany({
        where: {
            deleted: false
        },
        include: {
            ingredients: {
                include: { item: true}
            }
        }
    });
};

const deleteCocktail = async (id) => {
    return await prisma.cocktail.update({
        where: {
            id: Number(id)
        },
        data: {
            deleted: true
        }
    });
};

module.exports = {
    createCocktail,
    getAllCocktails,
    deleteCocktail
}