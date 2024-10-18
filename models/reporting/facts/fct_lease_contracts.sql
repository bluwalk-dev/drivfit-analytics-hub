SELECT
    id as lease_contract_id,
    name as lease_contract_name,
    state as lease_contact_state,
    customer_id,
    driver_id,
    b.vehicle_id,
    b.vehicle_license_plate,
    b.vehicle_deal_id,
    b.vehicle_deal_name, -- Atenção que talvez tenhamos o mesmo carro em mais do que um deal
    b.vehicle_name,
    c.station_name as start_station,
    d.station_name as end_station,
    start_inspection_id,
    end_inspection_id,
    CAST(start_date AS DATE) start_date,
    CAST(end_date AS DATE) end_date,
    end_date_estimated,
    start_kms,
    end_kms,
    wk_rent_price,
    wk_included_mileage,
    extra_mileage_price,
    rate_base_id
FROM {{ ref('stg_odoo__lease_contracts') }} a
LEFT JOIN {{ ref('dim_vehicles') }} b ON a.vehicle_id = b.vehicle_id
LEFT JOIN {{ ref('dim_stations') }} c ON a.start_station_id = c.station_id
LEFT JOIN {{ ref('dim_stations') }} d ON a.end_station_id = d.station_id
WHERE active is true