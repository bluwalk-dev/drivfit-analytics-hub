SELECT
    c.vehicle_license_plate,
    c.vehicle_model,
    b.station_name,
    b.station_location,
    a.status,
    a.stage
FROM {{ ref('stg_odoo__fleet_vehicles') }} a
LEFT JOIN {{ ref('dim_stations') }} b ON a.station_id = b.station_id
LEFT JOIN {{ ref('dim_vehicles') }} c ON a.id = c.vehicle_id