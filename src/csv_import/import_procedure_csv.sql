-- Requiert un path valide.
-- Requiert les IMM déjà créées (Herbivorie_imm.sql).

CREATE OR REPLACE PROCEDURE "Herbivorie".pr_import_placette_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r       RECORD;
  v_plac  Placette_id;
  v_zone  Code_zone;
  v_date  Date_eco;
  n_ok    integer := 0;
  n_skip  integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN
    RAISE EXCEPTION 'Chemin CSV requis';
  END IF;

  CREATE TEMP TABLE tmp_placette_import (
    plac TEXT,
    zone TEXT,
    date TEXT
  ) ON COMMIT DROP;

  EXECUTE format(
    'COPY tmp_placette_import FROM %L WITH (FORMAT CSV, HEADER true)',
    p_path
  );

  FOR r IN SELECT * FROM tmp_placette_import LOOP

    IF r.plac IS NULL OR btrim(r.plac) = '' THEN
      RAISE WARNING 'Placette ignorée (plac vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE;
    END IF;
    IF r.zone IS NULL OR btrim(r.zone) = '' THEN
      RAISE WARNING 'Placette % ignorée (zone vide): %', r.plac, row_to_json(r); n_skip := n_skip + 1; CONTINUE;
    END IF;
    BEGIN
      v_date := r.date::date;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Placette % ignorée (date invalide: %): %', r.plac, r.date, row_to_json(r);
      n_skip := n_skip + 1; CONTINUE;
    END;

    v_plac := r.plac::Placette_id;
    v_zone := r.zone::Code_zone;

    BEGIN
      CALL imm_insert_update_placette(v_plac, v_zone, v_date);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour placette % : %', r.plac, SQLERRM;
      n_skip := n_skip + 1;
    END;
  END LOOP;

  RAISE NOTICE 'Import Placette terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_site_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_code Code_site;
  v_nom  Nom_site;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_site_import (code TEXT, nom TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_site_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_site_import LOOP
    IF r.code IS NULL OR btrim(r.code) = '' THEN RAISE WARNING 'Site ignoré (code vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_code := r.code::Code_site;
    v_nom  := COALESCE(r.nom,'')::Nom_site;
    BEGIN
      CALL imm_insert_update_site(v_code, v_nom);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour site % : %', r.code, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Site terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_zone_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_code Code_zone;
  v_code_site Code_site;
  v_nom Nom_zone;
  v_desc Description_zone;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_zone_import (code TEXT, code_site TEXT, nom TEXT, description TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_zone_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_zone_import LOOP
    IF r.code IS NULL OR btrim(r.code) = '' THEN RAISE WARNING 'Zone ignorée (code vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.code_site IS NULL OR btrim(r.code_site) = '' THEN RAISE WARNING 'Zone % ignorée (code_site vide): %', r.code, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_code := r.code::Code_zone;
    v_code_site := r.code_site::Code_site;
    v_nom := COALESCE(r.nom,'')::Nom_zone;
    v_desc := COALESCE(r.description,'')::Description_zone;
    BEGIN
      CALL imm_insert_update_zone(v_code, v_code_site, v_nom, v_desc);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour zone % : %', r.code, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Zone terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_peuplement_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_peuplement Peuplement_id;
  v_desc Description;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_peuplement_import (peuplement TEXT, description TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_peuplement_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_peuplement_import LOOP
    IF r.peuplement IS NULL OR btrim(r.peuplement) = '' THEN RAISE WARNING 'Peuplement ignoré (code vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_peuplement := r.peuplement::Peuplement_id;
    v_desc := COALESCE(r.description,'')::Description;
    BEGIN
      CALL imm_insert_update_peuplement(v_peuplement, v_desc);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour peuplement % : %', r.peuplement, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Peuplement terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_arbre_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_arbre Arbre_id;
  v_desc Description;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_arbre_import (arbre TEXT, description TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_arbre_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_arbre_import LOOP
    IF r.arbre IS NULL OR btrim(r.arbre) = '' THEN RAISE WARNING 'Arbre ignoré (code vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_arbre := r.arbre::Arbre_id;
    v_desc := COALESCE(r.description,'')::Description;
    BEGIN
      CALL imm_insert_update_arbre(v_arbre, v_desc);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour arbre % : %', r.arbre, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Arbre terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_placette_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_plac Placette_id;
  v_zone Code_zone;
  v_date Date_eco;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_placette_import (plac TEXT, zone TEXT, date TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_placette_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_placette_import LOOP
    IF r.plac IS NULL OR btrim(r.plac) = '' THEN RAISE WARNING 'Placette ignorée (plac vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.zone IS NULL OR btrim(r.zone) = '' THEN RAISE WARNING 'Placette % ignorée (zone vide): %', r.plac, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'Placette % ignorée (date invalide: %): %', r.plac, r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    v_plac := r.plac::Placette_id; v_zone := r.zone::Code_zone;
    BEGIN
      CALL imm_insert_update_placette(v_plac, v_zone, v_date);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour placette % : %', r.plac, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Placette terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_parcelle_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_parcelle_id int;
  v_plac Placette_id;
  v_peuplement Peuplement_id;
  v_pos Position_parcelle;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_parcelle_import (parcelle_id TEXT, placette_id TEXT, peuplement TEXT, position TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_parcelle_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_parcelle_import LOOP
    IF r.parcelle_id IS NULL OR r.parcelle_id !~ '^[0-9]+$' THEN RAISE WARNING 'Parcelle ignorée (id invalide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.placette_id IS NULL OR btrim(r.placette_id) = '' THEN RAISE WARNING 'Parcelle % ignorée (placette vide): %', r.parcelle_id, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.position IS NULL OR r.position !~ '^[0-9]+$' THEN RAISE WARNING 'Parcelle % ignorée (position invalide): %', r.parcelle_id, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_parcelle_id := r.parcelle_id::int; v_plac := r.placette_id::Placette_id; v_peuplement := COALESCE(r.peuplement,'')::Peuplement_id; v_pos := r.position::int::Position_parcelle;
    BEGIN
      CALL imm_insert_update_parcelle(v_parcelle_id, v_plac, v_peuplement, v_pos);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour parcelle % : %', r.parcelle_id, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Parcelle terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_plant_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_id Plant_id;
  v_parcelle int;
  v_date Date_eco;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_plant_import (id TEXT, parcelle_id TEXT, date TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_plant_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_plant_import LOOP
    IF r.id IS NULL OR btrim(r.id) = '' THEN RAISE WARNING 'Plant ignoré (id vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.parcelle_id IS NULL OR r.parcelle_id !~ '^[0-9]+$' THEN RAISE WARNING 'Plant % ignoré (parcelle invalide): %', r.id, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'Plant % ignoré (date invalide: %): %', r.id, r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    v_id := r.id::Plant_id; v_parcelle := r.parcelle_id::int;
    BEGIN
      CALL imm_insert_update_plant(v_id, v_parcelle, v_date);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour plant % : %', r.id, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Plant terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_placette_couverture_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_plac Placette_id;
  v_type Couverture;
  v_taux TauxAvecIncertitude;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_pcouv_import (placette TEXT, type_couverture TEXT, taux TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_pcouv_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_pcouv_import LOOP
    IF r.placette IS NULL OR btrim(r.placette) = '' THEN RAISE WARNING 'Couverture ignorée (placette vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.type_couverture IS NULL OR btrim(r.type_couverture) = '' THEN RAISE WARNING 'Couverture % ignorée (type vide): %', r.placette, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    BEGIN v_taux := r.taux::TauxAvecIncertitude; EXCEPTION WHEN others THEN RAISE WARNING 'Couverture % ignorée (taux invalide: %): %', r.placette, r.taux, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    v_plac := r.placette::Placette_id; v_type := r.type_couverture::Couverture;
    BEGIN
      CALL imm_insert_update_placette_couverture(v_plac, v_type, v_taux);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour couverture % : %', r.placette, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Placette_couverture terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_placette_obstruction_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_plac Placette_id;
  v_hauteur Hauteur;
  v_type_obs text;
  v_taux TauxAvecIncertitude;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_pobs_import (placette TEXT, hauteur TEXT, type_obs TEXT, taux TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_pobs_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_pobs_import LOOP
    IF r.placette IS NULL OR btrim(r.placette) = '' THEN RAISE WARNING 'Obstruction ignorée (placette vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.hauteur IS NULL OR r.hauteur !~ '^[12]$' THEN RAISE WARNING 'Obstruction % ignorée (hauteur invalide): %', r.placette, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.type_obs IS NULL OR btrim(r.type_obs) = '' THEN RAISE WARNING 'Obstruction % ignorée (type_obs vide): %', r.placette, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    BEGIN v_taux := r.taux::TauxAvecIncertitude; EXCEPTION WHEN others THEN RAISE WARNING 'Obstruction % ignorée (taux invalide: %): %', r.placette, r.taux, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    v_plac := r.placette::Placette_id; v_hauteur := r.hauteur::int::Hauteur; v_type_obs := r.type_obs;
    BEGIN
      CALL imm_insert_update_placette_obstruction(v_plac, v_hauteur, v_type_obs, v_taux);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour obstruction % : %', r.placette, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Placette_Obstruction terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_placette_arbre_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_plac Placette_id;
  v_rang Rang;
  v_arbre Arbre_id;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_parbre_import (placette TEXT, rang TEXT, arbre TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_parbre_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_parbre_import LOOP
    IF r.placette IS NULL OR btrim(r.placette) = '' THEN RAISE WARNING 'Placette_Arbre ignoré (placette vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.rang IS NULL OR r.rang !~ '^[123]$' THEN RAISE WARNING 'Placette_Arbre % ignoré (rang invalide): %', r.placette, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.arbre IS NULL OR btrim(r.arbre) = '' THEN RAISE WARNING 'Placette_Arbre % ignoré (arbre vide): %', r.placette, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_plac := r.placette::Placette_id; v_rang := r.rang::int::Rang; v_arbre := r.arbre::Arbre_id;
    BEGIN
      CALL imm_insert_update_placette_arbre(v_plac, v_rang, v_arbre);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour placette_arbre % : %', r.placette, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import Placette_Arbre terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_obsdimension_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_id Plant_id;
  v_long Dim_mm;
  v_larg Dim_mm;
  v_date Date_eco;
  v_note text;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_obsdim_import (id TEXT, longueur TEXT, largeur TEXT, date TEXT, note TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_obsdim_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_obsdim_import LOOP
    IF r.id IS NULL OR btrim(r.id) = '' THEN RAISE WARNING 'ObsDimension ignorée (id plant vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.longueur IS NULL OR r.longueur !~ '^[0-9]+$' OR r.largeur IS NULL OR r.largeur !~ '^[0-9]+$' THEN RAISE WARNING 'ObsDimension % ignorée (dimensions invalides): %', r.id, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'ObsDimension % ignorée (date invalide: %): %', r.id, r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    v_id := r.id::Plant_id; v_long := r.longueur::int::Dim_mm; v_larg := r.largeur::int::Dim_mm; v_note := COALESCE(r.note,'');
    BEGIN
      CALL imm_insert_update_obsdimension(v_id, v_long, v_larg, v_date, v_note);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour obsdimension % : %', r.id, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import ObsDimension terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_obsfloraison_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_id Plant_id;
  v_date Date_eco;
  v_note text;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_obsflo_import (id TEXT, date TEXT, note TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_obsflo_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_obsflo_import LOOP
    IF r.id IS NULL OR btrim(r.id) = '' THEN RAISE WARNING 'ObsFloraison ignorée (id plant vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'ObsFloraison % ignorée (date invalide: %): %', r.id, r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    v_id := r.id::Plant_id; v_note := COALESCE(r.note,'');
    BEGIN
      CALL imm_insert_update_obsfloraison(v_id, v_date, v_note);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour obsfloraison % : %', r.id, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import ObsFloraison terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_obsetat_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_id Plant_id;
  v_etat Etat_id;
  v_date Date_eco;
  v_note text;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_obsetat_import (id TEXT, etat TEXT, date TEXT, note TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_obsetat_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_obsetat_import LOOP
    IF r.id IS NULL OR btrim(r.id) = '' THEN RAISE WARNING 'ObsEtat ignorée (id plant vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.etat IS NULL OR btrim(r.etat) = '' THEN RAISE WARNING 'ObsEtat % ignorée (etat vide): %', r.id, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'ObsEtat % ignorée (date invalide: %): %', r.id, r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    v_id := r.id::Plant_id; v_etat := r.etat::Etat_id; v_note := COALESCE(r.note,'');
    BEGIN
      CALL imm_insert_update_obsetat(v_id, v_etat, v_date, v_note);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour obsetat % : %', r.id, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import ObsEtat terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

