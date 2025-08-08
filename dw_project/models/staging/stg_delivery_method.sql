WITH stg_delivery_method AS (
    SELECT
    CAST(delivery_method_id AS INT) AS delivery_method_key,
    CAST(delivery_method_name AS STRING) AS delivery_method_name
    FROM `vit-lam-data.wide_world_importers.application__delivery_methods`
)

, stg_delivery_method_final AS (
    SELECT
    delivery_method_key,
    delivery_method_name
    FROM stg_delivery_method
    
    UNION ALL 
    SELECT 
    0 AS delivery_method_key,
    "Undefined" AS delivery_method_name

    UNION ALL 
    SELECT 
    -1 AS delivery_method_key,
    "ERROR" AS delivery_method_name
)
SELECT 
    COALESCE(delivery_method_key, 0) AS delivery_method_key,
    COALESCE(delivery_method_name, 'Undefined') AS delivery_method_name
FROM stg_delivery_method_final
