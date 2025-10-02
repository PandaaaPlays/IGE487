const express = require("express");
const multer = require("multer");
const { Pool } = require("pg");
const cors = require("cors");
const app = express();

// Connexion PostgreSQL
const pool = new Pool({
    user: "postgres",
    host: "10.44.88.225",
    database: "postgres",
    password: "password",
    port: 5432,
});

app.use(cors());
app.use(express.json());

pool.connect()
    .then(client => {
        console.log("Connecté à la base de données!")
    })
    .catch(err => {
        console.error("❌ Impossible de se connecter à PostgreSQL:", err.message);
    });

pool.on('connect', async (client) => {
    await client.query(`SET search_path TO "Herbivorie"`);
});

app.post("/api/carnetMeteo", async (req, res) => {
    const {
        temp_min, temp_max, hum_min, hum_max, prec_tot, prec_nat,
        vent_min, vent_max, pres_min, pres_max, date, note
    } = req.body;

    try {
        await pool.query(
            `INSERT INTO "Herbivorie".CarnetMeteo
             (temp_min, temp_max, hum_min, hum_max, prec_tot, prec_nat, vent_min, vent_max, pres_min, pres_max, date, note)
             VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)`,
             [temp_min, temp_max, hum_min, hum_max, prec_tot, prec_nat, vent_min, vent_max, pres_min, pres_max, date, note]
        );
        await pool.query(
            `CALL "Herbivorie".Meteo_ELT()`
        );
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Insert failed" });
    }
});

app.use(express.static("public"));

// Lancement serveur
const PORT = 8080;
app.listen(PORT, () => {
    console.log(`API Herbivorie active sur http://localhost:${PORT}`);
});
