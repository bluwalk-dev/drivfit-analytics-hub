{{ config(materialized='table') }}

with

source as (
    SELECT *
    FROM {{ source('odoo', 'hr_employee') }}
),

transformation as (

    select
        *
    from source
    

)

SELECT * FROM transformation