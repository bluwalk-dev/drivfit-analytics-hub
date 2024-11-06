WITH first_sunday AS (
  SELECT 
    date,
    FORMAT_DATE('%Y%m', DATE_SUB(DATE_TRUNC(date, MONTH), INTERVAL 1 MONTH)) AS closing_month,
    DATE_ADD(
      DATE_TRUNC(date, MONTH), 
      INTERVAL MOD(1 + (7 - EXTRACT(DAYOFWEEK FROM DATE_TRUNC(date, MONTH))), 7) DAY
    ) AS first_next_sunday,
    DATE_TRUNC(date, WEEK(MONDAY)) AS week_start_date,
    LAST_DAY(DATE_SUB(date, INTERVAL 1 MONTH)) AS month_end_date
  FROM {{ ref('util_calendar') }}
  WHERE 
    EXTRACT(DAY FROM date) = 1
)

SELECT 
  closing_month,
  week_start_date,
  month_end_date,
  first_next_sunday,
  (7 - EXTRACT(DAY FROM first_next_sunday))/7 AS share_this_month,
  7 - EXTRACT(DAY FROM first_next_sunday) AS days_this_month,
  (EXTRACT(DAY FROM first_next_sunday))/7 AS share_next_month,
  EXTRACT(DAY FROM first_next_sunday) AS days_next_month
FROM first_sunday
WHERE EXTRACT(DAY FROM first_next_sunday) < 7
ORDER BY closing_month