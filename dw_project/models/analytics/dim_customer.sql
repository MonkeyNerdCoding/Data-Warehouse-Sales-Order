WITH dim_customer_base AS (
    SELECT
        CAST(customer_id AS INT) AS customer_key,
        CAST(customer_name AS STRING) AS customer_name,
        CAST(is_statement_sent AS BOOLEAN) AS is_statement_sent,
        CAST(is_on_credit_hold AS BOOLEAN) AS is_on_credit_hold,
        CAST(credit_limit AS INT) AS credit_limit,
        CAST(standard_discount_percentage AS NUMERIC) AS standard_discount_percentage,
        CAST(account_opened_date AS DATE) AS account_opened_date,
        CAST(payment_days AS INT) AS payment_days,

        CAST(customer_category_id AS INT) AS customer_category_key,
        CAST(buying_group_id AS INT) AS buying_group_key,
        CAST(delivery_method_id AS INT) AS delivery_method_key,
        CAST(delivery_city_id AS INT) AS delivery_city_key,

        CAST(primary_contact_person_id AS INT) AS primary_contact_person_key,
        CAST(alternate_contact_person_id AS INT) AS alternate_contact_person_key,
        CAST(bill_to_customer_id AS INT) AS bill_to_customer_key

    FROM `vit-lam-data.wide_world_importers.sales__customers`
),

dim_customer_cleaned AS (
    SELECT
        customer_key,
        customer_name,
        COALESCE(credit_limit, 0) AS credit_limit,
        COALESCE(standard_discount_percentage, 0) AS standard_discount_percentage,
        COALESCE(account_opened_date, DATE '1900-01-01') AS account_opened_date,
        COALESCE(payment_days, 0) AS payment_days,
        COALESCE(customer_category_key, 0) AS customer_category_key,
        COALESCE(buying_group_key, 0) AS buying_group_key,
        COALESCE(delivery_method_key, 0) AS delivery_method_key,
        COALESCE(delivery_city_key, 0) AS delivery_city_key,
        COALESCE(primary_contact_person_key, 0) AS primary_contact_person_key,
        COALESCE(alternate_contact_person_key, 0) AS alternate_contact_person_key,
        COALESCE(bill_to_customer_key, 0) AS bill_to_customer_key,

        CASE 
            WHEN is_statement_sent IS TRUE THEN "Statement Sent"
            WHEN is_statement_sent IS FALSE THEN "No Statement"
            ELSE "Undefined"
        END AS is_statement_sent,

        CASE 
            WHEN is_on_credit_hold IS TRUE THEN "On Credit Hold"
            WHEN is_on_credit_hold IS FALSE THEN "Not On Credit Hold"
            ELSE "Undefined"
        END AS is_on_credit_hold
    FROM dim_customer_base

    UNION ALL
    SELECT
        0, "Undefined", 0, 0, DATE '1900-01-01', 0, 0, 0, 0, 0, 0, 0, 0,
        "Undefined", "Undefined"

    UNION ALL
    SELECT
        -1, "Error", -1, -1, DATE '1900-01-01', -1, -1, -1, -1, -1, -1, -1, -1,
        "Error", "Error"
),

dim_customer_final AS (
    SELECT
        d.*,

        -- Join buying group name
        bg.buying_group_name,

        -- Join contact person names
        COALESCE(p1.full_name,"Undefined") AS primary_contact_full_name,
        COALESCE(p2.full_name,"Undefined") AS alternate_contact_person_name,
        COALESCE(p3.full_name,"Undefined") AS bill_to_customer_name,

        -- Join delivery method
        COALESCE(dm.delivery_method_name,"Undefined") AS delivery_method_name,
        -- Join city and then province, country
        COALESCE(c.city_name,"Undefined") AS delivery_city_name,
        COALESCE(c.province_name,"Undefined") AS delivery_state_province_name,
        COALESCE(c.country_name,"Undefined") AS delivery_country_name,
        COALESCE(c.province_name,"Undefined") AS postal_state_province_name,
        COALESCE(c.country_name,"Undefined") AS postal_country_name,
        COALESCE(cc.customer_category_name,"Undefined") AS customer_category_name

    FROM dim_customer_cleaned d
    LEFT JOIN {{ ref('stg_buying_group') }} bg ON d.buying_group_key = bg.buying_group_key
    LEFT JOIN {{ ref('dim_person') }} p1 ON d.primary_contact_person_key = p1.person_key
    LEFT JOIN {{ ref('dim_person') }} p2 ON d.alternate_contact_person_key = p2.person_key
    LEFT JOIN {{ ref('dim_person') }} p3 ON d.bill_to_customer_key = p3.person_key
    LEFT JOIN {{ ref('stg_delivery_method') }} dm ON d.delivery_method_key = dm.delivery_method_key
    LEFT JOIN {{ ref('stg_city') }} c ON d.delivery_city_key = c.city_key
    LEFT JOIN {{ref('stg_customer_category')}} cc ON d.customer_category_key = cc.customer_category_key
)

SELECT * FROM dim_customer_final
