SELECT
    a.id,
    a.name,
    a.active,
    a.start_date,
    a.expiration_date as end_date,
    a.state,
    c.*
FROM {{ ref('stg_odoo__fleet_vehicle_log_contracts') }} a
LEFT JOIN {{ ref('stg_odoo__fleet_vehicle_costs') }} b ON a.cost_id = b.id
LEFT JOIN {{ ref('dim_vehicles') }} c ON b.vehicle_id = c.vehicle_id