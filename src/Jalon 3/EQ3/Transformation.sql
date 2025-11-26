-- Dim_Site
SELECT nom AS nom_site,
       code AS code_site
FROM staging_site;

-- Dim_Zone
SELECT code AS code_zone,
       code_site AS code_site,
       nom AS nom_zone,
       description AS description
FROM staging_zone;

-- Dim_Arbre

-- Dim_Parcelle

-- Dim_Placette

-- Dim_Plant

-- Dim_Site

-- Dim_Zone

-- Fact_Arbre

-- Fact_Couverture

-- Fact_Dimension

-- Fact_Etat

-- Fact_Floraison

-- Fact_Humidite

-- Fact_Note

-- Fact_Obstruction

-- Fact_Precipitation

-- Fact_Pression

-- Fact_Temperature

-- Fact_Vents
