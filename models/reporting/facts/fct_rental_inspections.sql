SELECT
    id as inspection_id,
    state,
    driver_id,
    vehicle_id,
    rental_contract_id,
    date,
    inspection_kms
FROM {{ ref('stg_odoo__fleet_vehicle_inspections') }}