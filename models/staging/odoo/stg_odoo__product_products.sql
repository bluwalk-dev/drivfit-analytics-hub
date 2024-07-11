{{ config(materialized='table') }}

with

source as (
    SELECT *
    FROM {{ source('odoo', 'product_product') }}
),

transformation as (

    select
        *
    from source
    
)

SELECT * FROM transformation