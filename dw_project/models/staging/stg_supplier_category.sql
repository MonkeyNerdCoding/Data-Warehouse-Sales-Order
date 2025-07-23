WITH stg_supplier_category AS (
    SELECT 
    CAST(supplier_category_id AS INT) AS supplier_category_key,
    CAST(supplier_category_name AS STRING) AS supplier_category_name
    FROM `vit-lam-data.wide_world_importers.purchasing__supplier_categories`
)

SELECT 
    COALESCE(supplier_category_key,0) AS supplier_category_key,
    COALESCE(supplier_category_name,'Undefined') AS supplier_category_name
FROM stg_supplier_category