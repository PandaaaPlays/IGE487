/*
////
-- =========================================================================== A
-- Meteo_imm.sql
-- ---------------------------------------------------------------------------
Activité : IGE487_2025-3
Encodage : UTF-8, sans BOM; fin de ligne Unix (LF)
Plateforme : PostgreSQL 9.4 à 17
Responsable : luc.lavoie@usherbrooke.ca
Version : 1.0.0
Statut : Liste de base des IMM de météo.
Résumé : Ajout des principaux IMM pour la gestion des tables météo.
-- =========================================================================== A
*/

-- ============================================================================
-- OBS TEMPERATURE
-- ============================================================================
CREATE OR REPLACE PROCEDURE imm_insert_update_obstemperature(
    p_date Date_eco,
    p_temp_min Temperature,
    p_temp_max Temperature,
    p_note TEXT,
    p_zone code_zone
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ObsTemperature (date, temp_min, temp_max, note, zone)
    VALUES (p_date, p_temp_min, p_temp_max, p_note, p_zone)
    ON CONFLICT (date) DO UPDATE
    SET temp_min = EXCLUDED.temp_min,
        temp_max = EXCLUDED.temp_max,
        note = EXCLUDED.note,
        zone = EXCLUDED.zone;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_obstemperature(p_date Date_eco)
RETURNS TABLE(
    date Date_eco,
    temp_min Temperature,
    temp_max Temperature,
    note TEXT,
    zone code_zone
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT obt.date, obt.temp_min, obt.temp_max, obt.note, obt.zone
    FROM ObsTemperature obt
    WHERE obt.date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_obstemperature(p_date Date_eco)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsTemperature WHERE date = p_date;
END;
$$;



-- ============================================================================
-- OBS HUMIDITE
-- ============================================================================
CREATE OR REPLACE PROCEDURE imm_insert_update_obshumidite(
    p_date Date_eco,
    p_hum_min Humidite,
    p_hum_max Humidite,
    p_zone code_zone
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ObsHumidite (date, hum_min, hum_max, zone)
    VALUES (p_date, p_hum_min, p_hum_max, p_zone)
    ON CONFLICT (date) DO UPDATE
    SET hum_min = EXCLUDED.hum_min,
        hum_max = EXCLUDED.hum_max,
        zone = EXCLUDED.zone;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_obshumidite(p_date Date_eco)
RETURNS TABLE(
    date Date_eco,
    hum_min Humidite,
    hum_max Humidite,
    zone code_zone
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT obh.date, obh.hum_min, obh.hum_max, obh.zone
    FROM ObsHumidite obh
    WHERE obh.date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_obshumidite(p_date Date_eco)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsHumidite WHERE date = p_date;
END;
$$;



-- ============================================================================
-- OBS VENTS
-- ============================================================================
CREATE OR REPLACE PROCEDURE imm_insert_update_obsvents(
    p_date Date_eco,
    p_vent_min Vitesse,
    p_vent_max Vitesse,
    p_zone code_zone
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ObsVents (date, vent_min, vent_max, zone)
    VALUES (p_date, p_vent_min, p_vent_max, p_zone)
    ON CONFLICT (date) DO UPDATE
    SET vent_min = EXCLUDED.vent_min,
        vent_max = EXCLUDED.vent_max,
        zone = EXCLUDED.zone;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_obsvents(p_date Date_eco)
RETURNS TABLE(
    date Date_eco,
    vent_min Vitesse,
    vent_max Vitesse,
    zone code_zone
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT obv.date, obv.vent_min, obv.vent_max, obv.zone
    FROM ObsVents obv
    WHERE obv.date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_obsvents(p_date Date_eco)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsVents WHERE date = p_date;
END;
$$;



-- ============================================================================
-- OBS PRESSION
-- ============================================================================
CREATE OR REPLACE PROCEDURE imm_insert_update_obspression(
    p_date Date_eco,
    p_pres_min Pression,
    p_pres_max Pression,
    p_zone code_zone
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ObsPression (date, pres_min, pres_max, zone)
    VALUES (p_date, p_pres_min, p_pres_max, p_zone)
    ON CONFLICT (date) DO UPDATE
    SET pres_min = EXCLUDED.pres_min,
        pres_max = EXCLUDED.pres_max,
        zone = EXCLUDED.zone;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_obspression(p_date Date_eco)
RETURNS TABLE(
    date Date_eco,
    pres_min Pression,
    pres_max Pression,
    zone code_zone
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT obp.date, obp.pres_min, obp.pres_max, obp.zone
    FROM ObsPression obp
    WHERE obp.date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_obspression(p_date Date_eco)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsPression WHERE date = p_date;
END;
$$;



-- ============================================================================
-- TYPE PRECIPITATIONS
-- ============================================================================
CREATE OR REPLACE PROCEDURE imm_insert_update_typeprecipitations(
    p_code Code_P,
    p_libelle TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO TypePrecipitations (code, libelle)
    VALUES (p_code, p_libelle)
    ON CONFLICT (code) DO UPDATE
    SET libelle = EXCLUDED.libelle;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_typeprecipitations(p_code Code_P)
RETURNS TABLE(
    code Code_P,
    libelle TEXT
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT tp.code, tp.libelle
    FROM TypePrecipitations tp
    WHERE tp.code = p_code;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_typeprecipitations(p_code Code_P)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM TypePrecipitations WHERE code = p_code;
END;
$$;



-- ============================================================================
-- OBS PRECIPITATIONS (with zone added)
-- ============================================================================
CREATE OR REPLACE PROCEDURE imm_insert_update_obsprecipitations(
    p_date Date_eco,
    p_prec_tot HNP,
    p_prec_nat Code_P,
    p_zone code_zone
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO ObsPrecipitations (date, prec_tot, prec_nat, zone)
    VALUES (p_date, p_prec_tot, p_prec_nat, p_zone)
    ON CONFLICT (date, prec_nat) DO UPDATE
    SET prec_tot = EXCLUDED.prec_tot,
        zone = EXCLUDED.zone;
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_obsprecipitations(p_date Date_eco)
RETURNS TABLE(
    date Date_eco,
    prec_tot HNP,
    prec_nat Code_P,
    zone code_zone
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT obp.date, obp.prec_tot, obp.prec_nat, obp.zone
    FROM ObsPrecipitations obp
    WHERE obp.date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_obsprecipitations(
    p_date Date_eco,
    p_prec_nat Code_P
)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM ObsPrecipitations
    WHERE date = p_date
      AND prec_nat = p_prec_nat;
END;
$$;



-- ============================================================================
-- CARNET METEO (no zone in model)
-- ============================================================================
CREATE OR REPLACE PROCEDURE imm_insert_carnetmeteo(
    p_temp_min text,
    p_temp_max text,
    p_hum_min text,
    p_hum_max text,
    p_prec_tot text,
    p_prec_nat text,
    p_vent_min text,
    p_vent_max text,
    p_pres_min text,
    p_pres_max text,
    p_date text,
    p_note text
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO CarnetMeteo (
        temp_min, temp_max, hum_min, hum_max, prec_tot, prec_nat,
        vent_min, vent_max, pres_min, pres_max, date, note
    )
    VALUES (
        p_temp_min, p_temp_max, p_hum_min, p_hum_max, p_prec_tot, p_prec_nat,
        p_vent_min, p_vent_max, p_pres_min, p_pres_max, p_date, p_note
    );
END;
$$;

CREATE OR REPLACE FUNCTION imm_get_carnetmeteo(p_date text)
RETURNS TABLE(
    temp_min text,
    temp_max text,
    hum_min text,
    hum_max text,
    prec_tot text,
    prec_nat text,
    vent_min text,
    vent_max text,
    pres_min text,
    pres_max text,
    date text,
    note text
) LANGUAGE plpgsql AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM CarnetMeteo cm
    WHERE cm.date = p_date;
END;
$$;

CREATE OR REPLACE PROCEDURE imm_delete_carnetmeteo(p_date text)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM CarnetMeteo WHERE date = p_date;
END;
$$;


/*
-- =========================================================================== Z
////
.Contributeurs
* Équipe du projet (Étienne, Imène, Mathieu et Mikael)

.Tâches réalisées
* 2025-10-08.
  - Création des IMM pour météo.

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
-- fin de {CoFELI}/src/Meteo_imm.sql
-- =========================================================================== Z
*/