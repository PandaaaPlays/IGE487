SET myvars.start_date = '2017-06-01';
SET myvars.end_date   = '2017-06-15';

DROP INDEX IF EXISTS idx_ObsDim_date;

EXPLAIN (ANALYZE, BUFFERS)
SELECT p.placette_id,
       AVG(od.longueur) as moyenne_longueur,
       AVG(od.largeur) as moyenne_largeur,
       COUNT(od.id) as nb_observations
FROM ObsDimension od
JOIN Plant pl ON od.id = pl.id
JOIN Parcelle p ON pl.parcelle_id = p.parcelle_id
WHERE od.date BETWEEN current_setting('myvars.start_date')::date AND current_setting('myvars.end_date')::date
GROUP BY p.placette_id;

CREATE INDEX IF NOT EXISTS idx_ObsDim_date
  ON "Herbivorie".obsdimension(date);

EXPLAIN (ANALYZE, BUFFERS)
SELECT p.placette_id,
       AVG(od.longueur) as moyenne_longueur,
       AVG(od.largeur) as moyenne_largeur,
       COUNT(od.id) as nb_observations
FROM ObsDimension od
JOIN Plant pl ON od.id = pl.id
JOIN Parcelle p ON pl.parcelle_id = p.parcelle_id
WHERE od.date BETWEEN current_setting('myvars.start_date')::date AND current_setting('myvars.end_date')::date
GROUP BY p.placette_id;