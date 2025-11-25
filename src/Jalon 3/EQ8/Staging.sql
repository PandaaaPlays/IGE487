DROP TABLE IF EXISTS Staging_Arbre;
DROP TABLE IF EXISTS Staging_Etat;
DROP TABLE IF EXISTS Staging_ObsArbreDominants;
DROP TABLE IF EXISTS Staging_ObsDimension;
DROP TABLE IF EXISTS Staging_ObsEtat;
DROP TABLE IF EXISTS Staging_ObsFloraison;
DROP TABLE IF EXISTS Staging_ObsHumidite;
DROP TABLE IF EXISTS Staging_ObsObstruction;
DROP TABLE IF EXISTS Staging_ObsPlantLocalisation;
DROP TABLE IF EXISTS Staging_ObsPrecipitation;
DROP TABLE IF EXISTS Staging_ObsPression;
DROP TABLE IF EXISTS Staging_ObsTemperature;
DROP TABLE IF EXISTS Staging_ObsVents;
DROP TABLE IF EXISTS Staging_Parcelle;
DROP TABLE IF EXISTS Staging_Peuplement;
DROP TABLE IF EXISTS Staging_Placette;
DROP TABLE IF EXISTS Staging_Plant;
DROP TABLE IF EXISTS Staging_Site;
DROP TABLE IF EXISTS Staging_TypeFloraison;
DROP TABLE IF EXISTS Staging_TypePrecipitation;
DROP TABLE IF EXISTS Staging_Zone;
DROP TABLE IF EXISTS Staging_ObsCouverture;

CREATE TABLE Staging_Arbre (
    arbreid VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_Etat (
    etatid VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_ObsArbreDominants (
    placetteid VARCHAR(50),
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    arbreid VARCHAR(50),
    dateobservation DATE,
    rang INTEGER,
    note TEXT
);

CREATE TABLE Staging_ObsDimension (
    plantid VARCHAR(50),
    dateobservation DATE,
    longueur DECIMAL,
    largeur DECIMAL,
    note TEXT
);

CREATE TABLE Staging_ObsEtat (
    plantid VARCHAR(50),
    dateobservation DATE,
    etat VARCHAR(50),
    note TEXT
);

CREATE TABLE Staging_ObsFloraison (
    plantid VARCHAR(50),
    dateobservation DATE,
    typefloraison VARCHAR(50),
    note TEXT
);

CREATE TABLE Staging_ObsHumidite (
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    dateobservation DATE,
    humiditemin DECIMAL,
    humiditemax DECIMAL,
    note TEXT
);

CREATE TABLE Staging_ObsObstruction (
    placetteid VARCHAR(50),
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    dateobservation DATE,
    hauteur DECIMAL,
    tauxfeuillu DECIMAL,
    tauxconifere DECIMAL,
    note TEXT
);

CREATE TABLE Staging_ObsPlantLocalisation (
    plantid VARCHAR(50),
    dateobservation DATE,
    parcelleid VARCHAR(50),
    placetteid VARCHAR(50),
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    coordonneesx DECIMAL,
    coordonneesy DECIMAL,
    note TEXT
);

CREATE TABLE Staging_ObsPrecipitation (
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    dateobservation DATE,
    typeprecipitation VARCHAR(50),
    precipitationtotale DECIMAL,
    note TEXT
);

CREATE TABLE Staging_ObsPression (
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    dateobservation DATE,
    pressionmin DECIMAL,
    pressionmax DECIMAL,
    note TEXT
);

CREATE TABLE Staging_ObsTemperature (
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    dateobservation DATE,
    temperaturemin DECIMAL,
    temperaturemax DECIMAL,
    note TEXT
);

CREATE TABLE Staging_ObsVents (
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    dateobservation DATE,
    ventmin DECIMAL,
    ventmax DECIMAL,
    note TEXT
);

CREATE TABLE Staging_Parcelle (
    parcelleid VARCHAR(50),
    placetteid VARCHAR(50),
    zoneid VARCHAR(50),
    siteid VARCHAR(50)
);

CREATE TABLE Staging_Peuplement (
    peuplementid VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_Placette (
    placetteid VARCHAR(50),
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    peuplementid VARCHAR(50),
    superficie DECIMAL,
    coordonneesx DECIMAL,
    coordonneesy DECIMAL
);

CREATE TABLE Staging_Plant (
    plantid VARCHAR(50)
);

CREATE TABLE Staging_Site (
    siteid VARCHAR(50),
    nom VARCHAR(255)
);

CREATE TABLE Staging_TypeFloraison (
    typefloraisonid VARCHAR(50),
    description TEXT
);

CREATE TABLE Staging_TypePrecipitation (
    typeprecipitationid VARCHAR(50),
    libelle VARCHAR(255)
);

CREATE TABLE Staging_Zone (
    zoneid VARCHAR(50),
    siteid VARCHAR(50)
);

CREATE TABLE Staging_ObsCouverture (
    placetteid VARCHAR(50),
    zoneid VARCHAR(50),
    siteid VARCHAR(50),
    dateobservation DATE,
    tauxmousses DECIMAL,
    tauxgraminees DECIMAL,
    tauxfougeres DECIMAL,
    note TEXT
);

COPY Staging_Arbre FROM '/EQ8/Archive/Arbre.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Etat FROM '/EQ8/Archive/Etat.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsArbreDominants FROM '/EQ8/Archive/ObsArbreDominants.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsDimension FROM '/EQ8/Archive/ObsDimension.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsEtat FROM '/EQ8/Archive/ObsEtat.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsFloraison FROM '/EQ8/Archive/ObsFloraison.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsHumidite FROM '/EQ8/Archive/ObsHumidite.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsObstruction FROM '/EQ8/Archive/ObsObstruction.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsPlantLocalisation FROM '/EQ8/Archive/ObsPlantLocalisation.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsPrecipitation FROM '/EQ8/Archive/ObsPrecipitation.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsPression FROM '/EQ8/Archive/ObsPression.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsTemperature FROM '/EQ8/Archive/ObsTemperature.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsVents FROM '/EQ8/Archive/ObsVents.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Parcelle FROM '/EQ8/Archive/Parcelle.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Peuplement FROM '/EQ8/Archive/Peuplement.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Placette FROM '/EQ8/Archive/Placette.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Plant FROM '/EQ8/Archive/Plant.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Site FROM '/EQ8/Archive/Site.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_TypeFloraison FROM '/EQ8/Archive/TypeFloraison.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_TypePrecipitation FROM '/EQ8/Archive/TypePrecipitation.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_Zone FROM '/EQ8/Archive/Zone.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
COPY Staging_ObsCouverture FROM '/EQ8/Archive/obscouverture.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');
