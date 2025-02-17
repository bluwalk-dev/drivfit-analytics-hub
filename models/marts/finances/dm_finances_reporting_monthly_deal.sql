SELECT
    year_month,
    vehicle_deal_name,
    reporting_level_1,
    reporting_level_2,
    reporting_level_3,
    reporting_level_4,
    -1 * SUM(balance) amount
FROM {{ ref('rpt_finances_reporting_ledger') }}
WHERE reporting_business = 'Rideshare Vehicle Solutions'
GROUP BY
    year_month,
    vehicle_deal_name,
    reporting_level_1,
    reporting_level_2,
    reporting_level_3,
    reporting_level_4
ORDER BY
    year_month,
    vehicle_deal_name,
    reporting_level_1,
    reporting_level_2,
    reporting_level_3,
    reporting_level_4