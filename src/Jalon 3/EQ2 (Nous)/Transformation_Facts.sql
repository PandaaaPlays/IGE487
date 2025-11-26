-- =============================================================================
-- Facts: Processus de l'évolution de la météo
-- =============================================================================

-- Fact_Temperature
COPY (
SELECT z.id_interne AS id_interne_zone,
       c.date_eco AS date,
       c.temp_min AS temp_min,
       c.temp_max AS temp_max,
       CAST((c.temp_min + c.temp_max) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne,
       CAST((c.temp_max - c.temp_min) AS DECIMAL(5,2)) AS variation,
       c.note AS note
FROM staging_carnetmeteo c
JOIN Dim_Zone z ON c.zone = z.code_zone
) TO '/EQ2/Loading/Fact_Temperature.csv' WITH (FORMAT CSV, HEADER);
--manquant: id_interne_zone

-- Fact_Humidite
COPY (
SELECT c.date_eco AS date,
       c.hum_min AS hum_min,
       c.hum_max AS hum_max,
       CAST((c.hum_min + c.hum_max) / 2.0 AS DECIMAL(5,2)) AS hum_moyenne,
       CAST((c.hum_max - c.hum_min) AS DECIMAL(5,2)) AS variation,
       c.note AS note
FROM staging_carnetmeteo c
) TO '/EQ2/Loading/Fact_Humidite.csv' WITH (FORMAT CSV, HEADER);
--manquant: id_interne_zone

-- Fact_Vents
COPY (
SELECT date_eco AS date,
       vent_min AS vent_min,
       vent_max AS vent_max,
       CAST((c.vent_min + c.vent_max) / 2.0 AS DECIMAL(5,2)) AS vent_moyenne,
       CAST((c.vent_max - c.vent_min) AS DECIMAL(5,2)) AS variation,
       note AS note
from staging_carnetmeteo c
) TO '/EQ2/Loading/Fact_Vents.csv' WITH (FORMAT CSV, HEADER);
--manquant: id_interne_zone

-- Fact_Pression
COPY (
SELECT date_eco AS date,
       pres_min AS pres_min,
       pres_max AS pres_max,
       CAST((c.pres_min + c.pres_max) / 2.0 AS DECIMAL(5,2)) AS pres_moyenne,
       CAST((c.pres_max - c.pres_min) AS DECIMAL(5,2)) AS variation,
       note AS note
FROM staging_carnetmeteo c
) TO '/EQ2/Loading/Fact_Pression.csv' WITH (FORMAT CSV, HEADER);
--manquant: id_interne_zone

-- Fact_Precipitation
COPY (
SELECT cm.date_eco AS date,
       tp.libelle AS prec_nature,
       cm.prec_tot AS prec_tot
FROM staging_carnetmeteo cm
JOIN staging_typeprecipitations tp
ON cm.prec_nat = tp.code
) TO '/EQ2/Loading/Fact_Precipitation.csv' WITH (FORMAT CSV, HEADER);
--manquant: id_interne_zone

-- =============================================================================
-- Facts: Processus de croissance d'une plante
-- =============================================================================

-- Fact_Dimension
COPY (
SELECT date_eco AS date,
       longueur AS longueur,
       largeur AS largeur,
       CAST(d.longueur * d.largeur AS DECIMAL(10,2)) AS superficie,
       note AS note
FROM staging_obsdimension d
) TO '/EQ2/Loading/Fact_Dimension.csv' WITH (FORMAT CSV, HEADER);
-- manquant: id_interne_plant, id_interne_parcelle

-- Fact_Etat
COPY (
SELECT ob.date_eco AS date,
       et.description AS etat,
       ob.note AS note
FROM staging_obsetat ob
JOIN staging_etat et
ON ob.etat = et.etat
) TO '/EQ2/Loading/Fact_Etat.csv' WITH (FORMAT CSV, HEADER);
-- manquant: id_interne_plant, id_interne_parcelle

-- Fact_Floraison
COPY (
SELECT date_eco AS date,
       note AS note
FROM staging_obsfloraison
) TO '/EQ2/Loading/Fact_Floraison.csv' WITH (FORMAT CSV, HEADER);
-- manquant: id_interne_plant, id_interne_parcelle

-- Fact_Note
COPY (
SELECT date_eco AS date,
       note AS note
FROM staging_plant_note
) TO '/EQ2/Loading/Fact_Note.csv' WITH (FORMAT CSV, HEADER);
--manquant: id_interne_plant, id_interne_parcelle

-- =============================================================================
-- Facts: Environnement d'une placette
-- =============================================================================

-- Fact_Couverture
COPY (
SELECT type_couverture AS type_couverture,
       taux AS taux
FROM staging_placette_couverture
) TO '/EQ2/Loading/Fact_Couverture.csv' WITH (FORMAT CSV, HEADER);
-- manquant: id_interne_placette, date

-- Fact_Obstruction
COPY (
SELECT type_obs AS type_obstruction,
       hauteur AS hauteur,
       taux AS taux
FROM staging_placette_obstruction
) TO '/EQ2/Loading/Fact_Obstruction.csv' WITH (FORMAT CSV, HEADER);
--manquant: id_interne_placette, date

-- Fact_Arbre
COPY (
SELECT rang AS rang
FROM staging_placette_arbre
) TO '/EQ2/Loading/Fact_Arbre.csv' WITH (FORMAT CSV, HEADER);
-- manquant: id_interne_placette, id_interne_arbre, date

