{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'rate_mileage') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation