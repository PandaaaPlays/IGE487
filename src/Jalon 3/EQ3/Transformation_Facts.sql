-- =============================================================================
-- Transformation Script for EQ3 - Facts
-- Generates CSV files for Facts
-- Requires Dimensions to be loaded in the database
-- =============================================================================

-- =============================================================================
-- Facts: Processus de l'évolution de la météo
-- =============================================================================

-- Fact_Temperature
COPY (
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.temp_min AS DECIMAL(5,2)) AS temp_min,
    CAST(s.temp_max AS DECIMAL(5,2)) AS temp_max,
    CAST((s.temp_min + s.temp_max) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne,
    CAST((s.temp_max - s.temp_min) AS DECIMAL(5,2)) AS variation,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone
) TO '/EQ3/Loading/Fact_Temperature.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Humidite
COPY (
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.hum_min AS DECIMAL(5,2)) AS hum_min,
    CAST(s.hum_max AS DECIMAL(5,2)) AS hum_max,
    CAST((s.hum_min + s.hum_max) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne,
    CAST((s.hum_max - s.hum_min) AS DECIMAL(5,2)) AS variation,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone
) TO '/EQ3/Loading/Fact_Humidite.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Vents
COPY (
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.vent_min AS DECIMAL(5,2)) AS vent_min,
    CAST(s.vent_max AS DECIMAL(5,2)) AS vent_max,
    CAST((s.vent_min + s.vent_max) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne,
    CAST((s.vent_max - s.vent_min) AS DECIMAL(5,2)) AS variation,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone
) TO '/EQ3/Loading/Fact_Vents.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Pression
COPY (
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.pres_min AS DECIMAL(6,2)) AS pres_min,
    CAST(s.pres_max AS DECIMAL(6,2)) AS pres_max,
    CAST((s.pres_min + s.pres_max) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne,
    CAST((s.pres_max - s.pres_min) AS DECIMAL(5,2)) AS variation,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone
) TO '/EQ3/Loading/Fact_Pression.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Precipitation
COPY (
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.prec_tot AS DECIMAL(5,2)) AS prec_tot,
    s.prec_nat AS prec_nature,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone
) TO '/EQ3/Loading/Fact_Precipitation.csv' WITH (FORMAT CSV, HEADER);

-- =============================================================================
-- Facts: Processus de croissance d'une plante
-- =============================================================================

-- Fact_Dimension
COPY (
SELECT
    dp.id_interne AS id_interne_plant,
    dpar.id_interne AS id_interne_parcelle,
    s.date_observation AS date,
    s.longueur,
    s.largeur,
    CAST(s.longueur * s.largeur AS DECIMAL(10,2)) AS superficie,
    '' AS note
FROM Staging_dimension s
JOIN Dim_Plant dp ON s.id = dp.plant_id
JOIN Staging_emplacementplant ep ON s.id = ep.plant_id AND s.date_observation BETWEEN ep.date_debut AND ep.date_fin
JOIN Dim_Parcelle dpar ON CAST(ep.zone_id AS VARCHAR) || CAST(ep.placette_id AS VARCHAR) || CAST(ep.parcelle AS VARCHAR) = dpar.parcelle_id
) TO '/EQ3/Loading/Fact_Dimension.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Etat
COPY (
SELECT
    dp.id_interne AS id_interne_plant,
    dpar.id_interne AS id_interne_parcelle,
    s.date_observation AS date,
    s.etat_id AS etat,
    '' AS note
FROM Staging_etat s
JOIN Dim_Plant dp ON s.id = dp.plant_id
JOIN Staging_emplacementplant ep ON s.id = ep.plant_id AND s.date_observation BETWEEN ep.date_debut AND ep.date_fin
JOIN Dim_Parcelle dpar ON CAST(ep.zone_id AS VARCHAR) || CAST(ep.placette_id AS VARCHAR) || CAST(ep.parcelle AS VARCHAR) = dpar.parcelle_id
) TO '/EQ3/Loading/Fact_Etat.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Floraison
COPY (
SELECT
    dp.id_interne AS id_interne_plant,
    dpar.id_interne AS id_interne_parcelle,
    s.date_observation AS date,
    CASE WHEN s.est_fruit = 'Oui' THEN 'Fruit' ELSE 'Fleur' END AS note
FROM Staging_floraison s
JOIN Dim_Plant dp ON s.id = dp.plant_id
JOIN Staging_emplacementplant ep ON s.id = ep.plant_id AND s.date_observation BETWEEN ep.date_debut AND ep.date_fin
JOIN Dim_Parcelle dpar ON CAST(ep.zone_id AS VARCHAR) || CAST(ep.placette_id AS VARCHAR) || CAST(ep.parcelle AS VARCHAR) = dpar.parcelle_id
) TO '/EQ3/Loading/Fact_Floraison.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Note
COPY (
SELECT
    dp.id_interne AS id_interne_plant,
    dpar.id_interne AS id_interne_parcelle,
    s.date_identification AS date,
    s.note AS note
FROM Staging_plant s
JOIN Dim_Plant dp ON s.id = dp.plant_id
JOIN Staging_emplacementplant ep ON s.id = ep.plant_id
JOIN Dim_Parcelle dpar ON CAST(ep.zone_id AS VARCHAR) || CAST(ep.placette_id AS VARCHAR) || CAST(ep.parcelle AS VARCHAR) = dpar.parcelle_id
WHERE s.note IS NOT NULL
) TO '/EQ3/Loading/Fact_Note.csv' WITH (FORMAT CSV, HEADER);

-- =============================================================================
-- Facts: Environnement d'une placette
-- =============================================================================

-- Fact_Couverture
COPY (
SELECT
    dp.id_interne AS id_interne_placette,
    sp.date AS date,
    s.couverture_type AS type_couverture,
    CAST(s.taux AS DECIMAL(5,2)) AS taux
FROM Staging_couverturesol s
JOIN Dim_Placette dp ON CAST(s.zone_id AS VARCHAR) || CAST(s.placette_id AS VARCHAR) = dp.placette_id
JOIN Staging_placette sp ON s.placette_id = CAST(sp.numero AS VARCHAR) AND s.zone_id = sp.zone_id
) TO '/EQ3/Loading/Fact_Couverture.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Obstruction
COPY (
SELECT
    dp.id_interne AS id_interne_placette,
    sp.date AS date,
    s.obstruction_type AS type_obstruction,
    s.hauteur,
    CAST(s.taux AS DECIMAL(5,2)) AS taux
FROM Staging_obstructionlaterale s
JOIN Dim_Placette dp ON CAST(s.zone_id AS VARCHAR) || CAST(s.placette_id AS VARCHAR) = dp.placette_id
JOIN Staging_placette sp ON s.placette_id = CAST(sp.numero AS VARCHAR) AND s.zone_id = sp.zone_id
) TO '/EQ3/Loading/Fact_Obstruction.csv' WITH (FORMAT CSV, HEADER);

-- Fact_Arbre
COPY (
SELECT
    dp.id_interne AS id_interne_placette,
    da.id_interne AS id_interne_arbre,
    sp.date AS date,
    s.rang AS rang
FROM Staging_ArbreDominant s
JOIN Dim_Placette dp ON CAST(s.zone_id AS VARCHAR) || CAST(s.placette_id AS VARCHAR) = dp.placette_id
JOIN Dim_Arbre da ON s.arbre_id = da.nom_arbre
JOIN Staging_placette sp ON s.placette_id = CAST(sp.numero AS VARCHAR) AND s.zone_id = sp.zone_id
) TO '/EQ3/Loading/Fact_Arbre.csv' WITH (FORMAT CSV, HEADER);
