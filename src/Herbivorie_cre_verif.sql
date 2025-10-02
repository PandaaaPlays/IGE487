
/*
== Validation de la table Taux

Il y a deux approches pour assurer la compacité de la table Taux sur son intervalle
de définition [0..100].

.Par vérification explicite de la compacité
....
create assertion Taux_Compcite as check (Test_Taux_compacite (0,100)) ;
....

.Par construction la table virtuelle (vue) Taux à partir seuils tMin
Par exemple à partir des seuils
....
  ('A', 76),
  ('B', 51),
  ('C', 26),
  ('D', 6),
  ('E', 1),
  ('F', 0)
....

On construit la table (vue) suivante
....
  ('A', 76, 100),
  ('B', 51, 75),
  ('C', 26, 50),
  ('D', 6, 25),
  ('E', 1, 5),
  ('F', 0, 0)
....

.Remarque
La seule contrainte applicable aux codes tCat est leur unicité.
Notamment, lors de leur utilisation, on prendra donc soin de ne pas se reposer
sur leur ordre.
Par exemple, la table suivante est valide :
....
  ('T', 76, 100),
  ('X', 51, 75),
  ('Y', 26, 50),
  ('D', 6, 25),
  ('M', 1, 5),
  ('F', 0, 0)
....

*/

CREATE OR REPLACE FUNCTION check_interval_compact(new_min Taux_val, new_max Taux_val)
    RETURNS BOOLEAN AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Taux
        WHERE tMin <= new_max AND tMax >= new_min
    ) THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION verifier_compacite_taux()
    RETURNS TRIGGER AS $$
BEGIN
    IF NOT check_interval_compact(NEW.tMin, NEW.tMax) THEN
        RAISE EXCEPTION 'Compactness of Taux violated: table must cover 0..100 without gaps.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trg_compacite_taux
    BEFORE INSERT OR UPDATE ON Taux
    FOR EACH ROW
EXECUTE FUNCTION verifier_compacite_taux();

/*
  -- ce qui suit est redondant si les trois conditions précédentes sont vérifiées
  and exists (
    select 1
    from Taux
    where tMax = 100 and tMin = (select max(tMin)from Taux)
    )
*/
;

INSERT INTO Taux
VALUES
    ('F', 0, 4),
    ('M', 5, 7),
    ('D', 7, 25),
    ('Y', 26, 50),
    ('X', 51, 75),
    ('T', 76, 100);

