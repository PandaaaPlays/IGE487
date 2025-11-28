-- -----------------------------------------------------------------------------
-- Dim_Site
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Dim_Site(
    p_code_site VARCHAR,
    p_nom_site VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Dim_Site (code_site, nom_site)
    VALUES (p_code_site, p_nom_site);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Dim_Site(
    p_id_interne INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_interne INTEGER,
    code_site VARCHAR,
    nom_site VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT s.id_interne, s.code_site, s.nom_site
    FROM Dim_Site s
    WHERE p_id_interne IS NULL OR s.id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Dim_Site(
    p_id_interne INTEGER,
    p_code_site VARCHAR,
    p_nom_site VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Dim_Site
    SET code_site = p_code_site,
        nom_site = p_nom_site
    WHERE id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Dim_Site(
    p_id_interne INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Dim_Site
    WHERE id_interne = p_id_interne;
END;
$$;

-- -----------------------------------------------------------------------------
-- Dim_Zone
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Dim_Zone(
    p_code_zone VARCHAR,
    p_code_site VARCHAR,
    p_nom_zone VARCHAR,
    p_description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Dim_Zone (code_zone, code_site, nom_zone, description)
    VALUES (p_code_zone, p_code_site, p_nom_zone, p_description);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Dim_Zone(
    p_id_interne INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_interne INTEGER,
    code_zone VARCHAR,
    code_site VARCHAR,
    nom_zone VARCHAR,
    description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT z.id_interne, z.code_zone, z.code_site, z.nom_zone, z.description
    FROM Dim_Zone z
    WHERE p_id_interne IS NULL OR z.id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Dim_Zone(
    p_id_interne INTEGER,
    p_code_zone VARCHAR,
    p_code_site VARCHAR,
    p_nom_zone VARCHAR,
    p_description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Dim_Zone
    SET code_zone = p_code_zone,
        code_site = p_code_site,
        nom_zone = p_nom_zone,
        description = p_description
    WHERE id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Dim_Zone(
    p_id_interne INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Dim_Zone
    WHERE id_interne = p_id_interne;
END;
$$;

-- -----------------------------------------------------------------------------
-- Dim_Placette
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Dim_Placette(
    p_placette_id VARCHAR,
    p_code_zone VARCHAR,
    p_date_creation DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Dim_Placette (placette_id, code_zone, date_creation)
    VALUES (p_placette_id, p_code_zone, p_date_creation);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Dim_Placette(
    p_id_interne INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_interne INTEGER,
    placette_id VARCHAR,
    code_zone VARCHAR,
    date_creation DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT p.id_interne, p.placette_id, p.code_zone, p.date_creation
    FROM Dim_Placette p
    WHERE p_id_interne IS NULL OR p.id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Dim_Placette(
    p_id_interne INTEGER,
    p_placette_id VARCHAR,
    p_code_zone VARCHAR,
    p_date_creation DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Dim_Placette
    SET placette_id = p_placette_id,
        code_zone = p_code_zone,
        date_creation = p_date_creation
    WHERE id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Dim_Placette(
    p_id_interne INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Dim_Placette
    WHERE id_interne = p_id_interne;
END;
$$;

-- -----------------------------------------------------------------------------
-- Dim_Parcelle
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Dim_Parcelle(
    p_parcelle_id VARCHAR,
    p_placette_id VARCHAR,
    p_peuplement VARCHAR,
    p_position VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Dim_Parcelle (parcelle_id, placette_id, peuplement, position)
    VALUES (p_parcelle_id, p_placette_id, p_peuplement, p_position);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Dim_Parcelle(
    p_id_interne INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_interne INTEGER,
    parcelle_id VARCHAR,
    placette_id VARCHAR,
    peuplement VARCHAR,
    "position" VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT p.id_interne, p.parcelle_id, p.placette_id, p.peuplement, p.position
    FROM Dim_Parcelle p
    WHERE p_id_interne IS NULL OR p.id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Dim_Parcelle(
    p_id_interne INTEGER,
    p_parcelle_id VARCHAR,
    p_placette_id VARCHAR,
    p_peuplement VARCHAR,
    p_position VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Dim_Parcelle
    SET parcelle_id = p_parcelle_id,
        placette_id = p_placette_id,
        peuplement = p_peuplement,
        position = p_position
    WHERE id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Dim_Parcelle(
    p_id_interne INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Dim_Parcelle
    WHERE id_interne = p_id_interne;
END;
$$;

-- -----------------------------------------------------------------------------
-- Dim_Plant
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Dim_Plant(
    p_parcelle_id VARCHAR,
    p_plant_id VARCHAR,
    p_date_decouverte DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Dim_Plant (parcelle_id, plant_id, date_decouverte)
    VALUES (p_parcelle_id, p_plant_id, p_date_decouverte);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Dim_Plant(
    p_id_interne INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_interne INTEGER,
    parcelle_id VARCHAR,
    plant_id VARCHAR,
    date_decouverte DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT p.id_interne, p.parcelle_id, p.plant_id, p.date_decouverte
    FROM Dim_Plant p
    WHERE p_id_interne IS NULL OR p.id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Dim_Plant(
    p_id_interne INTEGER,
    p_parcelle_id VARCHAR,
    p_plant_id VARCHAR,
    p_date_decouverte DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Dim_Plant
    SET parcelle_id = p_parcelle_id,
        plant_id = p_plant_id,
        date_decouverte = p_date_decouverte
    WHERE id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Dim_Plant(
    p_id_interne INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Dim_Plant
    WHERE id_interne = p_id_interne;
END;
$$;

-- -----------------------------------------------------------------------------
-- Dim_Arbre
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Dim_Arbre(
    p_nom_arbre VARCHAR,
    p_description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Dim_Arbre (nom_arbre, description)
    VALUES (p_nom_arbre, p_description);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Dim_Arbre(
    p_id_interne INTEGER DEFAULT NULL
)
RETURNS TABLE (
    id_interne INTEGER,
    nom_arbre VARCHAR,
    description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT a.id_interne, a.nom_arbre, a.description
    FROM Dim_Arbre a
    WHERE p_id_interne IS NULL OR a.id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Dim_Arbre(
    p_id_interne INTEGER,
    p_nom_arbre VARCHAR,
    p_description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Dim_Arbre
    SET nom_arbre = p_nom_arbre,
        description = p_description
    WHERE id_interne = p_id_interne;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Dim_Arbre(
    p_id_interne INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Dim_Arbre
    WHERE id_interne = p_id_interne;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Temperature
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Temperature(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_temp_min DECIMAL,
    p_temp_max DECIMAL,
    p_temp_moyenne DECIMAL,
    p_variation DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Temperature (id_interne_zone, date, temp_min, temp_max, temp_moyenne, variation, note)
    VALUES (p_id_interne_zone, p_date, p_temp_min, p_temp_max, p_temp_moyenne, p_variation, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Temperature(
    p_id_interne_zone INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_zone INTEGER,
    date DATE,
    temp_min DECIMAL,
    temp_max DECIMAL,
    temp_moyenne DECIMAL,
    variation DECIMAL,
    note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_zone, f.date, f.temp_min, f.temp_max, f.temp_moyenne, f.variation, f.note
    FROM Fact_Temperature f
    WHERE (p_id_interne_zone IS NULL OR f.id_interne_zone = p_id_interne_zone)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Temperature(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_temp_min DECIMAL,
    p_temp_max DECIMAL,
    p_temp_moyenne DECIMAL,
    p_variation DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Temperature
    SET temp_min = p_temp_min,
        temp_max = p_temp_max,
        temp_moyenne = p_temp_moyenne,
        variation = p_variation,
        note = p_note
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Temperature(
    p_id_interne_zone INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Temperature
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Humidite
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Humidite(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_hum_min DECIMAL,
    p_hum_max DECIMAL,
    p_temp_moyenne DECIMAL,
    p_variation DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Humidite (id_interne_zone, date, hum_min, hum_max, temp_moyenne, variation, note)
    VALUES (p_id_interne_zone, p_date, p_hum_min, p_hum_max, p_temp_moyenne, p_variation, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Humidite(
    p_id_interne_zone INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_zone INTEGER,
    date DATE,
    hum_min DECIMAL,
    hum_max DECIMAL,
    temp_moyenne DECIMAL,
    variation DECIMAL,
    note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_zone, f.date, f.hum_min, f.hum_max, f.temp_moyenne, f.variation, f.note
    FROM Fact_Humidite f
    WHERE (p_id_interne_zone IS NULL OR f.id_interne_zone = p_id_interne_zone)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Humidite(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_hum_min DECIMAL,
    p_hum_max DECIMAL,
    p_temp_moyenne DECIMAL,
    p_variation DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Humidite
    SET hum_min = p_hum_min,
        hum_max = p_hum_max,
        temp_moyenne = p_temp_moyenne,
        variation = p_variation,
        note = p_note
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Humidite(
    p_id_interne_zone INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Humidite
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Vents
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Vents(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_vent_min DECIMAL,
    p_vent_max DECIMAL,
    p_temp_moyenne DECIMAL,
    p_variation DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Vents (id_interne_zone, date, vent_min, vent_max, temp_moyenne, variation, note)
    VALUES (p_id_interne_zone, p_date, p_vent_min, p_vent_max, p_temp_moyenne, p_variation, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Vents(
    p_id_interne_zone INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_zone INTEGER,
    date DATE,
    vent_min DECIMAL,
    vent_max DECIMAL,
    temp_moyenne DECIMAL,
    variation DECIMAL,
    note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_zone, f.date, f.vent_min, f.vent_max, f.temp_moyenne, f.variation, f.note
    FROM Fact_Vents f
    WHERE (p_id_interne_zone IS NULL OR f.id_interne_zone = p_id_interne_zone)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Vents(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_vent_min DECIMAL,
    p_vent_max DECIMAL,
    p_temp_moyenne DECIMAL,
    p_variation DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Vents
    SET vent_min = p_vent_min,
        vent_max = p_vent_max,
        temp_moyenne = p_temp_moyenne,
        variation = p_variation,
        note = p_note
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Vents(
    p_id_interne_zone INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Vents
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Pression
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Pression(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_pres_min DECIMAL,
    p_pres_max DECIMAL,
    p_temp_moyenne DECIMAL,
    p_variation DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Pression (id_interne_zone, date, pres_min, pres_max, temp_moyenne, variation, note)
    VALUES (p_id_interne_zone, p_date, p_pres_min, p_pres_max, p_temp_moyenne, p_variation, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Pression(
    p_id_interne_zone INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_zone INTEGER,
    date DATE,
    pres_min DECIMAL,
    pres_max DECIMAL,
    temp_moyenne DECIMAL,
    variation DECIMAL,
    note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_zone, f.date, f.pres_min, f.pres_max, f.temp_moyenne, f.variation, f.note
    FROM Fact_Pression f
    WHERE (p_id_interne_zone IS NULL OR f.id_interne_zone = p_id_interne_zone)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Pression(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_pres_min DECIMAL,
    p_pres_max DECIMAL,
    p_temp_moyenne DECIMAL,
    p_variation DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Pression
    SET pres_min = p_pres_min,
        pres_max = p_pres_max,
        temp_moyenne = p_temp_moyenne,
        variation = p_variation,
        note = p_note
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Pression(
    p_id_interne_zone INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Pression
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Precipitation
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Precipitation(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_prec_tot DECIMAL,
    p_prec_nature VARCHAR,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Precipitation (id_interne_zone, date, prec_tot, prec_nature, note)
    VALUES (p_id_interne_zone, p_date, p_prec_tot, p_prec_nature, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Precipitation(
    p_id_interne_zone INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_zone INTEGER,
    date DATE,
    prec_tot DECIMAL,
    prec_nature VARCHAR,
    note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_zone, f.date, f.prec_tot, f.prec_nature, f.note
    FROM Fact_Precipitation f
    WHERE (p_id_interne_zone IS NULL OR f.id_interne_zone = p_id_interne_zone)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Precipitation(
    p_id_interne_zone INTEGER,
    p_date DATE,
    p_prec_tot DECIMAL,
    p_prec_nature VARCHAR,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Precipitation
    SET prec_tot = p_prec_tot,
        prec_nature = p_prec_nature,
        note = p_note
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Precipitation(
    p_id_interne_zone INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Precipitation
    WHERE id_interne_zone = p_id_interne_zone AND date = p_date;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Dimension
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Dimension(
    p_id_interne_plant INTEGER,
    p_date DATE,
    p_longueur DECIMAL,
    p_largeur DECIMAL,
    p_superficie DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Dimension (id_interne_plant, date, longueur, largeur, superficie, note)
    VALUES (p_id_interne_plant, p_date, p_longueur, p_largeur, p_superficie, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Dimension(
    p_id_interne_plant INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_plant INTEGER,
    date DATE,
    longueur DECIMAL,
    largeur DECIMAL,
    superficie DECIMAL,
    note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_plant, f.date, f.longueur, f.largeur, f.superficie, f.note
    FROM Fact_Dimension f
    WHERE (p_id_interne_plant IS NULL OR f.id_interne_plant = p_id_interne_plant)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Dimension(
    p_id_interne_plant INTEGER,
    p_date DATE,
    p_longueur DECIMAL,
    p_largeur DECIMAL,
    p_superficie DECIMAL,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Dimension
    SET longueur = p_longueur,
        largeur = p_largeur,
        superficie = p_superficie,
        note = p_note
    WHERE id_interne_plant = p_id_interne_plant AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Dimension(
    p_id_interne_plant INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Dimension
    WHERE id_interne_plant = p_id_interne_plant AND date = p_date;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Etat
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Etat(
    p_id_interne_plant INTEGER,
    p_date DATE,
    p_etat VARCHAR,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Etat (id_interne_plant, date, etat, note)
    VALUES (p_id_interne_plant, p_date, p_etat, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Etat(
    p_id_interne_plant INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_plant INTEGER,
    date DATE,
    etat VARCHAR,
    note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_plant, f.date, f.etat, f.note
    FROM Fact_Etat f
    WHERE (p_id_interne_plant IS NULL OR f.id_interne_plant = p_id_interne_plant)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Etat(
    p_id_interne_plant INTEGER,
    p_date DATE,
    p_etat VARCHAR,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Etat
    SET etat = p_etat,
        note = p_note
    WHERE id_interne_plant = p_id_interne_plant AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Etat(
    p_id_interne_plant INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Etat
    WHERE id_interne_plant = p_id_interne_plant AND date = p_date;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Floraison
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Floraison(
    p_id_interne_plant INTEGER,
    p_date DATE,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Floraison (id_interne_plant, date, note)
    VALUES (p_id_interne_plant, p_date, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Floraison(
    p_id_interne_plant INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_plant INTEGER,
    date DATE,
    note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_plant, f.date, f.note
    FROM Fact_Floraison f
    WHERE (p_id_interne_plant IS NULL OR f.id_interne_plant = p_id_interne_plant)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Floraison(
    p_id_interne_plant INTEGER,
    p_date DATE,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Floraison
    SET note = p_note
    WHERE id_interne_plant = p_id_interne_plant AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Floraison(
    p_id_interne_plant INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Floraison
    WHERE id_interne_plant = p_id_interne_plant AND date = p_date;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Note
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Note(
    p_id_interne_plant INTEGER,
    p_date DATE,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Note (id_interne_plant, date, note)
    VALUES (p_id_interne_plant, p_date, p_note);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Note(
    p_id_interne_plant INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_plant INTEGER,
    date DATE,
    note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_plant, f.date, f.note
    FROM Fact_Note f
    WHERE (p_id_interne_plant IS NULL OR f.id_interne_plant = p_id_interne_plant)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Note(
    p_id_interne_plant INTEGER,
    p_date DATE,
    p_note TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Note
    SET note = p_note
    WHERE id_interne_plant = p_id_interne_plant AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Note(
    p_id_interne_plant INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Note
    WHERE id_interne_plant = p_id_interne_plant AND date = p_date;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Couverture
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Couverture(
    p_id_interne_placette INTEGER,
    p_date DATE,
    p_type_couverture VARCHAR,
    p_taux DECIMAL,
    p_incertitude DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Couverture (id_interne_placette, date, type_couverture, taux, incertitude)
    VALUES (p_id_interne_placette, p_date, p_type_couverture, p_taux, p_incertitude);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Couverture(
    p_id_interne_placette INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL,
    p_type_couverture VARCHAR DEFAULT NULL
)
RETURNS TABLE (
    id_interne_placette INTEGER,
    date DATE,
    type_couverture VARCHAR,
    taux DECIMAL,
    incertitude DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_placette, f.date, f.type_couverture, f.taux, f.incertitude
    FROM Fact_Couverture f
    WHERE (p_id_interne_placette IS NULL OR f.id_interne_placette = p_id_interne_placette)
      AND (p_date IS NULL OR f.date = p_date)
      AND (p_type_couverture IS NULL OR f.type_couverture = p_type_couverture);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Couverture(
    p_id_interne_placette INTEGER,
    p_date DATE,
    p_type_couverture VARCHAR,
    p_taux DECIMAL,
    p_incertitude DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Couverture
    SET taux = p_taux,
        incertitude = p_incertitude
    WHERE id_interne_placette = p_id_interne_placette 
      AND date = p_date 
      AND type_couverture = p_type_couverture;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Couverture(
    p_id_interne_placette INTEGER,
    p_date DATE,
    p_type_couverture VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Couverture
    WHERE id_interne_placette = p_id_interne_placette 
      AND date = p_date 
      AND type_couverture = p_type_couverture;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Obstruction
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Obstruction(
    p_id_interne_placette INTEGER,
    p_date DATE,
    p_type_obstruction VARCHAR,
    p_hauteur DECIMAL,
    p_taux DECIMAL,
    p_incertitude DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Obstruction (id_interne_placette, date, type_obstruction, hauteur, taux, incertitude)
    VALUES (p_id_interne_placette, p_date, p_type_obstruction, p_hauteur, p_taux, p_incertitude);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Obstruction(
    p_id_interne_placette INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL,
    p_type_obstruction VARCHAR DEFAULT NULL,
    p_hauteur DECIMAL DEFAULT NULL
)
RETURNS TABLE (
    id_interne_placette INTEGER,
    date DATE,
    type_obstruction VARCHAR,
    hauteur DECIMAL,
    taux DECIMAL,
    incertitude DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_placette, f.date, f.type_obstruction, f.hauteur, f.taux, f.incertitude
    FROM Fact_Obstruction f
    WHERE (p_id_interne_placette IS NULL OR f.id_interne_placette = p_id_interne_placette)
      AND (p_date IS NULL OR f.date = p_date)
      AND (p_type_obstruction IS NULL OR f.type_obstruction = p_type_obstruction)
      AND (p_hauteur IS NULL OR f.hauteur = p_hauteur);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Obstruction(
    p_id_interne_placette INTEGER,
    p_date DATE,
    p_type_obstruction VARCHAR,
    p_hauteur DECIMAL,
    p_taux DECIMAL,
    p_incertitude DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Obstruction
    SET taux = p_taux,
        incertitude = p_incertitude
    WHERE id_interne_placette = p_id_interne_placette 
      AND date = p_date 
      AND type_obstruction = p_type_obstruction
      AND hauteur = p_hauteur;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Obstruction(
    p_id_interne_placette INTEGER,
    p_date DATE,
    p_type_obstruction VARCHAR,
    p_hauteur DECIMAL
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Obstruction
    WHERE id_interne_placette = p_id_interne_placette 
      AND date = p_date 
      AND type_obstruction = p_type_obstruction
      AND hauteur = p_hauteur;
END;
$$;

-- -----------------------------------------------------------------------------
-- Fact_Arbre
-- -----------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE IMM_Insert_Fact_Arbre(
    p_id_interne_placette INTEGER,
    p_id_interne_arbre INTEGER,
    p_date DATE,
    p_rang INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Fact_Arbre (id_interne_placette, id_interne_arbre, date, rang)
    VALUES (p_id_interne_placette, p_id_interne_arbre, p_date, p_rang);
END;
$$;

CREATE OR REPLACE FUNCTION IMM_Select_Fact_Arbre(
    p_id_interne_placette INTEGER DEFAULT NULL,
    p_id_interne_arbre INTEGER DEFAULT NULL,
    p_date DATE DEFAULT NULL
)
RETURNS TABLE (
    id_interne_placette INTEGER,
    id_interne_arbre INTEGER,
    date DATE,
    rang INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT f.id_interne_placette, f.id_interne_arbre, f.date, f.rang
    FROM Fact_Arbre f
    WHERE (p_id_interne_placette IS NULL OR f.id_interne_placette = p_id_interne_placette)
      AND (p_id_interne_arbre IS NULL OR f.id_interne_arbre = p_id_interne_arbre)
      AND (p_date IS NULL OR f.date = p_date);
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Update_Fact_Arbre(
    p_id_interne_placette INTEGER,
    p_id_interne_arbre INTEGER,
    p_date DATE,
    p_rang INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Fact_Arbre
    SET rang = p_rang
    WHERE id_interne_placette = p_id_interne_placette 
      AND id_interne_arbre = p_id_interne_arbre 
      AND date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE IMM_Delete_Fact_Arbre(
    p_id_interne_placette INTEGER,
    p_id_interne_arbre INTEGER,
    p_date DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Fact_Arbre
    WHERE id_interne_placette = p_id_interne_placette 
      AND id_interne_arbre = p_id_interne_arbre 
      AND date = p_date;
END;
$$;
