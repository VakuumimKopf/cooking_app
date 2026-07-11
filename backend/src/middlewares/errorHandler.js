const errorHandler = (err, req, res, next) => {
  console.error('💥 Ein Fehler ist aufgetreten:', err.stack);
  
  res.status(err.status || 500).json({
    error: err.message || 'Interner Server-Fehler'
  });
};

module.exports = errorHandler;