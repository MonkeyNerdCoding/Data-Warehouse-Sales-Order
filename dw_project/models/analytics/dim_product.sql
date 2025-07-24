WITH dim_product AS (
    SELECT
        CAST(stock_item_id AS INT) AS stock_item_key,
        CAST(stock_item_name AS STRING) AS stock_item_name,
        CAST(supplier_id AS INT) AS supplier_key, 
        CAST(unit_package_id AS INT) AS unit_package_key,
        CAST(outer_package_id AS INT) AS outer_package_key,
        CAST(color_id AS INT) AS color_key,
        CAST(lead_time_days AS INT) AS lead_time_days,
        CAST(quantity_per_outer AS INT) AS quantity,
        CAST(is_chiller_stock AS BOOLEAN) AS is_chiller_stock,
        CAST(unit_price AS NUMERIC) AS unit_price,
        CAST(tax_rate AS NUMERIC) AS tax_rate,
        CAST(brand AS STRING) AS brand,
        CAST(size AS STRING) AS size,
        CAST(recommended_retail_price AS NUMERIC) AS recommended_retail_price,
        CAST(barcode AS STRING) AS barcode
    FROM `vit-lam-data.wide_world_importers.warehouse__stock_items`

), dim_product_boolean_converted AS (
    SELECT
        stock_item_key,
        stock_item_name,
        supplier_key,
        unit_package_key,
        outer_package_key,
        color_key,
        lead_time_days,
        quantity,
        unit_price,
        tax_rate,
        brand,
        size,
        recommended_retail_price,
        barcode,
        CASE 
            WHEN is_chiller_stock IS TRUE THEN "Chiller Stock"
            WHEN is_chiller_stock IS FALSE THEN "Non-Chiller Stock"
            ELSE "Undefined"
        END AS is_chiller_stock
    FROM dim_product

), dim_product_final AS (
    SELECT
        COALESCE(dp.stock_item_key, 0) AS stock_item_key,
        COALESCE(dp.stock_item_name, "Undefined") AS stock_item_name,
        COALESCE(dp.supplier_key, 0) AS supplier_key,
        COALESCE(dp.unit_package_key, 0) AS unit_package_key,
        COALESCE(dp.outer_package_key, 0) AS outer_package_key,
        COALESCE(dp.color_key, 0) AS color_key,
        COALESCE(dp.lead_time_days, 0) AS lead_time_days,
        COALESCE(dp.quantity, 0) AS quantity,
        COALESCE(dp.unit_price, 0) AS unit_price,
        COALESCE(dp.tax_rate, 0) AS tax_rate,
        COALESCE(dp.brand, "Undefined") AS brand,
        COALESCE(dp.size, "Undefined") AS size,
        COALESCE(dp.recommended_retail_price, 0) AS recommended_retail_price,
        COALESCE(dp.barcode, "Undefined") AS barcode,
        COALESCE(dp.is_chiller_stock, "Undefined") AS is_chiller_stock
    FROM dim_product_boolean_converted dp

    UNION ALL

    SELECT
        0 AS stock_item_key,
        "Undefined" AS stock_item_name,
        0 AS supplier_key,
        0 AS unit_package_key,
        0 AS outer_package_key,
        0 AS color_key,
        0 AS lead_time_days,
        0 AS quantity,
        0 AS unit_price,
        0 AS tax_rate,
        "Undefined" AS brand,
        "Undefined" AS size,
        0 AS recommended_retail_price,
        "Undefined" AS barcode,
        "Undefined" AS is_chiller_stock
    UNION ALL 
    SELECT 
        -1 AS stock_item_key,
        "Undefined" AS stock_item_name,
        -1 AS supplier_key,
        -1 AS unit_package_key,
        -1 AS outer_package_key,
        -1 AS color_key,
        -1 AS lead_time_days,
        -1 AS quantity,
        -1 AS unit_price,
        -1 AS tax_rate,
        "Undefined" AS brand,
        "Undefined" AS size,
        -1 AS recommended_retail_price,
        "Undefined" AS barcode,
        "Undefined" AS is_chiller_stock
    
)

SELECT
    dpf.*,
    stgs.supplier_name,
    stgs.supplier_category_key,
    stgs.supplier_category_name,
    stgpt.package_type_name AS unit_package_name,
    stgopt.package_type_name AS outer_package_name,
    stgcol.color_name
FROM dim_product_final dpf
LEFT JOIN {{ref('stg_supplier')}} stgs
    ON dpf.supplier_key = stgs.supplier_key
LEFT JOIN {{ref('stg_package_type')}} stgpt
    ON dpf.unit_package_key = stgpt.package_type_key
LEFT JOIN {{ref('stg_package_type')}} stgopt
    ON dpf.outer_package_key = stgopt.package_type_key
LEFT JOIN {{ref('stg_color')}} stgcol
    ON dpf.color_key = stgcol.color_key
