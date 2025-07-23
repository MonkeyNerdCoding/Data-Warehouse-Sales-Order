WITH stg_color AS (
    SELECT
    CAST(color_id AS INT) AS color_key,
    CAST(color_name AS STRING) AS color_name
    FROM `vit-lam-data.wide_world_importers.warehouse__colors`
)
SELECT 
    COALESCE(color_key,0) AS color_key,
    COALESCE(color_name,'Undefined') AS color_name
FROM stg_color