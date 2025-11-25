-- ARBRE
CREATE OR REPLACE FUNCTION imm_getall_arbre()
RETURNS TABLE(
    arbre "Herbivorie".Arbre_id,
    description "Herbivorie".Description
) AS $$
    SELECT a.arbre, a.description
    FROM "Herbivorie".Arbre a;
$$ LANGUAGE sql;

-- PEUPLEMENT
CREATE OR REPLACE FUNCTION imm_getall_peuplement()
RETURNS TABLE(
    peuplement "Herbivorie".Peuplement_id,
    description "Herbivorie".Description
) AS $$
    SELECT p.peuplement, p.description
    FROM "Herbivorie".Peuplement p;
$$ LANGUAGE sql;

-- PLACETTE
CREATE OR REPLACE FUNCTION imm_getall_placette()
RETURNS TABLE(
    plac "Herbivorie".Placette_id,
    zone "Herbivorie".Code_zone,
    date_eco "Herbivorie".Date_eco
) AS $$
    SELECT pl.plac, pl.zone, pl.date
    FROM "Herbivorie".Placette pl;
$$ LANGUAGE sql;

-- PLACETTE_ARBRE
CREATE OR REPLACE FUNCTION imm_getall_placette_arbre()
RETURNS TABLE(
    placette "Herbivorie".Placette_id,
    rang "Herbivorie".Rang,
    arbre "Herbivorie".Arbre_id
) AS $$
    SELECT pa.placette, pa.rang, pa.arbre
    FROM "Herbivorie".Placette_Arbre pa;
$$ LANGUAGE sql;

-- PLACETTE_COUVERTURE
CREATE OR REPLACE FUNCTION imm_getall_placette_couverture()
RETURNS TABLE(
    placette "Herbivorie".Placette_id,
    type_couverture "Herbivorie".Couverture,
    taux "Herbivorie".TauxAvecIncertitude
) AS $$
    SELECT pc.placette, pc.type_couverture, pc.taux
    FROM "Herbivorie".Placette_Couverture pc;
$$ LANGUAGE sql;

-- PLACETTE_OBSTRUCTION
CREATE OR REPLACE FUNCTION imm_getall_placette_obstruction()
RETURNS TABLE(
    placette "Herbivorie".Placette_id,
    hauteur "Herbivorie".Hauteur,
    type_obs TEXT,
    taux "Herbivorie".TauxAvecIncertitude
) AS $$
    SELECT po.placette, po.hauteur, po.type_obs, po.taux
    FROM "Herbivorie".Placette_Obstruction po;
$$ LANGUAGE sql;

-- PARCELLE
CREATE OR REPLACE FUNCTION imm_getall_parcelle()
RETURNS TABLE(
    parcelle_id INTEGER,
    placette_id "Herbivorie".Placette_id,
    peuplement "Herbivorie".Peuplement_id,
    "position" "Herbivorie".Position_parcelle
) AS $$
    SELECT p.parcelle_id, p.placette_id, p.peuplement, p."position"
    FROM "Herbivorie".Parcelle p;
$$ LANGUAGE sql;

-- PLANT
CREATE OR REPLACE FUNCTION imm_getall_plant()
RETURNS TABLE(
    id "Herbivorie".Plant_id,
    parcelle_id INTEGER,
    date_eco "Herbivorie".Date_eco
) AS $$
    SELECT pl.id, pl.parcelle_id, pl.date
    FROM "Herbivorie".Plant pl;
$$ LANGUAGE sql;

-- PLANT_NOTE
CREATE OR REPLACE FUNCTION imm_getall_plant_note()
RETURNS TABLE(
    id INTEGER,
    id_plant "Herbivorie".Plant_id,
    date_eco "Herbivorie".Date_eco,
    note TEXT
) AS $$
    SELECT pn.id, pn.id_plant, pn.date, pn.note
    FROM "Herbivorie".Plant_Note pn;
$$ LANGUAGE sql;

-- OBSERVATION DIMENSION
CREATE OR REPLACE FUNCTION imm_getall_obsdimension()
RETURNS TABLE(
    id "Herbivorie".Plant_id,
    longueur "Herbivorie".Dim_mm,
    largeur "Herbivorie".Dim_mm,
    date_eco "Herbivorie".Date_eco,
    note TEXT
) AS $$
    SELECT od.id, od.longueur, od.largeur, od.date, od.note
    FROM "Herbivorie".ObsDimension od;
$$ LANGUAGE sql;

-- OBSERVATION FLORAISON
CREATE OR REPLACE FUNCTION imm_getall_obsfloraison()
RETURNS TABLE(
    id "Herbivorie".Plant_id,
    date_eco "Herbivorie".Date_eco,
    note TEXT
) AS $$
    SELECT ofl.id, ofl.date, ofl.note
    FROM "Herbivorie".ObsFloraison ofl;
$$ LANGUAGE sql;

-- ETAT
CREATE OR REPLACE FUNCTION imm_getall_etat()
RETURNS TABLE(
    etat "Herbivorie".Etat_id,
    description "Herbivorie".Description
) AS $$
    SELECT e.etat, e.description
    FROM "Herbivorie".Etat e;
$$ LANGUAGE sql;

-- OBSERVATION ETAT
CREATE OR REPLACE FUNCTION imm_getall_obsetat()
RETURNS TABLE(
    id "Herbivorie".Plant_id,
    etat "Herbivorie".Etat_id,
    date_eco "Herbivorie".Date_eco,
    note TEXT
) AS $$
    SELECT oe.id, oe.etat, oe.date, oe.note
    FROM "Herbivorie".ObsEtat oe;
$$ LANGUAGE sql;

-- SITE
CREATE OR REPLACE FUNCTION imm_getall_site()
RETURNS TABLE(
    code "Herbivorie".Code_site,
    nom "Herbivorie".Nom_site
) AS $$
    SELECT s.code, s.nom
    FROM "Herbivorie".Site s;
$$ LANGUAGE sql;

-- ZONE
CREATE OR REPLACE FUNCTION imm_getall_zone()
RETURNS TABLE(
    code "Herbivorie".Code_zone,
    code_site "Herbivorie".Code_site,
    nom "Herbivorie".Nom_zone,
    description "Herbivorie".Description_zone
) AS $$
    SELECT z.code, z.code_site, z.nom, z.description
    FROM "Herbivorie".Zone z;
$$ LANGUAGE sql;

-- OBS TEMPERATURE
CREATE OR REPLACE FUNCTION imm_getall_obstemperature()
RETURNS TABLE(
    date_eco "Herbivorie".Date_eco,
    temp_min "Herbivorie".Temperature,
    temp_max "Herbivorie".Temperature,
    note TEXT,
    zone_ "Herbivorie".Code_zone
) AS $$
    SELECT ot.date, ot.temp_min, ot.temp_max, ot.note, ot.zone
    FROM "Herbivorie".ObsTemperature ot;
$$ LANGUAGE sql;

-- OBS HUMIDITE
CREATE OR REPLACE FUNCTION imm_getall_obshumidite()
RETURNS TABLE(
    date_eco "Herbivorie".Date_eco,
    hum_min "Herbivorie".Humidite,
    hum_max "Herbivorie".Humidite,
    zone_ "Herbivorie".Code_zone
) AS $$
    SELECT oh.date, oh.hum_min, oh.hum_max, oh.zone
    FROM "Herbivorie".ObsHumidite oh;
$$ LANGUAGE sql;

-- OBS VENTS
CREATE OR REPLACE FUNCTION imm_getall_obsvents()
RETURNS TABLE(
    date_eco "Herbivorie".Date_eco,
    vent_min "Herbivorie".Vitesse,
    vent_max "Herbivorie".Vitesse,
    zone_ "Herbivorie".Code_zone
) AS $$
    SELECT ov.date, ov.vent_min, ov.vent_max, ov.zone
    FROM "Herbivorie".ObsVents ov;
$$ LANGUAGE sql;

-- OBS PRESSION
CREATE OR REPLACE FUNCTION imm_getall_obspression()
RETURNS TABLE(
    date_eco "Herbivorie".Date_eco,
    pres_min "Herbivorie".Pression,
    pres_max "Herbivorie".Pression,
    zone_ "Herbivorie".Code_zone
) AS $$
    SELECT op.date, op.pres_min, op.pres_max, op.zone
    FROM "Herbivorie".ObsPression op;
$$ LANGUAGE sql;

-- TYPE PRECIPITATIONS
CREATE OR REPLACE FUNCTION imm_getall_typeprecipitations()
RETURNS TABLE(
    code "Herbivorie".Code_P,
    libelle TEXT
) AS $$
    SELECT tp.code, tp.libelle
    FROM "Herbivorie".TypePrecipitations tp;
$$ LANGUAGE sql;

-- OBS PRECIPITATIONS
CREATE OR REPLACE FUNCTION imm_getall_obsprecipitations()
RETURNS TABLE(
    date_eco "Herbivorie".Date_eco,
    prec_tot "Herbivorie".HNP,
    prec_nat "Herbivorie".Code_P,
    zone_ "Herbivorie".Code_zone
) AS $$
    SELECT op.date, op.prec_tot, op.prec_nat, op.zone
    FROM "Herbivorie".ObsPrecipitations op;
$$ LANGUAGE sql;

-- CARNET METEO
CREATE OR REPLACE FUNCTION imm_getall_carnetmeteo()
RETURNS TABLE(
    temp_min TEXT,
    temp_max TEXT,
    hum_min TEXT,
    hum_max TEXT,
    prec_tot TEXT,
    prec_nat TEXT,
    vent_min TEXT,
    vent_max TEXT,
    pres_min TEXT,
    pres_max TEXT,
    date_eco TEXT,
    note TEXT,
    zone TEXT
) AS $$
    SELECT *
    FROM "Herbivorie".CarnetMeteo;
$$ LANGUAGE sql;
