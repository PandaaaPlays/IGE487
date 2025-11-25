DROP TABLE IF EXISTS Staging_Arbre CASCADE;
DROP TABLE IF EXISTS Staging_CarnetMeteo CASCADE;
DROP TABLE IF EXISTS Staging_Etat CASCADE;
DROP TABLE IF EXISTS Staging_ObsDimension CASCADE;
DROP TABLE IF EXISTS Staging_ObsEtat CASCADE;
DROP TABLE IF EXISTS Staging_ObsFloraison CASCADE;
DROP TABLE IF EXISTS Staging_Parcelle CASCADE;
DROP TABLE IF EXISTS Staging_Peuplement CASCADE;
DROP TABLE IF EXISTS Staging_Placette CASCADE;
DROP TABLE IF EXISTS Staging_Placette_Arbre CASCADE;
DROP TABLE IF EXISTS Staging_Placette_Couverture CASCADE;
DROP TABLE IF EXISTS Staging_Placette_Obstruction CASCADE;
DROP TABLE IF EXISTS Staging_Plant CASCADE;
DROP TABLE IF EXISTS Staging_Plant_Note CASCADE;
DROP TABLE IF EXISTS Staging_Site CASCADE;
DROP TABLE IF EXISTS Staging_TypePrecipitations CASCADE;
DROP TABLE IF EXISTS Staging_Zone CASCADE;

CREATE TABLE Staging_Arbre (
    arbre VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_CarnetMeteo (
    temp_min TEXT,
    temp_max TEXT,
    hum_min TEXT,
    hum_max TEXT,
    prec_tot TEXT,
    prec_nat TEXT,
    vent_min TEXT,
    vent_max TEXT,
    pres_min TEXT,
    pres_max TEXT,
    date_eco TEXT,
    note TEXT,
    zone TEXT
);

CREATE TABLE Staging_Etat (
    etat VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_ObsDimension (
    id VARCHAR(50),
    longueur DECIMAL(10,2),
    largeur DECIMAL(10,2),
    date_eco DATE,
    note TEXT
);

CREATE TABLE Staging_ObsEtat (
    id VARCHAR(50),
    etat VARCHAR(50),
    date_eco DATE,
    note TEXT
);

CREATE TABLE Staging_ObsFloraison (
    id VARCHAR(50),
    date_eco DATE,
    note TEXT
);

CREATE TABLE Staging_Parcelle (
    parcelle_id VARCHAR(50),
    placette_id VARCHAR(50),
    peuplement VARCHAR(50),
    position VARCHAR(50)
);

CREATE TABLE Staging_Peuplement (
    peuplement VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_Placette (
    plac VARCHAR(50),
    zone VARCHAR(50),
    date_eco DATE
);

CREATE TABLE Staging_Placette_Arbre (
    placette VARCHAR(50),
    rang VARCHAR(50),
    arbre VARCHAR(50)
);

CREATE TABLE Staging_Placette_Couverture (
    placette VARCHAR(50),
    type_couverture VARCHAR(50),
    taux TEXT
);

CREATE TABLE Staging_Placette_Obstruction (
    placette VARCHAR(50),
    hauteur DECIMAL(5,2),
    type_obs VARCHAR(50),
    taux TEXT
);

CREATE TABLE Staging_Plant (
    id VARCHAR(50),
    parcelle_id VARCHAR(50),
    date_eco DATE
);

CREATE TABLE Staging_Plant_Note (
    id VARCHAR(50),
    id_plant VARCHAR(50),
    date_eco DATE,
    note TEXT
);

CREATE TABLE Staging_Site (
    code VARCHAR(50),
    nom VARCHAR(100)
);

CREATE TABLE Staging_TypePrecipitations (
    code VARCHAR(50),
    libelle VARCHAR(100)
);

CREATE TABLE Staging_Zone (
    code VARCHAR(50),
    code_site VARCHAR(50),
    nom VARCHAR(100),
    description TEXT
);

COPY Staging_Arbre FROM '/EQ2/Archive/Arbre.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_CarnetMeteo FROM '/EQ2/Archive/CarnetMeteo.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Etat FROM '/EQ2/Archive/Etat.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsDimension FROM '/EQ2/Archive/ObsDimension.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsEtat FROM '/EQ2/Archive/ObsEtat.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsFloraison FROM '/EQ2/Archive/ObsFloraison.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Parcelle FROM '/EQ2/Archive/Parcelle.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Peuplement FROM '/EQ2/Archive/Peuplement.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Placette FROM '/EQ2/Archive/Placette.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Placette_Arbre FROM '/EQ2/Archive/Placette_Arbre.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Placette_Couverture FROM '/EQ2/Archive/Placette_Couverture.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Placette_Obstruction FROM '/EQ2/Archive/Placette_Obstruction.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Plant FROM '/EQ2/Archive/Plant.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Plant_Note FROM '/EQ2/Archive/Plant_Note.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Site FROM '/EQ2/Archive/Site.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_TypePrecipitations FROM '/EQ2/Archive/TypePrecipitations.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Zone FROM '/EQ2/Archive/Zone.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');