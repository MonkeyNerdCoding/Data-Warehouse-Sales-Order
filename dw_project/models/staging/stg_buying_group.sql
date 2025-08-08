WITH stg_buying_group AS (
    SELECT 
    CAST(buying_group_id AS INT) AS buying_group_key,
    CAST(buying_group_name AS STRING) AS buying_group_name
    FROM `vit-lam-data.wide_world_importers.sales__buying_groups`
), stg_buying_group_final AS (
    SELECT 
    COALESCE(buying_group_key, 0) AS buying_group_key,
    COALESCE(buying_group_name, "Undefined") AS buying_group_name
    FROM stg_buying_group

    UNION ALL 
    SELECT 
    0 AS buying_group_key,
    "Undefined" AS buying_group_name

    UNION ALL 
    SELECT 
    -1 AS buying_group_key,
    "ERROR" AS buying_group_name
)
SELECT *
FROM stg_buying_group_final