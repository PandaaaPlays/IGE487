/*
////
-- =========================================================================== A
-- Meteo_imm_test.sql
-- ---------------------------------------------------------------------------
Activité : IGE487_2025-3
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 9.4 à 17
Responsable : luc.lavoie@usherbrooke.ca
Version : 1.0.0
Statut : Tests de base complets et fonctionnels.
Résumé : Ajout de tests pour les différents IMM de météo.
-- =========================================================================== A
*/

BEGIN;

SET client_min_messages TO NOTICE;

DO $$
BEGIN
    RAISE NOTICE 'Début des tests Meteo...';
END;
$$;

-- 
-- TYPE PRECIPITATIONS
-- 
CALL imm_insert_update_typeprecipitations('G', 'Grêle');
CALL imm_insert_update_typeprecipitations('N', 'Neige');
CALL imm_insert_update_typeprecipitations('P', 'Pluie');

SELECT * FROM imm_get_typeprecipitations('G');
SELECT * FROM imm_get_typeprecipitations('N');
SELECT * FROM imm_get_typeprecipitations('P');

-- 
-- OBS TEMPERATURE
-- 
CALL imm_insert_update_obstemperature('2025-06-01', 12::temperature, 25::temperature, 'Temps ensoleillé');
SELECT * FROM imm_get_obstemperature('2025-06-01');

CALL imm_insert_update_obstemperature('2025-06-02', 10::temperature, 22::temperature, 'Nuageux');
SELECT * FROM imm_get_obstemperature('2025-06-02');

-- 
-- OBS HUMIDITE
-- 
CALL imm_insert_update_obshumidite('2025-06-01', 40::humidite, 60::humidite);
SELECT * FROM imm_get_obshumidite('2025-06-01');

CALL imm_insert_update_obshumidite('2025-06-02', 50::humidite, 70::humidite);
SELECT * FROM imm_get_obshumidite('2025-06-02');

-- 
-- OBS VENTS
-- 
CALL imm_insert_update_obsvents('2025-06-01', 5::vitesse, 20::vitesse);
SELECT * FROM imm_get_obsvents('2025-06-01');

CALL imm_insert_update_obsvents('2025-06-02', 10::vitesse, 25::vitesse);
SELECT * FROM imm_get_obsvents('2025-06-02');

-- 
-- OBS PRESSION
-- 
CALL imm_insert_update_obspression('2025-06-01', 1010::pression, 1020::pression);
SELECT * FROM imm_get_obspression('2025-06-01');

CALL imm_insert_update_obspression('2025-06-02', 1005::pression, 1015::pression);
SELECT * FROM imm_get_obspression('2025-06-02');

-- 
-- OBS PRECIPITATIONS
-- 
CALL imm_insert_update_obsprecipitations('2025-06-01', 5::hnp, 'P');
SELECT * FROM imm_get_obsprecipitations('2025-06-01');

CALL imm_insert_update_obsprecipitations('2025-06-02', 0::hnp, 'N');
SELECT * FROM imm_get_obsprecipitations('2025-06-02');

-- 
-- CARNET METEO
-- 
CALL imm_insert_carnetmeteo(
    '12', '25', '40', '60', '5', 'P', '5', '20', '1010', '1020', '2025-06-01', 'Note journée 1'
);
CALL imm_insert_carnetmeteo(
    '10', '22', '50', '70', '0', 'N', '10', '25', '1005', '1015', '2025-06-02', 'Note journée 2'
);

SELECT * FROM imm_get_carnetmeteo('2025-06-01');
SELECT * FROM imm_get_carnetmeteo('2025-06-02');

-- 
-- UPDATE TESTS
-- 
CALL imm_insert_update_obstemperature('2025-06-01', 13::temperature, 26::temperature, 'Température modifiée');
SELECT * FROM imm_get_obstemperature('2025-06-01');

CALL imm_insert_update_obsprecipitations('2025-06-01', 10::hnp, 'P');
SELECT * FROM imm_get_obsprecipitations('2025-06-01');

-- 
-- DELETE TESTS
-- 
CALL imm_delete_obstemperature('2025-06-02');
SELECT * FROM ObsTemperature WHERE date = '2025-06-02';

CALL imm_delete_obshumidite('2025-06-02');
SELECT * FROM ObsHumidite WHERE date = '2025-06-02';

CALL imm_delete_obsprecipitations('2025-06-02', 'N');
SELECT * FROM ObsPrecipitations WHERE date = '2025-06-02';

CALL imm_delete_carnetmeteo('2025-06-02');
SELECT * FROM CarnetMeteo WHERE date = '2025-06-02';

DO $$
BEGIN
    RAISE NOTICE 'Tests Meteo completés!';
END;
$$;

ROLLBACK;

/*
-- =========================================================================== Z
////
.Contributeurs
* Équipe du projet (Étienne, Imène, Mathieu et Mikael)

.Tâches réalisées
* 2025-10-08.
  - Création des test des IMM de météo.

.Adresse, droits d’auteur et copyright
  Groupe Metis
  Département d’informatique
  Faculté des sciences
  Université de Sherbrooke
  Sherbrooke (Québec)  J1K 2R1
  Canada
  http://info.usherbrooke.ca/llavoie/
  [CC-BY-NC-4.0 (http://creativecommons.org/licenses/by-nc/4.0)]

-- -----------------------------------------------------------------------------
-- fin de {CoFELI}/src/Meteo_imm_test.sql
-- =========================================================================== Z
*/