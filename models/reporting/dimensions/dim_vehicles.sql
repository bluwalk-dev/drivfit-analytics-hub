select
    id as vehicle_id,
    license_plate as vehicle_license_plate,
    b.vehicle_deal_name,
    vin_sn as vehicle_vin,
    c.vehicle_name,
    c.vehicle_brand,
    c.vehicle_model,
    vehicle_model_version as vehicle_model_version,
    c.vehicle_model_id,
    c.vehicle_brand_id,
    fuel_type as vehicle_fuel,
    transmission as vehicle_transmission,
    a.billing_account_id analytic_account_id
FROM {{ ref('stg_odoo__fleet_vehicles') }} a
LEFT JOIN {{ ref('dim_vehicle_deals') }} b ON a.deal_id = b.vehicle_deal_id
LEFT JOIN {{ ref('dim_vehicle_models') }} c ON a.model_id = c.vehicle_model_id