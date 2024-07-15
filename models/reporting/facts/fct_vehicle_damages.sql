SELECT
    a.*, b.vehicle_license_plate, b.vehicle_deal_name
FROM {{ ref('stg_odoo__fleet_vehicle_damage_log') }} a
LEFT JOIN {{ ref('dim_vehicles') }} b ON a.vehicle_id = b.vehicle_id