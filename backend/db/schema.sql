CREATE TABLE recipes (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    ingredients TEXT[] NOT NULL, -- Speichert Zutaten als Liste/Array
    steps TEXT[] NOT NULL,       -- Speichert die Kochschritte als Liste/Array
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);