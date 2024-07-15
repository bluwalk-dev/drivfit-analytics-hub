SELECT
    a.id,
    a.date,
    a.name,
    a.amount,
    a.account_id,
    b.analytic_account_type,
    b.analytic_account_name,
    b.analytic_account_owner_contact_id,
    a.partner_id,
    a.product_id,
    c.product_code,
    a.rental_contract_id,
    a.vehicle_damage_id,
    IFNULL(IFNULL(d.vehicle_license_plate, e.vehicle_license_plate), f.vehicle_license_plate) AS vehicle_license_plate,
    IFNULL(IFNULL(d.vehicle_deal_name, e.vehicle_deal_name), f.vehicle_deal_name) AS vehicle_deal_name,
    a.move_id,
    a.payment_cycle
FROM {{ ref('stg_odoo__account_analytic_lines') }} a
LEFT JOIN {{ ref('dim_accounting_analytic_accounts') }} b ON a.account_id = b.analytic_account_id
LEFT JOIN {{ ref('dim_products') }} c ON a.product_id = c.product_id
-- Vehicle Attribution
LEFT JOIN {{ ref('fct_rental_contracts') }} d ON a.rental_contract_id = d.rental_contract_id
LEFT JOIN {{ ref('fct_vehicle_damages') }} e ON a.vehicle_damage_id = e.id
LEFT JOIN {{ ref('fct_vehicle_insurance_claims') }} f ON a.insurance_claim_id = f.id
ORDER BY a.date DESC
