-- Clean avant les tests
TRUNCATE TABLE Fact_Arbre, Fact_Obstruction, Fact_Couverture, Fact_Note, Fact_Floraison, Fact_Etat, Fact_Dimension, Fact_Precipitation, Fact_Pression, Fact_Vents, Fact_Humidite, Fact_Temperature CASCADE;
TRUNCATE TABLE Dim_Arbre, Dim_Plant, Dim_Parcelle, Dim_Placette, Dim_Zone, Dim_Site CASCADE;

-- -----------------------------------------------------------------------------
-- Test Dim_Site
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Dim_Site...';
    
    -- Insert
    CALL IMM_Insert_Dim_Site('SITE01', 'Site Test');
    
    -- Select
    SELECT id_interne INTO v_id FROM IMM_Select_Dim_Site() WHERE code_site = 'SITE01';
    IF v_id IS NULL THEN RAISE EXCEPTION 'Insertion ratée pour Dim_Site'; END IF;
    
    -- Update
    CALL IMM_Update_Dim_Site(v_id, 'SITE01_UPD', 'Site Test Updated');
    PERFORM * FROM IMM_Select_Dim_Site(v_id) WHERE code_site = 'SITE01_UPD';
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Dim_Site'; END IF;
    
    -- Delete
    CALL IMM_Delete_Dim_Site(v_id);
    PERFORM * FROM IMM_Select_Dim_Site(v_id);
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Dim_Site'; END IF;
    
    RAISE NOTICE 'Dim_Site Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Dim_Zone
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_zone_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Dim_Zone...';
    
    -- Setup dependency
    CALL IMM_Insert_Dim_Site('SITE_Z', 'Site for Zone');
    
    -- Insert
    CALL IMM_Insert_Dim_Zone('ZONE01', 'SITE_Z', 'Zone Test', 'Desc');
    
    -- Select
    SELECT id_interne INTO v_zone_id FROM IMM_Select_Dim_Zone() WHERE code_zone = 'ZONE01';
    IF v_zone_id IS NULL THEN RAISE EXCEPTION 'Insertion ratée pour Dim_Zone'; END IF;
    
    -- Update
    CALL IMM_Update_Dim_Zone(v_zone_id, 'ZONE01_UPD', 'SITE_Z', 'Zone Updated', 'Desc Upd');
    PERFORM * FROM IMM_Select_Dim_Zone(v_zone_id) WHERE code_zone = 'ZONE01_UPD';
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Dim_Zone'; END IF;
    
    -- Delete
    CALL IMM_Delete_Dim_Zone(v_zone_id);
    PERFORM * FROM IMM_Select_Dim_Zone(v_zone_id);
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Dim_Zone'; END IF;
    
    RAISE NOTICE 'Dim_Zone Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Dim_Placette
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_placette_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Dim_Placette...';
    
    -- Insert
    CALL IMM_Insert_Dim_Placette('PLAC01', 'ZONE01', '2023-01-01');
    
    -- Select
    SELECT id_interne INTO v_placette_id FROM IMM_Select_Dim_Placette() WHERE placette_id = 'PLAC01';
    IF v_placette_id IS NULL THEN RAISE EXCEPTION 'Insertion ratée pour Dim_Placette'; END IF;
    
    -- Update
    CALL IMM_Update_Dim_Placette(v_placette_id, 'PLAC01_UPD', 'ZONE01', '2023-01-02');
    PERFORM * FROM IMM_Select_Dim_Placette(v_placette_id) WHERE placette_id = 'PLAC01_UPD';
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Dim_Placette'; END IF;
    
    -- Delete
    CALL IMM_Delete_Dim_Placette(v_placette_id);
    PERFORM * FROM IMM_Select_Dim_Placette(v_placette_id);
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Dim_Placette'; END IF;
    
    RAISE NOTICE 'Dim_Placette Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Dim_Parcelle
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_parcelle_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Dim_Parcelle...';
    
    -- Insert
    CALL IMM_Insert_Dim_Parcelle('PARC01', 'PLAC01', 'Peuplement', 'Pos');
    
    -- Select
    SELECT id_interne INTO v_parcelle_id FROM IMM_Select_Dim_Parcelle() WHERE parcelle_id = 'PARC01';
    IF v_parcelle_id IS NULL THEN RAISE EXCEPTION 'Insertion ratée pour Dim_Parcelle'; END IF;
    
    -- Update
    CALL IMM_Update_Dim_Parcelle(v_parcelle_id, 'PARC01_UPD', 'PLAC01', 'Peup Upd', 'Pos Upd');
    PERFORM * FROM IMM_Select_Dim_Parcelle(v_parcelle_id) WHERE parcelle_id = 'PARC01_UPD';
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Dim_Parcelle'; END IF;
    
    -- Delete
    CALL IMM_Delete_Dim_Parcelle(v_parcelle_id);
    PERFORM * FROM IMM_Select_Dim_Parcelle(v_parcelle_id);
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Dim_Parcelle'; END IF;
    
    RAISE NOTICE 'Dim_Parcelle Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Dim_Plant
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_plant_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Dim_Plant...';
    
    -- Insert
    CALL IMM_Insert_Dim_Plant('PARC01', 'PLANT01', '2023-05-01');
    
    -- Select
    SELECT id_interne INTO v_plant_id FROM IMM_Select_Dim_Plant() WHERE plant_id = 'PLANT01';
    IF v_plant_id IS NULL THEN RAISE EXCEPTION 'Insertion ratée pour Dim_Plant'; END IF;
    
    -- Update
    CALL IMM_Update_Dim_Plant(v_plant_id, 'PARC01', 'PLANT01_UPD', '2023-05-02');
    PERFORM * FROM IMM_Select_Dim_Plant(v_plant_id) WHERE plant_id = 'PLANT01_UPD';
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Dim_Plant'; END IF;
    
    -- Delete
    CALL IMM_Delete_Dim_Plant(v_plant_id);
    PERFORM * FROM IMM_Select_Dim_Plant(v_plant_id);
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Dim_Plant'; END IF;
    
    RAISE NOTICE 'Dim_Plant Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Dim_Arbre
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_arbre_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Dim_Arbre...';
    
    -- Insert
    CALL IMM_Insert_Dim_Arbre('Arbre 1', 'Desc Arbre');
    
    -- Select
    SELECT id_interne INTO v_arbre_id FROM IMM_Select_Dim_Arbre() WHERE nom_arbre = 'Arbre 1';
    IF v_arbre_id IS NULL THEN RAISE EXCEPTION 'Insertion ratée pour Dim_Arbre'; END IF;
    
    -- Update
    CALL IMM_Update_Dim_Arbre(v_arbre_id, 'Arbre 1 Upd', 'Desc Upd');
    PERFORM * FROM IMM_Select_Dim_Arbre(v_arbre_id) WHERE nom_arbre = 'Arbre 1 Upd';
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Dim_Arbre'; END IF;
    
    -- Delete
    CALL IMM_Delete_Dim_Arbre(v_arbre_id);
    PERFORM * FROM IMM_Select_Dim_Arbre(v_arbre_id);
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Dim_Arbre'; END IF;
    
    RAISE NOTICE 'Dim_Arbre Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Temperature
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_zone_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Temperature...';
    
    -- Setup Zone
    CALL IMM_Insert_Dim_Site('SITE_T', 'Site T');
    CALL IMM_Insert_Dim_Zone('ZONE_T', 'SITE_T', 'Zone T', 'Desc');
    SELECT id_interne INTO v_zone_id FROM IMM_Select_Dim_Zone() WHERE code_zone = 'ZONE_T';
    
    -- Insert
    CALL IMM_Insert_Fact_Temperature(v_zone_id, '2023-06-01', 10.0, 20.0, 15.0, 5.0, 'Note');
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Temperature(v_zone_id, '2023-06-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Temperature'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Temperature(v_zone_id, '2023-06-01', 12.0, 22.0, 17.0, 5.0, 'Note Upd');
    PERFORM * FROM IMM_Select_Fact_Temperature(v_zone_id, '2023-06-01') WHERE temp_min = 12.0;
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Temperature'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Temperature(v_zone_id, '2023-06-01');
    PERFORM * FROM IMM_Select_Fact_Temperature(v_zone_id, '2023-06-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Temperature'; END IF;
    
    RAISE NOTICE 'Fact_Temperature Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Humidite
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_zone_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Humidite...';
    
    SELECT id_interne INTO v_zone_id FROM IMM_Select_Dim_Zone() WHERE code_zone = 'ZONE_T';
    
    -- Insert
    CALL IMM_Insert_Fact_Humidite(v_zone_id, '2023-06-01', 50.0, 80.0, 65.0, 10.0, 'Note');
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Humidite(v_zone_id, '2023-06-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Humidite'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Humidite(v_zone_id, '2023-06-01', 55.0, 85.0, 70.0, 10.0, 'Note Upd');
    PERFORM * FROM IMM_Select_Fact_Humidite(v_zone_id, '2023-06-01') WHERE hum_min = 55.0;
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Humidite'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Humidite(v_zone_id, '2023-06-01');
    PERFORM * FROM IMM_Select_Fact_Humidite(v_zone_id, '2023-06-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Humidite'; END IF;
    
    RAISE NOTICE 'Fact_Humidite Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Vents
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_zone_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Vents...';
    
    SELECT id_interne INTO v_zone_id FROM IMM_Select_Dim_Zone() WHERE code_zone = 'ZONE_T';
    
    -- Insert
    CALL IMM_Insert_Fact_Vents(v_zone_id, '2023-06-01', 10.0, 30.0, 20.0, 5.0, 'Note');
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Vents(v_zone_id, '2023-06-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Vents'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Vents(v_zone_id, '2023-06-01', 15.0, 35.0, 25.0, 5.0, 'Note Upd');
    PERFORM * FROM IMM_Select_Fact_Vents(v_zone_id, '2023-06-01') WHERE vent_min = 15.0;
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Vents'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Vents(v_zone_id, '2023-06-01');
    PERFORM * FROM IMM_Select_Fact_Vents(v_zone_id, '2023-06-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Vents'; END IF;
    
    RAISE NOTICE 'Fact_Vents Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Pression
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_zone_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Pression...';
    
    SELECT id_interne INTO v_zone_id FROM IMM_Select_Dim_Zone() WHERE code_zone = 'ZONE_T';
    
    -- Insert
    CALL IMM_Insert_Fact_Pression(v_zone_id, '2023-06-01', 1000.0, 1020.0, 1010.0, 5.0, 'Note');
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Pression(v_zone_id, '2023-06-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Pression'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Pression(v_zone_id, '2023-06-01', 1005.0, 1025.0, 1015.0, 5.0, 'Note Upd');
    PERFORM * FROM IMM_Select_Fact_Pression(v_zone_id, '2023-06-01') WHERE pres_min = 1005.0;
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Pression'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Pression(v_zone_id, '2023-06-01');
    PERFORM * FROM IMM_Select_Fact_Pression(v_zone_id, '2023-06-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Pression'; END IF;
    
    RAISE NOTICE 'Fact_Pression Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Precipitation
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_zone_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Precipitation...';
    
    SELECT id_interne INTO v_zone_id FROM IMM_Select_Dim_Zone() WHERE code_zone = 'ZONE_T';
    
    -- Insert
    CALL IMM_Insert_Fact_Precipitation(v_zone_id, '2023-06-01', 10.0, 'Rain', 'Note');
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Precipitation(v_zone_id, '2023-06-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Precipitation'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Precipitation(v_zone_id, '2023-06-01', 15.0, 'Rain', 'Note Upd');
    PERFORM * FROM IMM_Select_Fact_Precipitation(v_zone_id, '2023-06-01') WHERE prec_tot = 15.0;
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Precipitation'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Precipitation(v_zone_id, '2023-06-01');
    PERFORM * FROM IMM_Select_Fact_Precipitation(v_zone_id, '2023-06-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Precipitation'; END IF;
    
    RAISE NOTICE 'Fact_Precipitation Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Dimension
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_plant_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Dimension...';
    
    -- Setup Plant
    CALL IMM_Insert_Dim_Plant('PARC_D', 'PLANT_D', '2023-06-01');
    SELECT id_interne INTO v_plant_id FROM IMM_Select_Dim_Plant() WHERE plant_id = 'PLANT_D';
    
    -- Insert
    CALL IMM_Insert_Fact_Dimension(v_plant_id, '2023-07-01', 10.0, 5.0, 50.0, 'Note');
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Dimension(v_plant_id, '2023-07-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Dimension'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Dimension(v_plant_id, '2023-07-01', 12.0, 6.0, 72.0, 'Note Upd');
    PERFORM * FROM IMM_Select_Fact_Dimension(v_plant_id, '2023-07-01') WHERE longueur = 12.0;
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Dimension'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Dimension(v_plant_id, '2023-07-01');
    PERFORM * FROM IMM_Select_Fact_Dimension(v_plant_id, '2023-07-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Dimension'; END IF;
    
    RAISE NOTICE 'Fact_Dimension Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Etat
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_plant_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Etat...';
    
    SELECT id_interne INTO v_plant_id FROM IMM_Select_Dim_Plant() WHERE plant_id = 'PLANT_D';
    
    -- Insert
    CALL IMM_Insert_Fact_Etat(v_plant_id, '2023-07-01', 'Good', 'Note');
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Etat(v_plant_id, '2023-07-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Etat'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Etat(v_plant_id, '2023-07-01', 'Bad', 'Note Upd');
    PERFORM * FROM IMM_Select_Fact_Etat(v_plant_id, '2023-07-01') WHERE etat = 'Bad';
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Etat'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Etat(v_plant_id, '2023-07-01');
    PERFORM * FROM IMM_Select_Fact_Etat(v_plant_id, '2023-07-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Etat'; END IF;
    
    RAISE NOTICE 'Fact_Etat Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Floraison
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_plant_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Floraison...';
    
    SELECT id_interne INTO v_plant_id FROM IMM_Select_Dim_Plant() WHERE plant_id = 'PLANT_D';
    
    -- Insert
    CALL IMM_Insert_Fact_Floraison(v_plant_id, '2023-07-01', 'Note');
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Floraison(v_plant_id, '2023-07-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Floraison'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Floraison(v_plant_id, '2023-07-01', 'Note Upd');
    PERFORM * FROM IMM_Select_Fact_Floraison(v_plant_id, '2023-07-01') WHERE note = 'Note Upd';
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Floraison'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Floraison(v_plant_id, '2023-07-01');
    PERFORM * FROM IMM_Select_Fact_Floraison(v_plant_id, '2023-07-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Floraison'; END IF;
    
    RAISE NOTICE 'Fact_Floraison Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Note
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_plant_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Note...';
    
    SELECT id_interne INTO v_plant_id FROM IMM_Select_Dim_Plant() WHERE plant_id = 'PLANT_D';
    
    -- Insert
    CALL IMM_Insert_Fact_Note(v_plant_id, '2023-07-01', 'Note');
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Note(v_plant_id, '2023-07-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Note'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Note(v_plant_id, '2023-07-01', 'Note Upd');
    PERFORM * FROM IMM_Select_Fact_Note(v_plant_id, '2023-07-01') WHERE note = 'Note Upd';
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Note'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Note(v_plant_id, '2023-07-01');
    PERFORM * FROM IMM_Select_Fact_Note(v_plant_id, '2023-07-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Note'; END IF;
    
    RAISE NOTICE 'Fact_Note Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Couverture
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_placette_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Couverture...';
    
    -- Setup Placette
    CALL IMM_Insert_Dim_Placette('PLAC_C', 'ZONE_C', '2023-06-01');
    SELECT id_interne INTO v_placette_id FROM IMM_Select_Dim_Placette() WHERE placette_id = 'PLAC_C';
    
    -- Insert
    CALL IMM_Insert_Fact_Couverture(v_placette_id, '2023-07-01', 'Type A', 0.5, 0.1);
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Couverture(v_placette_id, '2023-07-01', 'Type A');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Couverture'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Couverture(v_placette_id, '2023-07-01', 'Type A', 0.6, 0.2);
    PERFORM * FROM IMM_Select_Fact_Couverture(v_placette_id, '2023-07-01', 'Type A') WHERE taux = 0.6;
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Couverture'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Couverture(v_placette_id, '2023-07-01', 'Type A');
    PERFORM * FROM IMM_Select_Fact_Couverture(v_placette_id, '2023-07-01', 'Type A');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Couverture'; END IF;
    
    RAISE NOTICE 'Fact_Couverture Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Obstruction
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_placette_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Obstruction...';
    
    SELECT id_interne INTO v_placette_id FROM IMM_Select_Dim_Placette() WHERE placette_id = 'PLAC_C';
    
    -- Insert
    CALL IMM_Insert_Fact_Obstruction(v_placette_id, '2023-07-01', 'Type O', 10.0, 0.5, 0.1);
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Obstruction(v_placette_id, '2023-07-01', 'Type O', 10.0);
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Obstruction'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Obstruction(v_placette_id, '2023-07-01', 'Type O', 10.0, 0.6, 0.2);
    PERFORM * FROM IMM_Select_Fact_Obstruction(v_placette_id, '2023-07-01', 'Type O', 10.0) WHERE taux = 0.6;
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Obstruction'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Obstruction(v_placette_id, '2023-07-01', 'Type O', 10.0);
    PERFORM * FROM IMM_Select_Fact_Obstruction(v_placette_id, '2023-07-01', 'Type O', 10.0);
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Obstruction'; END IF;
    
    RAISE NOTICE 'Fact_Obstruction Tests réussis!';
END;
$$;

-- -----------------------------------------------------------------------------
-- Test Fact_Arbre
-- -----------------------------------------------------------------------------
DO $$
DECLARE
    v_placette_id INTEGER;
    v_arbre_id INTEGER;
BEGIN
    RAISE NOTICE 'Test pour la table Fact_Arbre...';
    
    SELECT id_interne INTO v_placette_id FROM IMM_Select_Dim_Placette() WHERE placette_id = 'PLAC_C';
    CALL IMM_Insert_Dim_Arbre('Arbre_F', 'Desc');
    SELECT id_interne INTO v_arbre_id FROM IMM_Select_Dim_Arbre() WHERE nom_arbre = 'Arbre_F';
    
    -- Insert
    CALL IMM_Insert_Fact_Arbre(v_placette_id, v_arbre_id, '2023-07-01', 1);
    
    -- Select
    PERFORM * FROM IMM_Select_Fact_Arbre(v_placette_id, v_arbre_id, '2023-07-01');
    IF NOT FOUND THEN RAISE EXCEPTION 'Insertion ratée pour Fact_Arbre'; END IF;
    
    -- Update
    CALL IMM_Update_Fact_Arbre(v_placette_id, v_arbre_id, '2023-07-01', 2);
    PERFORM * FROM IMM_Select_Fact_Arbre(v_placette_id, v_arbre_id, '2023-07-01') WHERE rang = 2;
    IF NOT FOUND THEN RAISE EXCEPTION 'Modification ratée pour Fact_Arbre'; END IF;
    
    -- Delete
    CALL IMM_Delete_Fact_Arbre(v_placette_id, v_arbre_id, '2023-07-01');
    PERFORM * FROM IMM_Select_Fact_Arbre(v_placette_id, v_arbre_id, '2023-07-01');
    IF FOUND THEN RAISE EXCEPTION 'Suppression ratée pour Fact_Arbre'; END IF;
    
    RAISE NOTICE 'Fact_Arbre Tests réussis!';
END;
$$;
