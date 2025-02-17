SELECT
    date,
    vehicle_license_plate,
    vehicle_deal_name,
    cost_category,
    cost_attribution,
    amount
FROM {{ ref('fct_accounting_direct_costs') }}
WHERE cost_category != 'Vehicle Cost'

UNION ALL

SELECT
    a.end_date as date,
    b.vehicle_license_plate,
    b.vehicle_deal_name,
    'Vehicle Cost' as cost_category,
    'Vehicle Cost' as cost_attribution,
    cost as amount
FROM {{ ref('rpt_vehicle_renting_cost') }} a
LEFT JOIN {{ ref('dim_vehicles') }} b on a.vehicle_id = b.vehicle_id