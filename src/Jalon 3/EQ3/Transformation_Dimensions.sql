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
       pa.parcelle_id AS parcelle_id,
       pa.placette_id AS placette_id,
       pe.description AS peuplement,
       pa.position AS position
FROM staging_parcelle pa
JOIN staging_peuplement pe
ON pa.peuplement = pe.id
) TO '/EQ3/Loading/Dim_Parcelle.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Plant
COPY (
SELECT DISTINCT
       id AS plant_id,
       opl.parcelleid AS parcelle_id,
       date_identification AS date_decouverte
FROM staging_plant
LEFT JOIN staging_obsplantlocalisation opl ON opl.plantid = id
) TO '/EQ3/Loading/Dim_Plant.csv' WITH (FORMAT CSV, HEADER);

-- Dim_Arbre
COPY (
SELECT DISTINCT
       id AS nom_arbre,
       description AS description
FROM staging_arbre
) TO '/EQ3/Loading/Dim_Arbre.csv' WITH (FORMAT CSV, HEADER);