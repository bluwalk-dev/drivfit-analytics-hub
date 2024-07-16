SELECT
    year_month, 
    vehicle_id, 
    count(*) fleet_days
FROM {{ ref('int_fleet_vehicles_per_day_list') }}
GROUP BY 
    year_month, 
    vehicle_id
ORDER BY vehicle_id, year_month  desc