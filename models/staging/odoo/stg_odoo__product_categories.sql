{{ config(materialized='table') }}

with

source as (
    SELECT *
    FROM {{ source('odoo', 'product_category') }}
),

transformation as (

    select
        *
    from source
    
)

SELECT * FROM transformation