WITH stg_delivery_method AS (
    SELECT
    CAST(delivery_method_id AS INT) AS delivery_method_key,
    CAST(delivery_method_name AS STRING) AS delivery_method_name
    FROM `vit-lam-data.wide_world_importers.application__delivery_methods`
)
SELECT 
    COALESCE(delivery_method_key,0) AS delivery_method_key,
    COALESCE(delivery_method_name,"Undefined") AS delivery_method_name
FROM stg_delivery_method
