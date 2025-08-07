WITH stg_color AS (
    SELECT
    CAST(color_id AS INT) AS color_key,
    CAST(color_name AS STRING) AS color_name
    FROM `vit-lam-data.wide_world_importers.warehouse__colors`
),
stg_color_final AS (
    SELECT 
    COALESCE(color_key,0) AS color_key,
    COALESCE(color_name,'Undefined') AS color_name
    FROM stg_color

    UNION ALL
    SELECT 
    -0 AS color_key,
    "Undefined" AS color_name

    UNION ALL 
    SELECT 
    -1 AS color_key,
    "ERROR" AS color_name
)
    
SELECT
    color_key,
    color_name
FROM stg_color_final
