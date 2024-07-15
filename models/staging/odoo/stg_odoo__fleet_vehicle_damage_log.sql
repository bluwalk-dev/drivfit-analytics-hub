{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'fleet_vehicle_damage_log') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation
