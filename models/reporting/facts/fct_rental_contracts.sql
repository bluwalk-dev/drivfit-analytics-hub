SELECT
    id as rental_contract_id,
    name as rental_contract_name,
    state as rental_contact_state,
    parent_id,
    b.vehicle_license_plate,
    b.vehicle_deal_name, -- Atenção que talvez tenhamos o mesmo carro em mais do que um deal
    b.vehicle_name,
    c.station_name as start_station,
    d.station_name as end_station,
    start_inspection_id,
    end_inspection_id,
    start_date,
    end_date,
    start_kms,
    end_kms,
    active
FROM {{ ref('stg_odoo__rental_contracts') }} a
LEFT JOIN {{ ref('dim_vehicles') }} b ON a.vehicle_id = b.vehicle_id

LEFT JOIN {{ ref('dim_stations') }} c ON a.start_station_id = c.station_id
LEFT JOIN {{ ref('dim_stations') }} d ON a.end_station_id = d.station_id