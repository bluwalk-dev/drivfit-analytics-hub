SELECT
    a.id,
    a.date,
    a.name,
    a.amount,
    a.partner_id,
    a.product_id,
    a.product_code,
    b.vehicle_license_plate,
    b.vehicle_deal_name,
    CASE
        WHEN product_code IN ('R-RENTAL-DAY') THEN 'Base Revenue'
        WHEN product_code IN ('R-RENTAL-KM', 'R-RENTAL-PACK_KMS') THEN 'Mileage'
        WHEN product_code IN ('R-RENTAL-PACK_PROTECTION') THEN 'Protection'
        WHEN product_code IN ('R-VEHICLE-DAMAGE', 'R-RENTAL-DEDUCTIBLE', 'R-RENTAL-ICLAIMFEE', 'R-RENTAL-ICLAIM') THEN 'Damages Collected'
        WHEN (product_code LIKE 'R-RENTAL-PENALTY%') OR (product_code IN ('R-RENTAL-FINE', 'R-RENTAL-CARWASH')) THEN 'Penalties & Others'
        ELSE ''
    END as revenue_category
FROM {{ ref('fct_accounting_analytic_lines') }} a
LEFT JOIN {{ ref('fct_rental_contracts') }} b ON a.rental_contract_id = b.rental_contract_id
WHERE move_id IS NULL AND analytic_account_type = 'Customer'
ORDER BY date DESC


