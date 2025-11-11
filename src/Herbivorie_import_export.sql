-- Herbivorie schema
COPY Arbre TO '/tmp/Arbre.csv' WITH CSV HEADER;
COPY Peuplement TO '/tmp/Peuplement.csv' WITH CSV HEADER;
COPY Site TO '/tmp/Site.csv' WITH CSV HEADER;
COPY Zone TO '/tmp/Zone.csv' WITH CSV HEADER;
COPY Placette TO '/tmp/Placette.csv' WITH CSV HEADER;
COPY Placette_couverture TO '/tmp/Placette_couverture.csv' WITH CSV HEADER;
COPY Placette_Obstruction TO '/tmp/Placette_Obstruction.csv' WITH CSV HEADER;
COPY Placette_Arbre TO '/tmp/Placette_Arbre.csv' WITH CSV HEADER;
COPY Parcelle TO '/tmp/Parcelle.csv' WITH CSV HEADER;
COPY Plant TO '/tmp/Plant.csv' WITH CSV HEADER;
COPY Plant_Note TO '/tmp/Plant_Note.csv' WITH CSV HEADER;
COPY ObsDimension TO '/tmp/ObsDimension.csv' WITH CSV HEADER;
COPY ObsFloraison TO '/tmp/ObsFloraison.csv' WITH CSV HEADER;
COPY Etat TO '/tmp/Etat.csv' WITH CSV HEADER;
COPY ObsEtat TO '/tmp/ObsEtat.csv' WITH CSV HEADER;

COPY (
    SELECT
        -- Placette info
        pl.plac AS placette_id,
        pl.zone AS zone,
        pl.date AS placette_date,

        -- Zone & Site info
        z.code AS zone_code,
        z.nom AS zone_nom,
        z.description AS zone_desc,
        s.code AS site_code,
        s.nom AS site_nom,

        -- Placette coverage
        pc.type_couverture,
        pc.taux,

        -- Placette obstruction
        po.hauteur,
        po.type_obs AS obstruction_type,
        po.taux AS obstruction_taux,

        -- Placette arbres
        pa.rang AS arbre_rang,
        a.arbre AS arbre_variete,
        a.description AS arbre_desc,

        -- Parcelle info
        parc.parcelle_id,
        parc.position AS parcelle_position,
        parc.peuplement AS parcelle_peuplement,

        -- Plant info
        p.id AS plant_id,
        p.date AS plant_date,

        -- Plant notes
        pn.note AS plant_note,

        -- Observations
        od.longueur AS feuille_longueur,
        od.largeur AS feuille_largeur,
        od.date AS dimension_date,
        ofl.date AS floraison_date,
        ofl.note AS floraison_note,
        oe.etat AS plant_etat,
        oe.date AS etat_date

    FROM Placette pl
    LEFT JOIN Zone z ON pl.zone = z.code
    LEFT JOIN Site s ON z.code_site = s.code

    LEFT JOIN Placette_couverture pc ON pl.plac = pc.placette
    LEFT JOIN Placette_Obstruction po ON pl.plac = po.placette
    LEFT JOIN Placette_Arbre pa ON pl.plac = pa.placette
    LEFT JOIN Arbre a ON pa.arbre = a.arbre

    LEFT JOIN Parcelle parc ON pl.plac = parc.placette_id
    LEFT JOIN Peuplement pe ON parc.peuplement = pe.peuplement
    LEFT JOIN Plant p ON parc.parcelle_id = p.parcelle_id
    LEFT JOIN Plant_Note pn ON p.id = pn.id_plant
    LEFT JOIN ObsDimension od ON p.id = od.id
    LEFT JOIN ObsFloraison ofl ON p.id = ofl.id
    LEFT JOIN ObsEtat oe ON p.id = oe.id
)
TO '/tmp/Herbivorie.csv' WITH CSV HEADER;


-- Meteo schema
COPY ObsTemperature TO '/tmp/ObsTemperature.csv' WITH CSV HEADER;
COPY ObsHumidite TO '/tmp/ObsHumidite.csv' WITH CSV HEADER;
COPY ObsVents TO '/tmp/ObsVents.csv' WITH CSV HEADER;
COPY ObsPression TO '/tmp/ObsPression.csv' WITH CSV HEADER;
COPY TypePrecipitations TO '/tmp/TypePrecipitations.csv' WITH CSV HEADER;
COPY ObsPrecipitations TO '/tmp/ObsPrecipitations.csv' WITH CSV HEADER;
COPY CarnetMeteo TO '/tmp/CarnetMeteo.csv' WITH CSV HEADER;

COPY (
    SELECT t.date,
           t.temp_min,
           t.temp_max,
           h.hum_min,
           h.hum_max,
           v.vent_min,
           v.vent_max,
           p.pres_min,
           p.pres_max,
           prec.prec_tot,
           prec.prec_nat,
           ''::text AS note
    FROM ObsTemperature t
        LEFT JOIN ObsHumidite h ON h.date = t.date
        LEFT JOIN ObsVents v ON v.date = t.date
        LEFT JOIN ObsPression p ON p.date = t.date
        LEFT JOIN ObsPrecipitations prec ON prec.date = t.date
    )
TO '/tmp/Meteo.csv' WITH CSV HEADER;

