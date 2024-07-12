SELECT
    date,
    vehicle_deal_name,
    count(*) fleet_size
FROM {{ ref('int_fleet_vehicles_per_day_list') }}
GROUP BY date, vehicle_deal_name
ORDER BY date DESC