{{ config(materialized='table') }}

with

source as (
    SELECT *
    FROM {{ source('odoo', 'hr_department') }}
),

transformation as (

    select
        *
    from source
    

)

SELECT * FROM transformation
