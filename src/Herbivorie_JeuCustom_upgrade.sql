
SET SCHEMA 'Herbivorie';

-- ==================================================================
-- Jeu de données massif pour tests (version robuste)
-- - Ajoute des placettes A0..Z9 manquantes
-- - Remplit parcelles, plants, obs (dimension, floraison, état, notes)
-- - Ajoute données de base minimales si absentes (Site/Zone/Arbre/Peuplement/Etat)
-- ==================================================================

DO $$
DECLARE
  v_has_zone BOOLEAN;
  v_has_arbre BOOLEAN;
  v_has_peuplement BOOLEAN;
  v_has_etat BOOLEAN;

  v_site_code "Herbivorie".Code_site := 'AA';
  v_zone_code "Herbivorie".Code_zone;
  v_zone_name "Herbivorie".Nom_zone;
  v_plac_id  "Herbivorie".Placette_id;
  v_base_date "Herbivorie".Date_eco := DATE '2017-05-01';
  v_plac_date "Herbivorie".Date_eco;

  v_parc_pos INT;
  v_parc_id INT;
  v_n_plants INT;
  v_plant_seq INT := 4000;
  v_plant_letter CHAR(1);
  v_pid "Herbivorie".Plant_id;

  v_n_dim INT;
  v_n_etat INT;
  v_etat_code "Herbivorie".Etat_id;

  v_taux INT;
  v_inc  INT;
  v_ha   INT;
  v_type_obs TEXT;
  v_type_cov TEXT;

  v_long_mm INT;
  v_larg_mm INT;
  v_flor_rand FLOAT;
  v_peuplement_id "Herbivorie".Peuplement_id;
  v_arb1 "Herbivorie".Arbre_id;
  v_arb2 "Herbivorie".Arbre_id;
  v_arb3 "Herbivorie".Arbre_id;

BEGIN
  -- ================= Fallbacks de référence si vides =================
  SELECT EXISTS(SELECT 1 FROM "Herbivorie".Site) INTO v_has_zone;
  IF NOT v_has_zone THEN
    INSERT INTO "Herbivorie".Site(code, nom) VALUES (v_site_code, 'Site Démo');
  END IF;

  SELECT EXISTS(SELECT 1 FROM "Herbivorie".Zone) INTO v_has_zone;
  IF NOT v_has_zone THEN
    INSERT INTO "Herbivorie".Zone(code, code_site, nom, description) VALUES
      ('Z1', v_site_code, 'Zone 1', 'Zone démo 1'),
      ('Z2', v_site_code, 'Zone 2', 'Zone démo 2'),
      ('Z3', v_site_code, 'Zone 3', 'Zone démo 3'),
      ('Z4', v_site_code, 'Zone 4', 'Zone démo 4'),
      ('Z5', v_site_code, 'Zone 5', 'Zone démo 5');
  END IF;

  SELECT EXISTS(SELECT 1 FROM "Herbivorie".Arbre) INTO v_has_arbre;
  IF NOT v_has_arbre THEN
    INSERT INTO "Herbivorie".Arbre(arbre, description) VALUES
      ('ACER', 'Érable'),
      ('BETULA', 'Bouleau'),
      ('PINUS', 'Pin');
  END IF;

  SELECT EXISTS(SELECT 1 FROM "Herbivorie".Peuplement) INTO v_has_peuplement;
  IF NOT v_has_peuplement THEN
    INSERT INTO "Herbivorie".Peuplement(peuplement, description) VALUES
      ('FEUI', 'Feuillu'),
      ('CONI', 'Conifères'),
      ('MIXT', 'Mixte');
  END IF;

  SELECT EXISTS(SELECT 1 FROM "Herbivorie".Etat) INTO v_has_etat;
  IF NOT v_has_etat THEN
    INSERT INTO "Herbivorie".Etat(etat, description) VALUES
      ('O', 'Observé'),
      ('B', 'Bouton'),
      ('X', 'Inconnu');
  END IF;

  -- ================== Génération massive ==================
  FOR v_plac_id IN
    SELECT (chr(l) || d::TEXT)::TEXT
    FROM generate_series(ascii('A'), ascii('Z')) AS l
    CROSS JOIN generate_series(0,9) AS d
  LOOP
    -- sauter si la placette existe déjà
    IF EXISTS (SELECT 1 FROM "Herbivorie".Placette pl WHERE pl.plac = v_plac_id) THEN
      CONTINUE;
    END IF;

    -- choisir une zone existante aléatoire
    SELECT z.code INTO v_zone_code
    FROM "Herbivorie".Zone z
    ORDER BY random()
    LIMIT 1;

    v_plac_date := v_base_date + (random()*120)::INT;

    INSERT INTO "Herbivorie".Placette(plac, zone, date)
    VALUES (v_plac_id, v_zone_code, v_plac_date);

    -- arbres dominants (3)
    SELECT a.arbre INTO v_arb1 FROM "Herbivorie".Arbre a ORDER BY random() LIMIT 1;
    SELECT a.arbre INTO v_arb2 FROM "Herbivorie".Arbre a ORDER BY random() LIMIT 1;
    SELECT a.arbre INTO v_arb3 FROM "Herbivorie".Arbre a ORDER BY random() LIMIT 1;

    INSERT INTO "Herbivorie".Placette_Arbre(placette, rang, arbre)
    VALUES (v_plac_id,1,v_arb1),(v_plac_id,2,v_arb2),(v_plac_id,3,v_arb3);

    -- couvertures: GRAMINEES, FOUGERES, MOUSSES
    FOREACH v_type_cov IN ARRAY ARRAY['GRAMINEES','FOUGERES','MOUSSES'] LOOP
      v_taux := (random()*100)::INT;
      v_inc  := (random()*20)::INT;
      INSERT INTO "Herbivorie".Placette_couverture(placette, type_couverture, taux)
      VALUES (v_plac_id, v_type_cov, ROW(v_taux, v_inc));
    END LOOP;

    -- obstructions: hauteur 1 et 2, types Feuillu/Conifer/Total
    FOR v_ha IN 1..2 LOOP
      FOREACH v_type_obs IN ARRAY ARRAY['Feuillu','Conifer','Total'] LOOP
        v_taux := (random()*100)::INT;
        v_inc  := (random()*20)::INT;
        INSERT INTO "Herbivorie".Placette_Obstruction(placette, hauteur, type_obs, taux, incertitude)
        VALUES (v_plac_id, v_ha, v_type_obs, ROW(v_taux, v_inc), v_inc);
      END LOOP;
    END LOOP;

    -- 10 parcelles (0..9)
    FOR v_parc_pos IN 0..9 LOOP
      SELECT p.peuplement INTO v_peuplement_id
      FROM "Herbivorie".Peuplement p
      ORDER BY random()
      LIMIT 1;

      INSERT INTO "Herbivorie".Parcelle(placette_id, peuplement, position)
      VALUES (v_plac_id, v_peuplement_id, v_parc_pos)
      RETURNING parcelle_id INTO v_parc_id;

      -- 1..3 plants par parcelle
      v_n_plants := 1 + (random()*2)::INT;
      FOR i IN 1..v_n_plants LOOP
        v_plant_seq := v_plant_seq + 1;
        IF (v_plant_seq % 3) = 1 THEN
          v_plant_letter := 'A';
        ELSIF (v_plant_seq % 3) = 2 THEN
          v_plant_letter := 'B';
        ELSE
          v_plant_letter := 'C';
        END IF;

        v_pid := 'MM' || v_plant_letter || to_char(v_plant_seq, 'FM0000');

        INSERT INTO "Herbivorie".Plant(id, parcelle_id, date)
        VALUES (v_pid, v_parc_id, v_plac_date + (1 + (random()*20)::INT));

        -- 1..3 dimensions
        v_n_dim := 1 + (random()*2)::INT;
        FOR j IN 1..v_n_dim LOOP
          v_long_mm := 30 + (random()*150)::INT;
          v_larg_mm := 20 + (random()*120)::INT;
          INSERT INTO "Herbivorie".ObsDimension(id, longueur, largeur, date, note)
          VALUES (v_pid,
                  v_long_mm,
                  v_larg_mm,
                  (SELECT date FROM "Herbivorie".Plant WHERE id = v_pid) + (j*5 + (random()*3)::INT),
                  CASE WHEN random() < 0.2 THEN 'note courte' ELSE '' END);
        END LOOP;

        -- 0..1 floraison
        v_flor_rand := random();
        IF v_flor_rand < 0.6 THEN
          INSERT INTO "Herbivorie".ObsFloraison(id, date, note)
          VALUES (v_pid,
                  (SELECT date FROM "Herbivorie".Plant WHERE id = v_pid) + (3 + (random()*10)::INT),
                  CASE WHEN random() < 0.15 THEN 'floraison observée' ELSE '' END);
        END IF;

        -- 1..4 états
        v_n_etat := 1 + (random()*3)::INT;
        FOR j IN 1..v_n_etat LOOP
          SELECT e.etat INTO v_etat_code FROM "Herbivorie".Etat e ORDER BY random() LIMIT 1;
          INSERT INTO "Herbivorie".ObsEtat(id, etat, date, note)
          VALUES (v_pid,
                  v_etat_code,
                  (SELECT date FROM "Herbivorie".Plant WHERE id = v_pid) + (j*7 + (random()*4)::INT),
                  CASE WHEN random() < 0.1 THEN 'changement notable' ELSE '' END);
        END LOOP;

        -- 0..2 notes libres
        IF random() < 0.5 THEN
          INSERT INTO "Herbivorie".Plant_Note(id_plant, date, note)
          VALUES (v_pid,
                  (SELECT date FROM "Herbivorie".Plant WHERE id = v_pid) + (2 + (random()*8)::INT),
                  'note: observation terrain');
        END IF;
        IF random() < 0.3 THEN
          INSERT INTO "Herbivorie".Plant_Note(id_plant, date, note)
          VALUES (v_pid,
                  (SELECT date FROM "Herbivorie".Plant WHERE id = v_pid) + (10 + (random()*15)::INT),
                  'note: suivi supplémentaire');
        END IF;

      END LOOP; -- plants
    END LOOP;   -- parcelles
  END LOOP;     -- placettes

END;
$$;

-- ANALYZE tout le schéma pour de bons plans d'exécution
DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'Herbivorie'
    LOOP
        EXECUTE 'ANALYZE Herbivorie.' || quote_ident(r.tablename);
    END LOOP;
END;
$$;
