DROP TABLE IF EXISTS Dim_Site CASCADE;
CREATE TABLE Dim_Site (
    id_interne SERIAL PRIMARY KEY,
    code_site VARCHAR(50),
    nom_site VARCHAR(100)
);

DROP TABLE IF EXISTS Dim_Zone CASCADE;
CREATE TABLE Dim_Zone (
    id_interne SERIAL PRIMARY KEY,
    code_zone VARCHAR(50),
    code_site VARCHAR(50),
    nom_zone VARCHAR(100),
    description TEXT
);

DROP TABLE IF EXISTS Dim_Placette CASCADE;
CREATE TABLE Dim_Placette (
    id_interne SERIAL PRIMARY KEY,
    placette_id VARCHAR(50),
    code_zone VARCHAR(50),
    date_creation DATE
);

DROP TABLE IF EXISTS Dim_Parcelle CASCADE;
CREATE TABLE Dim_Parcelle (
    id_interne SERIAL PRIMARY KEY,
    parcelle_id VARCHAR(50),
    placette_id VARCHAR(50),
    peuplement VARCHAR(100),
    position VARCHAR(50)
);

DROP TABLE IF EXISTS Dim_Plant CASCADE;
CREATE TABLE Dim_Plant (
    id_interne SERIAL PRIMARY KEY,
    parcelle_id VARCHAR(50),
    plant_id VARCHAR(50),
    date_decouverte DATE
);

DROP TABLE IF EXISTS Dim_Arbre CASCADE;
CREATE TABLE Dim_Arbre (
    nom_site VARCHAR(100)
);

DROP TABLE IF EXISTS Dim_Zone CASCADE;
CREATE TABLE Dim_Zone (
    id_interne SERIAL PRIMARY KEY,
    code_zone VARCHAR(50),
    code_site VARCHAR(50),
    nom_zone VARCHAR(100),
    description TEXT
);

DROP TABLE IF EXISTS Dim_Placette CASCADE;
CREATE TABLE Dim_Placette (
    id_interne SERIAL PRIMARY KEY,
    placette_id VARCHAR(50),
    code_zone VARCHAR(50),
    date_creation DATE
);

DROP TABLE IF EXISTS Dim_Parcelle CASCADE;
CREATE TABLE Dim_Parcelle (
    id_interne SERIAL PRIMARY KEY,
    parcelle_id VARCHAR(50),
    placette_id VARCHAR(50),
    peuplement VARCHAR(100),
    position VARCHAR(50)
);

DROP TABLE IF EXISTS Dim_Plant CASCADE;
CREATE TABLE Dim_Plant (
    id_interne SERIAL PRIMARY KEY,
    parcelle_id VARCHAR(50),
    plant_id VARCHAR(50),
    date_decouverte DATE
);

DROP TABLE IF EXISTS Dim_Arbre CASCADE;
CREATE TABLE Dim_Arbre (
    id_interne SERIAL PRIMARY KEY,
    nom_arbre VARCHAR(50),
    description TEXT
);

-- =============================================================================
-- Facts: Processus de l'évolution de la météo
-- =============================================================================

DROP TABLE IF EXISTS Fact_Temperature CASCADE;
CREATE TABLE Fact_Temperature (
    id_interne_zone INTEGER,
    date DATE,
    temp_min DECIMAL(5,2),
    temp_max DECIMAL(5,2),
    temp_moyenne DECIMAL(5, 2),
    variation DECIMAL(5, 2),
    note TEXT,
    PRIMARY KEY (id_interne_zone, date),
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

DROP TABLE IF EXISTS Fact_Humidite CASCADE;
CREATE TABLE Fact_Humidite (
    id_interne_zone INTEGER,
    date DATE,
    hum_min DECIMAL(5,2),
    hum_max DECIMAL(5,2),
    temp_moyenne DECIMAL(5, 2),
    variation DECIMAL(5, 2),
    note TEXT,
    PRIMARY KEY (id_interne_zone, date),
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

DROP TABLE IF EXISTS Fact_Vents CASCADE;
CREATE TABLE Fact_Vents (
    id_interne_zone INTEGER,
    date DATE,
    vent_min DECIMAL(5,2),
    vent_max DECIMAL(5,2),
    temp_moyenne DECIMAL(5, 2),
    variation DECIMAL(5, 2),
    note TEXT,
    PRIMARY KEY (id_interne_zone, date),
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

DROP TABLE IF EXISTS Fact_Pression CASCADE;
CREATE TABLE Fact_Pression (
    id_interne_zone INTEGER,
    date DATE,
    pres_min DECIMAL(7,2),
    pres_max DECIMAL(7,2),
    temp_moyenne DECIMAL(7, 2),
    variation DECIMAL(7, 2),
    note TEXT,
    PRIMARY KEY (id_interne_zone, date),
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

DROP TABLE IF EXISTS Fact_Precipitation CASCADE;
CREATE TABLE Fact_Precipitation (
    id_interne_zone INTEGER,
    date DATE,
    prec_tot DECIMAL(5,2),
    prec_nature VARCHAR(50),
    note TEXT,
    PRIMARY KEY (id_interne_zone, date),
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

-- =============================================================================
-- Facts: Processus de croissance d'une plante
-- =============================================================================

DROP TABLE IF EXISTS Fact_Dimension CASCADE;
CREATE TABLE Fact_Dimension (
    id_interne_plant INTEGER,
    date DATE,
    longueur DECIMAL(10,2),
    largeur DECIMAL(10,2),
    superficie DECIMAL(10,2),
    note TEXT,
    PRIMARY KEY (id_interne_plant, date),
    FOREIGN KEY (id_interne_plant) REFERENCES Dim_Plant(id_interne)
);

DROP TABLE IF EXISTS Fact_Etat CASCADE;
CREATE TABLE Fact_Etat (
    id_interne_plant INTEGER,
    date DATE,
    etat VARCHAR(50),
    note TEXT,
    PRIMARY KEY (id_interne_plant, date),
    FOREIGN KEY (id_interne_plant) REFERENCES Dim_Plant(id_interne)
);

DROP TABLE IF EXISTS Fact_Floraison CASCADE;
CREATE TABLE Fact_Floraison (
    id_interne_plant INTEGER,
    date DATE,
    note TEXT,
    PRIMARY KEY (id_interne_plant, date),
    FOREIGN KEY (id_interne_plant) REFERENCES Dim_Plant(id_interne)
);

DROP TABLE IF EXISTS Fact_Note CASCADE;
CREATE TABLE Fact_Note (
    id_interne_plant INTEGER,
    date DATE,
    note TEXT,
    PRIMARY KEY (id_interne_plant, date),
    FOREIGN KEY (id_interne_plant) REFERENCES Dim_Plant(id_interne)
);

-- =============================================================================
-- Facts: Environnement d'une placette
-- =============================================================================

DROP TABLE IF EXISTS Fact_Couverture CASCADE;
CREATE TABLE Fact_Couverture (
    id_interne_placette INTEGER,
    date DATE,
    type_couverture VARCHAR(50),
    taux DECIMAL,
    incertitude DECIMAL,
    PRIMARY KEY (id_interne_placette, date, type_couverture),
    FOREIGN KEY (id_interne_placette) REFERENCES Dim_Placette(id_interne)
);

DROP TABLE IF EXISTS Fact_Obstruction CASCADE;
CREATE TABLE Fact_Obstruction (
    id_interne_placette INTEGER,
    date DATE,
    type_obstruction VARCHAR(50),
    hauteur DECIMAL(5,2),
    taux DECIMAL,
    incertitude DECIMAL,
    PRIMARY KEY (id_interne_placette, date, type_obstruction, hauteur),
    FOREIGN KEY (id_interne_placette) REFERENCES Dim_Placette(id_interne)
);

DROP TABLE IF EXISTS Fact_Arbre CASCADE;
CREATE TABLE Fact_Arbre (
    id_interne_placette INTEGER,
    id_interne_arbre INTEGER,
    date DATE,
    rang INTEGER,
    PRIMARY KEY (id_interne_placette, id_interne_arbre, date),
    FOREIGN KEY (id_interne_placette) REFERENCES Dim_Placette(id_interne),
    FOREIGN KEY (id_interne_arbre) REFERENCES Dim_Arbre(id_interne)
);
