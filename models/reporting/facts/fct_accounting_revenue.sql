SELECT
    a.id,
    a.date,
    a.name,
    -1 * a.amount as amount,
    a.partner_id,
    a.product_id,
    a.product_code,
    a.vehicle_license_plate,
    a.vehicle_deal_name,
    CASE
        WHEN product_code IN ('R-RENTAL-DAY') THEN 'Base Revenue'
        WHEN product_code IN ('R-RENTAL-KM', 'R-RENTAL-PACK_KMS') THEN 'Mileage'
        WHEN product_code IN ('R-RENTAL-PACK_PROTECTION') THEN 'Protection'
        WHEN product_code IN ('R-VEHICLE-DAMAGE', 'R-RENTAL-DEDUCTIBLE', 'R-RENTAL-ICLAIMFEE', 'R-RENTAL-ICLAIM') THEN 'Damages Collected'
        WHEN (product_code LIKE 'R-RENTAL-PENALTY%') OR (product_code IN ('R-RENTAL-FINE', 'R-RENTAL-CARWASH', 'R-VEHICLE-PICKUP')) THEN 'Penalties & Others'
        WHEN product_code IN ('A-DD-RETURN') THEN 'Banking & Transaction Fees'
        ELSE ''
    END as revenue_category,
    CASE
        WHEN vehicle_deal_name IS NOT NULL THEN 'Vehicle Revenue'
        ELSE 'Generic Revenue'
    END as revenue_attribution
FROM {{ ref('fct_accounting_analytic_lines') }} a
WHERE move_id IS NULL AND analytic_account_type = 'Customer'
ORDER BY date DESC


