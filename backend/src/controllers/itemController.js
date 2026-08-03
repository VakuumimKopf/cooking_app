const itemModel = require('../models/itemModel');

const getItems = async (req, res, next) => {
    try {
        const items = await itemModel.getAllItems();
        return res.json(items);
    } catch (error) {
        next(error)
    }
};

const createItem = async (req, res, next) => {
    try {
        const {name} = req.body;

        // Sicherheits-Checks

        const newItem = await itemModel.createItem({ name });
        return res.status(201).json(newItem);
    } catch (error) {
        next(error);
    }
};

module.exports = {
    getItems,
    createItem
}