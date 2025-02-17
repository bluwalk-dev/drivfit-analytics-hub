SELECT
    a.year_month,
    a.fleet_size,
    b.new_contracts
FROM {{ ref('agg_rental_monthly') }} a
LEFT JOIN {{ ref('agg_contracts_new_monthly') }} b ON a.year_month = b.year_month
WHERE a.year_month >= 202501