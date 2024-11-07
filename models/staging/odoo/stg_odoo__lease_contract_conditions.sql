{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'lease_contract_condition') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation