----------------------------------------
--              PLACETTE              --
----------------------------------------
-- Procédure pour insérer ou mettre à jour une placette
CREATE OR REPLACE FUNCTION imm_insert_edit_placette(
    p_plac Placette_id,
    p_peuplement Peuplement_id,
    p_date Date_eco
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Placette (plac, peuplement, date)
    VALUES (p_plac, p_peuplement, p_date)
    ON CONFLICT (plac) DO UPDATE
    SET peuplement = EXCLUDED.peuplement,
        date = EXCLUDED.date;
END;
$$ LANGUAGE plpgsql;

-- Lire une placette et ses informations
CREATE OR REPLACE FUNCTION imm_get_placette(p_plac Placette_id)
RETURNS TABLE(
    plac Placette_id,
    peuplement Peuplement_id,
    date Date_eco
) AS $$
BEGIN
    RETURN QUERY
    SELECT plac, peuplement, date
    FROM Placette
    WHERE plac = p_plac;
END;
$$ LANGUAGE plpgsql;

-- Procédure pour supprimer une placette.
CREATE OR REPLACE FUNCTION imm_delete_placette(p_plac Placette_id)
    RETURNS VOID AS $$
BEGIN
    DELETE FROM Placette
    WHERE plac = p_plac;
END;
$$ LANGUAGE plpgsql;

-------------------------------------
--              PLANT              --
-------------------------------------
-- Procédure pour insérer ou mettre à jour un plant
CREATE OR REPLACE FUNCTION imm_insert_edit_plant(
    p_id Plant_id,
    p_placette Placette_id,
    p_parcelle Parcelle,
    p_date Date_eco
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Plant (id, placette, parcelle, date)
    VALUES (p_id, p_placette, p_parcelle, p_date)
    ON CONFLICT (id) DO UPDATE
    SET placette = EXCLUDED.placette,
        parcelle = EXCLUDED.parcelle,
        date = EXCLUDED.date;
END;
$$ LANGUAGE plpgsql;

-- Lire un plant
CREATE OR REPLACE FUNCTION imm_get_plant(p_id Plant_id)
RETURNS TABLE(
    id Plant_id,
    placette Placette_id,
    parcelle Parcelle,
    date Date_eco,
    note TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT id, placette, parcelle, date, note
    FROM Plant
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

-- Procédure pour supprimer un plant.
CREATE OR REPLACE FUNCTION imm_delete_plant(p_id INTEGER)
    RETURNS VOID AS $$
BEGIN
    DELETE FROM Plant
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------
--              Observation (état)              --
--------------------------------------------------
-- Procédure pour insérer ou mettre à jour l’état d’un plant
CREATE OR REPLACE FUNCTION imm_insert_edit_obsetat(
    p_id Plant_id,
    p_etat Etat_id,
    p_date Date_eco,
    p_note TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO ObsEtat (id, etat, date, note)
    VALUES (p_id, p_etat, p_date, p_note)
    ON CONFLICT (id, date) DO UPDATE
    SET etat = EXCLUDED.etat,
        note = EXCLUDED.note;
END;
$$ LANGUAGE plpgsql;

-- Mettre à jour l’état d’un plant à une date donnée
CREATE OR REPLACE FUNCTION imm_update_obsetat(
    p_id Plant_id,
    p_date Date_eco,
    p_etat Etat_id
) RETURNS VOID AS $$
BEGIN
    UPDATE ObsEtat
    SET etat = p_etat
    WHERE id = p_id AND date = p_date;
END;
$$ LANGUAGE plpgsql;

-- Procédure pour supprimer un observation d'état.
CREATE OR REPLACE FUNCTION imm_delete_obsetat(p_id INTEGER)
    RETURNS VOID AS $$
BEGIN
    DELETE FROM Plant
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

----------------------------------------
--              Dimensions            --
----------------------------------------
-- Procédure pour insérer ou mettre à jour les dimensions d'un plant.
CREATE OR REPLACE FUNCTION imm_insert_edit_obsdimension(
    p_id Plant_id,
    p_longueur Dim_mm,
    p_largeur Dim_mm,
    p_date Date_eco,
    p_note TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO ObsDimension (id, longueur, largeur, date, note)
    VALUES (p_id, p_longueur, p_largeur, p_date, p_note)
    ON CONFLICT (id, date) DO UPDATE
    SET longueur = EXCLUDED.longueur,
        largeur = EXCLUDED.largeur,
        note = EXCLUDED.note;
END;
$$ LANGUAGE plpgsql;

-- Lire une dimension.
CREATE OR REPLACE FUNCTION imm_get_plant(p_id Plant_id, p_date Date_eco)
RETURNS TABLE(
    id Plant_id,
    longueur Dim_mm,
    largeur Dim_mm,
    date Date_eco,
    note TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT id, longueur, largeur, date, note
    FROM obsdimension
    WHERE id = p_id AND date = p_date;
END;
$$ LANGUAGE plpgsql;

-- Procédure pour supprimer une dimension.
CREATE OR REPLACE FUNCTION imm_delete_dimension(p_id Plant_id, p_date Date_eco)
    RETURNS VOID AS $$
BEGIN
    DELETE FROM obsdimension
    WHERE id = p_id AND p_date = date;
END;
$$ LANGUAGE plpgsql;

















--------------------------------------------------
--              ARBRE                           --
--------------------------------------------------
-- Insertion ou mise à jour d’un arbre
CREATE OR REPLACE FUNCTION imm_insert_arbre(
    p_arbre Arbre_id,
    p_description Description
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Arbre (arbre, description)
    VALUES (p_arbre, p_description)
    ON CONFLICT (arbre) DO UPDATE
    SET description = EXCLUDED.description;
END;
$$ LANGUAGE plpgsql;

-- Lecture d’un arbre
CREATE OR REPLACE FUNCTION imm_get_arbre(p_arbre Arbre_id)
RETURNS TABLE(
    arbre Arbre_id,
    description Description
) AS $$
BEGIN
    RETURN QUERY SELECT arbre, description
    FROM Arbre
    WHERE arbre = p_arbre;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------
--              PEUPLEMENT                      --
--------------------------------------------------
-- Insertion ou mise à jour d’un peuplement
CREATE OR REPLACE FUNCTION imm_insert_peuplement(
    p_peuplement Peuplement_id,
    p_description Description
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Peuplement (peuplement, description)
    VALUES (p_peuplement, p_description)
    ON CONFLICT (peuplement) DO UPDATE
    SET description = EXCLUDED.description;
END;
$$ LANGUAGE plpgsql;

-- Lecture d’un peuplement
CREATE OR REPLACE FUNCTION imm_get_peuplement(p_peuplement Peuplement_id)
RETURNS TABLE(
    peuplement Peuplement_id,
    description Description
) AS $$
BEGIN
    RETURN QUERY SELECT peuplement, description
    FROM Peuplement
    WHERE peuplement = p_peuplement;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------
--              PLACETTE_ARBRE                  --
--------------------------------------------------
-- Insertion ou mise à jour d’un arbre associé à une placette
CREATE OR REPLACE FUNCTION imm_insert_placette_arbre(
    p_placette Placette_id,
    p_rang Rang,
    p_arbre Arbre_id
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Placette_Arbre (placette, rang, arbre)
    VALUES (p_placette, p_rang, p_arbre)
    ON CONFLICT (placette, rang) DO UPDATE
    SET arbre = EXCLUDED.arbre;
END;
$$ LANGUAGE plpgsql;

-- Lecture des arbres d’une placette
CREATE OR REPLACE FUNCTION imm_get_placette_arbre(p_placette Placette_id)
RETURNS TABLE(
    placette Placette_id,
    rang Rang,
    arbre Arbre_id
) AS $$
BEGIN
    RETURN QUERY
    SELECT placette, rang, arbre
    FROM Placette_Arbre
    WHERE placette = p_placette;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------
--              PLACETTE_COUVERTURE             --
--------------------------------------------------
-- Insertion ou mise à jour d’une couverture de placette
CREATE OR REPLACE FUNCTION imm_insert_placette_couverture(
    p_placette Placette_id,
    p_type Couverture,
    p_taux Taux
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Placette_Couverture (placette, type_couverture, taux)
    VALUES (p_placette, p_type, p_taux)
    ON CONFLICT (placette, type_couverture) DO UPDATE
    SET taux = EXCLUDED.taux;
END;
$$ LANGUAGE plpgsql;

-- Lecture des couvertures d’une placette
CREATE OR REPLACE FUNCTION imm_get_placette_couverture(p_placette Placette_id)
RETURNS TABLE(
    placette Placette_id,
    type_couverture Couverture,
    taux Taux
) AS $$
BEGIN
    RETURN QUERY
    SELECT placette, type_couverture, taux
    FROM Placette_Couverture
    WHERE placette = p_placette;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------
--              PLACETTE_OBSTRUCTION            --
--------------------------------------------------
-- Insertion ou mise à jour d’une obstruction latérale
CREATE OR REPLACE FUNCTION imm_insert_placette_obstruction(
    p_placette Placette_id,
    p_hauteur Hauteur,
    p_type TEXT,
    p_taux Taux
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Placette_Obstruction (placette, hauteur, type_obs, taux)
    VALUES (p_placette, p_hauteur, p_type, p_taux)
    ON CONFLICT (placette, hauteur, type_obs) DO UPDATE
    SET taux = EXCLUDED.taux;
END;
$$ LANGUAGE plpgsql;

-- Lecture des obstructions d’une placette
CREATE OR REPLACE FUNCTION imm_get_placette_obstruction(p_placette Placette_id)
RETURNS TABLE(
    placette Placette_id,
    hauteur Hauteur,
    type_obs TEXT,
    taux Taux
) AS $$
BEGIN
    RETURN QUERY
    SELECT placette, hauteur, type_obs, taux
    FROM Placette_Obstruction
    WHERE placette = p_placette;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------
--              ETAT                            --
--------------------------------------------------
-- Insertion ou mise à jour d’un état
CREATE OR REPLACE FUNCTION imm_insert_etat(
    p_etat Etat_id,
    p_description Description
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Etat (etat, description)
    VALUES (p_etat, p_description)
    ON CONFLICT (etat) DO UPDATE
    SET description = EXCLUDED.description;
END;
$$ LANGUAGE plpgsql;

-- Lecture d’un état
CREATE OR REPLACE FUNCTION imm_get_etat(p_etat Etat_id)
RETURNS TABLE(
    etat Etat_id,
    description Description
) AS $$
BEGIN
    RETURN QUERY SELECT etat, description
    FROM Etat
    WHERE etat = p_etat;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------
--              OBSFLORAISON                    --
--------------------------------------------------
-- Insertion ou mise à jour de la première floraison observée
CREATE OR REPLACE FUNCTION imm_insert_obsfloraison(
    p_id Plant_id,
    p_date Date_eco,
    p_note TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO ObsFloraison (id, date, note)
    VALUES (p_id, p_date, p_note)
    ON CONFLICT (id) DO UPDATE
    SET date = LEAST(ObsFloraison.date, EXCLUDED.date),
        note = EXCLUDED.note;
END;
$$ LANGUAGE plpgsql;

-- Lecture de la floraison d’un plant
CREATE OR REPLACE FUNCTION imm_get_obsfloraison(p_id Plant_id)
RETURNS TABLE(
    id Plant_id,
    date Date_eco,
    note TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT id, date, note
    FROM ObsFloraison
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------
--              PLANT_NOTE                      --
--------------------------------------------------
-- Insertion d’une note pour un plant
CREATE OR REPLACE FUNCTION imm_insert_plant_note(
    p_id_plant Plant_id,
    p_date Date_eco,
    p_note TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Plant_Note (id_plant, date, note)
    VALUES (p_id_plant, p_date, p_note);
END;
$$ LANGUAGE plpgsql;

-- Lecture des notes d’un plant
CREATE OR REPLACE FUNCTION imm_get_plant_note(p_id_plant Plant_id)
RETURNS TABLE(
    id SERIAL,
    id_plant Plant_id,
    date Date_eco,
    note TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT id, id_plant, date, note
    FROM Plant_Note
    WHERE id_plant = p_id_plant
    ORDER BY date;
END;
$$ LANGUAGE plpgsql;
