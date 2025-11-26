-- =============================================================================
-- Dimensions
-- =============================================================================

-- Dim_Site
COPY (
SELECT DISTINCT
       id AS code_site,
       nom AS nom_site
FROM Staging_site
) TO '/EQ3/Loading/Dim_Site.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Zone
COPY (
SELECT DISTINCT
       z.id AS code_zone,
       z.site_id AS code_site,
       '' AS nom_zone,
       z.description AS description
FROM Staging_zone z
) TO '/EQ3/Loading/Dim_Zone.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Placette
COPY (
SELECT DISTINCT
       CAST(p.numero AS VARCHAR) AS placette_id,
       p.zone_id AS code_zone,
       p.date AS date_creation
FROM Staging_placette p
) TO '/EQ3/Loading/Dim_Placette.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Parcelle
COPY (
SELECT DISTINCT
       ep.parcelle AS parcelle_id,
       ep.placette_id AS placette_id,
       p.description AS peuplement,
       '' AS position
FROM Staging_emplacementplant ep
LEFT JOIN Staging_placette pl ON ep.placette_id = CAST(pl.numero AS VARCHAR) AND ep.zone_id = pl.zone_id
LEFT JOIN Staging_peuplement p ON pl.peuplement_id = p.id
) TO '/EQ3/Loading/Dim_Parcelle.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Plant
COPY (
SELECT DISTINCT
       p.id AS plant_id,
       p.date_identification AS date_decouverte
FROM Staging_plant p
) TO '/EQ3/Loading/Dim_Plant.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Arbre
COPY (
SELECT DISTINCT
       a.id AS arbre_id,
       a.description AS description
FROM Staging_Arbre a
) TO '/EQ3/Loading/Dim_Arbre.csv' WITH (FORMAT CSV, HEADER);

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
JOIN Dim_Parcelle dpar ON ep.parcelle = dpar.parcelle_id
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
JOIN Dim_Parcelle dpar ON ep.parcelle = dpar.parcelle_id
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
JOIN Dim_Parcelle dpar ON ep.parcelle = dpar.parcelle_id
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
JOIN Dim_Parcelle dpar ON ep.parcelle = dpar.parcelle_id
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
JOIN Dim_Placette dp ON s.placette_id = dp.placette_id
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
JOIN Dim_Placette dp ON s.placette_id = dp.placette_id
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
JOIN Dim_Placette dp ON s.placette_id = dp.placette_id
JOIN Dim_Arbre da ON s.arbre_id = da.nom_arbre
JOIN Staging_placette sp ON s.placette_id = CAST(sp.numero AS VARCHAR) AND s.zone_id = sp.zone_id
) TO '/EQ3/Loading/Fact_Arbre.csv' WITH (FORMAT CSV, HEADER);