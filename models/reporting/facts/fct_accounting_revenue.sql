WITH
analytic_lines_ba AS (
-- We should grab move_lines of accounts 7xxx instead. This is much less reliable.
-- Validate attribution by finding "Vehicle Attribution" without vehicle plate
-- Validate attribution by finding lines without a product
    SELECT
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
            WHEN product_code IN ('R-RENTAL-KM') THEN 'Extra Mileage'
            WHEN product_code IN ('R-RENTAL-PACK_KMS') THEN 'Mileage'
            WHEN product_code IN ('R-RENTAL-PACK_PROTECTION') THEN 'Protection'
            WHEN product_code IN ('V-RENTING-MISC', 'V-MAINT-REPAIR', 'V-MAINT-MAINTENANCE', 'V-MAINT-DEDUCTIBLE', 'R-VEHICLE-DAMAGE', 'R-RENTAL-DEDUCTIBLE', 'R-RENTAL-ICLAIMFEE', 'R-RENTAL-ICLAIM') THEN 'Damages Collected'
            WHEN (product_code LIKE 'R-RENTAL-PENALTY%') OR (product_code IN ('R-VEHICLE-PICKUP', 'R-RENTAL-FINE', 'R-RENTAL-CARWASH')) THEN 'Penalties & Others'
            WHEN product_code IN ('R-TOLL') THEN 'Tolls'
            WHEN product_code IN ('R-REFUND') THEN 'Discounts'
            WHEN product_code IN ('A-DD-RETURN') THEN 'Banking & Transaction Fees'
            WHEN product_code IN ('V-LOGISTICS-COURIER', 'V-ADMIN-FINES') THEN 'Administrative'
            ELSE ''
        END as revenue_category,
        CASE
            WHEN product_code IN ('V-LOGISTICS-COURIER', 'V-ADMIN-FINES', 'A-DD-RETURN', 'R-REFUND', 'R-TOLL') THEN 'Generic Revenue'
            ELSE 'Vehicle Revenue'
        END as revenue_attribution
    FROM {{ ref('fct_accounting_analytic_lines') }} a
    WHERE move_id IS NULL AND analytic_account_type = 'Customer'
),

insurance_compensations as (
    select
        date,
        name,
        -1*balance as amount,
        NULL partner_id,
        NULL product_id,
        '' product_code,
        '' vehicle_license_plate,
        '' vehicle_deal_name,
        'Insurance compensations' as revenue_category,
        'Generic Revenue' as revenue_attribution
    from {{ ref('fct_accounting_move_lines') }}
    where account_code like '7872%'
)

SELECT * FROM analytic_lines_ba
UNION ALL
SELECT * FROM insurance_compensations