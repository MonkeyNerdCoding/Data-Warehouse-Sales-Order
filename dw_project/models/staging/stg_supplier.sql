WITH stg_supplier AS (
    SELECT 
    CAST(supplier_id AS INT) AS supplier_key,
    CAST(supplier_name AS STRING) AS supplier_name,
    CAST(supplier_category_id AS INT) AS supplier_category_key
    FROM `vit-lam-data.wide_world_importers.purchasing__suppliers`
)

, stg_supplier_final AS (
    SELECT 
    supplier_key,
    supplier_name,
    supplier_category_key
    FROM stg_supplier
    
    UNION ALL 
    SELECT 
    0 AS supplier_key,
    "Undefined" AS supplier_name,
    0 AS supplier_category_key

    UNION ALL 
    SELECT 
    -1 AS supplier_key,
    "ERROR" AS supplier_name,
    0 AS supplier_category_key
)
SELECT 
    COALESCE(stgs.supplier_key, 0) AS supplier_key,
    COALESCE(stgs.supplier_name, 'Undefined') AS supplier_name,
    COALESCE(stgs.supplier_category_key, 0) AS supplier_category_key,
    COALESCE(stgsc.supplier_category_name, 'Undefined') AS supplier_category_name
FROM stg_supplier_final stgs
LEFT JOIN {{ref('stg_supplier_category')}} stgsc
on stgs.supplier_category_key = stgsc.supplier_category_key
