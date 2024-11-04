{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'account_move_line_account_tax_rel') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation