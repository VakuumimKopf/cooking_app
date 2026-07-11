// ALT (mit rohem SQL):
// const pool = require('../config/db');
// const insertRecipe = async (data) => {
//   const result = await pool.query('INSERT INTO recipes...', [...]);
//   return result.rows[0];
// }

// NEU (mit Prisma):
const prisma = require('../config/prisma');

// 1. Alle Rezepte holen
const getAllRecipes = async () => {
  return await prisma.recipe.findMany({
    orderBy: { id: 'desc' } // Sortiert nach ID abwärts
  });
};

// 2. Ein neues Rezept speichern
const insertRecipe = async (recipeData) => {
  return await prisma.recipe.create({
    data: {
      title: recipeData.title,
      ingredients: recipeData.ingredients,
      steps: recipeData.steps
    }
  });
};

module.exports = {
  getAllRecipes,
  insertRecipe
};