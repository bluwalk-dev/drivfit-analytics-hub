WITH source_table AS (
  SELECT 
    start_date, 
    IFNULL(end_date, CURRENT_DATE()) AS end_date, 
    vehicle_id,
    vehicle_deal_id, 
    vehicle_deal_name,
    daily_base_price * 7 AS base_price 
  FROM {{ ref('fct_rental_contracts') }}
),

DateDifference AS (
  SELECT
    vehicle_deal_id,
    base_price,
    start_date,
    end_date,
    TIMESTAMP_DIFF(CAST(end_date AS TIMESTAMP), CAST(start_date AS TIMESTAMP), DAY) AS duration_days,
    GENERATE_DATE_ARRAY(CAST(start_date AS DATE), CAST(end_date AS DATE)) AS date_range
  FROM source_table
  WHERE 
    CAST(IFNULL(end_date, CURRENT_DATE()) AS DATE) > CAST(start_date AS DATE)
    AND TIMESTAMP_DIFF(CAST(end_date AS TIMESTAMP), CAST(start_date AS TIMESTAMP), DAY) > 0
),

FlattenedDates AS (
  SELECT
    vehicle_deal_id,
    base_price,
    date AS single_date
  FROM DateDifference, UNNEST(date_range) AS date
)

SELECT
  vehicle_deal_id,
  single_date AS date,
  AVG(base_price) AS avg_base_price
FROM FlattenedDates
WHERE vehicle_deal_id IS NOT NULL
GROUP BY
  vehicle_deal_id,
  date
ORDER BY
  vehicle_deal_id,
  date