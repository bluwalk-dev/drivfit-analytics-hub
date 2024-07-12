SELECT
    id,
    date,
    name,
    amount,
    account_id,
    b.analytic_account_type,
    b.analytic_account_name,
    b.analytic_account_owner_contact_id,
    partner_id,
    a.product_id,
    c.product_code,
    a.rental_contract_id,
    move_id,
    payment_cycle,
FROM {{ ref('stg_odoo__account_analytic_lines') }} a
left join {{ ref('dim_accounting_analytic_accounts') }} b ON a.account_id = b.analytic_account_id
LEFT JOIN {{ ref('dim_products') }} c ON a.product_id = c.product_id
ORDER BY date DESC