{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'sale_order_line') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation