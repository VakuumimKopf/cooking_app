require('dotenv').config();
const express = require('express');
const { Pool } = require('pg');

const app = express();
app.use(express.json()); // Erlaubt es dem Backend, JSON-Daten zu lesen

// 1. Verbindung zur Postgres-Datenbank herstellen (Connection Pool)
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// Test-Abfrage beim Starten: Läuft die DB überhaupt?
pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error('❌ Fehler bei der Datenbankverbindung:', err);
  } else {
    console.log('✅ Erfolgreich mit PostgreSQL verbunden!');
  }
});

// 2. ROUTE: Alle Rezepte ausgeben (GET)
app.get('/api/recipes', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM recipes ORDER BY id DESC');
    res.json(result.rows); // Schickt die Rezepte als JSON ans Frontend
  } catch (err) {
    console.error(err);
    res.status(500).send('Server-Fehler beim Laden der Rezepte');
  }
});

// 3. ROUTE: Ein neues Rezept speichern (POST)
app.post('/api/recipes', async (req, res) => {
  const { title, ingredients, steps } = req.body;
  try {
    const queryText = 'INSERT INTO recipes (title, ingredients, steps) VALUES ($1, $2, $3) RETURNING *';
    const values = [title, ingredients, steps];
    
    const result = await pool.query(queryText, values);
    res.status(201).json(result.rows[0]); // Gibt das gespeicherte Rezept inklusive ID zurück
  } catch (err) {
    console.error(err);
    res.status(500).send('Server-Fehler beim Speichern des Rezepts');
  }
});

// Server starten
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Backend läuft auf http://localhost:${PORT}`);
});