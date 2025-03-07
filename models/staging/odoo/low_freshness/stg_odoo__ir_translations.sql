with

source as (
    SELECT *
    FROM {{ source('odoo', 'ir_translation') }}
),

transformation as (

    select
        *
    from source
    
)

SELECT * FROM transformation