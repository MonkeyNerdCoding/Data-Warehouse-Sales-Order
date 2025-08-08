WITH stg_province AS (
    SELECT
    CAST(state_province_id AS INT) AS province_key,
    CAST(state_province_name AS STRING) AS province_name,
    CAST(country_id AS INT) AS country_key
    FROM `vit-lam-data.wide_world_importers.application__state_provinces`
)

, stg_province_final AS (
    SELECT
    province_key,
    province_name,
    country_key
    FROM stg_province

    UNION ALL 
    SELECT 
    0 AS province_key,
    "Undefined" AS province_name,
    0 AS country_key
    
    UNION ALL 
    SELECT 
    -1 AS province_key,
    "ERROR" AS province_name,
    -1 AS country_key
)

SELECT 
    COALESCE(stg_province_final.province_key, 0) AS province_key,
    COALESCE(stg_province_final.province_name, 'Undefined') AS province_name,
    COALESCE(stg_province_final.country_key, 0) AS country_key,
    COALESCE(stg_country.country_name,"Undefined") AS country_name
FROM stg_province_final
LEFT JOIN {{ref('stg_country')}}
ON stg_province_final.country_key = stg_country.country_key
