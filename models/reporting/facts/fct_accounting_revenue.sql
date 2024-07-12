SELECT
    id,
    date,
    name,
    amount,
    partner_id,
    product_id,
    product_code,
    vehicle_license_plate,
    vehicle_deal_name
FROM {{ ref('fct_accounting_analytic_lines') }} a
LEFT JOIN {{ ref('fct_rental_contracts') }} b ON LEFT(a.name, 13) = b.rental_contract_name
WHERE move_id IS NOT NULL AND analytic_account_type = 'Customer'
ORDER BY date DESC


