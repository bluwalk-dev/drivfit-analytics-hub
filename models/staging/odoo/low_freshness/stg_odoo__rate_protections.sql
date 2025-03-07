{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'rate_protection') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation