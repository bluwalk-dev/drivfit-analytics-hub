{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'fleet_vehicle_cost') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation
