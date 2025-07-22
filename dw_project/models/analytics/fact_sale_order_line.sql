WITH fact_sale_order_line AS (
    SELECT 
        CAST(order_line_id AS INT) AS order_line_key,
        CAST(order_id AS INT) AS order_key,
        CAST(stock_item_id AS INT) AS stock_item_key,
        CAST(package_type_id AS INT) AS package_type_key,
        CAST(quantity AS INT) AS quantity,
        CAST(unit_price AS NUMERIC) AS unit_price,
        CAST(picking_completed_when AS DATETIME) AS order_picking_completed_when,
        CAST(tax_rate AS NUMERIC) AS tax_rate,
        quantity * unit_price AS gross_amount,
        quantity * unit_price * tax_rate AS tax_amount,
        quantity * unit_price - quantity * unit_price * tax_rate AS net_amount
    FROM `vit-lam-data.wide_world_importers.sales__order_lines`
)

SELECT 
    fsol.*, 
    stgfo.customer_key,
    stgfo.sale_person_key,
    stgfo.picked_by_person_key,
    stgfo.contact_person_key,
    stgfo.order_date,
    stgfo.is_undersupply_backordered
FROM fact_sale_order_line fsol
LEFT JOIN {{ ref('stg_fact_order') }} stgfo
    ON fsol.order_key = stgfo.order_key
