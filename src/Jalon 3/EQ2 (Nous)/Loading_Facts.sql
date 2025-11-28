COPY Fact_Temperature(id_interne_zone, date, temp_min, temp_max, temp_moyenne, variation, note) FROM '/EQ2/Loading/Fact_Temperature.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Humidite(id_interne_zone, date, hum_min, hum_max, hum_moyenne, variation, note) FROM '/EQ2/Loading/Fact_Humidite.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Vents(id_interne_zone, date, vent_min, vent_max, vent_moyenne, variation, note) FROM '/EQ2/Loading/Fact_Vents.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Pression(id_interne_zone, date, pres_min, pres_max, pres_moyenne, variation, note) FROM '/EQ2/Loading/Fact_Pression.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Precipitation(id_interne_zone, date, prec_tot, prec_nature, note) FROM '/EQ2/Loading/Fact_Precipitation.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Dimension(id_interne_plant, date, longueur, largeur, superficie, note) FROM '/EQ2/Loading/Fact_Dimension.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Etat(id_interne_plant, date, etat, note) FROM '/EQ2/Loading/Fact_Etat.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Floraison(id_interne_plant, date, note) FROM '/EQ2/Loading/Fact_Floraison.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Note(id_interne_plant, date, note) FROM '/EQ2/Loading/Fact_Note.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Couverture(id_interne_placette, date, type_couverture, taux, incertitude) FROM '/EQ2/Loading/Fact_Couverture.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Obstruction(id_interne_placette, date, type_obstruction, hauteur, taux, incertitude) FROM '/EQ2/Loading/Fact_Obstruction.csv' WITH (FORMAT CSV, HEADER);

COPY Fact_Arbre(id_interne_placette, id_interne_arbre, date, rang) FROM '/EQ2/Loading/Fact_Arbre.csv' WITH (FORMAT CSV, HEADER);
