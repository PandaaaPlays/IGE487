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
    SELECT pa.peuplement AS "Allo",
           pa.position,
           pl.date,
           pl.zone
    FROM Parcelle pa
        LEFT JOIN Placette pl ON pa.placette_id = Placette.plac
        LEFT JOIN
    )
TO '/tmp/Herbivorie_Placette.csv' WITH CSV HEADER;

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

