DROP TABLE IF EXISTS Staging_Arbre;
DROP TABLE IF EXISTS Staging_ArbreDominant;
DROP TABLE IF EXISTS Staging_CarnetArbre;
DROP TABLE IF EXISTS Staging_CarnetMeteo;
DROP TABLE IF EXISTS Staging_carnetpeuplement;
DROP TABLE IF EXISTS Staging_carnetplacette;
DROP TABLE IF EXISTS Staging_carnetplant;
DROP TABLE IF EXISTS Staging_carnetsite;
DROP TABLE IF EXISTS Staging_carnettypeetat;
DROP TABLE IF EXISTS Staging_carnettypeprecipitation;
DROP TABLE IF EXISTS Staging_carnetzone;
DROP TABLE IF EXISTS Staging_couverturesol;
DROP TABLE IF EXISTS Staging_dimension;
DROP TABLE IF EXISTS Staging_emplacementplant;
DROP TABLE IF EXISTS Staging_etat;
DROP TABLE IF EXISTS Staging_floraison;
DROP TABLE IF EXISTS Staging_herbivorie_observation;
DROP TABLE IF EXISTS Staging_meteo_observation;
DROP TABLE IF EXISTS Staging_obshumidite;
DROP TABLE IF EXISTS Staging_obsprecipitation;
DROP TABLE IF EXISTS Staging_obspression;
DROP TABLE IF EXISTS Staging_obstemperature;
DROP TABLE IF EXISTS Staging_obstructionlaterale;
DROP TABLE IF EXISTS Staging_obsvent;
DROP TABLE IF EXISTS Staging_peuplement;
DROP TABLE IF EXISTS Staging_placette;
DROP TABLE IF EXISTS Staging_plant;
DROP TABLE IF EXISTS Staging_site;
DROP TABLE IF EXISTS Staging_typeetat;
DROP TABLE IF EXISTS Staging_typeprecipitation;
DROP TABLE IF EXISTS Staging_zone;

CREATE TABLE Staging_Arbre (
    id VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_ArbreDominant (
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    placette_id VARCHAR(50),
    rang INTEGER,
    arbre_id VARCHAR(50)
);

CREATE TABLE Staging_CarnetArbre (
    arbre_id VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_CarnetMeteo (
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    date DATE,
    temp_min INTEGER,
    temp_max INTEGER,
    hum_min INTEGER,
    hum_max INTEGER,
    vent_min INTEGER,
    vent_max INTEGER,
    pres_min INTEGER,
    pres_max INTEGER,
    prec_tot INTEGER,
    prec_nat VARCHAR(50),
    note TEXT
);

CREATE TABLE Staging_carnetpeuplement (
    peuplement_id VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_carnetplacette (
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    placette_numero INTEGER,
    peuplement_id VARCHAR(50),
    date_placette DATE,
    hauteur DECIMAL,
    obstruction_type VARCHAR(50),
    taux_obstruction INTEGER,
    couverture_type VARCHAR(50),
    taux_couverture INTEGER,
    rang_arbre INTEGER,
    arbre_id VARCHAR(50)
);

CREATE TABLE Staging_carnetplant (
    plant_id VARCHAR(50),
    date_identification DATE,
    note_plant TEXT,
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    placette_numero INTEGER,
    parcelle VARCHAR(50),
    date_debut_emplacement DATE,
    date_fin_emplacement DATE,
    est_actuel VARCHAR(10),
    note_emplacement TEXT,
    date_observation DATE,
    note_observation TEXT,
    longueur DECIMAL,
    largeur DECIMAL,
    est_fruit VARCHAR(10),
    etat_id VARCHAR(50)
);

CREATE TABLE Staging_carnetsite (
    site_id VARCHAR(50),
    nom VARCHAR(255),
    description TEXT
);

CREATE TABLE Staging_carnettypeetat (
    etat_id VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_carnettypeprecipitation (
    code VARCHAR(50),
    libelle VARCHAR(255)
);

CREATE TABLE Staging_carnetzone (
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_couverturesol (
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    placette_id VARCHAR(50),
    couverture_type VARCHAR(50),
    taux INTEGER
);

CREATE TABLE Staging_dimension (
    id VARCHAR(50),
    date_observation DATE,
    longueur DECIMAL,
    largeur DECIMAL
);

CREATE TABLE Staging_emplacementplant (
    plant_id VARCHAR(50),
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    placette_id VARCHAR(50),
    parcelle VARCHAR(50),
    date_debut DATE,
    date_fin DATE,
    est_actuel VARCHAR(10),
    note TEXT
);

CREATE TABLE Staging_etat (
    id VARCHAR(50),
    date_observation DATE,
    etat_id VARCHAR(50)
);

CREATE TABLE Staging_floraison (
    id VARCHAR(50),
    date_observation DATE,
    est_fruit VARCHAR(10)
);

CREATE TABLE Staging_herbivorie_observation (
    plant_id VARCHAR(50),
    date DATE,
    note TEXT
);

CREATE TABLE Staging_meteo_observation (
    date DATE,
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    note TEXT
);

CREATE TABLE Staging_obshumidite (
    date DATE,
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    hum_min INTEGER,
    hum_max INTEGER
);

CREATE TABLE Staging_obsprecipitation (
    date DATE,
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    prec_tot INTEGER,
    prec_nat VARCHAR(50)
);

CREATE TABLE Staging_obspression (
    date DATE,
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    pres_min INTEGER,
    pres_max INTEGER
);

CREATE TABLE Staging_obstemperature (
    date DATE,
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    temp_min INTEGER,
    temp_max INTEGER
);

CREATE TABLE Staging_obstructionlaterale (
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    placette_id VARCHAR(50),
    hauteur DECIMAL,
    obstruction_type VARCHAR(50),
    taux INTEGER
);

CREATE TABLE Staging_obsvent (
    date DATE,
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    vent_min INTEGER,
    vent_max INTEGER
);

CREATE TABLE Staging_peuplement (
    id VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_placette (
    site_id VARCHAR(50),
    zone_id VARCHAR(50),
    numero INTEGER,
    peuplement_id VARCHAR(50),
    date DATE
);

CREATE TABLE Staging_plant (
    id VARCHAR(50),
    date_identification DATE,
    note TEXT
);

CREATE TABLE Staging_site (
    id VARCHAR(50),
    nom VARCHAR(255),
    description TEXT
);

CREATE TABLE Staging_typeetat (
    id VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_typeprecipitation (
    code VARCHAR(50),
    libelle VARCHAR(255)
);

CREATE TABLE Staging_zone (
    site_id VARCHAR(50),
    id VARCHAR(50),
    description TEXT
);

COPY Staging_Arbre FROM '/EQ3/Archive/Arbre.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ArbreDominant FROM '/EQ3/Archive/ArbreDominant.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_CarnetArbre FROM '/EQ3/Archive/CarnetArbre.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_CarnetMeteo FROM '/EQ3/Archive/CarnetMeteo.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_carnetpeuplement FROM '/EQ3/Archive/carnetpeuplement.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_carnetplacette FROM '/EQ3/Archive/carnetplacette.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_carnetplant FROM '/EQ3/Archive/carnetplant.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_carnetsite FROM '/EQ3/Archive/carnetsite.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_carnettypeetat FROM '/EQ3/Archive/carnettypeetat.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_carnettypeprecipitation FROM '/EQ3/Archive/carnettypeprecipitation.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_carnetzone FROM '/EQ3/Archive/carnetzone.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_couverturesol FROM '/EQ3/Archive/couverturesol.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_dimension FROM '/EQ3/Archive/dimension.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_emplacementplant FROM '/EQ3/Archive/emplacementplant.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_etat FROM '/EQ3/Archive/etat.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_floraison FROM '/EQ3/Archive/floraison.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_herbivorie_observation FROM '/EQ3/Archive/herbivorie_observation.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_meteo_observation FROM '/EQ3/Archive/meteo_observation.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_obshumidite FROM '/EQ3/Archive/obshumidite.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_obsprecipitation FROM '/EQ3/Archive/obsprecipitation.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_obspression FROM '/EQ3/Archive/obspression.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_obstemperature FROM '/EQ3/Archive/obstemperature.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_obstructionlaterale FROM '/EQ3/Archive/obstructionlaterale.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_obsvent FROM '/EQ3/Archive/obsvent.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_peuplement FROM '/EQ3/Archive/peuplement.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_placette FROM '/EQ3/Archive/placette.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_plant FROM '/EQ3/Archive/plant.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_site FROM '/EQ3/Archive/site.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_typeetat FROM '/EQ3/Archive/typeetat.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_typeprecipitation FROM '/EQ3/Archive/typeprecipitation.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_zone FROM '/EQ3/Archive/zone.csv' WITH(FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');