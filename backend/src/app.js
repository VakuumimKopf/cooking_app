const express = require('express');

const recipesRoutes = require('./routes/recipeRoutes');
const cocktailRoutes = require('./routes/cocktailRoutes');
const itemRoutes = require('./routes/itemRoutes');

const errorHandler = require('./middlewares/errorHandler'); 

const app = express();

app.use(express.json());

app.use('/api/recipes', recipesRoutes);

app.use('/api/cocktails', cocktailRoutes);

app.use('/api/items', itemRoutes);


app.use(errorHandler);

module.exports = app;