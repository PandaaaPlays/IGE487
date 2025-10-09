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

-- Supression d'une placette complete.
CREATE OR REPLACE PROCEDURE imm_delete_full_placette(p_plac Placette_id)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Placette_Arbre WHERE placette = p_plac;
    DELETE FROM Placette_Couverture WHERE placette = p_plac;
    DELETE FROM Placette_Obstruction WHERE placette = p_plac;
    DELETE FROM Plant WHERE placette = p_plac;
    DELETE FROM Placette WHERE plac = p_plac;
END;
$$;