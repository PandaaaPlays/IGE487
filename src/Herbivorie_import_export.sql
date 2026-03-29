-- Herbivorie schema
COPY "Herbivorie".Arbre TO '/tmp/Arbre.csv' WITH CSV HEADER;
COPY "Herbivorie".Peuplement TO '/tmp/Peuplement.csv' WITH CSV HEADER;
COPY "Herbivorie".Site TO '/tmp/Site.csv' WITH CSV HEADER;
COPY "Herbivorie".Zone TO '/tmp/Zone.csv' WITH CSV HEADER;
COPY "Herbivorie".Placette TO '/tmp/Placette.csv' WITH CSV HEADER;
COPY "Herbivorie".Placette_couverture TO '/tmp/Placette_couverture.csv' WITH CSV HEADER;
COPY "Herbivorie".Placette_Obstruction TO '/tmp/Placette_Obstruction.csv' WITH CSV HEADER;
COPY "Herbivorie".Placette_Arbre TO '/tmp/Placette_Arbre.csv' WITH CSV HEADER;
COPY "Herbivorie".Parcelle TO '/tmp/Parcelle.csv' WITH CSV HEADER;
COPY "Herbivorie".Plant TO '/tmp/Plant.csv' WITH CSV HEADER;
COPY "Herbivorie".Plant_Note TO '/tmp/Plant_Note.csv' WITH CSV HEADER;
COPY "Herbivorie".ObsDimension TO '/tmp/ObsDimension.csv' WITH CSV HEADER;
COPY "Herbivorie".ObsFloraison TO '/tmp/ObsFloraison.csv' WITH CSV HEADER;
COPY "Herbivorie".Etat TO '/tmp/Etat.csv' WITH CSV HEADER;
COPY "Herbivorie".ObsEtat TO '/tmp/ObsEtat.csv' WITH CSV HEADER;

CREATE OR REPLACE VIEW "Herbivorie".v_hervivorie_template_export AS
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
FROM "Herbivorie".Placette pl
LEFT JOIN "Herbivorie".Zone z ON pl.zone = z.code
LEFT JOIN "Herbivorie".Site s ON z.code_site = s.code
LEFT JOIN "Herbivorie".Placette_couverture pc ON pl.plac = pc.placette
LEFT JOIN "Herbivorie".Placette_Obstruction po ON pl.plac = po.placette
LEFT JOIN "Herbivorie".Placette_Arbre pa ON pl.plac = pa.placette
LEFT JOIN "Herbivorie".Arbre a ON pa.arbre = a.arbre
LEFT JOIN "Herbivorie".Parcelle parc ON pl.plac = parc.placette_id
LEFT JOIN "Herbivorie".Peuplement pe ON parc.peuplement = pe.peuplement
LEFT JOIN "Herbivorie".Plant p ON parc.parcelle_id = p.parcelle_id
LEFT JOIN "Herbivorie".Plant_Note pn ON p.id = pn.id_plant
LEFT JOIN "Herbivorie".ObsDimension od ON p.id = od.id
LEFT JOIN "Herbivorie".ObsFloraison ofl ON p.id = ofl.id
LEFT JOIN "Herbivorie".ObsEtat oe ON p.id = oe.id;

CREATE OR REPLACE FUNCTION "Herbivorie".generate_herbivorie_template_csv(p_dir text)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  dir      text := regexp_replace(p_dir, '[\\/]+$', '');   -- enlève / ou \ final
  out_path text := dir || '/Herbivorie_template.csv';
BEGIN
  -- vérification du chemin selon linux ou windows
  IF NOT (out_path LIKE '/tmp%' OR out_path LIKE '/var/lib/postgresql/%' OR out_path ~ '^[A-Za-z]:[\\/].*') THEN
    RAISE EXCEPTION 'Chemin "%" non autorisé. Utilisez /tmp, /var/lib/postgresql/... ou un chemin Windows (ex. C:\temp).', out_path;
  END IF;

  -- Template vide (en-têtes uniquement)
  EXECUTE format(
    'COPY (SELECT * FROM "Herbivorie".v_hervivorie_template_export LIMIT 0)
     TO %L WITH (FORMAT CSV, HEADER true)',
    out_path
  );
END;
$func$;

-- export du template vide
-- SELECT "Herbivorie".generate_herbivorie_template_csv('C:/temp');
    SELECT "Herbivorie".generate_herbivorie_template_csv('C:\Universite\IGE487_J2J3J4');





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

