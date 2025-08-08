WITH stg_supplier_category AS (
    SELECT 
    CAST(supplier_category_id AS INT) AS supplier_category_key,
    CAST(supplier_category_name AS STRING) AS supplier_category_name
    FROM `vit-lam-data.wide_world_importers.purchasing__supplier_categories`
)

, stg_supplier_category_final AS (
    SELECT 
    supplier_category_key,
    supplier_category_name
    FROM stg_supplier_category
    
    UNION ALL 
    SELECT 
    0 AS supplier_category_key,
    "Undefined" AS supplier_category_name

    UNION ALL 
    SELECT 
    -1 AS supplier_category_key,
    "ERROR" AS supplier_category_name
)

SELECT 
    COALESCE(supplier_category_key, 0) AS supplier_category_key,
    COALESCE(supplier_category_name, 'Undefined') AS supplier_category_name
FROM stg_supplier_category_final