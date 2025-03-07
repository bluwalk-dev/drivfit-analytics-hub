{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'account_analytic_line') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation