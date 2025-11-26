
-- 2.1 Fact_Dimension
COPY (
    SELECT
        od.plantid AS plant_id,
        COALESCE(opl.parcelleid, 'INCONNU') AS parcelle_id,
        od.dateobservation AS date,
        od.longueur,
        od.largeur,
        (od.longueur * od.largeur) AS superficie,
        od.note
    FROM Staging_ObsDimension od
    LEFT JOIN Staging_ObsPlantLocalisation opl ON od.plantid = opl.plantid AND od.dateobservation = opl.dateobservation
) TO '/EQ8/Loading/Fact_Dimension.csv' WITH (FORMAT CSV, HEADER);

-- 2.2 Fact_Etat
COPY (
    SELECT
        oe.plantid AS plant_id,
        COALESCE(opl.parcelleid, 'INCONNU') AS parcelle_id,
        oe.dateobservation AS date,
        oe.etat,
        oe.note
    FROM Staging_ObsEtat oe
    LEFT JOIN Staging_ObsPlantLocalisation opl ON oe.plantid = opl.plantid AND oe.dateobservation = opl.dateobservation
) TO '/EQ8/Loading/Fact_Etat.csv' WITH (FORMAT CSV, HEADER);

-- 2.3 Fact_Floraison
COPY (
    SELECT
        ofl.plantid AS plant_id,
        COALESCE(opl.parcelleid, 'INCONNU') AS parcelle_id,
        ofl.dateobservation AS date,
        ofl.note
    FROM Staging_ObsFloraison ofl
    LEFT JOIN Staging_ObsPlantLocalisation opl ON ofl.plantid = opl.plantid AND ofl.dateobservation = opl.dateobservation
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
    FROM Staging_ObsTemperature ot
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
    FROM Staging_ObsHumidite oh
) TO '/EQ8/Loading/Fact_Humidite.csv' WITH (FORMAT CSV, HEADER);

-- 3.3 Fact_Vents
COPY (
    SELECT
        ov.zoneid AS code_zone,
        ov.dateobservation AS date,
        ov.ventmin AS vent_min,
        ov.ventmax AS vent_max,
        NULL::DECIMAL(5,2) AS temp_moyenne,
        0 AS variation,
        ov.note
    FROM Staging_ObsVents ov
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
    FROM Staging_ObsPression op
) TO '/EQ8/Loading/Fact_Pression.csv' WITH (FORMAT CSV, HEADER);

-- 3.5 Fact_Precipitation
COPY (
    SELECT
        opr.zoneid AS code_zone,
        opr.dateobservation AS date,
        opr.precipitationtotale AS prec_tot,
        opr.typeprecipitation AS prec_nature,
        opr.note
    FROM Staging_ObsPrecipitation opr
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
    FROM Staging_ObsCouverture oc
    UNION ALL
    SELECT
        oc.placetteid AS placette_id,
        oc.dateobservation AS date,
        'Graminées' AS type_couverture,
        oc.tauxgraminees AS taux
    FROM Staging_ObsCouverture oc
    UNION ALL
    SELECT
        oc.placetteid AS placette_id,
        oc.dateobservation AS date,
        'Fougères' AS type_couverture,
        oc.tauxfougeres AS taux
    FROM Staging_ObsCouverture oc
) TO '/EQ8/Loading/Fact_Couverture.csv' WITH (FORMAT CSV, HEADER);

-- 4.2 Fact_Obstruction
COPY (
    SELECT
        oo.placetteid AS placette_id,
        oo.dateobservation AS date,
        'Feuillu' AS type_obstruction,
        oo.hauteur,
        oo.tauxfeuillu AS taux
    FROM Staging_ObsObstruction oo
    UNION ALL
    SELECT
        oo.placetteid AS placette_id,
        oo.dateobservation AS date,
        'Conifère' AS type_obstruction,
        oo.hauteur,
        oo.tauxconifere AS taux
    FROM Staging_ObsObstruction oo
) TO '/EQ8/Loading/Fact_Obstruction.csv' WITH (FORMAT CSV, HEADER);

-- 4.3 Fact_Arbre
COPY (
    SELECT
        oad.placetteid AS placette_id,
        oad.arbreid AS arbre_id,
        oad.dateobservation AS date,
        oad.rang
    FROM Staging_ObsArbreDominants oad
) TO '/EQ8/Loading/Fact_Arbre.csv' WITH (FORMAT CSV, HEADER);
