WITH stg_customer_category AS(
    SELECT
    CAST(customer_category_id AS INT) AS customer_category_key,
    CAST(customer_category_name AS STRING) AS customer_category_name
    FROM `vit-lam-data.wide_world_importers.sales__customer_categories`
)

SELECT 
    COALESCE(customer_category_key,0) AS customer_category_key,
    COALESCE(customer_category_name,"Undefined") AS customer_category_name
FROM stg_customer_category