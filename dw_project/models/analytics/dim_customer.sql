WITH dim_customer_base AS (
    SELECT
        CAST(customer_id AS INT) AS customer_key,
        CAST(customer_name AS STRING) AS customer_name,
        CAST(credit_limit AS INT) AS credit_limit,
        CAST(standard_discount_percentage AS FLOAT64) AS standard_discount_percentage,
        CAST(account_opened_date AS DATE) AS account_opened_date,
        CAST(payment_days AS INT) AS payment_days,
        CAST(customer_category_id AS INT) AS customer_category_key,
        CAST(buying_group_id AS INT) AS buying_group_key,
        CAST(delivery_method_id AS INT) AS delivery_method_key,
        CAST(delivery_city_id AS INT) AS delivery_city_key,
        CAST(postal_city_id AS INT) AS postal_city_key,                             -- ✅ THÊM DÒNG NÀY
        CAST(primary_contact_person_id AS INT) AS primary_contact_person_key,
        CAST(alternate_contact_person_id AS INT) AS alternate_contact_person_key,
        CAST(bill_to_customer_id AS INT) AS bill_to_customer_key,
        is_statement_sent,
        is_on_credit_hold
    FROM `vit-lam-data.wide_world_importers.sales__customers`
),

dim_customer_boolean_converted AS (
    SELECT
        customer_key,
        customer_name,
        credit_limit,
        standard_discount_percentage,
        account_opened_date,
        payment_days,
        customer_category_key,
        buying_group_key,
        delivery_method_key,
        delivery_city_key,
        postal_city_key,                         -- ✅ THÊM DÒNG NÀY
        primary_contact_person_key,
        alternate_contact_person_key,
        bill_to_customer_key,
        CASE 
            WHEN is_statement_sent = TRUE THEN "Statement Sent"
            WHEN is_statement_sent = FALSE THEN "Not Statement Sent"
            ELSE "Undefined"
        END AS is_statement_sent,
        CASE 
            WHEN is_on_credit_hold = TRUE THEN "On Credit Hold"
            WHEN is_on_credit_hold = FALSE THEN "Not On Credit Hold"
            ELSE "Undefined"
        END AS is_on_credit_hold
    FROM dim_customer_base
),

dim_customer_final AS (
    SELECT 
        customer_key,
        customer_name,
        credit_limit,
        standard_discount_percentage,
        account_opened_date,
        payment_days,
        customer_category_key,
        buying_group_key,
        delivery_method_key,
        delivery_city_key,
        postal_city_key,                         -- ✅ THÊM DÒNG NÀY
        primary_contact_person_key,
        alternate_contact_person_key,
        bill_to_customer_key,
        is_statement_sent,
        is_on_credit_hold
    FROM dim_customer_boolean_converted

    UNION ALL
    SELECT
        0 AS customer_key,
        "Undefined" AS customer_name,
        0 AS credit_limit,
        0 AS standard_discount_percentage,
        DATE '1900-01-01' AS account_opened_date,
        0 AS payment_days,
        0 AS customer_category_key,
        0 AS buying_group_key,
        0 AS delivery_method_key,
        0 AS delivery_city_key,
        0 AS postal_city_key,                   -- ✅ THÊM DÒNG NÀY
        0 AS primary_contact_person_key,
        0 AS alternate_contact_person_key,
        0 AS bill_to_customer_key,
        "Undefined" AS is_statement_sent,
        "Undefined" AS is_on_credit_hold

    UNION ALL
    SELECT
        -1 AS customer_key,
        "Error" AS customer_name,
        -1 AS credit_limit,
        -1 AS standard_discount_percentage,
        DATE '1900-01-01' AS account_opened_date,
        -1 AS payment_days,
        -1 AS customer_category_key,
        -1 AS buying_group_key,
        -1 AS delivery_method_key,
        -1 AS delivery_city_key,
        -1 AS postal_city_key,                  -- ✅ THÊM DÒNG NÀY
        -1 AS primary_contact_person_key,
        -1 AS alternate_contact_person_key,
        -1 AS bill_to_customer_key,
        "Error" AS is_statement_sent,
        "Error" AS is_on_credit_hold
),

dim_customer_enriched AS (
    SELECT 
        COALESCE(d.customer_key, 0) AS customer_key,
        COALESCE(d.customer_name, 'Undefined') AS customer_name,
        COALESCE(d.credit_limit, 0) AS credit_limit,
        COALESCE(d.standard_discount_percentage, 0) AS standard_discount_percentage,
        COALESCE(d.account_opened_date, '1900-01-01') AS account_opened_date,
        COALESCE(d.payment_days, 0) AS payment_days,
        COALESCE(d.customer_category_key, 0) AS customer_category_key,
        COALESCE(d.buying_group_key, 0) AS buying_group_key,
        COALESCE(d.delivery_method_key, 0) AS delivery_method_key,
        COALESCE(d.delivery_city_key, 0) AS delivery_city_key,
        COALESCE(d.postal_city_key, 0) AS postal_city_key,
        COALESCE(d.primary_contact_person_key, 0) AS primary_contact_person_key,
        COALESCE(d.alternate_contact_person_key, 0) AS alternate_contact_person_key,
        COALESCE(d.bill_to_customer_key, 0) AS bill_to_customer_key,
        COALESCE(d.is_statement_sent, 'Undefined') AS is_statement_sent,
        COALESCE(d.is_on_credit_hold, 'Undefined') AS is_on_credit_hold,

        -- -- Join contact person names
        COALESCE(p1.full_name, 'Undefined') AS primary_contact_full_name,
        COALESCE(p2.full_name, 'Undefined') AS alternate_contact_person_name,
        COALESCE(p3.full_name, 'Undefined') AS bill_to_customer_name,

         -- Join delivery method
        COALESCE(dm.delivery_method_name, 'Undefined') AS delivery_method_name,

        COALESCE(c1.city_name, 'Undefined') AS delivery_city_name,
        COALESCE(c1.province_name, 'Undefined') AS delivery_state_province_name,      -- ✅ SỬA DÙNG c1
        COALESCE(c1.country_name, 'Undefined') AS delivery_country_name,              -- ✅ SỬA DÙNG c1
        COALESCE(c1.state_province_key, 0) AS delivery_state_province_key,
        COALESCE(c1.country_key, 0) AS delivery_country_key,
        COALESCE(c2.province_name, 'Undefined') AS postal_state_province_name,        -- ✅ SỬA DÙNG c2
        COALESCE(c2.country_name, 'Undefined') AS postal_country_name,                 -- ✅ SỬA DÙNG c2

        cc.customer_category_name AS customer_category_name
    FROM dim_customer_final d
    
    LEFT JOIN {{ ref('stg_city') }} c1 
        ON d.delivery_city_key = c1.city_key
    LEFT JOIN {{ ref('stg_city') }} c2 
        ON d.postal_city_key = c2.city_key

    LEFT JOIN {{ ref('stg_buying_group') }} bg ON d.buying_group_key = bg.buying_group_key

    LEFT JOIN {{ ref('dim_person') }} p1 ON d.primary_contact_person_key = p1.person_key
    LEFT JOIN {{ ref('dim_person') }} p2 ON d.alternate_contact_person_key = p2.person_key
    LEFT JOIN {{ ref('dim_person') }} p3 ON d.bill_to_customer_key = p3.person_key
    LEFT JOIN {{ref('stg_customer_category')}} cc ON d.customer_category_key = cc.customer_category_key

    LEFT JOIN {{ ref('stg_delivery_method') }} dm ON d.delivery_method_key = dm.delivery_method_key


)

SELECT * FROM dim_customer_enriched
