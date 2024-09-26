{{ config(materialized='table') }}

with

source as (
    select
        id,
        name,
        license_plate,
        fleet_id,
        obe_manufacturer,
        CAST(CAST(obe_code AS INT) AS STRING) obe_code,
        billing_account_id,
        partner_id,
        supplier_id,
        record_type,
        record_type_description,
        service_type,
        service_description,
        DATE(entry_date) as entry_date,
        entry_date as timestamp_entry,
        DATETIME(TIMESTAMP(entry_date), 'Europe/Lisbon') localtime_entry,
        entry_code,
        entry_description,
        DATE(exit_date) as exit_date,
        exit_date as timestamp_exit,
        DATETIME(TIMESTAMP(exit_date), 'Europe/Lisbon') localtime_exit,
        exit_code,
        exit_description,
        toll_class,
        vvp_transaction_id,
        vat_rate,
        price,
        cost,
        company_id,
        status,
        payment_cycle,
        transaction_code,
        mopr_file_name,
        merf_file_name,
        rental_contract_id
    from {{ source('odoo', 'tolls') }}
),

transformation as (

    select
        TO_HEX(MD5(COALESCE(obe_code, '') || COALESCE(CAST(DATETIME(DATE(localtime_exit), TIME(EXTRACT(HOUR FROM localtime_exit), EXTRACT(MINUTE FROM localtime_exit), 0)) AS STRING), ''))) transaction_key,
        *
    from source
    
)

select * from transformation