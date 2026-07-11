require('dotenv').config();

const app = require('./app');

const PORT = process.env.PORT || 3000;

const startServer = async () => {
    try {
        console.log('✅ Alle Datenbankverbindungen erfolgreich hergestellt.');    
        app.listen(PORT, () => {
            console.log(`🚀 Server läuft wie ein Profi auf http://localhost:${PORT}`);
        });
    } catch (error) {
        console.error('❌ Kritischer Fehler beim Serverstart:', error);
        process.exit(1);
    }
};

startServer();