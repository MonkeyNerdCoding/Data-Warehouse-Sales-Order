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
)
SELECT
  *
FROM
  stg_fact_order