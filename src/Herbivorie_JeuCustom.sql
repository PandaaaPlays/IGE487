SET SCHEMA 'Herbivorie';

-- ===================================================================
-- Arbre
-- ===================================================================
INSERT INTO Arbre VALUES
('ABIBAL', 'Abies balsamea'),
('ACESAC', 'Acer saccharum'),
('BETALL', 'Betula alleghaniensis'),
('BETCOR', 'Betula papyrifera var. cordifolia'),
('BETPAP', 'Betula papyrifera'),
('FAGGRA', 'Fagus grandifolia'),
('NA',     'non applicable (sans objet)'),
('PICMAR', 'Picea mariana'),
('SORSSP', 'Sorbus sp.'),
('PICEGL', 'Picea glauca'),
('ACERUB', 'Acer rubrum'),
('BETNIG', 'Betula nigra');

-- ===================================================================
-- Peuplement
-- ===================================================================
INSERT INTO Peuplement VALUES
('ERHE', 'érablière à hêtre'),
('BEMI', 'bétulai à érable et sapin'),
('SABO', 'sapinière à bouleau'),
('SAPI', 'sapinière pure'),
('ERSA', 'érablière à sapin'),
('PEBO', 'pessière à bouleau'),
('FAGO', 'forêt de feuillus'),
('PINM', 'pineraie mixte');

-- ===================================================================
-- Etat
-- ===================================================================
INSERT INTO Etat VALUES
('O', 'vivante'),
('B', 'broutée'),
('X', 'fanée'),
('C', 'cassée'),
('D', 'disparue'),
('N', 'non retrouvée'),
('S', 'sous-développée'),
('M', 'malade');

-- ===================================================================
-- Site
-- ===================================================================
INSERT INTO Site VALUES
('PN','Parc National A'),
('FB','Forêt B'),
('RC','Réserve C');

-- ===================================================================
-- Zone
-- ===================================================================
INSERT INTO Zone VALUES
('Z1','PN','Zone Est','Zone dense avec érables et hêtres'),
('Z2','PN','Zone Ouest','Zone plus clairsemée avec sapins'),
('Z3','FB','Zone Nord','Zone humide avec bouleaux'),
('Z4','FB','Zone Sud','Zone sèche avec conifères'),
('Z5','RC','Zone Centrale','Zone mixte feuillus/conifères');

-- ===================================================================
-- Placette
-- ===================================================================
INSERT INTO Placette VALUES
('A1','Z1','2017-07-25'),
('A2','Z1','2017-07-26'),
('A3','Z2','2017-08-01'),
('B1','Z2','2017-07-25'),
('B2','Z3','2017-07-26'),
('B3','Z3','2017-08-02'),
('C1','Z4','2017-07-26'),
('C2','Z4','2017-07-27'),
('C3','Z5','2017-08-02');

-- ===================================================================
-- Placette_Arbre
-- ===================================================================
INSERT INTO Placette_Arbre VALUES
('A1',1,'ACESAC'),('A1',2,'FAGGRA'),('A1',3,'BETALL'),
('A2',1,'BETPAP'),('A2',2,'ACESAC'),('A2',3,'ABIBAL'),
('A3',1,'ABIBAL'),('A3',2,'BETCOR'),('A3',3,'SORSSP'),
('B1',1,'ACESAC'),('B1',2,'FAGGRA'),('B1',3,'BETPAP'),
('B2',1,'ACESAC'),('B2',2,'ABIBAL'),('B2',3,'PICMAR'),
('B3',1,'ABIBAL'),('B3',2,'BETCOR'),('B3',3,'PICMAR'),
('C1',1,'ACESAC'),('C1',2,'FAGGRA'),('C1',3,'NA'),
('C2',1,'ACESAC'),('C2',2,'ABIBAL'),('C2',3,'PICMAR'),
('C3',1,'PICMAR'),('C3',2,'BETALL'),('C3',3,'ABIBAL');

-- ===================================================================
-- Parcelle
-- ===================================================================
INSERT INTO Parcelle (placette_id, peuplement, position) VALUES
('A1','ERHE',1),
('A1','ERHE',2),
('A1','ERHE',3),
('A2','BEMI',1),
('A2','BEMI',2),
('A2','BEMI',3),
('B1','ERHE',1),
('B1','ERHE',2),
('B2','SABO',1),
('B2','SABO',2),
('C1','ERHE',1),
('C1','ERSA',2),
('C2','PEBO',1);

-- ===================================================================
-- Plant
-- ===================================================================
INSERT INTO Plant VALUES
('MMA1001',1,'2017-05-08'),
('MMA1002',2,'2017-05-08'),
('MMA1003',3,'2017-05-09'),
('MMB2001',4,'2017-05-10'),
('MMB2002',5,'2017-05-11'),
('MMB2003',6,'2017-05-12'),
('MMC3001',7,'2017-05-13'),
('MMC3002',8,'2017-05-14'),
('MMC3003',9,'2017-05-15');

-- ===================================================================
-- ObsDimension
-- ===================================================================
INSERT INTO ObsDimension VALUES
('MMA1001',50,35,'2017-05-08','pas jolie'),
('MMA1001',120,85,'2017-06-04',''),
('MMA1002',55,40,'2017-05-08',''),
('MMB2001',80,65,'2017-05-10','soleil matinal'),
('MMC3001',60,50,'2017-05-13','ombre partielle');

-- ===================================================================
-- ObsFloraison
-- ===================================================================
INSERT INTO ObsFloraison VALUES
('MMA1001','2017-05-08',''),
('MMA1002','2017-05-08',''),
('MMB2001','2017-05-10',''),
('MMC3001','2017-05-13','');

-- ===================================================================
-- ObsEtat
-- ===================================================================
INSERT INTO ObsEtat VALUES
('MMA1001','O','2017-06-08',''),
('MMA1002','B','2017-06-08','feuilles broutées'),
('MMB2001','O','2017-06-10',''),
('MMC3001','C','2017-06-15','cassé par vent');




DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'Herbivorie'
    LOOP
        EXECUTE 'ANALYZE Herbivorie.' || quote_ident(r.tablename);
    END LOOP;
END;
$$;