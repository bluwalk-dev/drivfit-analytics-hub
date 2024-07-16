WITH best_step AS (
    SELECT
        vehicle_id,
        vehicle_deal_id,
        year_month,
        cumulated_fleet_days,
        step_km,
        total_cost,
        ROW_NUMBER() OVER (PARTITION BY vehicle_id, year_month ORDER BY total_cost) AS rn
    FROM {{ ref('int_fleet_vehicles_renting_step_cost') }}
)

SELECT
    a.vehicle_id,
    a.vehicle_deal_id,
    b.start_date,
    b.end_date,
    a.year_month,
    a.step_km AS best_step,
    a.total_cost - COALESCE(LAG(a.total_cost) OVER (PARTITION BY a.vehicle_id ORDER BY a.year_month), 0) AS cost
FROM best_step a
LEFT JOIN {{ ref('util_month_intervals') }} b ON a.year_month = b.year_month
WHERE rn = 1
ORDER BY
    vehicle_id DESC, year_month DESC