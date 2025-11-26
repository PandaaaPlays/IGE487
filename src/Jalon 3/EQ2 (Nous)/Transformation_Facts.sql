-- =============================================================================
-- Facts: Processus de l'évolution de la météo
-- =============================================================================

-- Fact_Temperature
COPY (
SELECT z.id_interne AS id_interne_zone,
       c.date_eco AS date,
       c.temp_min AS temp_min,
       c.temp_max AS temp_max,
       CAST((c.temp_min::DECIMAL + c.temp_max::DECIMAL) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne,
       CAST((c.temp_min::DECIMAL - c.temp_max::DECIMAL) AS DECIMAL(5,2)) AS variation,
       c.note AS note
FROM staging_carnetmeteo c
JOIN Dim_Zone z ON c.zone = z.code_zone
) TO '/EQ2/Loading/Fact_Temperature.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Humidite
COPY (
SELECT z.id_interne AS id_interne_zone,
       c.date_eco AS date,
       c.hum_min AS hum_min,
       c.hum_max AS hum_max,
       CAST((c.hum_min::DECIMAL  + c.hum_max::DECIMAL ) / 2.0 AS DECIMAL(5,2)) AS hum_moyenne,
       CAST((c.hum_max::DECIMAL  - c.hum_min::DECIMAL ) AS DECIMAL(5,2)) AS variation,
       c.note AS note
FROM staging_carnetmeteo c
JOIN Dim_Zone z ON c.zone = z.code_zone
) TO '/EQ2/Loading/Fact_Humidite.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Vents
COPY (
SELECT z.id_interne AS id_interne_zone,
       c.date_eco AS date,
       c.vent_min AS vent_min,
       c.vent_max AS vent_max,
       CAST((c.vent_min::DECIMAL + c.vent_max::DECIMAL) / 2.0 AS DECIMAL(5,2)) AS vent_moyenne,
       CAST((c.vent_max::DECIMAL  - c.vent_min::DECIMAL ) AS DECIMAL(5,2)) AS variation,
       c.note AS note
FROM staging_carnetmeteo c
JOIN Dim_Zone z ON c.zone = z.code_zone
) TO '/EQ2/Loading/Fact_Vents.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Pression
COPY (
SELECT z.id_interne AS id_interne_zone,
       c.date_eco AS date,
       c.pres_min AS pres_min,
       c.pres_max AS pres_max,
       CAST((c.pres_min::DECIMAL + c.pres_max::DECIMAL ) / 2.0 AS DECIMAL(7,2)) AS pres_moyenne,
       CAST((c.pres_max::DECIMAL  - c.pres_min::DECIMAL ) AS DECIMAL(7,2)) AS variation,
       c.note AS note
FROM staging_carnetmeteo c
JOIN Dim_Zone z ON c.zone = z.code_zone
) TO '/EQ2/Loading/Fact_Pression.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Precipitation
COPY (
SELECT z.id_interne AS id_interne_zone,
       cm.date_eco AS date,
       cm.prec_tot AS prec_tot,
       tp.libelle AS prec_nature,
       cm.note AS note
FROM staging_carnetmeteo cm
JOIN staging_typeprecipitations tp ON cm.prec_nat = tp.code
JOIN Dim_Zone z ON cm.zone = z.code_zone
) TO '/EQ2/Loading/Fact_Precipitation.csv' WITH (FORMAT CSV, HEADER);

-- =============================================================================
-- Facts: Processus de croissance d'une plante
-- =============================================================================

-- Fact_Dimension
COPY (
SELECT p.id_interne AS id_interne_plant,
       date_eco AS date,
       longueur AS longueur,
       largeur AS largeur,
       CAST(d.longueur * d.largeur AS DECIMAL) AS superficie,
       note AS note
FROM staging_obsdimension d
JOIN Dim_Plant p ON d.id = p.plant_id
) TO '/EQ2/Loading/Fact_Dimension.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Etat
COPY (
SELECT p.id_interne AS id_interne_plant,
       ob.date_eco AS date,
       et.description AS etat,
       ob.note AS note
FROM staging_obsetat ob
JOIN staging_etat et ON ob.etat = et.etat
JOIN Dim_Plant p ON ob.id = p.plant_id
) TO '/EQ2/Loading/Fact_Etat.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Floraison
COPY (
SELECT p.id_interne AS id_interne_plant,
       ob.date_eco AS date,
       ob.note AS note
FROM staging_obsfloraison ob
JOIN Dim_Plant p ON ob.id = p.plant_id
) TO '/EQ2/Loading/Fact_Floraison.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Note
COPY (
SELECT p.id_interne AS id_interne_plant,
       n.date_eco AS date,
       n.note AS note
FROM staging_plant_note n
JOIN Dim_Plant p ON n.id_plant = p.plant_id
) TO '/EQ2/Loading/Fact_Note.csv' WITH (FORMAT CSV, HEADER);

-- =============================================================================
-- Facts: Environnement d'une placette
-- =============================================================================

-- Fact_Couverture
COPY (
SELECT p.id_interne AS id_interne_placette,
       CURRENT_DATE AS date,
       c.type_couverture AS type_couverture,
       (regexp_match(c.taux, '\((\d+),(\d+)\)'))[1]::DECIMAL(5,2) AS taux,
       (regexp_match(c.taux, '\((\d+),(\d+)\)'))[2]::DECIMAL(5,2) AS incertitude
FROM staging_placette_couverture c
JOIN Dim_Placette p ON c.placette = p.placette_id
) TO '/EQ2/Loading/Fact_Couverture.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Obstruction
COPY (
SELECT p.id_interne AS id_interne_placette,
       CURRENT_DATE AS date,
       o.type_obs AS type_obstruction,
       o.hauteur AS hauteur,
       (regexp_match(o.taux, '\((\d+),(\d+)\)'))[1]::DECIMAL(5,2) AS taux,
       (regexp_match(o.taux, '\((\d+),(\d+)\)'))[2]::DECIMAL(5,2) AS incertitude
FROM staging_placette_obstruction o
JOIN Dim_Placette p ON o.placette = p.placette_id
) TO '/EQ2/Loading/Fact_Obstruction.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Arbre
COPY (
SELECT p.id_interne AS id_interne_placette,
       da.id_interne AS id_interne_arbre,
       CURRENT_DATE AS date,
       a.rang AS rang
FROM staging_placette_arbre a
JOIN Dim_Placette p ON a.placette = p.placette_id
JOIN dim_arbre da ON da.nom_arbre = a.arbre
) TO '/EQ2/Loading/Fact_Arbre.csv' WITH (FORMAT CSV, HEADER);
