SELECT 
    a.date,
    a.name,
    b.analytic_account_name,
    c.product_code,
    d.vehicle_license_plate,
    d.vehicle_deal_name,
    balance amount
from {{ ref('fct_accounting_move_lines') }} a
left join {{ ref('dim_accounting_analytic_accounts') }} b on a.analytic_account_id = b.analytic_account_id
left join {{ ref('dim_products') }} c on a.product_id = c.product_id
left join {{ ref('dim_vehicles') }} d on a.analytic_account_id = d.analytic_account_id
WHERE 
    a.account_code like '6%' AND 
    (b.analytic_account_name like '%COS/%' OR b.analytic_account_name like 'FLEET%')