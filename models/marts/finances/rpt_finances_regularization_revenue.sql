WITH 
blockN_rev AS (
    SELECT
        b.closing_month,
        'month_n' as block,
        'rev' as block_type,
        a.account_id,
        a.contact_id,
        ROUND(a.debit * b.share_this_month, 2) debit,
        ROUND(a.credit * b.share_this_month, 2) credit,
        a.name,
        a.product_id,
        a.vehicle_id
    FROM {{ ref('fct_accounting_move_lines') }} a
    LEFT JOIN {{ ref('util_month_regularization') }} b ON a.date = b.first_next_sunday
    WHERE
        a.account_internal_group = 'income' AND
        a.journal_id = 12 AND
        a.move_state = 'posted' AND
        b.closing_month IS NOT NULL
),
blockN_prov AS (
    SELECT
        b.closing_month,
        'month_n' as block,
        'prov' as block_type,
        NULL as account_id,
        a.contact_id,
        ROUND(a.credit * b.share_this_month, 2) debit,
        ROUND(a.debit * b.share_this_month, 2) credit,
        a.name,
        a.product_id,
        a.vehicle_id
    FROM {{ ref('fct_accounting_move_lines') }} a
    LEFT JOIN {{ ref('util_month_regularization') }} b ON a.date = b.first_next_sunday
    WHERE
        a.account_internal_group = 'income' AND
        a.journal_id = 12 AND
        a.move_state = 'posted' AND
        b.closing_month IS NOT NULL
),
blockN1_rev AS (
    SELECT
        b.closing_month,
        'month_n1' as block,
        'rev' as block_type,
        a.account_id,
        a.contact_id,
        a.credit - ROUND(a.credit * b.share_this_month, 2) debit,
        a.debit - ROUND(a.debit * b.share_this_month, 2) credit,
        a.name,
        a.product_id,
        a.vehicle_id
    FROM {{ ref('fct_accounting_move_lines') }} a
    LEFT JOIN {{ ref('util_month_regularization') }} b ON a.date = b.first_next_sunday
    WHERE
        a.account_internal_group = 'income' AND
        a.journal_id = 12 AND
        a.move_state = 'posted' AND
        b.closing_month IS NOT NULL
),
blockN1_prov AS (
    SELECT
        b.closing_month,
        'month_n1' as block,
        'prov' as block_type,
        NULL as account_id,
        a.contact_id,
        a.debit - ROUND(a.debit * b.share_this_month, 2) debit,
        a.credit - ROUND(a.credit * b.share_this_month, 2) credit,
        a.name,
        a.product_id,
        a.vehicle_id
    FROM {{ ref('fct_accounting_move_lines') }} a
    LEFT JOIN {{ ref('util_month_regularization') }} b ON a.date = b.first_next_sunday
    WHERE
        a.account_internal_group = 'income' AND
        a.journal_id = 12 AND
        a.move_state = 'posted' AND
        b.closing_month IS NOT NULL
)

SELECT * FROM blockN_rev
UNION ALL
SELECT * FROM blockN_prov
UNION ALL
SELECT * FROM blockN1_rev
UNION ALL
SELECT * FROM blockN1_prov