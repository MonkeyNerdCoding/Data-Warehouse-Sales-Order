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
    FROM vit-lam-data.wide_world_importers.sales__order_lines
)

SELECT 
    COALESCE(fsol.order_line_key, 0) AS order_line_key,
    COALESCE(fsol.order_key, 0) AS order_key,
    COALESCE(fsol.stock_item_key, 0) AS stock_item_key,
    -- COALESCE(fsol.package_type_key, 0) AS package_type_key,
    COALESCE(fsol.quantity, 0) AS quantity,
    COALESCE(fsol.unit_price, 0) AS unit_price,
    COALESCE(fsol.order_picking_completed_when, '1900-01-01') AS order_picking_completed_when,
    COALESCE(fsol.tax_rate,0) AS tax_rate,
   COALESCE( fsol.gross_amount,0) AS gross_amount,
   COALESCE( fsol.tax_amount,0) AS tax_amount,
   COALESCE( fsol.net_amount,0) AS net_amount,
   COALESCE( stgfo.customer_key,0) AS customer_key,
    COALESCE(stgfo.sale_person_key,0) AS sale_person_key,
   COALESCE( stgfo.picked_by_person_key,0) AS picked_by_person_key,
   COALESCE( stgfo.contact_person_key,0) AS contact_person_key,
    COALESCE(stgfo.order_date,'1900-01-01') AS order_date,
    -- COALESCE(stgfo.is_undersupply_backordered,0) AS is_undersupply_backordered, 
    FARM_FINGERPRINT(CONCAT(CAST(stgfo.is_undersupply_backordered AS STRING), ',', CAST(fsol.package_type_key AS STRING))) AS composite_key,

FROM fact_sale_order_line fsol
LEFT JOIN {{ ref('stg_fact_order') }} stgfo
    ON fsol.order_key = stgfo.order_key
    

LEFT JOIN {{ ref('dim_sale_order_line_indicator') }} dsil
    ON FARM_FINGERPRINT(CONCAT(CAST(stgfo.is_undersupply_backordered AS STRING), ',', CAST(fsol.package_type_key AS STRING))) = dsil.composite_key
    AND fsol.package_type_key = dsil.package_type_key