-- BDD.sql
-- Base de Données Décisionnelle (Data Warehouse) Model for EQ2

-- =============================================================================
-- Dimensions
-- =============================================================================

DROP TABLE IF EXISTS Dim_Site CASCADE;
CREATE TABLE Dim_Site (
    id_interne SERIAL PRIMARY KEY,
    code_site VARCHAR(50) UNIQUE,
    nom_site VARCHAR(100)
);

DROP TABLE IF EXISTS Dim_Zone CASCADE;
CREATE TABLE Dim_Zone (
    id_interne SERIAL PRIMARY KEY,
    code_zone VARCHAR(50) UNIQUE,
    code_site VARCHAR(50),
    nom_zone VARCHAR(100),
    description TEXT,
    FOREIGN KEY (code_site) REFERENCES Dim_Site(code_site)
);

DROP TABLE IF EXISTS Dim_Placette CASCADE;
CREATE TABLE Dim_Placette (
    id_interne SERIAL PRIMARY KEY,
    placette_id VARCHAR(50) UNIQUE,
    code_zone VARCHAR(50),
    date_creation DATE,
    FOREIGN KEY (code_zone) REFERENCES Dim_Zone(code_zone)
);

DROP TABLE IF EXISTS Dim_Parcelle CASCADE;
CREATE TABLE Dim_Parcelle (
    id_interne SERIAL PRIMARY KEY,
    parcelle_id VARCHAR(50) UNIQUE,
    placette_id VARCHAR(50),
    peuplement VARCHAR(100),
    position VARCHAR(50),
    FOREIGN KEY (placette_id) REFERENCES Dim_Placette(placette_id)
);

DROP TABLE IF EXISTS Dim_Plant CASCADE;
CREATE TABLE Dim_Plant (
    id_interne SERIAL PRIMARY KEY,
    plant_id VARCHAR(50) UNIQUE,
    date_decouverte DATE
);

DROP TABLE IF EXISTS Dim_Arbre CASCADE;
CREATE TABLE Dim_Arbre (
    id_interne SERIAL PRIMARY KEY,
    nom_arbre VARCHAR(50) UNIQUE,
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
    note TEXT,
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

DROP TABLE IF EXISTS Fact_Humidite CASCADE;
CREATE TABLE Fact_Humidite (
    id_interne_zone INTEGER,
    date DATE,
    hum_min DECIMAL(5,2),
    hum_max DECIMAL(5,2),
    note TEXT,
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

DROP TABLE IF EXISTS Fact_Vents CASCADE;
CREATE TABLE Fact_Vents (
    id_interne_zone INTEGER,
    date DATE,
    vent_min DECIMAL(5,2),
    vent_max DECIMAL(5,2),
    note TEXT,
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

DROP TABLE IF EXISTS Fact_Pression CASCADE;
CREATE TABLE Fact_Pression (
    id_interne_zone INTEGER,
    date DATE,
    pres_min DECIMAL(6,2),
    pres_max DECIMAL(6,2),
    note TEXT,
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

DROP TABLE IF EXISTS Fact_Precipitation CASCADE;
CREATE TABLE Fact_Precipitation (
    id_interne_zone INTEGER,
    date DATE,
    prec_tot DECIMAL(5,2),
    prec_nature VARCHAR(50),
    note TEXT,
    FOREIGN KEY (id_interne_zone) REFERENCES Dim_Zone(id_interne)
);

-- =============================================================================
-- Facts: Processus de croissance d'une plante
-- =============================================================================

DROP TABLE IF EXISTS Fact_Dimension CASCADE;
CREATE TABLE Fact_Dimension (
    id_interne_plant INTEGER,
    id_interne_parcelle INTEGER,
    date DATE,
    longueur DECIMAL(10,2),
    largeur DECIMAL(10,2),
    note TEXT,
    FOREIGN KEY (id_interne_plant) REFERENCES Dim_Plant(id_interne),
    FOREIGN KEY (id_interne_parcelle) REFERENCES Dim_Parcelle(id_interne)
);

DROP TABLE IF EXISTS Fact_Etat CASCADE;
CREATE TABLE Fact_Etat (
    id_interne_plant INTEGER,
    id_interne_parcelle INTEGER,
    date DATE,
    etat VARCHAR(50),
    note TEXT,
    FOREIGN KEY (id_interne_plant) REFERENCES Dim_Plant(id_interne),
    FOREIGN KEY (id_interne_parcelle) REFERENCES Dim_Parcelle(id_interne)
);

DROP TABLE IF EXISTS Fact_Floraison CASCADE;
CREATE TABLE Fact_Floraison (
    id_interne_plant INTEGER,
    id_interne_parcelle INTEGER,
    date DATE,
    note TEXT,
    FOREIGN KEY (id_interne_plant) REFERENCES Dim_Plant(id_interne),
    FOREIGN KEY (id_interne_parcelle) REFERENCES Dim_Parcelle(id_interne)
);

DROP TABLE IF EXISTS Fact_Note CASCADE;
CREATE TABLE Fact_Note (
    id_interne_plant INTEGER,
    id_interne_parcelle INTEGER,
    date DATE,
    note TEXT,
    FOREIGN KEY (id_interne_plant) REFERENCES Dim_Plant(id_interne),
    FOREIGN KEY (id_interne_parcelle) REFERENCES Dim_Parcelle(id_interne)
);

-- =============================================================================
-- Facts: Processus du développement d'une placette
-- =============================================================================

DROP TABLE IF EXISTS Fact_Couverture CASCADE;
CREATE TABLE Fact_Couverture (
    id_interne_placette INTEGER,
    date DATE,
    type_couverture VARCHAR(50),
    taux DECIMAL(5,2),
    FOREIGN KEY (id_interne_placette) REFERENCES Dim_Placette(id_interne)
);

DROP TABLE IF EXISTS Fact_Obstruction CASCADE;
CREATE TABLE Fact_Obstruction (
    id_interne_placette INTEGER,
    date DATE,
    type_obstruction VARCHAR(50),
    hauteur DECIMAL(5,2),
    taux DECIMAL(5,2),
    FOREIGN KEY (id_interne_placette) REFERENCES Dim_Placette(id_interne)
);

DROP TABLE IF EXISTS Fact_Arbre CASCADE;
CREATE TABLE Fact_Arbre (
    id_interne_placette INTEGER,
    id_interne_arbre INTEGER,
    date DATE,
    rang INTEGER,
    FOREIGN KEY (id_interne_placette) REFERENCES Dim_Placette(id_interne),
    FOREIGN KEY (id_interne_arbre) REFERENCES Dim_Arbre(id_interne)
);
