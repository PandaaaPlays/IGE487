/*
////
-- =========================================================================== A
-- Meteo_req4.sql
-- ---------------------------------------------------------------------------
Activité : IFT187_2022-1
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 9.4 à 17
Responsable : luc.lavoie@usherbrooke.ca
Version : 0.1.1a
Statut : en cours de développement
Résumé : Test minimaliste d’importation des carnets météorologiques.
-- =========================================================================== A
*/

/*
-- =========================================================================== B
////

Test minimaliste d’importation des carnets météorologiques dans la base de données.

////
-- =========================================================================== B
*/

--
-- Spécification du schéma
--
SET SCHEMA 'Herbivorie' ;

-- Vider les tables du contenu des précédents essais
delete from ObsTemperature ;
delete from ObsHumidite ;
delete from ObsPrecipitations ;
delete from ObsVents ;
delete from ObsPression ;
delete from CarnetMeteo ;

-- Ajouter les données au carnet météorologique (remarquons la conversion implicite des données numériques!!!)
insert into CarnetMeteo (temp_min, temp_max, hum_min, hum_max, prec_tot, prec_nat, vent_min, vent_max, pres_min, pres_max, date, note)
VALUES
    -- Données initiales
    (10, 14, 18, 24, 0, 'P', 4, 20, 1028, 1030, '2016-05-04', 'Départ'),
    (10, 14, 18, 24, null, null, 4, 20, 1028, 1030, '2016-05-05', 'Comme hier'),
    (10, 14, 18, 24, null, null, 4, 20, 1028, 1030, '2015-05-05', 'Refus date'),
    (10, 65, -2, 24, 10, 'K', 4, 2000, 1028, 2000, '2016-07-05', 'Refus température max'),
    (12, 15, 24, 30, 1, 'P', 8, 10, 1026, 1028, '2016-05-06', 'Fin'),

    -- 2016
    (12, 23, 50, 85, 1, 'P', 5, 30, 1014, 1020, '2016-06-05', 'Pluie faible'),
    (NULL, 26, 40, NULL, NULL, NULL, 8, 25, 1016, 1023, '2016-06-15', 'Température min manquant'),
    (17, NULL, 35, 65, 3, 'G', NULL, 60, 1008, 1015, '2016-06-28', 'Vent manquant'),

    -- 2017
    (19, 32, 25, 55, 0, NULL, 10, 35, 1009, 1017, '2017-06-10', 'Temps sec et chaud'),
    (21, 35, NULL, 45, NULL, NULL, 12, NULL, 1007, 1013, '2017-06-21', 'Canicule, humidité et vent max manquants'),
    (NULL, NULL, 30, 60, 5, 'P', NULL, NULL, NULL, NULL, '2017-06-27', 'Capteurs non fonctionnels'),

    -- 2018
    (13, 22, 60, 95, 15, 'P', 6, 25, 1005, 1010, '2018-06-04', 'Pluies continues'),
    (15, 24, NULL, 90, 12, 'P', 8, 28, 1007, 1013, '2018-06-12', 'Humidité minimale manquante'),
    (16, 25, 50, 88, NULL, 'G', 10, 55, NULL, 1011, '2018-06-20', 'Précipitations manquantes, pres_min manquant'),

    -- 2019
    (17, 28, 45, NULL, 8, 'P', 7, 40, 1009, 1016, '2019-06-07', 'Humidité max manquante'),
    (20, 33, 28, 65, 0, NULL, 10, 42, 1008, NULL, '2019-06-18', 'Pression max manquante'),
    (18, 29, 35, 80, 10, 'P', 15, 65, 1003, 1010, '2019-06-26', 'Forte pluie'),

    -- 2020
    (NULL, 20, 65, 95, 20, 'P', 5, NULL, 1006, 1012, '2020-06-02', 'Temp min manquante, vent max manquant'),
    (13, 22, 55, 90, NULL, 'P', NULL, 30, 1009, 1016, '2020-06-14', 'Précipitations manquantes'),
    (15, 24, 50, 78, 3, 'P', 12, 50, 1005, 1012, NULL, 'Date manquante (invalide dans toutes les observations)'),

    -- 2021
    (20, 33, 25, 55, 0, NULL, 10, 38, 1008, 1013, '2021-06-06', 'Chaud et sec, nature précip. manquantes'),
    (22, 36, 18, 48, NULL, NULL, 15, 45, 1005, 1011, '2021-06-18', 'Précipitations manquant'),
    (21, 34, 20, 50, NULL, 'P', NULL, 42, 1007, 1012, '2021-06-28', 'Vent min manquant'),

    -- 2022
    (16, 27, 40, 78, 5, 'P', 8, 28, NULL, 1020, '2022-06-08', 'Pression min manquante'),
    (NULL, 30, 35, 70, 0, NULL, 9, 33, 1010, 1016, '2022-06-17', 'Temp min manquante, nature précip. manquantes'),
    (19, 32, 28, 65, 4, 'P', 10, NULL, 1006, 1012, '2022-06-25', 'Vent max manquant'),

    -- 2023
    (14, 24, 55, 92, 10, 'P', 6, 28, 1008, 1015, '2023-06-03', 'Temps humide'),
    (17, 28, 40, 80, 12, 'P', NULL, 60, 1004, 1011, '2023-06-13', 'Vent min manquant'),
    (NULL, 29, 38, 75, 5, 'P', 10, 35, 1009, 1016, '2023-06-22', 'Temp min manquante'),

    -- 2024
    (23, 36, NULL, 50, 0, NULL, 14, 40, 1006, NULL, '2024-06-05', 'Hum. min manquante, pres.max manquante'),
    (24, 39, 15, 45, NULL, NULL, 18, 55, 1002, 1009, '2024-06-20', 'Précipitations manquantes'),
    (22, NULL, 25, 55, 2, 'P', 12, 42, 1008, 1013, '2024-06-29', 'Temp max manquante'),

    -- 2025
    (15, 26, 45, 80, 6, 'P', NULL, 28, 1012, 1018, '2025-06-07', 'Vent min manquant'),
    (17, NULL, 40, NULL, 0, NULL, 8, 30, 1015, 1021, '2025-06-15', 'Temp max et hum. max manquants'),
    (18, 30, 38, 70, NULL, 'P', 10, 48, 1009, NULL, '2025-06-26', 'Pression max manquante, précipitations manquantes')
;

-- Faire l’importation
call Meteo_ELT () ;

-- Fin

/*
-- =========================================================================== Z
////
.Contributeurs
* (LL01) luc.lavoie@usherbrooke.ca

.Tâches projetées
* 2022-01-23 LL01. Enrichier

.Tâches réalisées
* 2022-01-23 LL01. Création.

.Références
* {CoFELI}/Exemple/Herbivorie/pub/Herbivorie_EPP.pdf
////

.Adresse, droits d’auteur et copyright
  Groupe Metis
  Département d’informatique
  Faculté des sciences
  Université de Sherbrooke
  Sherbrooke (Québec)  J1K 2R1
  Canada
  http://info.usherbrooke.ca/llavoie/
  [CC-BY-NC-4 (http://creativecommons.org/licenses/by-nc/4)]

-- -----------------------------------------------------------------------------
-- fin de {CoFELI}/Exemple/Herbivorie/src/Meteo_req4.sql
-- =========================================================================== Z
*/
