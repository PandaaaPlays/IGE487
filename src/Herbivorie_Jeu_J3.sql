SET SCHEMA 'Herbivorie';

-- Site (1)
INSERT INTO site (code, nom)
VALUES ('MC', 'Mont Jacques Cartier');

-- Zones (2 par site)
INSERT INTO zone (code, code_site, nom, description)
VALUES ('VN', 'MC', 'Versant Nord', 'Versant au Nord du mont Jacques Cartier'),
       ('VS', 'MC', 'Versant Sud', 'Versant au Sud du mont Jacques Cartier');

-- Placette (4 par zone)
INSERT INTO placette (plac, zone, date)
VALUES ('S1', 'VS', DATE('2025-08-18')),
       ('S2', 'VS', DATE('2025-09-18')),
       ('S3', 'VS', DATE('2025-10-18')),
       ('S4', 'VS', DATE('2025-11-18'));
INSERT INTO placette (plac, zone, date)
VALUES ('N1', 'VN', DATE('2025-08-11')),
       ('N2', 'VN', DATE('2025-09-11')),
       ('N3', 'VN', DATE('2025-10-11')),
       ('N4', 'VN', DATE('2025-11-11'));

-- Peuplement (1 par placette)
INSERT INTO peuplement (peuplement, description)
VALUES ('SABB', 'Sapinière à bouleau blanc'),
       ('EABJ', 'Érablière à bouleau jaune'),
       ('PNOI', 'Pessière noire'),
       ('BBOR', 'Bétulaie boréale'),
       ('TARB', 'Toundra arbustive'),
       ('PGRI', 'Pinède grise'),
       ('MMIX', 'Mélèzin mixte'),
       ('FACL', 'Forêt alpine clairsemée');

-- Parcelle (100 par placette)
DO $$
DECLARE
    i INT;
    placette TEXT;
    peuplements TEXT[] := ARRAY['SABB','EABJ','PNOI','BBOR','TARB','PGRI','MMIX','FACL'];
    placettes  TEXT[] := ARRAY['S1','S2','S3','S4','N1','N2','N3','N4'];
    idx INT;
BEGIN
    FOREACH placette IN ARRAY placettes
    LOOP
        FOR i IN 0..99 LOOP
            idx := floor(random() * array_length(peuplements,1))::int + 1;
            INSERT INTO parcelle (placette_id, peuplement, position)
            VALUES (placette, peuplements[idx], i);
        END LOOP;
    END LOOP;
END $$;

-- Plant (1 à 2 par parcelle)
DO $$
DECLARE
    parcelle_id INT;
    n_plants INT;
    i INT;

    code_plant TEXT;
    letter TEXT;
    num TEXT;
    obs_date DATE;
BEGIN
    FOR parcelle_id IN 1..800 LOOP
        n_plants := 1 + floor(random() * 2)::INT;

        FOR i IN 1..n_plants LOOP
            LOOP
                letter := chr(65 + floor(random()*3)::INT);
                num := lpad(floor(random()*10000)::INT::TEXT, 4, '0');
                code_plant := 'MC' || letter || num;

                EXIT WHEN NOT EXISTS (
                    SELECT 1 FROM plant WHERE id = code_plant
                );
            END LOOP;

            obs_date := DATE '2025-06-01' + floor(random() * 150)::INT;

            INSERT INTO plant (id, parcelle_id, date)
            VALUES (code_plant, parcelle_id, obs_date);
        END LOOP;
    END LOOP;
END $$;

-- Arbre (11)
INSERT INTO arbre (arbre, description)
VALUES ('ERABLE', 'Arbre du Canada'),
       ('BOULOT', 'Pour gagner sa vie'),
       ('CHENE', 'Poste de télévision'),
       ('PEUPLIER', 'Stun arbre'),
       ('FRENE', 'Attention ca glisse'),
       ('POMMIER', 'Watch out la gravité'),
       ('PIN', 'Gadoua'),
       ('SAPIN', 'Noël!'),
       ('BAOBAB', 'Oui, oui sur le top du Mont JC'),
       ('BONZAI', 'Même pas un arbre...'),
       ('NOYER', 'Glou glou');

-- Arbre (0 à 3 par placette)
DO $$
DECLARE
    placette TEXT;
    arbres TEXT[] := ARRAY[
        'ERABLE','BOULOT','CHENE','PEUPLIER','FRENE',
        'POMMIER','PIN','SAPIN','BAOBAB','BONZAI','NOYER'
    ];
    placettes TEXT[] := ARRAY['S1','S2','S3','S4','N1','N2','N3','N4'];

    n_arbre INT;
    used_rangs INT[];
    rang INT;
    idx INT;
BEGIN
    FOREACH placette IN ARRAY placettes
    LOOP
        n_arbre := floor(random() * 4)::INT;
        used_rangs := ARRAY[]::INT[];

        FOR i IN 1..n_arbre LOOP
            LOOP
                rang := 1 + floor(random() * 3)::INT;
                EXIT WHEN NOT (rang = ANY(used_rangs));
            END LOOP;

            used_rangs := array_append(used_rangs, rang);

            idx := floor(random() * array_length(arbres,1))::INT + 1;

            INSERT INTO placette_arbre (placette, rang, arbre)
            VALUES (placette, rang, arbres[idx]);

        END LOOP;
    END LOOP;
END $$;

-- Etat
INSERT INTO etat (etat, description)
VALUES ('A', 'Excellent'),
       ('B', 'Bon'),
       ('C', 'Correct'),
       ('D', 'Mauvais'),
       ('E', 'Très mauvais');

-- TODO Plant_note

-- TODO placette_couv et obstr

-- Observation de dimension (au moins 2000)
DO $$
DECLARE
    plant_rec RECORD;
    n_obs INT;
    i INT;

    obs_longueur INT;
    obs_largeur INT;
    obs_date DATE;
    notes TEXT[] := ARRAY['Plante un peu croche','Belle forme pour celle-ci!','Super belle plante','Goute très bon','Un chevreuil est passé par là'];
    idx INT;
    used_dates DATE[];
BEGIN
    FOR plant_rec IN SELECT id FROM plant LOOP

        n_obs := 1 + floor(random() * 5)::INT;
        used_dates := ARRAY[]::DATE[];

        FOR i IN 1..n_obs LOOP

            LOOP
                obs_date := DATE '2025-06-01' + floor(random() * 213)::INT;
                EXIT WHEN NOT (obs_date = ANY(used_dates));
            END LOOP;

            used_dates := array_append(used_dates, obs_date);

            obs_longueur := 1 + floor(random() * 999)::INT;
            obs_largeur  := 1 + floor(random() * 999)::INT;

            idx := floor(random() * array_length(notes,1))::INT + 1;

            INSERT INTO obsdimension (id, longueur, largeur, date, note)
            VALUES (plant_rec.id, obs_longueur, obs_largeur, obs_date, notes[idx]);
        END LOOP;
    END LOOP;
END $$;

-- Observation des états (au moins 2000)
DO $$
DECLARE
    plant_rec RECORD;
    n_obs INT;
    obs_date DATE;
    etats TEXT[] := ARRAY['A','B','C','D','E'];
    idx INT;
    used_dates DATE[];
BEGIN
    FOR plant_rec IN SELECT id FROM plant LOOP
        n_obs := 1 + floor(random() * 5)::INT;
        used_dates := ARRAY[]::DATE[];

        FOR i IN 1..n_obs LOOP
            LOOP
                obs_date := DATE '2025-06-01' + floor(random() * 213)::INT;
                EXIT WHEN NOT (obs_date = ANY(used_dates));
            END LOOP;

            used_dates := array_append(used_dates, obs_date);
            idx := floor(random() * array_length(etats,1))::INT + 1;

            INSERT INTO obsetat (id, etat, date, note)
            VALUES (plant_rec.id, etats[idx], obs_date, 'Observation automatique');
        END LOOP;
    END LOOP;
END $$;

-- Observation des floraisons (une seule par plant)
DO $$
DECLARE
    plant_rec RECORD;
    obs_date DATE;
BEGIN
    FOR plant_rec IN SELECT id FROM plant LOOP
        obs_date := DATE '2025-06-01' + floor(random() * 213)::INT;

        INSERT INTO obsfloraison (id, date, note)
        VALUES (plant_rec.id, obs_date, 'Observation floraison automatique');
    END LOOP;
END $$;

-- Observation de humidité
DO $$
DECLARE
    obs_date DATE;
    zone TEXT;
BEGIN
    FOR i IN 1..2000 LOOP
        obs_date := DATE '2025-06-01' + floor(random() * 213)::INT;
        zone := (ARRAY['VN','VS'])[floor(random() * 2 + 1)::int];
        BEGIN
            INSERT INTO obshumidite (date, hum_min, hum_max, zone)
            VALUES (
                obs_date,
                floor(random()*50)::int,
                50 + floor(random()*50)::int,
                zone
            );
        EXCEPTION WHEN unique_violation THEN
            -- skip duplicate
        END;
    END LOOP;
END $$;

-- Observation des précipitations
DO $$
DECLARE
    obs_date DATE;
    zone TEXT;
    prec_code CHAR(1);
BEGIN
    FOR i IN 1..2000 LOOP
        obs_date := DATE '2025-06-01' + floor(random() * 213)::INT;
        zone := (ARRAY['VN','VS'])[floor(random() * 2 + 1)::int];
        prec_code := (ARRAY['G','N','P'])[floor(random()*3 + 1)::int];
        BEGIN
            INSERT INTO obsprecipitations (date, prec_nat, prec_tot, zone)
            VALUES (
                obs_date,
                prec_code,
                floor(random()*501)::int,
                zone
            );
        EXCEPTION WHEN unique_violation THEN
            -- skip duplicate
        END;
    END LOOP;
END $$;

-- Observation de pression
DO $$
DECLARE
    obs_date DATE;
    zone TEXT;
BEGIN
    FOR i IN 1..2000 LOOP
        obs_date := DATE '2025-06-01' + floor(random() * 213)::INT;
        zone := (ARRAY['VN','VS'])[floor(random() * 2 + 1)::int];
        BEGIN
            INSERT INTO obspression (date, pres_min, pres_max, zone)
            VALUES (
                obs_date,
                900 + floor(random()*201)::int,
                900 + floor(random()*201)::int,
                zone
            );
        EXCEPTION WHEN unique_violation THEN
            -- skip duplicate
        END;
    END LOOP;
END $$;

-- Observation de température
DO $$
DECLARE
    obs_date DATE;
    zone TEXT;
BEGIN
    FOR i IN 1..2000 LOOP
        obs_date := DATE '2025-06-01' + floor(random() * 213)::INT;
        zone := (ARRAY['VN','VS'])[floor(random() * 2 + 1)::int];
        BEGIN
            INSERT INTO obstemperature (date, temp_min, temp_max, note, zone)
            VALUES (
                obs_date,
                -50 + floor(random()*51)::int,
                floor(random()*51)::int,
                'Observation automatique',
                zone
            );
        EXCEPTION WHEN unique_violation THEN
            -- skip duplicate
        END;
    END LOOP;
END $$;

-- Observation de vents
DO $$
DECLARE
    obs_date DATE;
    zone TEXT;
BEGIN
    FOR i IN 1..2000 LOOP
        obs_date := DATE '2025-06-01' + floor(random() * 213)::INT;
        zone := (ARRAY['VN','VS'])[floor(random() * 2 + 1)::int];
        BEGIN
            INSERT INTO obsvents (date, vent_min, vent_max, zone)
            VALUES (
                obs_date,
                floor(random()*151)::int,
                150 + floor(random()*151)::int,
                zone
            );
        EXCEPTION WHEN unique_violation THEN
            -- skip duplicate
        END;
    END LOOP;
END $$;

-- Calcul du total d'observations
SELECT
    'ObsDimension', COUNT(*) FROM ObsDimension
UNION ALL
SELECT
    'ObsEtat', COUNT(*) FROM ObsEtat
UNION ALL
SELECT
    'ObsFloraison', COUNT(*) FROM ObsFloraison
UNION ALL
SELECT
    'ObsTemperature', COUNT(*) FROM ObsTemperature
UNION ALL
SELECT
    'ObsHumidite', COUNT(*) FROM ObsHumidite
UNION ALL
SELECT
    'ObsVents', COUNT(*) FROM ObsVents
UNION ALL
SELECT
    'ObsPression', COUNT(*) FROM ObsPression
UNION ALL
SELECT
    'ObsPrecipitations', COUNT(*) FROM ObsPrecipitations;
