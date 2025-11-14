CREATE OR REPLACE PROCEDURE pr_import_obstemperature_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_date Date_eco;
  v_tmin Temperature;
  v_tmax Temperature;
  v_note text;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_obstemp_import (date TEXT, temp_min TEXT, temp_max TEXT, note TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_obstemp_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_obstemp_import LOOP
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'ObsTemperature ignorée (date invalide: %): %', r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    IF r.temp_min IS NULL OR r.temp_min !~ '^-?[0-9]+$' OR r.temp_max IS NULL OR r.temp_max !~ '^-?[0-9]+$' THEN RAISE WARNING 'ObsTemperature ignorée (températures invalides): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_tmin := r.temp_min::int::Temperature; v_tmax := r.temp_max::int::Temperature; v_note := COALESCE(r.note,'');
    BEGIN
      CALL imm_insert_update_obstemperature(v_date, v_tmin, v_tmax, v_note);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour obstemperature % : %', r.date, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import ObsTemperature terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_obshumidite_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_date Date_eco;
  v_hmin Humidite;
  v_hmax Humidite;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_obshum_import (date TEXT, hum_min TEXT, hum_max TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_obshum_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_obshum_import LOOP
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'ObsHumidite ignorée (date invalide: %): %', r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    IF r.hum_min IS NULL OR r.hum_min !~ '^[0-9]+$' OR r.hum_max IS NULL OR r.hum_max !~ '^[0-9]+$' THEN RAISE WARNING 'ObsHumidite ignorée (humidité invalide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_hmin := r.hum_min::int::Humidite; v_hmax := r.hum_max::int::Humidite;
    BEGIN
      CALL imm_insert_update_obshumidite(v_date, v_hmin, v_hmax);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour obshumidite % : %', r.date, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import ObsHumidite terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_obsvents_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_date Date_eco;
  v_vmin Vitesse;
  v_vmax Vitesse;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_obsvent_import (date TEXT, vent_min TEXT, vent_max TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_obsvent_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_obsvent_import LOOP
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'ObsVents ignorée (date invalide: %): %', r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    IF r.vent_min IS NULL OR r.vent_min !~ '^[0-9]+$' OR r.vent_max IS NULL OR r.vent_max !~ '^[0-9]+$' THEN RAISE WARNING 'ObsVents ignorée (vitesse invalide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_vmin := r.vent_min::int::Vitesse; v_vmax := r.vent_max::int::Vitesse;
    BEGIN
      CALL imm_insert_update_obsvents(v_date, v_vmin, v_vmax);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour obsvents % : %', r.date, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import ObsVents terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_obspression_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_date Date_eco;
  v_pmin Pression;
  v_pmax Pression;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_obspres_import (date TEXT, pres_min TEXT, pres_max TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_obspres_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_obspres_import LOOP
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'ObsPression ignorée (date invalide: %): %', r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    IF r.pres_min IS NULL OR r.pres_min !~ '^[0-9]+$' OR r.pres_max IS NULL OR r.pres_max !~ '^[0-9]+$' THEN RAISE WARNING 'ObsPression ignorée (pression invalide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_pmin := r.pres_min::int::Pression; v_pmax := r.pres_max::int::Pression;
    BEGIN
      CALL imm_insert_update_obspression(v_date, v_pmin, v_pmax);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour obspression % : %', r.date, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import ObsPression terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_typeprecipitations_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_code Code_P;
  v_lib text;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_tprecip_import (code TEXT, libelle TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_tprecip_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_tprecip_import LOOP
    IF r.code IS NULL OR btrim(r.code) = '' THEN RAISE WARNING 'TypePrecipitations ignoré (code vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_code := r.code::Code_P; v_lib := COALESCE(r.libelle,'');
    BEGIN
      CALL imm_insert_update_typeprecipitations(v_code, v_lib);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour typeprecipitations % : %', r.code, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import TypePrecipitations terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_obsprecipitations_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  v_date Date_eco;
  v_prec HNP;
  v_nat Code_P;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_obsprec_import (date TEXT, prec_tot TEXT, prec_nat TEXT) ON COMMIT DROP;
  EXECUTE format('COPY tmp_obsprec_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_obsprec_import LOOP
    BEGIN v_date := r.date::date; EXCEPTION WHEN others THEN RAISE WARNING 'ObsPrecipitations ignorée (date invalide: %): %', r.date, row_to_json(r); n_skip := n_skip + 1; CONTINUE; END;
    IF r.prec_tot IS NULL OR r.prec_tot !~ '^[0-9]+$' THEN RAISE WARNING 'ObsPrecipitations ignorée (prec_tot invalide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    IF r.prec_nat IS NULL OR btrim(r.prec_nat) = '' THEN RAISE WARNING 'ObsPrecipitations ignorée (prec_nat vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    v_prec := r.prec_tot::int::HNP; v_nat := r.prec_nat::Code_P;
    BEGIN
      CALL imm_insert_update_obsprecipitations(v_date, v_prec, v_nat);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur IMM pour obsprecipitations % : %', r.date, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import ObsPrecipitations terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;

CREATE OR REPLACE PROCEDURE pr_import_carnetmeteo_csv(p_path text)
LANGUAGE plpgsql
SECURITY DEFINER
AS $func$
DECLARE
  r RECORD;
  n_ok integer := 0;
  n_skip integer := 0;
BEGIN
  IF p_path IS NULL OR btrim(p_path) = '' THEN RAISE EXCEPTION 'Chemin CSV requis'; END IF;
  CREATE TEMP TABLE tmp_carnetmeteo_import (
    temp_min  text,
    temp_max  text,
    hum_min   text,
    hum_max   text,
    prec_tot  text,
    prec_nat  text,
    vent_min  text,
    vent_max  text,
    pres_min  text,
    pres_max  text,
    date      text,
    note      text
  ) ON COMMIT DROP;
  EXECUTE format('COPY tmp_carnetmeteo_import FROM %L WITH (FORMAT CSV, HEADER true)', p_path);
  FOR r IN SELECT * FROM tmp_carnetmeteo_import LOOP
    IF r.date IS NULL OR btrim(r.date) = '' THEN RAISE WARNING 'CarnetMeteo ignoré (date vide): %', row_to_json(r); n_skip := n_skip + 1; CONTINUE; END IF;
    BEGIN
      INSERT INTO CarnetMeteo(temp_min,temp_max,hum_min,hum_max,prec_tot,prec_nat,vent_min,vent_max,pres_min,pres_max,date,note)
      VALUES (r.temp_min,r.temp_max,r.hum_min,r.hum_max,r.prec_tot,r.prec_nat,r.vent_min,r.vent_max,r.pres_min,r.pres_max,r.date,r.note);
      n_ok := n_ok + 1;
    EXCEPTION WHEN others THEN
      RAISE WARNING 'Erreur pour CarnetMeteo % : %', r.date, SQLERRM; n_skip := n_skip + 1;
    END;
  END LOOP;
  RAISE NOTICE 'Import CarnetMeteo terminé : % ok, % ignorées/erreurs.', n_ok, n_skip;
END;
$func$;
