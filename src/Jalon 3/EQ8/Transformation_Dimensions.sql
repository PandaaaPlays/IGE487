-- ===========================================================================
-- 1. EXPORT DES DIMENSIONS (Clés naturelles uniquement)
-- ===========================================================================

-- 1.1 Dim_Site
COPY (
    SELECT DISTINCT 
        siteid AS code_site,
        nom AS nom_site
    FROM Staging_Site
) TO '/EQ8/Loading/Dim_Site.csv' WITH (FORMAT CSV, HEADER);

-- 1.2 Dim_Zone
COPY (
    SELECT DISTINCT 
        z.zoneid AS code_zone,
        z.siteid AS code_site,
        NULL AS nom_zone, -- Pas de nom adans Staging_Zone
        NULL AS description -- Pas de description dans Staging_Zone
    FROM Staging_Zone z
) TO '/EQ8/Loading/Dim_Zone.csv' WITH (FORMAT CSV, HEADER);

-- 1.3 Dim_Placette
COPY (
    SELECT DISTINCT 
        p.placetteid AS placette_id,
        p.zoneid AS code_zone,
        CURRENT_DATE AS date_creation
    FROM Staging_Placette p
) TO '/EQ8/Loading/Dim_Placette.csv' WITH (FORMAT CSV, HEADER);

-- 1.4 Dim_Parcelle
COPY (
    SELECT DISTINCT 
        pa.parcelleid AS parcelle_id,
        pa.placetteid AS placette_id,
        'Inconnu' AS peuplement,
        '0' AS position
    FROM Staging_Parcelle pa
) TO '/EQ8/Loading/Dim_Parcelle.csv' WITH (FORMAT CSV, HEADER);

-- 1.5 Dim_Plant
COPY (
    SELECT 
        p.plantid AS plant_id,
        opl.parcelleid AS parcelle_id,
        MIN(opl.dateobservation) AS date_decouverte
    FROM Staging_Plant p
    LEFT JOIN Staging_ObsPlantLocalisation opl ON p.plantid = opl.plantid
    GROUP BY p.plantid, opl.parcelleid
) TO '/EQ8/Loading/Dim_Plant.csv' WITH (FORMAT CSV, HEADER);

-- 1.6 Dim_Arbre
COPY (
    SELECT DISTINCT 
        arbreid AS arbre_id,
        description
    FROM Staging_Arbre
) TO '/EQ8/Loading/Dim_Arbre.csv' WITH (FORMAT CSV, HEADER);
