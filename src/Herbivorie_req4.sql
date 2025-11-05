/*
////
-- =========================================================================== A
-- Herbivorie_req4.sql
-- ---------------------------------------------------------------------------
Activité : IFT187_2025-1
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 9.4 à 17
Responsable : luc.lavoie@usherbrooke.ca
Version : 0.2.0a
Statut : Solutionnaire préliminaire
Résumé : Mise en oeuvre d’une vue unifiée des données météorologiques.
-- =========================================================================== A
*/

/*
////

-- =========================================================================== B
Mise en oeuvre des demandes de modifications Y3, Y4, Y5
(vue unifiée des données météorologiques).

.Notes de mise en oeuvre
a.  aucune.

////
-- =========================================================================== B
*/

--
-- Spécification du schéma
--
SET SCHEMA 'Herbivorie' ;

--
-- Y3.
-- Définir une vue donnant les conditions météorologiques complètes hors précipitation.
-- Maintenir les mêmes identifiants d’attributs qu’en Y1 (voir Meteo_cre.sql).
-- Clarification :
--   Que signifie complète ?
--   Que faire si, pour une date donnée, certaines mesures sont absentes ?
--   Toutes les mesures doivent être présentes pour qu'un tuple soit retenu.
--
CREATE VIEW Meteo_HP
(
  date      ,   -- date de la prise de donnée
  temp_min  ,   -- la température minimale,
  temp_max  ,   -- la température maximale,
  note      ,   -- note supplémentaire à propos des conditions du jour
  hum_min   ,   -- le taux d’humidité absolue minimal (en pourcentage),
  hum_max   ,   -- le taux d’humidité absolue maximal (en pourcentage),
  vent_min  ,   -- la vitesse minimale des vents (en km/h),
  vent_max  ,   -- la vitesse maximale des vents (en km/h),
  pres_min  ,   -- la pression atmosphérique minimale (en hPa),
  pres_max      -- la pression atmosphérique maximale (en hPa),
) AS
  SELECT *
    FROM ObsTemperature
      NATURAL JOIN ObsHumidite
      NATURAL JOIN ObsVents
      NATURAL JOIN ObsPression
;

--
-- Y4.
-- Retirer les données météorologiques pour une période donnée.
--
CREATE OR REPLACE PROCEDURE Supprimer_Temperature_Anormale(
    d_debut DATE,
    d_fin DATE,
    seuil_temp SMALLINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM ObsTemperature
    WHERE date BETWEEN d_debut AND d_fin
      AND temp_min < seuil_temp;
END;
$$;

--
-- Y5.
-- Augmenter les températures rapportées d'un pourcentage pour une periode donnée.
--
CREATE OR REPLACE PROCEDURE Modifier_Temperature_Periode(
    d_debut DATE,
    d_fin DATE,
    pourcentage SMALLINT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE ObsTemperature
    SET temp_min = temp_min + (pourcentage / 100) * abs(temp_min), temp_max = temp_max + (pourcentage / 100) * abs(temp_max)
    WHERE (date BETWEEN d_debut AND d_fin);
END;
$$;

/*
-- =========================================================================== Z
////
.Contributeurs :
* (CK01) christina.khnaisser@usherbrooke.ca
* (LL01) luc.lavoie@usherbrooke.ca

.Tâches projetées
* ...

.Tâches réalisées
* 2025-02-05 LL01. Revue sommaire
  - Coquilles et ponctuation.
* 2017-09-24 LL01. Création
  - Version initiale.

.Références
* [EPP] {CoFELI}/Exemple/Herbivorie/pub/Herbivorie_EPP.pdf
* [SML] {CoFELI}/Exemple/Herbivorie/pub/Herbivorie_SML.pdf
////

.Adresse, droits d'auteur et copyright :
  Groupe Metis
  Département d'informatique
  Faculté des sciences
  Université de Sherbrooke
  Sherbrooke (Québec)  J1K 2R1
  Canada
  http://info.usherbrooke.ca/llavoie/
  [CC-BY-NC-4.0 (http://creativecommons.org/licenses/by-nc/4.0)]

-- -----------------------------------------------------------------------------
-- fin de {CoFELI}/Exemple/Herbivorie/src/Herbivorie_req4.sql
-- =========================================================================== Z
*/
