{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'vehicle_category') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation