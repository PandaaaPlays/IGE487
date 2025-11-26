-- =============================================================================
-- Dimensions
-- =============================================================================

-- Dim_Site
COPY (
SELECT DISTINCT
       nom AS nom_site,
       code AS code_site
FROM staging_site
) TO '/EQ2/Loading/Dim_Site.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Zone
COPY (
SELECT DISTINCT
       code AS code_zone,
       code_site AS code_site,
       nom AS nom_zone,
       description AS description
FROM staging_zone
) TO '/EQ2/Loading/Dim_Zone.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Placette
COPY (
SELECT DISTINCT
       plac AS placette_id,
       zone AS code_zone,
       date_eco AS date_creation
FROM staging_placette
) TO '/EQ2/Loading/Dim_Placette.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Parcelle
COPY (
SELECT DISTINCT
       pa.parcelle_id AS parcelle_id,
       pa.placette_id AS placette_id,
       pe.description AS peuplement,
       pa.position AS position
FROM staging_parcelle pa
JOIN staging_peuplement pe
ON pa.peuplement = pe.peuplement
) TO '/EQ2/Loading/Dim_Parcelle.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Plant
COPY (
SELECT DISTINCT
       id AS plant_id,
       date_eco AS date_decouverte
FROM staging_plant
) TO '/EQ2/Loading/Dim_Plant.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Arbre
COPY (
SELECT DISTINCT
       arbre AS nom_arbre,
       description AS description
FROM staging_arbre
) TO '/EQ2/Loading/Dim_Arbre.csv' WITH (FORMAT CSV, HEADER);