SELECT
    *
FROM {{ ref('stg_odoo__lease_contract_conditions') }} a
WHERE a.active is true