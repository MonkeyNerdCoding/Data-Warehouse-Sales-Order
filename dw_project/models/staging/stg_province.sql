WITH stg_province AS (
    SELECT
    CAST(state_province_id AS INT) AS province_key,
    CAST(state_province_name AS STRING) AS province_name,
    CAST(country_id AS INT) AS country_key
    FROM `vit-lam-data.wide_world_importers.application__state_provinces`
)

SELECT 
    COALESCE(stg_province.province_key,0) AS province_key,
    COALESCE(stg_province.province_name,"Undefined") AS province_name,
    COALESCE(stg_province.country_key,0) AS country_key,
    COALESCE(stg_country.country_name,"Undefined") AS country_name
FROM stg_province
LEFT JOIN {{ref('stg_country')}}
ON stg_province.country_key = stg_country.country_key
