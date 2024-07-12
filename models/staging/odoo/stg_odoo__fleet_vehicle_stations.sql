{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'fleet_vehicle_station') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation