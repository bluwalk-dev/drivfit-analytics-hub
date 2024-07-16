WITH daily_odometer AS (
    SELECT
        vehicle_id,
        DATE(date) AS date,
        value odometer,
        ROW_NUMBER() OVER (PARTITION BY vehicle_id, DATE(date) ORDER BY date DESC) AS rn
    FROM {{ ref('stg_odoo__fleet_vehicle_odometer') }}
)
SELECT
    a.date,
    b.year_month,
    a.vehicle_id,
    a.odometer
FROM daily_odometer a
LEFT JOIN {{ ref('util_calendar') }} b ON a.date = b.date
WHERE rn = 1