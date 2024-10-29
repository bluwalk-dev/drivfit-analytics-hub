SELECT
    a.id as rental_contract_id,
    a.name as rental_contract_name,
    a.state as rental_contact_state,
    a.parent_id,
    a.driver_id,
    e.contact_name driver_name,
    f.analytic_account_owner_contact_id customer_id,
    g.contact_name customer_name,
    b.vehicle_id,
    b.vehicle_license_plate,
    b.vehicle_deal_id,
    b.vehicle_deal_name, -- Atenção que talvez tenhamos o mesmo carro em mais do que um deal
    b.vehicle_name,
    c.station_name as start_station,
    d.station_name as end_station,
    a.start_inspection_id,
    a.end_inspection_id,
    a.start_date,
    a.end_date,
    a.start_kms,
    a.end_kms,
    a.active,
    a.rate_base_value as daily_base_price,
    a.protection_daily_value as daily_protection_price,
    a.mileage_value as daily_mileage_price,
    a.mileage_limit as daily_mileage_limit,
    a.mileage_excess as mileage_excess_price,

    -- Transmission and fuel type details
    IFNULL(i.transmission, b.vehicle_transmission) as vehicle_transmission_letter,  -- Letter representing the transmission type
    CASE 
        WHEN IFNULL(i.fuel, b.vehicle_fuel_type_code) = 'D' THEN 'diesel'
        WHEN IFNULL(i.fuel, b.vehicle_fuel_type_code) IN ('E','F') THEN 'electric'
        WHEN IFNULL(i.fuel, b.vehicle_fuel_type_code) = 'H' THEN 'hybrid'
        WHEN IFNULL(i.fuel, b.vehicle_fuel_type_code) = 'L' THEN 'lpg'
        WHEN IFNULL(i.fuel, b.vehicle_fuel_type_code) = 'G' THEN 'gasoline'
        ELSE NULL 
    END as vehicle_fuel_type,
    IFNULL(i.fuel, b.vehicle_fuel_type_code) as vehicle_fuel_letter
    
FROM {{ ref('stg_odoo__rental_contracts') }} a
LEFT JOIN {{ ref('dim_vehicles') }} b ON a.vehicle_id = b.vehicle_id

LEFT JOIN {{ ref('dim_stations') }} c ON a.start_station_id = c.station_id
LEFT JOIN {{ ref('dim_stations') }} d ON a.end_station_id = d.station_id

LEFT JOIN {{ ref('dim_contacts') }} e ON a.driver_id = e.contact_id
LEFT JOIN {{ ref('dim_accounting_analytic_accounts') }} f ON a.billing_account_id = f.analytic_account_id
LEFT JOIN {{ ref('dim_contacts') }} g ON f.analytic_account_owner_contact_id = g.contact_id

LEFT JOIN {{ ref('stg_odoo__rate_bases') }} h ON a.rate_base_id = h.id
LEFT JOIN {{ ref('stg_odoo__vehicle_categories') }} i ON h.vehicle_category_id = i.id  -- Joining with vehicle categories

WHERE a.active is true