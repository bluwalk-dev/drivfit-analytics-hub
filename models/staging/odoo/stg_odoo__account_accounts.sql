{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'account_account') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation