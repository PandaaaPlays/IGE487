COPY fact_temperature(id_interne_zone, date, temp_min, temp_max, temp_moyenne, variation, note) FROM '/EQ2/Loading/Fact_Temperature.csv' WITH (FORMAT CSV, HEADER);
