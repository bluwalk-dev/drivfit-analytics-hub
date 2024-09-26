SELECT * FROM
    (SELECT 
        *, 
        ROW_NUMBER() OVER (
            PARTITION BY identificador, data_saida, hora_saida, saida 
            ORDER BY load_timestamp DESC
        ) AS __row_number
    FROM {{ ref("stg_via_verde__statements") }} 
    )
WHERE __row_number = 1