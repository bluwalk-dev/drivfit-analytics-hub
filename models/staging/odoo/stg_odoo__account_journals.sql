{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'account_journal') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation