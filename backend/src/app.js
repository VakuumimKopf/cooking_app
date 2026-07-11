const express = require('express');
const recipesRoutes = require('./routes/recipeRoutes');
const errorHandler = require('./middlewares/errorHandler'); 

const app = express();

app.use(express.json());

app.use('/api/recipes', recipesRoutes);


app.use(errorHandler);

module.exports = app;