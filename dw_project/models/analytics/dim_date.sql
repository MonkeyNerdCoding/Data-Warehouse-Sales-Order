WITH date_range AS (
  SELECT 
    MIN(order_date) AS min_date,
    MAX(order_date) AS max_date
  FROM {{ ref('stg_fact_order') }}
  WHERE EXTRACT(YEAR FROM order_date) > 1900
),
dates AS (
  SELECT day
  FROM UNNEST(GENERATE_DATE_ARRAY(
      (SELECT min_date FROM date_range),
      (SELECT max_date FROM date_range),
      INTERVAL 1 DAY
  )) AS day
  UNION ALL 
  SELECT DATE '1900-01-01'
  UNION ALL 
  SELECT DATE '1900-02-01'
)
SELECT
  CAST(FORMAT_DATE('%Y%m%d', day) AS INT64) AS date_key,
  day AS full_date,
  EXTRACT(DAY FROM day) AS day_of_month,
  EXTRACT(MONTH FROM day) AS month,
  FORMAT_DATE('%B', day) AS month_name,
  EXTRACT(QUARTER FROM day) AS quarter,
  EXTRACT(YEAR FROM day) AS year,
  FORMAT_DATE('%A', day) AS day_name,
  EXTRACT(DAYOFWEEK FROM day) AS day_of_week,
  CASE 
    WHEN EXTRACT(DAYOFWEEK FROM day) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS day_type,
  EXTRACT(WEEK FROM day) AS week_of_year
FROM dates
ORDER BY full_date
