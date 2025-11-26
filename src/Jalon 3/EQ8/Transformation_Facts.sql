-- 2.1 Fact_Dimension
COPY (
    SELECT
        dp.id_interne AS id_interne_plant,
        od.dateobservation AS date,
        od.longueur,
        od.largeur,
        (od.longueur * od.largeur) AS superficie,
        od.note
    FROM Staging_ObsDimension od
    LEFT JOIN Staging_ObsPlantLocalisation opl ON od.plantid = opl.plantid AND od.dateobservation = opl.dateobservation
    JOIN Dim_Plant dp ON dp.plant_id = od.plantid AND dp.parcelle_id IS NOT DISTINCT FROM opl.parcelleid
) TO '/EQ8/Loading/Fact_Dimension.csv' WITH (FORMAT CSV, HEADER);

-- 2.2 Fact_Etat
COPY (
    SELECT
        dp.id_interne AS id_interne_plant,
        oe.dateobservation AS date,
        oe.etat,
        oe.note
    FROM Staging_ObsEtat oe
    LEFT JOIN Staging_ObsPlantLocalisation opl ON oe.plantid = opl.plantid AND oe.dateobservation = opl.dateobservation
    JOIN Dim_Plant dp ON dp.plant_id = oe.plantid AND dp.parcelle_id IS NOT DISTINCT FROM opl.parcelleid
) TO '/EQ8/Loading/Fact_Etat.csv' WITH (FORMAT CSV, HEADER);

-- 2.3 Fact_Floraison
COPY (
    SELECT
        dp.id_interne AS id_interne_plant,
        ofl.dateobservation AS date,
        ofl.note
    FROM Staging_ObsFloraison ofl
    LEFT JOIN Staging_ObsPlantLocalisation opl ON ofl.plantid = opl.plantid AND ofl.dateobservation = opl.dateobservation
    JOIN Dim_Plant dp ON dp.plant_id = ofl.plantid AND dp.parcelle_id IS NOT DISTINCT FROM opl.parcelleid
) TO '/EQ8/Loading/Fact_Floraison.csv' WITH (FORMAT CSV, HEADER);

-- 2.4 Fact_Note
COPY (
SELECT
    dp.id_interne AS id_interne_plant,
    s.dateobservation AS date,
    s.note AS note
FROM staging_obsplantlocalisation s
JOIN Dim_Plant dp ON s.plantid = dp.plant_id
WHERE s.note IS NOT NULL
) TO '/EQ8/Loading/Fact_Note.csv' WITH (FORMAT CSV, HEADER);

-- ===========================================================================
-- 3. FAITS MÉTÉO (Référence via code_zone)
-- ===========================================================================

-- 3.1 Fact_Temperature
COPY (
    SELECT
        dz.id_interne AS id_interne_zone,
        ot.dateobservation AS date,
        ot.temperaturemin AS temp_min,
        ot.temperaturemax AS temp_max,
        (ot.temperaturemin + ot.temperaturemax) / 2 AS temp_moyenne,
        (ot.temperaturemax - ot.temperaturemin) AS variation,
        ot.note
    FROM Staging_ObsTemperature ot
    JOIN Dim_Zone dz ON dz.code_zone = ot.zoneid AND dz.code_site = ot.siteid
) TO '/EQ8/Loading/Fact_Temperature.csv' WITH (FORMAT CSV, HEADER);

-- 3.2 Fact_Humidite
COPY (
    SELECT
        dz.id_interne AS id_interne_zone,
        oh.dateobservation AS date,
        oh.humiditemin AS hum_min,
        oh.humiditemax AS hum_max,
        NULL::DECIMAL(5,2) AS temp_moyenne,
        (oh.humiditemax - oh.humiditemin) AS variation,
        oh.note
    FROM Staging_ObsHumidite oh
    JOIN Dim_Zone dz ON dz.code_zone = oh.zoneid AND dz.code_site = oh.siteid
) TO '/EQ8/Loading/Fact_Humidite.csv' WITH (FORMAT CSV, HEADER);

-- 3.3 Fact_Vents
COPY (
    SELECT
        dz.id_interne AS id_interne_zone,
        ov.dateobservation AS date,
        ov.ventmin AS vent_min,
        ov.ventmax AS vent_max,
        NULL::DECIMAL(5,2) AS temp_moyenne,
        0 AS variation,
        ov.note
    FROM Staging_ObsVents ov
    JOIN Dim_Zone dz ON dz.code_zone = ov.zoneid AND dz.code_site = ov.siteid
) TO '/EQ8/Loading/Fact_Vents.csv' WITH (FORMAT CSV, HEADER);

-- 3.4 Fact_Pression
COPY (
    SELECT
        dz.id_interne AS id_interne_zone,
        op.dateobservation AS date,
        op.pressionmin AS pres_min,
        op.pressionmax AS pres_max,
        NULL::DECIMAL(5,2) AS temp_moyenne,
        (op.pressionmax - op.pressionmin) AS variation,
        op.note
    FROM Staging_ObsPression op
    JOIN Dim_Zone dz ON dz.code_zone = op.zoneid AND dz.code_site = op.siteid
) TO '/EQ8/Loading/Fact_Pression.csv' WITH (FORMAT CSV, HEADER);

-- 3.5 Fact_Precipitation
COPY (
    SELECT
        dz.id_interne AS id_interne_zone,
        opr.dateobservation AS date,
        opr.precipitationtotale AS prec_tot,
        opr.typeprecipitation AS prec_nature,
        opr.note
    FROM Staging_ObsPrecipitation opr
    JOIN Dim_Zone dz ON dz.code_zone = opr.zoneid AND dz.code_site = opr.siteid
) TO '/EQ8/Loading/Fact_Precipitation.csv' WITH (FORMAT CSV, HEADER);

-- ===========================================================================
-- 4. FAITS ENVIRONNEMENT (Référence via placette_id)
-- ===========================================================================

-- 4.1 Fact_Couverture
COPY (
    SELECT
        dp.id_interne AS id_interne_placette,
        oc.dateobservation AS date,
        'Mousses' AS type_couverture,
        oc.tauxmousses AS taux
    FROM Staging_ObsCouverture oc
    JOIN Dim_Placette dp ON dp.placette_id = oc.placetteid AND dp.code_zone = oc.zoneid
    UNION ALL
    SELECT
        dp.id_interne AS id_interne_placette,
        oc.dateobservation AS date,
        'Graminées' AS type_couverture,
        oc.tauxgraminees AS taux
    FROM Staging_ObsCouverture oc
    JOIN Dim_Placette dp ON dp.placette_id = oc.placetteid AND dp.code_zone = oc.zoneid
    UNION ALL
    SELECT
        dp.id_interne AS id_interne_placette,
        oc.dateobservation AS date,
        'Fougères' AS type_couverture,
        oc.tauxfougeres AS taux
    FROM Staging_ObsCouverture oc
    JOIN Dim_Placette dp ON dp.placette_id = oc.placetteid AND dp.code_zone = oc.zoneid
) TO '/EQ8/Loading/Fact_Couverture.csv' WITH (FORMAT CSV, HEADER);

-- 4.2 Fact_Obstruction
COPY (
    SELECT
        dp.id_interne AS id_interne_placette,
        oo.dateobservation AS date,
        'Feuillu' AS type_obstruction,
        oo.hauteur,
        oo.tauxfeuillu AS taux
    FROM Staging_ObsObstruction oo
    JOIN Dim_Placette dp ON dp.placette_id = oo.placetteid AND dp.code_zone = oo.zoneid
    UNION ALL
    SELECT
        dp.id_interne AS id_interne_placette,
        oo.dateobservation AS date,
        'Conifère' AS type_obstruction,
        oo.hauteur,
        oo.tauxconifere AS taux
    FROM Staging_ObsObstruction oo
    JOIN Dim_Placette dp ON dp.placette_id = oo.placetteid AND dp.code_zone = oo.zoneid
) TO '/EQ8/Loading/Fact_Obstruction.csv' WITH (FORMAT CSV, HEADER);

-- 4.3 Fact_Arbre
COPY (
    SELECT
        dp.id_interne AS id_interne_placette,
        da.id_interne AS id_interne_arbre,
        oad.dateobservation AS date,
        oad.rang
    FROM Staging_ObsArbreDominants oad
    JOIN Dim_Placette dp ON dp.placette_id = oad.placetteid AND dp.code_zone = oad.zoneid
    JOIN Dim_Arbre da ON da.nom_arbre = oad.arbreid
) TO '/EQ8/Loading/Fact_Arbre.csv' WITH (FORMAT CSV, HEADER);



