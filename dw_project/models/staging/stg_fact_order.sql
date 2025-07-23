WITH stg_fact_order AS (
  SELECT
    CAST(order_id AS INT) AS order_key,
    CAST(customer_id AS INT) AS customer_key,
    CAST(salesperson_person_id AS INT) AS sale_person_key,
    CAST(picked_by_person_id AS INT) AS picked_by_person_key,
    CAST(contact_person_id AS INT) AS contact_person_key,
    CAST(order_date AS DATE) AS order_date,
    CAST(is_undersupply_backordered AS BOOLEAN) AS is_undersupply_backordered
  FROM
    `vit-lam-data.wide_world_importers.sales__orders`
),stg_fact_order_converted_boolean AS (
    SELECT 
    order_key,
    customer_key,
    sale_person_key,
    picked_by_person_key,
    contact_person_key,
    order_date,
    CASE 
      WHEN is_undersupply_backordered IS TRUE THEN "Backordered"
      WHEN is_undersupply_backordered IS FALSE THEN "Available" 
    END AS is_undersupply_backordered
  FROM stg_fact_order
)

SELECT
    order_key,
    COALESCE(customer_key,0) AS customer_key,
    COALESCE(sale_person_key,0) AS sale_person_key,
    COALESCE(picked_by_person_key,0) AS picked_by_person_key,
    COALESCE(contact_person_key,0) AS contact_person_key,
    order_date,
    is_undersupply_backordered
FROM
  stg_fact_order_converted_boolean
