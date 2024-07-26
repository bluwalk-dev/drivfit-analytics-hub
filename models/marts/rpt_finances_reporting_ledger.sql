WITH reporting_structure AS (
    SELECT * 
    FROM {{ ref('dim_reporting_structure') }}
)


SELECT
    d.year_month,
    a.date,
    IFNULL(c.reporting_business, f.reporting_business) reporting_business,
    IFNULL(c.reporting_level_1, f.reporting_level_1) reporting_level_1, 
    IFNULL(c.reporting_level_2, f.reporting_level_2) reporting_level_2,
    IFNULL(c.reporting_level_3, f.reporting_level_3) reporting_level_3,
    IFNULL(c.reporting_level_4, f.reporting_level_4) reporting_level_4,
    a.name,
    a.move_name,
    a.account_name,
    a.account_code,
    a.analytic_account_name,
    a.balance,
    e.vehicle_license_plate,
    e.vehicle_deal_name
FROM {{ ref('fct_accounting_move_lines') }} a
LEFT JOIN {{ ref('dim_accounting_accounts') }} b ON a.account_code = b.account_code
LEFT JOIN reporting_structure c ON a.account_code = c.account_code
LEFT JOIN reporting_structure f ON a.analytic_account_name = f.analytic_account_name
LEFT JOIN {{ ref('util_calendar') }} d ON a.date = d.date
LEFT JOIN {{ ref('dim_vehicles') }} e ON a.vehicle_id = e.vehicle_id
WHERE
    (a.account_code like '6%' or a.account_code like '7%') AND 
    move_state = 'posted'
ORDER BY year_month DESC