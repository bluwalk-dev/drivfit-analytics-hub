SELECT
    id as rental_contract_id,
    name as rental_contract_name,
    state as rental_contact_state,
    parent_id,
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
    start_inspection_id,
    end_inspection_id,
    start_date,
    end_date,
    start_kms,
    end_kms,
    active,
    rate_base_value as daily_base_price
FROM {{ ref('stg_odoo__rental_contracts') }} a
LEFT JOIN {{ ref('dim_vehicles') }} b ON a.vehicle_id = b.vehicle_id

LEFT JOIN {{ ref('dim_stations') }} c ON a.start_station_id = c.station_id
LEFT JOIN {{ ref('dim_stations') }} d ON a.end_station_id = d.station_id

LEFT JOIN {{ ref('dim_contacts') }} e ON a.driver_id = e.contact_id
LEFT JOIN {{ ref('dim_accounting_analytic_accounts') }} f ON a.billing_account_id = f.analytic_account_id
LEFT JOIN {{ ref('dim_contacts') }} g ON f.analytic_account_owner_contact_id = g.contact_id