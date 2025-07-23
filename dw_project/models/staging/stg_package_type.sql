WITH stg_package_type AS(
    SELECT 
    CAST(package_type_id AS INT) AS package_type_key,
    CAST(package_type_name AS STRING) AS package_type_name
    FROM `vit-lam-data.wide_world_importers.warehouse__package_types`
)
SELECT 
    COALESCE(package_type_key,0) AS package_type_key,
    COALESCE(package_type_name,'Undefined') AS package_type_name
FROM stg_package_type
