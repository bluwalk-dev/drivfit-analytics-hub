SELECT
    a.id as booking_id,
    a.name as booking_name,
    a.state as booking_state,
    a.booking_type,
    a.active,
    a.driver_id,
    e.contact_name as driver_name,
    a.client_id as customer_id,
    g.contact_name customer_name,
    b.vehicle_id,
    b.vehicle_license_plate,
    b.vehicle_deal_id,
    b.vehicle_deal_name, -- Atenção que talvez tenhamos o mesmo carro em mais do que um deal
    b.vehicle_name,

    a.start_station_id as booking_pickup_station,
    c.station_name,
    
    a.rate_base_id,
    a.rate_mileage_id,
    a.mileage_limit,
    a.mileage_excess,
    a.rate_protection_id
    
FROM {{ ref('stg_odoo__bookings') }} a
LEFT JOIN {{ ref('dim_vehicles') }} b ON a.vehicle_id = b.vehicle_id
LEFT JOIN {{ ref('dim_stations') }} c ON a.start_station_id = c.station_id
LEFT JOIN {{ ref('dim_contacts') }} e ON a.driver_id = e.contact_id
LEFT JOIN {{ ref('dim_contacts') }} g ON a.client_id = g.contact_id
LEFT JOIN {{ ref('stg_odoo__rate_bases') }} h ON a.rate_base_id = h.id
LEFT JOIN {{ ref('stg_odoo__vehicle_categories') }} i ON h.vehicle_category_id = i.id  -- Joining with vehicle categories