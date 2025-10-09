--
-- PLACETTE
--
CREATE OR REPLACE PROCEDURE imm_insert_update_placette(
    p_plac Placette_id,
    p_peuplement Peuplement_id,
    p_date Date_eco
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Placette (plac, peuplement, date)
    VALUES (p_plac, p_peuplement, p_date)
    ON CONFLICT (plac) DO UPDATE
    SET peuplement = EXCLUDED.peuplement,
        date = EXCLUDED.date;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_placette(p_plac Placette_id)
RETURNS TABLE(
    plac Placette_id,
    peuplement Peuplement_id,
    date Date_eco
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT p.plac, p.peuplement, p.date
    FROM Placette p
    WHERE p.plac = p_plac;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_full_delete_placette(p_plac Placette_id)
LANGUAGE plpgsql AS $$
DECLARE
    r_plant RECORD;
BEGIN
    FOR r_plant IN
        SELECT id FROM Plant WHERE placette = p_plac
    LOOP
        DELETE FROM Plant_Note WHERE id_plant = r_plant.id;
    END LOOP;

    DELETE FROM ObsEtat WHERE id IN (SELECT id FROM Plant WHERE placette = p_plac);
    DELETE FROM ObsDimension WHERE id IN (SELECT id FROM Plant WHERE placette = p_plac);
    DELETE FROM ObsFloraison WHERE id IN (SELECT id FROM Plant WHERE placette = p_plac);

    DELETE FROM Plant WHERE placette = p_plac;

    DELETE FROM Placette_Arbre WHERE placette = p_plac;
    DELETE FROM Placette_Couverture WHERE placette = p_plac;
    DELETE FROM Placette_Obstruction WHERE placette = p_plac;

    DELETE FROM Placette WHERE plac = p_plac;
END;
$$;

-- Suppression avec erreur si placette référencé dans une autre table.
CREATE OR REPLACE PROCEDURE imm_delete_placette(p_plac Placette_id)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Placette WHERE plac = p_plac;
END;
$$;

--
-- PLANT
--
CREATE OR REPLACE PROCEDURE imm_insert_update_plant(
    p_id Plant_id,
    p_placette Placette_id,
    p_parcelle Parcelle,
    p_date Date_eco
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Plant (id, placette, parcelle, date)
    VALUES (p_id, p_placette, p_parcelle, p_date)
    ON CONFLICT (id) DO UPDATE
    SET placette = EXCLUDED.placette,
        parcelle = EXCLUDED.parcelle,
        date = EXCLUDED.date;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_plant(p_id Plant_id)
RETURNS TABLE(
    id Plant_id,
    placette Placette_id,
    parcelle Parcelle,
    date Date_eco
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT p.id, p.placette, p.parcelle, p.date
    FROM Plant p
    WHERE p.id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_plant(p_id Plant_id)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Plant WHERE id = p_id;
END;
$$;

--
-- OBSERVATION ÉTAT
--
CREATE OR REPLACE PROCEDURE imm_insert_update_obsetat(
    p_id Plant_id,
    p_etat Etat_id,
    p_date Date_eco,
    p_note TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ObsEtat (id, etat, date, note)
    VALUES (p_id, p_etat, p_date, p_note)
    ON CONFLICT (id, date) DO UPDATE
    SET etat = EXCLUDED.etat,
        note = EXCLUDED.note;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_update_obsetat(
    p_id Plant_id,
    p_date Date_eco,
    p_etat Etat_id
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE ObsEtat
    SET etat = p_etat
    WHERE id = p_id AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_obsetat(p_id Plant_id, p_date Date_eco)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsEtat WHERE id = p_id AND date = p_date;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_obsetat(p_id Plant_id)
RETURNS TABLE(
    id Plant_id,
    etat Etat_id,
    date Date_eco,
    note TEXT
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT obe.id, obe.etat, obe.date, obe.note
    FROM ObsEtat obe
    WHERE obe.id = p_id;
END;
$$;

--
-- DIMENSIONS
--
CREATE OR REPLACE PROCEDURE imm_insert_update_obsdimension(
    p_id Plant_id,
    p_longueur Dim_mm,
    p_largeur Dim_mm,
    p_date Date_eco,
    p_note TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ObsDimension (id, longueur, largeur, date, note)
    VALUES (p_id, p_longueur, p_largeur, p_date, p_note)
    ON CONFLICT (id, date) DO UPDATE
    SET longueur = EXCLUDED.longueur,
        largeur = EXCLUDED.largeur,
        note = EXCLUDED.note;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_obsdimension(
    p_id Plant_id,
    p_date Date_eco
)
RETURNS TABLE(
    id Plant_id,
    longueur Dim_mm,
    largeur Dim_mm,
    date Date_eco,
    note TEXT
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT obd.id, obd.longueur, obd.largeur, obd.date, obd.note
    FROM ObsDimension obd
    WHERE obd.id = p_id AND obd.date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_obsdimension(p_id Plant_id, p_date Date_eco)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsDimension WHERE id = p_id AND date = p_date;
END;
$$;

--
-- ARBRE
--
CREATE OR REPLACE PROCEDURE imm_insert_update_arbre(
    p_arbre Arbre_id,
    p_description Description
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Arbre (arbre, description)
    VALUES (p_arbre, p_description)
    ON CONFLICT (arbre) DO UPDATE
    SET description = EXCLUDED.description;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_arbre(p_arbre Arbre_id)
RETURNS TABLE(
    arbre Arbre_id,
    description Description
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT a.arbre, a.description
    FROM Arbre a
    WHERE a.arbre = p_arbre;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_arbre(p_arbre Arbre_id)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Arbre WHERE arbre = p_arbre;
END;
$$;

--
-- PEUPLEMENT
--
CREATE OR REPLACE PROCEDURE imm_insert_update_peuplement(
    p_peuplement Peuplement_id,
    p_description Description
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Peuplement (peuplement, description)
    VALUES (p_peuplement, p_description)
    ON CONFLICT (peuplement) DO UPDATE
    SET description = EXCLUDED.description;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_peuplement(p_peuplement Peuplement_id)
RETURNS TABLE(
    peuplement Peuplement_id,
    description Description
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT p.peuplement, p.description
    FROM Peuplement p
    WHERE p.peuplement = p_peuplement;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_full_delete_peuplement(p_peuplement Peuplement_id)
LANGUAGE plpgsql AS $$
DECLARE
    r_plac RECORD;
BEGIN
    FOR r_plac IN
        SELECT plac FROM Placette WHERE peuplement = p_peuplement
    LOOP
        CALL imm_full_delete_placette(r_plac.plac);
    END LOOP;

    DELETE FROM Peuplement WHERE peuplement = p_peuplement;
END;
$$;

-- Suppression avec erreur si peuplement référencé dans une placette.
CREATE OR REPLACE PROCEDURE imm_delete_peuplement(p_peuplement Peuplement_id)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Peuplement WHERE peuplement = p_peuplement;
END;
$$;

--
-- PLACETTE_ARBRE
--
CREATE OR REPLACE PROCEDURE imm_insert_update_placette_arbre(
    p_placette Placette_id,
    p_rang Rang,
    p_arbre Arbre_id
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Placette_Arbre (placette, rang, arbre)
    VALUES (p_placette, p_rang, p_arbre)
    ON CONFLICT (placette, rang) DO UPDATE
    SET arbre = EXCLUDED.arbre;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_placette_arbre(p_placette Placette_id)
RETURNS TABLE(
    placette Placette_id,
    rang Rang,
    arbre Arbre_id
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT pa.placette, pa.rang, pa.arbre
    FROM Placette_Arbre pa
    WHERE pa.placette = p_placette;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_placette_arbre(
    p_placette Placette_id,
    p_rang Rang
)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Placette_Arbre WHERE placette = p_placette AND rang = p_rang;
END;
$$;

--
-- PLACETTE_COUVERTURE
--
CREATE OR REPLACE PROCEDURE imm_insert_update_placette_couverture(
    p_placette Placette_id,
    p_type Couverture,
    p_taux Taux
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Placette_Couverture (placette, type_couverture, taux)
    VALUES (p_placette, p_type, p_taux)
    ON CONFLICT (placette, type_couverture) DO UPDATE
    SET taux = EXCLUDED.taux;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_placette_couverture(p_placette Placette_id)
RETURNS TABLE(
    placette Placette_id,
    type_couverture Couverture,
    taux Taux
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT pc.placette, pc.type_couverture, pc.taux
    FROM Placette_Couverture pc
    WHERE pc.placette = p_placette;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_placette_couverture(
    p_placette Placette_id,
    p_type Couverture
)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Placette_Couverture
    WHERE placette = p_placette AND type_couverture = p_type;
END;
$$;

--
-- PLACETTE_OBSTRUCTION
--
CREATE OR REPLACE PROCEDURE imm_insert_update_placette_obstruction(
    p_placette Placette_id,
    p_hauteur Hauteur,
    p_type TEXT,
    p_taux Taux
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Placette_Obstruction (placette, hauteur, type_obs, taux)
    VALUES (p_placette, p_hauteur, p_type, p_taux)
    ON CONFLICT (placette, hauteur, type_obs) DO UPDATE
    SET taux = EXCLUDED.taux;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_placette_obstruction(p_placette Placette_id)
RETURNS TABLE(
    placette Placette_id,
    hauteur Hauteur,
    type_obs TEXT,
    taux Taux
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT po.placette, po.hauteur, po.type_obs, po.taux
    FROM Placette_Obstruction po
    WHERE po.placette = p_placette;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_placette_obstruction(
    p_placette Placette_id,
    p_hauteur Hauteur,
    p_type TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Placette_Obstruction
    WHERE placette = p_placette AND hauteur = p_hauteur AND type_obs = p_type;
END;
$$;

--
-- ETAT
--
CREATE OR REPLACE PROCEDURE imm_insert_update_etat(
    p_etat Etat_id,
    p_description Description
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Etat (etat, description)
    VALUES (p_etat, p_description)
    ON CONFLICT (etat) DO UPDATE
    SET description = EXCLUDED.description;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_etat(p_etat Etat_id)
RETURNS TABLE(
    etat Etat_id,
    description Description
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT e.etat, e.description
    FROM Etat e
    WHERE e.etat = p_etat;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_full_delete_etat(p_etat Etat_id)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsEtat WHERE etat = p_etat;
    DELETE FROM Etat WHERE etat = p_etat;
END;
$$;

-- Suppression avec erreur si état référencé dans une observation.
CREATE OR REPLACE PROCEDURE imm_delete_etat(p_etat Etat_id)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Etat WHERE etat = p_etat;
END;
$$;

--
-- OBSFLORAISON
--
CREATE OR REPLACE PROCEDURE imm_insert_update_obsfloraison(
    p_id Plant_id,
    p_date Date_eco,
    p_note TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ObsFloraison (id, date, note)
    VALUES (p_id, p_date, p_note)
    ON CONFLICT (id) DO UPDATE
    SET date = LEAST(ObsFloraison.date, EXCLUDED.date),
        note = EXCLUDED.note;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_obsfloraison(p_id Plant_id)
RETURNS TABLE(
    id Plant_id,
    date Date_eco,
    note TEXT
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT obf.id, obf.date, obf.note
    FROM ObsFloraison obf
    WHERE obf.id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_obsfloraison(p_id Plant_id)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsFloraison WHERE id = p_id;
END;
$$;

--
-- PLANT_NOTE
--
CREATE OR REPLACE PROCEDURE imm_insert_plant_note(
    p_id_plant Plant_id,
    p_date Date_eco,
    p_note TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Plant_Note (id_plant, date, note)
    VALUES (p_id_plant, p_date, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_plant_note(p_id_plant Plant_id)
RETURNS TABLE(
    id INTEGER,
    id_plant Plant_id,
    date Date_eco,
    note TEXT
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT pn.id, pn.id_plant, pn.date, pn.note
    FROM Plant_Note pn
    WHERE pn.id_plant = p_id_plant
    ORDER BY pn.date;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_plant_note(p_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Plant_Note WHERE id = p_id;
END;
$$;
