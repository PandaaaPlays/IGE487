-- =============================================================================
-- Dimensions
-- =============================================================================

-- Dim_Site
COPY (
SELECT DISTINCT
       nom AS nom_site,
       id AS code_site
FROM staging_site
) TO '/EQ3/Loading/Dim_Site.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Zone
COPY (
SELECT DISTINCT
       id AS code_zone,
       site_id AS code_site,
       NULL AS nom_zone,
       description AS description
FROM staging_zone
) TO '/EQ3/Loading/Dim_Zone.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Placette
COPY (
SELECT DISTINCT
       numero AS placette_id,
       zone_id AS code_zone,
       date AS date_creation
FROM staging_placette
) TO '/EQ3/Loading/Dim_Placette.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Parcelle
COPY (
SELECT DISTINCT
       ep.parcelle AS parcelle_id,
       ep.placette_id AS placette_id,
       pe.description AS peuplement,
       NULL AS position
FROM staging_emplacementplant ep
LEFT JOIN staging_placette p ON CAST(p.numero AS TEXT) = ep.placette_id
JOIN staging_peuplement pe ON p.peuplement_id = pe.id
) TO '/EQ3/Loading/Dim_Parcelle.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Plant
COPY (
SELECT DISTINCT
       id AS plant_id,
       ep.parcelle AS parcelle_id,
       date_identification AS date_decouverte
FROM staging_plant
LEFT JOIN staging_emplacementplant ep ON ep.plant_id = id
) TO '/EQ3/Loading/Dim_Plant.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Arbre
COPY (
SELECT DISTINCT
       id AS nom_arbre,
       description AS description
FROM staging_arbre
) TO '/EQ3/Loading/Dim_Arbre.csv' WITH (FORMAT CSV, HEADER);