{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'account_partial_reconcile') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation