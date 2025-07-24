WITH stg_country AS (
    SELECT 
    CAST(country_id AS INT) AS country_key,
    CAST(country_name AS STRING) AS country_name
    FROM `vit-lam-data.wide_world_importers.application__countries`
)

SELECT 
    COALESCE(country_key,0) AS country_key,
    COALESCE(country_name,"Undefined") AS country_name
FROM stg_country