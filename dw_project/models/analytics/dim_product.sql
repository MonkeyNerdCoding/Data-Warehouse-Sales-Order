WITH dim_product AS(
    SELECT
    CAST(stock_item_id AS INT) AS stock_item_key,
    CAST(stock_item_name AS STRING) AS stock_item_name,
    FROM `vit-lam-data.wide_world_importers.warehouse__stock_items`
    
)

SELECT
    *
FROM
    dim_product
