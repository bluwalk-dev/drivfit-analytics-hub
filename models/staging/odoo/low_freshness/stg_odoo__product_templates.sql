{{ config(materialized='table') }}

with

source as (
    SELECT *
    FROM {{ source('odoo', 'product_template') }}
),

transformation as (

    select
        *
    from source
    
)

SELECT * FROM transformation