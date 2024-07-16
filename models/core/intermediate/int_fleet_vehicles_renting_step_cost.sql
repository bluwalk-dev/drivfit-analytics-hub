WITH 

annualized_mileage AS (
    SELECT
        a.vehicle_deal_id,
        a.vehicle_id,
        a.year_month,
        a.odometer,
        b.fleet_days,
        SUM(b.fleet_days) OVER (PARTITION BY a.vehicle_id ORDER BY a.year_month) AS cumulated_fleet_days,
        a.odometer / SUM(b.fleet_days) OVER (PARTITION BY a.vehicle_id ORDER BY a.year_month) * 365 as pace
    FROM {{ ref('agg_fleet_vehicle_odometer_monthly') }} a
    LEFT JOIN {{ ref('agg_fleet_vehicle_days_monthly') }} b on a.year_month = b.year_month AND a.vehicle_id = b.vehicle_id
),

adjustments AS (
    SELECT
        am.vehicle_id,
        am.vehicle_deal_id,
        am.year_month,
        am.cumulated_fleet_days,
        am.odometer,
        am.pace AS annualized_mileage,
        ps.step_km,
        ps.base_price * 12 / 365 * cumulated_fleet_days AS base_cost,
        CASE 
            WHEN am.odometer > (ps.step_km / 365 * cumulated_fleet_days) THEN 
                CASE 
                    WHEN am.odometer > (ps.step_km / 365 * cumulated_fleet_days) * 1.25 THEN ps.extra_km_price * 1.5 * (am.odometer - (ps.step_km / 365 * cumulated_fleet_days))
                    ELSE ps.extra_km_price * (am.odometer - (ps.step_km / 365 * cumulated_fleet_days))
                END
            ELSE ps.less_km_price * LEAST((ps.step_km / 365 * cumulated_fleet_days) * 0.25, (ps.step_km / 365 * cumulated_fleet_days) - am.odometer)
        END AS adjustment_cost
    FROM annualized_mileage am
    JOIN {{ ref('dim_vehicle_deal_renting_pricing') }} ps ON am.vehicle_deal_id = ps.vehicle_deal_id
)

select
    vehicle_id,
    vehicle_deal_id,
    year_month,
    cumulated_fleet_days,
    step_km,
    base_cost + adjustment_cost as total_cost
from adjustments
order by vehicle_id desc, year_month desc