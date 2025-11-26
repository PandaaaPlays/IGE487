-- ===========================================================================
-- Script de Transformation EQ8 (Staging -> CSV)
-- ===========================================================================
-- Ce script génère des fichiers CSV contenant uniquement les clés naturelles
-- et les attributs descriptifs. Les clés techniques (id_interne) seront générées
-- automatiquement par la BDD lors de l'importation.
--
-- Stratégie :
-- 1. Export direct des Dimensions avec clés naturelles uniquement
-- 2. Export des Faits avec références via clés naturelles
-- 3. À l'import, la BDD générera les id_interne et fera le mapping
-- ===========================================================================

-- ===========================================================================
-- 1. EXPORT DES DIMENSIONS (Clés naturelles uniquement)
-- ===========================================================================

-- 1.1 Dim_Site
COPY (
    SELECT DISTINCT
        siteid AS code_site,
        description AS nom_site
    FROM "Site"
) TO '/EQ8/Loading/Dim_Site.csv' WITH (FORMAT CSV, HEADER);

-- 1.2 Dim_Zone
COPY (
    SELECT DISTINCT
        z.zoneid AS code_zone,
        'EQ8' AS code_site,
        z.zoneid AS nom_zone,
        z.description AS description
    FROM "Zone" z
) TO '/EQ8/Loading/Dim_Zone.csv' WITH (FORMAT CSV, HEADER);

-- 1.3 Dim_Placette
COPY (
    SELECT DISTINCT
        p.placetteid AS placette_id,
        p.zoneid AS code_zone,
        CURRENT_DATE AS date_creation
    FROM "Placette" p
) TO '/EQ8/Loading/Dim_Placette.csv' WITH (FORMAT CSV, HEADER);

-- 1.4 Dim_Parcelle
COPY (
    SELECT DISTINCT
        pa.parcelleid AS parcelle_id,
        pa.placetteid AS placette_id,
        'Inconnu' AS peuplement,
        '0' AS position
    FROM "Parcelle" pa
) TO '/EQ8/Loading/Dim_Parcelle.csv' WITH (FORMAT CSV, HEADER);

-- 1.5 Dim_Plant
COPY (
    SELECT
        p.plantid AS plant_id,
        MIN(opl.dateobservation) AS date_decouverte
    FROM "Plant" p
    LEFT JOIN "ObsPlantLocalisation" opl ON p.plantid = opl.plantid
    GROUP BY p.plantid
) TO '/EQ8/Loading/Dim_Plant.csv' WITH (FORMAT CSV, HEADER);

-- 1.6 Dim_Arbre
COPY (
    SELECT DISTINCT
        arbreid AS arbre_id,
        description
    FROM "Arbre"
) TO '/EQ8/Loading/Dim_Arbre.csv' WITH (FORMAT CSV, HEADER);

-- ===========================================================================
-- 2. EXPORT DES FAITS (Références via clés naturelles)
-- ===========================================================================

-- 2.1 Fact_Dimension
-- Note: On garde plant_id et parcelle_id au lieu de id_interne_plant et id_interne_parcelle
COPY (
    SELECT
        od.plantid AS plant_id,
        COALESCE(opl.parcelleid, 'INCONNU') AS parcelle_id,
        od.dateobservation AS date,
        od.longueur,
        od.largeur,
        (od.longueur * od.largeur) AS superficie,
        od.note
    FROM "ObsDimension" od
    LEFT JOIN "ObsPlantLocalisation" opl ON od.plantid = opl.plantid AND od.dateobservation = opl.dateobservation
) TO '/EQ8/Loading/Fact_Dimension.csv' WITH (FORMAT CSV, HEADER);

-- 2.2 Fact_Etat
COPY (
    SELECT
        oe.plantid AS plant_id,
        COALESCE(opl.parcelleid, 'INCONNU') AS parcelle_id,
        oe.dateobservation AS date,
        oe.etat,
        oe.note
    FROM "ObsEtat" oe
    LEFT JOIN "ObsPlantLocalisation" opl ON oe.plantid = opl.plantid AND oe.dateobservation = opl.dateobservation
) TO '/EQ8/Loading/Fact_Etat.csv' WITH (FORMAT CSV, HEADER);

-- 2.3 Fact_Floraison
COPY (
    SELECT
        ofl.plantid AS plant_id,
        COALESCE(opl.parcelleid, 'INCONNU') AS parcelle_id,
        ofl.dateobservation AS date,
        ofl.note
    FROM "ObsFloraison" ofl
    LEFT JOIN "ObsPlantLocalisation" opl ON ofl.plantid = opl.plantid AND ofl.dateobservation = opl.dateobservation
) TO '/EQ8/Loading/Fact_Floraison.csv' WITH (FORMAT CSV, HEADER);

-- ===========================================================================
-- 3. FAITS MÉTÉO (Référence via code_zone)
-- ===========================================================================

-- 3.1 Fact_Temperature
COPY (
    SELECT
        ot.zoneid AS code_zone,
        ot.dateobservation AS date,
        ot.temperaturemin AS temp_min,
        ot.temperaturemax AS temp_max,
        (ot.temperaturemin + ot.temperaturemax) / 2 AS temp_moyenne,
        (ot.temperaturemax - ot.temperaturemin) AS variation,
        ot.note
    FROM "ObsTemperature" ot
) TO '/EQ8/Loading/Fact_Temperature.csv' WITH (FORMAT CSV, HEADER);

-- 3.2 Fact_Humidite
COPY (
    SELECT
        oh.zoneid AS code_zone,
        oh.dateobservation AS date,
        oh.humiditemin AS hum_min,
        oh.humiditemax AS hum_max,
        NULL::DECIMAL(5,2) AS temp_moyenne,
        (oh.humiditemax - oh.humiditemin) AS variation,
        oh.note
    FROM "ObsHumidite" oh
) TO '/EQ8/Loading/Fact_Humidite.csv' WITH (FORMAT CSV, HEADER);

-- 3.3 Fact_Vents
COPY (
    SELECT
        ov.zoneid AS code_zone,
        ov.dateobservation AS date,
        ov.ventvitesse AS vent_min,
        ov.ventvitesse AS vent_max,
        NULL::DECIMAL(5,2) AS temp_moyenne,
        0 AS variation,
        ov.note
    FROM "ObsVents" ov
) TO '/EQ8/Loading/Fact_Vents.csv' WITH (FORMAT CSV, HEADER);

-- 3.4 Fact_Pression
COPY (
    SELECT
        op.zoneid AS code_zone,
        op.dateobservation AS date,
        op.pressionmin AS pres_min,
        op.pressionmax AS pres_max,
        NULL::DECIMAL(5,2) AS temp_moyenne,
        (op.pressionmax - op.pressionmin) AS variation,
        op.note
    FROM "ObsPression" op
) TO '/EQ8/Loading/Fact_Pression.csv' WITH (FORMAT CSV, HEADER);

-- 3.5 Fact_Precipitation
COPY (
    SELECT
        opr.zoneid AS code_zone,
        opr.dateobservation AS date,
        opr.precipitationtotale AS prec_tot,
        opr.typeprecipitation AS prec_nature,
        opr.note
    FROM "ObsPrecipitation" opr
) TO '/EQ8/Loading/Fact_Precipitation.csv' WITH (FORMAT CSV, HEADER);

-- ===========================================================================
-- 4. FAITS ENVIRONNEMENT (Référence via placette_id)
-- ===========================================================================

-- 4.1 Fact_Couverture
COPY (
    SELECT
        oc.placetteid AS placette_id,
        oc.dateobservation AS date,
        'Mousses' AS type_couverture,
        oc.tauxmousses AS taux
    FROM "obscouverture" oc
    UNION ALL
    SELECT
        oc.placetteid AS placette_id,
        oc.dateobservation AS date,
        'Graminées' AS type_couverture,
        oc.tauxgraminees AS taux
    FROM "obscouverture" oc
    UNION ALL
    SELECT
        oc.placetteid AS placette_id,
        oc.dateobservation AS date,
        'Fougères' AS type_couverture,
        oc.tauxfougeres AS taux
    FROM "obscouverture" oc
) TO '/EQ8/Loading/Fact_Couverture.csv' WITH (FORMAT CSV, HEADER);

-- 4.2 Fact_Obstruction
COPY (
    SELECT
        oo.placetteid AS placette_id,
        oo.dateobservation AS date,
        'Feuillu' AS type_obstruction,
        oo.hauteur,
        oo.tauxfeuillu AS taux
    FROM "ObsObstruction" oo
    UNION ALL
    SELECT
        oo.placetteid AS placette_id,
        oo.dateobservation AS date,
        'Conifère' AS type_obstruction,
        oo.hauteur,
        oo.tauxconifere AS taux
    FROM "ObsObstruction" oo
) TO '/EQ8/Loading/Fact_Obstruction.csv' WITH (FORMAT CSV, HEADER);

-- 4.3 Fact_Arbre
COPY (
    SELECT
        oad.placetteid AS placette_id,
        oad.arbreid AS arbre_id,
        oad.dateobservation AS date,
        oad.rang
    FROM "ObsArbreDominants" oad
) TO '/EQ8/Loading/Fact_Arbre.csv' WITH (FORMAT CSV, HEADER);