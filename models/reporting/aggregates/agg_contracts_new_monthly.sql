SELECT
    c.year_month,
    COUNT(*) AS new_contracts,
    SUM(CASE WHEN a.customer_id = 21 THEN 1 ELSE 0 END) AS new_contracts_driver,
    SUM(CASE WHEN a.customer_id != 21 THEN 1 ELSE 0 END) AS new_contracts_company
FROM {{ ref('fct_lease_contracts') }} a
LEFT JOIN {{ ref('fct_rental_bookings') }} b ON a.booking_id = b.booking_id
LEFT JOIN {{ ref('util_calendar') }} c ON a.start_date = c.date
WHERE b.booking_type = 'new'
  AND a.lease_contact_state != 'draft'
GROUP BY c.year_month