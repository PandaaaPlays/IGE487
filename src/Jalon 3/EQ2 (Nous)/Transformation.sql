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

--

SELECT * FROM dim_zone