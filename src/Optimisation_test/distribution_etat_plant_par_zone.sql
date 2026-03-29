SET myvars.start_date = '2017-06-01';
SET myvars.end_date   = '2017-06-15';

DROP INDEX IF EXISTS idx_obsetat_date_etat_plant;
DROP INDEX IF EXISTS idx_placette_zone;

EXPLAIN (ANALYZE, BUFFERS)
SELECT z.code, oe.etat, COUNT(*) as nb_plants
FROM ObsEtat oe
JOIN Plant pl ON oe.id = pl.id
JOIN Parcelle p ON pl.parcelle_id = p.parcelle_id
JOIN Placette plct ON p.placette_id = plct.plac
JOIN Zone z ON plct.zone = z.code
WHERE oe.date BETWEEN current_setting('myvars.start_date')::date AND current_setting('myvars.end_date')::date
GROUP BY z.code, oe.etat;

CREATE INDEX idx_obsetat_date_etat_plant ON ObsEtat(date, etat, id);
CREATE INDEX idx_placette_zone ON Placette(zone);

EXPLAIN (ANALYZE, BUFFERS)
SELECT z.code, oe.etat, COUNT(*) as nb_plants
FROM ObsEtat oe
JOIN Plant pl ON oe.id = pl.id
JOIN Parcelle p ON pl.parcelle_id = p.parcelle_id
JOIN Placette plct ON p.placette_id = plct.plac
JOIN Zone z ON plct.zone = z.code
WHERE oe.date BETWEEN current_setting('myvars.start_date')::date AND current_setting('myvars.end_date')::date
GROUP BY z.code, oe.etat;