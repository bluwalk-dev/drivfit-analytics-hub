{{ config(materialized='table') }}

with

source as (
    select
        *
    from {{ source('odoo', 'booking') }}
),

transformation as (

    select
        
        *

    from source
    
)

select * from transformation