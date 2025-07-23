WITH stg_supplier AS (
    SELECT 
    CAST(supplier_id AS INT) AS supplier_key,
    CAST(supplier_name AS STRING) AS supplier_name,
    CAST(supplier_category_id AS INT) AS supplier_category_key
    FROM `vit-lam-data.wide_world_importers.purchasing__suppliers`
)
SELECT 
    COALESCE(stgs.supplier_key,0) AS supplier_key,
    COALESCE(stgs.supplier_name,'Undefined') AS supplier_name,
    COALESCE(stgs.supplier_category_key,0) AS supplier_category_key,
    stgsc.supplier_category_name AS supplier_category_name
FROM stg_supplier stgs
LEFT JOIN {{ref('stg_supplier_category')}} stgsc
on stgs.supplier_category_key = stgsc.supplier_category_key
