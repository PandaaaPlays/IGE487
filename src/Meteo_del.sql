/*
////
-- =========================================================================== A
-- Meteo_del.sql
-- ---------------------------------------------------------------------------
Activité : IGE487_2025-1
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 9.4 à 17
Responsable : luc.lavoie@usherbrooke.ca
Version : 0.1.1a
Statut : base de développement
Résumé : Suppression des tables d’observations météorologiques..
-- =========================================================================== A
*/

--
-- Spécification du schéma
--
SET SCHEMA 'Herbivorie' ;

DROP TABLE ObsTemperature;
DROP TABLE ObsHumidite;
DROP TABLE ObsPression;
DROP TABLE ObsVents;
DROP TABLE TypePrecipitations;
DROP TABLE ObsPrecipitations;
DROP TABLE CarnetMeteo;

DROP DOMAIN Temperature;
DROP DOMAIN Humidite;
DROP DOMAIN Vitesse;
DROP DOMAIN Pression;
DROP DOMAIN HNP;
DROP DOMAIN Code_P;

/*
-- =========================================================================== Z
////
.Contributeurs
* (LL01) luc.lavoie@usherbrooke.ca

.Tâches projetées
* 2022-02-10 LL01. Généraliser.
  - Introduire les concepts d’unité de mesure, de type de mesure, etc.
  - Introduire un mécanisme paramétrable de vérification générale des mesures.
  - Rendre le tout évolutif.
* 2022-01-23 LL01. Compléter le schéma.
  - Mieux documenter conjointement Herbivorie et Meteo.
  - Affiner le mécanisme d’ELT.
  - Développer des jeux de données.

.Tâches réalisées
* 2022-01-17 LL01. Création.
  - Création du schéma de base.
  - Validation minimale du carnet d’observations (voir test0).
  - Importation des observations intègres (voir ini).

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
  [CC-BY-NC-4.0 (http://creativecommons.org/licenses/by-nc/4.0)]

-- -----------------------------------------------------------------------------
-- fin de {CoFELI}/Exemple/Herbivorie/src/Meteo_del.sql
-- =========================================================================== Z
*/