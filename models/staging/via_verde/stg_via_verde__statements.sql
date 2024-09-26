{{ config(materialized='view') }}

with

source as (
    select
        documento_nr,
        CAST(data_emissao AS DATE) data_emissao,
        CAST(nif AS INTEGER) nif,
        contracto_nr,
        identificador,
        IF(matricula = 'Desconhecida', NULL, REPLACE(matricula, '-','')) matricula,
        referencia_mb,
        CAST(data_entrada AS DATE) data_entrada,
        CAST(IF(hora_entrada='', NULL, CONCAT(hora_entrada,':00')) AS TIME) hora_entrada,
        DATETIME(CAST(data_entrada AS DATE), CAST(IF(hora_entrada='', NULL, CONCAT(hora_entrada,':00')) AS TIME)) localtime_entrada,
        TIMESTAMP(DATETIME(CAST(data_entrada AS DATE), CAST(IF(hora_entrada='', NULL, CONCAT(hora_entrada,':00')) AS TIME)), 'Europe/Lisbon') timestamp_entrada,
        IF(entrada='',NULL, entrada) entrada,
        CAST(data_saida AS DATE) data_saida,
        CAST(IF(hora_saida='', NULL, CONCAT(hora_saida,':00')) AS TIME) hora_saida,
        DATETIME(CAST(data_saida AS DATE), CAST(IF(hora_saida='', NULL, CONCAT(hora_saida,':00')) AS TIME)) localtime_saida,
        TIMESTAMP(DATETIME(CAST(data_saida AS DATE), CAST(IF(hora_saida='', NULL, CONCAT(hora_saida,':00')) AS TIME)), 'Europe/Lisbon') timestamp_saida,
        IF(saida='', NULL, saida) saida,
        CAST(valor AS NUMERIC) valor,
        CAST(valor_desconto AS NUMERIC) valor_desconto,
        CAST(taxa_iva AS INTEGER) taxa_iva,
        operador,
        servico,
        CAST(data_pagamento AS DATE) data_pagamento,
        cartao_n,
        duracao,
        quantidade,
        valor_energia,
        valor_acesso_rede,
        valor_tempo_opc,
        valor_energia_opc,
        valor_ativacao_opc,
        iec,
        taxa_egme,
        conta_digital,
        CAST(load_timestamp AS TIMESTAMP) load_timestamp

    from {{ source('via_verde', 'statement') }}
),

transformation as (

    select
        
        TO_HEX(MD5(COALESCE(identificador, '') || COALESCE(CAST(localtime_saida AS STRING), ''))) transaction_key,
        *

    from source
    
)

select * from transformation