SELECT 
    a.date,
    a.name,
    b.analytic_account_name,
    c.product_code,
    d.vehicle_license_plate,
    d.vehicle_deal_name,
    CASE
        WHEN analytic_account_name LIKE '%Agency Cost%' THEN 'Agency cost'
        WHEN analytic_account_name LIKE '%Banking and Transaction%' THEN 'Banking & Transaction Fees'
        WHEN analytic_account_name LIKE '%Infleet & Defleet%' THEN 'Infleet & Defleet'
        WHEN analytic_account_name LIKE '%Logistics%' THEN 'Logistics'
        WHEN analytic_account_name LIKE '%Other%' THEN 'Other'
        WHEN analytic_account_name LIKE '%Sales fee%' THEN 'Discounts'
        WHEN analytic_account_name LIKE '%Telematics%' THEN 'Telematics & WeProov'
        WHEN analytic_account_name LIKE '%Tolls%' THEN 'Tolls'
        WHEN analytic_account_name LIKE 'FLEET%' THEN CASE
            WHEN product_code = 'V-INSR-INSR' THEN 'Insurance'
            WHEN product_code LIKE 'V-MAINT%' THEN 'Tyres & Maintenance'
            WHEN product_code LIKE 'V-RECOND%' OR product_code = 'V-INSR-DEDUCTIBLE' THEN 'Damage Repair'
            WHEN product_code LIKE 'V-RENTING%' THEN 'Vehicle Cost'
            WHEN product_code = 'V-ADMIN-FINES' THEN 'Administrative'
            ELSE ''
            END
        ELSE ''
    END as cost_category,
    CASE
        WHEN analytic_account_name LIKE 'FLEET%' THEN 'Vehicle Cost'
        ELSE 'Generic Cost'
    END as cost_attribution,
    balance amount
from {{ ref('fct_accounting_move_lines') }} a
left join {{ ref('dim_accounting_analytic_accounts') }} b on a.analytic_account_id = b.analytic_account_id
left join {{ ref('dim_products') }} c on a.product_id = c.product_id
left join {{ ref('dim_vehicles') }} d on a.analytic_account_id = d.analytic_account_id
WHERE
    a.account_code like '6%' AND 
    (b.analytic_account_name like '%COS/%' OR b.analytic_account_name like 'FLEET%')