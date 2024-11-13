WITH merged_objects AS (
    SELECT CAST(value AS INT64) value
    FROM 
        {{ ref("stg_hubspot__contacts") }},
        UNNEST(SPLIT(merged_objects, ';')) AS value
    WHERE merged_objects IS NOT NULL
)

SELECT
    hs_contact_id,
    first_name,
    last_name,
    email,
    contact_phone_nr
    
FROM {{ ref("stg_hubspot__contacts") }}
WHERE 
    is_deleted = FALSE AND
    hs_contact_id NOT IN (SELECT * FROM merged_objects)