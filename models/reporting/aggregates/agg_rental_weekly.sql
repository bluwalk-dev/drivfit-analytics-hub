SELECT
    year_week,
    COUNT(DISTINCT date) AS nr_days,
    SUM(rental_days) AS rental_days,
    ROUND(SUM(rental_days) / COUNT(DISTINCT date),2) as fleet_size
FROM {{ ref('agg_rental_daily') }}
GROUP BY year_week
ORDER BY year_week DESC