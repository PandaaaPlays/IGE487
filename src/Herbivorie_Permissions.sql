DO $$
DECLARE
  db text := current_database();
  roles text[] := ARRAY[
    'ige487_61','ige487_63','ige487_64','ige487_65','ige487_66','ige487_67','ige487_68','ige487_69','ige487_70'
  ];
  r text;
BEGIN
  FOREACH r IN ARRAY roles LOOP
    EXECUTE format('GRANT CONNECT ON DATABASE %I TO %I', db, r);
  END LOOP;
END $$;

DO $$
DECLARE
  roles text[] := ARRAY[
    'ige487_61','ige487_63','ige487_64','ige487_65','ige487_66','ige487_67','ige487_68','ige487_69','ige487_70'
  ];
  r text;
BEGIN
  FOREACH r IN ARRAY roles LOOP
    EXECUTE format('GRANT USAGE ON SCHEMA "Herbivorie" TO %I', r);

    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_arbre() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_peuplement() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_placette() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_placette_arbre() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_placette_couverture() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_placette_obstruction() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_parcelle() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_plant() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_plant_note() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_obsdimension() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_obsfloraison() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_etat() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_obsetat() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_site() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_zone() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_obstemperature() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_obshumidite() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_obsvents() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_obspression() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_typeprecipitations() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_obsprecipitations() TO %I', r);
    EXECUTE format('GRANT EXECUTE ON FUNCTION imm_getall_carnetmeteo() TO %I', r);
  END LOOP;
END
$$;
