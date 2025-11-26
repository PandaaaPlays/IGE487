-- =============================================================================
-- Dimensions
-- =============================================================================

-- Dim_Site
SELECT DISTINCT
       id AS code_site,
       nom AS nom_site
FROM Staging_site;

-- Dim_Zone
SELECT DISTINCT
       z.id AS code_zone,
       z.site_id AS code_site,
       '' AS nom_zone,
       z.description AS description
FROM Staging_zone z;

-- Dim_Placette
SELECT DISTINCT
       CAST(p.numero AS VARCHAR) AS placette_id,
       p.zone_id AS code_zone,
       p.date AS date_creation
FROM Staging_placette p;

-- Dim_Parcelle
SELECT DISTINCT
       ep.parcelle AS parcelle_id,
       ep.placette_id AS placette_id,
       p.description AS peuplement,
       '' AS position
FROM Staging_emplacementplant ep
LEFT JOIN Staging_placette pl ON ep.placette_id = CAST(pl.numero AS VARCHAR) AND ep.zone_id = pl.zone_id
LEFT JOIN Staging_peuplement p ON pl.peuplement_id = p.id;

-- Dim_Plant
SELECT DISTINCT
       p.id AS plant_id,
       p.date_identification AS date_decouverte
FROM Staging_plant p;

-- Dim_Arbre
SELECT DISTINCT
       a.id AS arbre_id,
       a.description AS description
FROM Staging_Arbre a;

-- =============================================================================
-- Facts: Processus de l'évolution de la météo
-- =============================================================================

-- Fact_Temperature
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.temp_min AS DECIMAL(5,2)) AS temp_min,
    CAST(s.temp_max AS DECIMAL(5,2)) AS temp_max,
    CAST((s.temp_min + s.temp_max) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne,
    CAST((s.temp_max - s.temp_min) AS DECIMAL(5,2)) AS variation,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone;

-- Fact_Humidite
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.hum_min AS DECIMAL(5,2)) AS hum_min,
    CAST(s.hum_max AS DECIMAL(5,2)) AS hum_max,
    CAST((s.hum_min + s.hum_max) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne, -- Note: Schema says temp_moyenne in Fact_Humidite? Assuming it means hum_moyenne or just keeping column name
    CAST((s.hum_max - s.hum_min) AS DECIMAL(5,2)) AS variation,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone;

-- Fact_Vents
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.vent_min AS DECIMAL(5,2)) AS vent_min,
    CAST(s.vent_max AS DECIMAL(5,2)) AS vent_max,
    CAST((s.vent_min + s.vent_max) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne, -- Note: Schema column name
    CAST((s.vent_max - s.vent_min) AS DECIMAL(5,2)) AS variation,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone;

-- Fact_Pression
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.pres_min AS DECIMAL(6,2)) AS pres_min,
    CAST(s.pres_max AS DECIMAL(6,2)) AS pres_max,
    CAST((s.pres_min + s.pres_max) / 2.0 AS DECIMAL(5,2)) AS temp_moyenne, -- Note: Schema column name
    CAST((s.pres_max - s.pres_min) AS DECIMAL(5,2)) AS variation,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone;

-- Fact_Precipitation
SELECT
    z.id_interne AS id_interne_zone,
    s.date AS date,
    CAST(s.prec_tot AS DECIMAL(5,2)) AS prec_tot,
    s.prec_nat AS prec_nature,
    s.note
FROM Staging_CarnetMeteo s
JOIN Dim_Zone z ON s.zone_id = z.code_zone;

-- =============================================================================
-- Facts: Processus de croissance d'une plante
-- =============================================================================

-- Fact_Dimension
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
JOIN Dim_Parcelle dpar ON ep.parcelle = dpar.parcelle_id;

-- Fact_Etat
SELECT
    dp.id_interne AS id_interne_plant,
    dpar.id_interne AS id_interne_parcelle,
    s.date_observation AS date,
    s.etat_id AS etat,
    '' AS note
FROM Staging_etat s
JOIN Dim_Plant dp ON s.id = dp.plant_id
JOIN Staging_emplacementplant ep ON s.id = ep.plant_id AND s.date_observation BETWEEN ep.date_debut AND ep.date_fin
JOIN Dim_Parcelle dpar ON ep.parcelle = dpar.parcelle_id;

-- Fact_Floraison
SELECT
    dp.id_interne AS id_interne_plant,
    dpar.id_interne AS id_interne_parcelle,
    s.date_observation AS date,
    CASE WHEN s.est_fruit = 'Oui' THEN 'Fruit' ELSE 'Fleur' END AS note -- Mapping est_fruit to note or similar
FROM Staging_floraison s
JOIN Dim_Plant dp ON s.id = dp.plant_id
JOIN Staging_emplacementplant ep ON s.id = ep.plant_id AND s.date_observation BETWEEN ep.date_debut AND ep.date_fin
JOIN Dim_Parcelle dpar ON ep.parcelle = dpar.parcelle_id;

-- Fact_Note
SELECT
    dp.id_interne AS id_interne_plant,
    dpar.id_interne AS id_interne_parcelle,
    s.date_identification AS date,
    s.note AS note
FROM Staging_plant s
JOIN Dim_Plant dp ON s.id = dp.plant_id
JOIN Staging_emplacementplant ep ON s.id = ep.plant_id -- Assuming note is from identification time, using current or first emplacement
JOIN Dim_Parcelle dpar ON ep.parcelle = dpar.parcelle_id
WHERE s.note IS NOT NULL;

-- =============================================================================
-- Facts: Environnement d'une placette
-- =============================================================================

-- Fact_Couverture
SELECT
    dp.id_interne AS id_interne_placette,
    sp.date AS date,
    s.couverture_type AS type_couverture,
    CAST(s.taux AS DECIMAL(5,2)) AS taux
FROM Staging_couverturesol s
JOIN Dim_Placette dp ON s.placette_id = dp.placette_id
JOIN Staging_placette sp ON s.placette_id = CAST(sp.numero AS VARCHAR) AND s.zone_id = sp.zone_id;

-- Fact_Obstruction
SELECT
    dp.id_interne AS id_interne_placette,
    sp.date AS date,
    s.obstruction_type AS type_obstruction,
    s.hauteur,
    CAST(s.taux AS DECIMAL(5,2)) AS taux
FROM Staging_obstructionlaterale s
JOIN Dim_Placette dp ON s.placette_id = dp.placette_id
JOIN Staging_placette sp ON s.placette_id = CAST(sp.numero AS VARCHAR) AND s.zone_id = sp.zone_id;

-- Fact_Arbre
SELECT
    dp.id_interne AS id_interne_placette,
    da.id_interne AS id_arbre_arbre,
    sp.date AS date,
    s.rang AS rang
FROM Staging_ArbreDominant s
JOIN Dim_Placette dp ON s.placette_id = dp.placette_id
JOIN Dim_Arbre da ON s.arbre_id = da.nom_arbre
JOIN Staging_placette sp ON s.placette_id = CAST(sp.numero AS VARCHAR) AND s.zone_id = sp.zone_id;