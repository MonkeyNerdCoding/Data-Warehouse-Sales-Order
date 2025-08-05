WITH stg_customer_category AS(
    SELECT
    CAST(customer_category_id AS INT) AS customer_category_key,
    CAST(customer_category_name AS STRING) AS customer_category_name
    FROM `vit-lam-data.wide_world_importers.sales__customer_categories`

    UNION ALL
    SELECT 
    0 AS customer_category_key,
    "Undefined" AS customer_category_name

    UNION ALL 
    SELECT 
    -1 AS customer_category_key,
    "ERROR" AS customer_category_name
)

SELECT 
    customer_category_key,
    customer_category_name
FROM stg_customer_category