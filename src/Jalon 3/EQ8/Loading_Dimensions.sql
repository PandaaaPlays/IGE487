COPY Dim_Site(code_site, nom_site) FROM '/EQ8/Loading/Dim_Site.csv' WITH (FORMAT CSV, HEADER);

COPY Dim_Zone(code_zone, code_site, nom_zone, description) FROM '/EQ8/Loading/Dim_Zone.csv' WITH (FORMAT CSV, HEADER);

COPY Dim_Placette(placette_id, code_zone, date_creation) FROM '/EQ8/Loading/Dim_Placette.csv' WITH (FORMAT CSV, HEADER);

COPY Dim_Parcelle(parcelle_id, placette_id, peuplement, position) FROM '/EQ8/Loading/Dim_Parcelle.csv' WITH (FORMAT CSV, HEADER);

COPY Dim_Plant(plant_id, date_decouverte) FROM '/EQ8/Loading/Dim_Plant.csv' WITH (FORMAT CSV, HEADER);

CREATE TABLE dim_arbre_stage(
    nom_arbre TEXT,
    description TEXT
);
COPY dim_arbre_stage (nom_arbre, description)
FROM '/EQ8/Loading/Dim_Arbre.csv'
WITH (FORMAT CSV, HEADER);

INSERT INTO dim_arbre (nom_arbre, description)
SELECT nom_arbre, description
FROM dim_arbre_stage
ON CONFLICT DO NOTHING;