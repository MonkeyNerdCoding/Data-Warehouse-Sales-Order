WITH stg_country AS (
    SELECT 
    CAST(country_id AS INT) AS country_key,
    CAST(country_name AS STRING) AS country_name
    FROM `vit-lam-data.wide_world_importers.application__countries`
)

, stg_country_final AS (
    SELECT 
    country_key,
    country_name
    FROM stg_country

    UNION ALL 
    SELECT 
    0 AS country_key,
    "Undefined" AS country_name

    UNION ALL
    SELECT 
    -1 AS country_key,
    "ERROR" AS country_name
)

SELECT 
    COALESCE(country_key, 0) AS country_key,
    COALESCE(country_name, 'Undefined') AS country_name
FROM stg_country_final