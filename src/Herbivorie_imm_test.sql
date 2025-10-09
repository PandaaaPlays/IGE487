BEGIN;

SET client_min_messages TO NOTICE;

DO $$
BEGIN
    RAISE NOTICE 'Début des tests...';
END;
$$;

-- 
-- PEUPLEMENT
-- 
CALL imm_insert_update_peuplement('ERAB', 'Érablière à bouleau');
SELECT * FROM imm_get_peuplement('ERAB');

CALL imm_insert_update_peuplement('PESH', 'Pessière à hêtre');
SELECT * FROM imm_get_peuplement('PESH');

-- 
-- PLACETTE
-- 
CALL imm_insert_update_placette('A1', 'ERAB', '2025-01-01');
SELECT * FROM imm_get_placette('A1');

CALL imm_insert_update_placette('B2', 'PESH', '2025-06-01');
SELECT * FROM imm_get_placette('B2');

-- 
-- ARBRE
-- 
CALL imm_insert_update_arbre('ARBRE1', 'Chêne pédonculé');
CALL imm_insert_update_arbre('ARBRE2', 'Pin sylvestre');
SELECT * FROM imm_get_arbre('ARBRE1');
SELECT * FROM imm_get_arbre('ARBRE2');

-- 
-- PLACETTE_ARBRE
-- 
CALL imm_insert_update_placette_arbre('A1', 1, 'ARBRE1');
CALL imm_insert_update_placette_arbre('A1', 2, 'ARBRE2');
SELECT * FROM imm_get_placette_arbre('A1');

-- 
-- PLACETTE_COUVERTURE
-- 
CALL imm_insert_update_placette_couverture('A1', 'Graminees', 40);
CALL imm_insert_update_placette_couverture('A1', 'Fougeres', 20);
SELECT * FROM imm_get_placette_couverture('A1');

-- 
-- PLACETTE_OBSTRUCTION
-- 
CALL imm_insert_update_placette_obstruction('A1', 1, 'Canopée', 80);
CALL imm_insert_update_placette_obstruction('A1', 2, 'Sous-bois', 60);
SELECT * FROM imm_get_placette_obstruction('A1');

-- 
-- ETAT
-- 
CALL imm_insert_update_etat('O', 'Arbre vivant');
CALL imm_insert_update_etat('C', 'Arbre cassé');
SELECT * FROM imm_get_etat('O');

-- 
-- PLANT
-- 
CALL imm_insert_update_plant('MMA1040', 'A1', 4, '2025-01-02');
SELECT * FROM imm_get_plant('MMA1040');

CALL imm_insert_update_plant('MMA7060', 'A1', 5, '2025-01-02');
SELECT * FROM imm_get_plant('MMA7060');

-- 
-- OBSERVATION ÉTAT
-- 
CALL imm_insert_update_obsetat('MMA1040', 'O', '2025-02-01', 'Bon état général');
CALL imm_insert_update_obsetat('MMA7060', 'C', '2025-03-01', 'Cassé naturellement');
SELECT * FROM imm_get_obsetat('MMA1040');

CALL imm_update_obsetat('MMA1040', '2025-03-01', 'C');
SELECT * FROM imm_get_obsetat('MMA1040');

-- 
-- DIMENSIONS
-- 
CALL imm_insert_update_obsdimension('MMA1040', 120, 30, '2025-02-01', 'Croissance normale');
CALL imm_insert_update_obsdimension('MMA7060', 125, 33, '2025-03-01', 'Légère augmentation');
SELECT * FROM imm_get_obsdimension('MMA1040', '2025-03-01');

-- 
-- OBSFLORAISON
-- 
CALL imm_insert_update_obsfloraison('MMA1040', '2025-03-15', 'Floraison observée');
SELECT * FROM imm_get_obsfloraison('MMA1040');

-- 
-- PLANT NOTE
-- 
CALL imm_insert_plant_note('MMA1040', '2025-03-01', 'Observation 1');
CALL imm_insert_plant_note('MMA7060', '2025-04-01', 'Observation 2');
SELECT * FROM imm_get_plant_note('MMA1040');

-- 
-- SUPPRESSION DES OBSERVATIONS
-- 
CALL imm_delete_all_observations('MMA1040');
SELECT * FROM ObsEtat WHERE id = 'MMA1040';
SELECT * FROM ObsDimension WHERE id = 'MMA1040';
SELECT * FROM ObsFloraison WHERE id = 'MMA1040';
SELECT * FROM Plant_Note WHERE id_plant = 'MMA1040';

-- 
-- SUPRESSION DES ENREGISTREMENTS
-- 
CALL imm_delete_placette_couverture('A1', 'Graminees');
CALL imm_delete_placette_obstruction('A1', 1, 'Canopée');
CALL imm_delete_placette_arbre('A1', 2);
CALL imm_delete_plant('MMA1040');
CALL imm_delete_arbre('ARBRE2');
CALL imm_full_delete_etat('C');
CALL imm_full_delete_peuplement('ERAB');
SELECT 'Suppressions OK' AS info;

-- 
-- SUPRESSION PLACETTE ENTIERE
-- 
CALL imm_delete_full_placette('A1');

SELECT * FROM Placette WHERE plac = 'A1';
SELECT * FROM Plant WHERE placette = 'A1';
SELECT * FROM Placette_Arbre WHERE placette = 'A1';
SELECT * FROM Placette_Couverture WHERE placette = 'A1';
SELECT * FROM Placette_Obstruction WHERE placette = 'A1';

DO $$
BEGIN
    RAISE NOTICE 'Tests completés!';
END;
$$;

ROLLBACK;
