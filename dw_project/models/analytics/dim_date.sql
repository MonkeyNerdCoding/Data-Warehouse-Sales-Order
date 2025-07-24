SELECT
  FORMAT_DATE('%a', d) AS day_of_week_short,        -- Mon, Tue, ...
  FORMAT_DATE('%A', d) AS day_of_week,              -- Monday, Tuesday, ...
  CASE 
    WHEN EXTRACT(DAYOFWEEK FROM d) IN (1, 7) THEN 'Weekend'
    ELSE 'Weekday'
  END AS is_weekday_or_weekend,                     -- Weekday / Weekend
  DATE_TRUNC(d, MONTH) AS year_month,               -- 2022-02-01
  FORMAT_DATE('%B', d) AS month,                    -- January, February
  DATE_TRUNC(d, YEAR) AS year,                      -- 2022-01-01
  EXTRACT(YEAR FROM d) AS year_number,              -- 2022
  EXTRACT(QUARTER FROM d) AS quarter_number         -- 1, 2, 3, 4
FROM
  UNNEST(GENERATE_DATE_ARRAY('2010-01-01', '2030-12-31', INTERVAL 1 DAY)) AS d
