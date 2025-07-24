WITH stg_city AS (
    SELECT
    CAST(city_id AS INT) AS city_key,
    CAST(city_name AS STRING) AS city_name,
    CAST(state_province_id AS INT) AS state_province_key
    FROM `vit-lam-data.wide_world_importers.application__cities`
)

SELECT 
    COALESCE(stg_city.city_key,0) AS city_key,
    COALESCE(stg_city.city_name,"Undefined") AS city_name,
    COALESCE(stg_city.state_province_key,0) AS state_province_key,
    COALESCE(stg_province.province_name,"Undefined") AS province_name,
    COALESCE(stg_province.country_key,0) AS country_key,
    COALESCE(stg_province.country_name,"Undefined") AS country_name
FROM stg_city
LEFT JOIN {{ref('stg_province')}}
ON stg_city.state_province_key = stg_province.province_key