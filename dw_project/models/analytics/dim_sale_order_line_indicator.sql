WITH dim_is_undersupply_backordered AS (
    SELECT
        TRUE AS is_undersupply_backordered_boolean,
        "Backordered" AS is_undersupply_backordered
    UNION ALL 

     SELECT
        FALSE AS is_undersupply_backordered_boolean,
        "Available" AS is_undersupply_backordered 
)
SELECT
    FARM_FINGERPRINT(CONCAT(diub.is_undersupply_backordered, ',' , dim_package_type.package_type_key))AS composite_key,
    diub.is_undersupply_backordered_boolean,
    diub.is_undersupply_backordered,
    dim_package_type.package_type_key,
    dim_package_type.package_type_name
FROM dim_is_undersupply_backordered AS diub
CROSS JOIN {{ref('dim_package_type')}} AS dim_package_type
ORDER BY 1,3

-- Tóm tắt cho tôi tại sao phải dùng indicator table?


-- Bây giờ cần phải tạo một compose_key cho bên thằng bảng fact, vì phải có compose_key mới join được 
-- lưu ý khi tạo compose_key bên fact phải chuyển sang String, và phải join theo compose_key của dim_sale_order_line_indicator Dùng FARM_FINERPRINT Như kiểu HASH)
