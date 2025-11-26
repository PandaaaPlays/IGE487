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
