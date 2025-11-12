-- ================================================
-- Combien de plants par placette / par zone / dans une plage de dates ?
-- Mesure avant/après index avec variables de session
-- ================================================

-- 0) Paramètres
SET myvars.start_date = '2017-05-01';
SET myvars.end_date   = '2017-09-01';

SHOW myvars.start_date;
SHOW myvars.end_date;

-- 1) cas de base SANS index : on supprime les index s’ils existent
DROP INDEX IF EXISTS "Herbivorie".idx_parcelle_placette;
DROP INDEX IF EXISTS "Herbivorie".idx_plant_date_parcelle;

-- 1.a) Par PLACETTE
EXPLAIN (ANALYZE, BUFFERS)
SELECT pl.plac AS placette_id, COUNT(p.id) AS nb_plants
FROM "Herbivorie".Placette pl
JOIN "Herbivorie".Parcelle pa ON pa.placette_id = pl.plac
JOIN "Herbivorie".Plant    p  ON p.parcelle_id  = pa.parcelle_id
WHERE p.date BETWEEN current_setting('myvars.start_date')::date
                 AND current_setting('myvars.end_date')::date
GROUP BY pl.plac
ORDER BY pl.plac;

-- 1.b) Par ZONE
EXPLAIN (ANALYZE, BUFFERS)
SELECT z.code AS zone, COUNT(p.id) AS nb_plants
FROM "Herbivorie".Placette pl
JOIN "Herbivorie".Zone     z  ON z.code         = pl.zone
JOIN "Herbivorie".Parcelle pa ON pa.placette_id = pl.plac
JOIN "Herbivorie".Plant    p  ON p.parcelle_id  = pa.parcelle_id
WHERE p.date BETWEEN current_setting('myvars.start_date')::date
                 AND current_setting('myvars.end_date')::date
GROUP BY z.code
ORDER BY z.code;

-- 2) Création des INDEX + mise à jour des stats
CREATE INDEX IF NOT EXISTS idx_parcelle_placette
  ON "Herbivorie".Parcelle(placette_id);

-- Filtre d'abord par date, puis lookup par parcelle_id
CREATE INDEX IF NOT EXISTS idx_plant_date_parcelle
  ON "Herbivorie".Plant(date, parcelle_id);

ANALYZE "Herbivorie".Placette;
ANALYZE "Herbivorie".Parcelle;
ANALYZE "Herbivorie".Plant;

-- 3.a) Par PLACETTE — avec index
EXPLAIN (ANALYZE, BUFFERS)
SELECT pl.plac AS placette_id, COUNT(p.id) AS nb_plants
FROM "Herbivorie".Placette pl
JOIN "Herbivorie".Parcelle pa ON pa.placette_id = pl.plac
JOIN "Herbivorie".Plant    p  ON p.parcelle_id  = pa.parcelle_id
WHERE p.date BETWEEN current_setting('myvars.start_date')::date
                 AND current_setting('myvars.end_date')::date
GROUP BY pl.plac
ORDER BY pl.plac;

-- 3.b) Par ZONE — avec index
EXPLAIN (ANALYZE, BUFFERS)
SELECT z.code AS zone, COUNT(p.id) AS nb_plants
FROM "Herbivorie".Placette pl
JOIN "Herbivorie".Zone     z  ON z.code         = pl.zone
JOIN "Herbivorie".Parcelle pa ON pa.placette_id = pl.plac
JOIN "Herbivorie".Plant    p  ON p.parcelle_id  = pa.parcelle_id
WHERE p.date BETWEEN current_setting('myvars.start_date')::date
                 AND current_setting('myvars.end_date')::date
GROUP BY z.code
ORDER BY z.code;