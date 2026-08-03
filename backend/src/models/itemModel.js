const prisma = require('../config/prisma');

const getAllItems = async () => {
  return await prisma.Item.findMany({
    orderBy: { id: 'desc' } // Sortiert nach ID abwärts
  });
};

const createItem = async (itemData) => {
  return await prisma.Item.create({
    data: {
      name: itemData.name
    }
  });
};

module.exports = {
  getAllItems,
  createItem
};