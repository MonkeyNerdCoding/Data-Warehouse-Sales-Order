WITH base_dates AS (
  SELECT
    d AS date_key,
    FORMAT_DATE('%a', d) AS day_of_week_short,
    FORMAT_DATE('%A', d) AS day_of_week,
    CASE 
      WHEN EXTRACT(DAYOFWEEK FROM d) IN (1, 7) THEN 'Weekend'
      ELSE 'Weekday'
    END AS is_weekday_or_weekend,
    DATE_TRUNC(d, MONTH) AS year_month,                     -- DATE
    FORMAT_DATE('%B', d) AS month,                          -- STRING
    DATE_TRUNC(d, YEAR) AS year,                            -- DATE
    EXTRACT(YEAR FROM d) AS year_number,                    -- INT64
    EXTRACT(QUARTER FROM d) AS quarter_number               -- INT64
  FROM UNNEST(GENERATE_DATE_ARRAY('2010-01-01', '2030-12-31', INTERVAL 1 DAY)) AS d
),

special_dates AS (
  SELECT 
    DATE '1900-01-01' AS date_key,
    'N/A' AS day_of_week_short,
    'Undefined' AS day_of_week,
    'Undefined' AS is_weekday_or_weekend,
    CAST(NULL AS DATE) AS year_month,
    CAST(NULL AS STRING) AS month,
    CAST(NULL AS DATE) AS year,
    CAST(NULL AS INT64) AS year_number,
    CAST(NULL AS INT64) AS quarter_number
  UNION ALL
  SELECT 
    DATE '1900-02-01',
    'N/A',
    'Error',
    'Error',
    CAST(NULL AS DATE),
    CAST(NULL AS STRING),
    CAST(NULL AS DATE),
    CAST(NULL AS INT64),
    CAST(NULL AS INT64)
)

SELECT *
FROM base_dates
UNION ALL
SELECT *
FROM special_dates
ORDER BY date_key
