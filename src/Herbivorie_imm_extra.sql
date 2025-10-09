/*
////
-- =========================================================================== A
-- Herbivorie_imm_extra.sql
-- ---------------------------------------------------------------------------
Activité : IGE487_2025-3
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 9.4 à 17
Responsable : luc.lavoie@usherbrooke.ca
Version : 1.0.0
Statut : Liste de base des IMM de herbivorie.
Résumé : Ajout des IMM supplémentaires (spéciaux) pour la gestion des tables herbivorie.
-- =========================================================================== A
*/

-- Suppression de toutes les observations d'une plante.
CREATE OR REPLACE PROCEDURE imm_delete_all_observations(p_id Plant_id)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsEtat WHERE id = p_id;
    DELETE FROM ObsDimension WHERE id = p_id;
    DELETE FROM ObsFloraison WHERE id = p_id;
    DELETE FROM Plant_Note WHERE id_plant = p_id;
END;
$$;

/*
-- =========================================================================== Z
////
.Contributeurs
* Équipe du projet (Étienne, Imène, Mathieu et Mikael)

.Tâches réalisées
* 2025-10-08.
  - Création des IMM supplémentaires pour herbivorie.

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
-- fin de {CoFELI}/src/Herbivorie_imm_extra.sql
-- =========================================================================== Z
*/