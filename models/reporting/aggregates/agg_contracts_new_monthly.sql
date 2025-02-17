SELECT
    c.year_month,
    count(*) new_contracts
FROM {{ ref('fct_lease_contracts') }} a
LEFT JOIN {{ ref('fct_rental_bookings') }} b ON a.booking_id = b.booking_id
LEFT JOIN {{ ref('util_calendar') }} c ON a.start_date = c.date
where b.booking_type = 'new' and a.lease_contact_state != 'draft'
group by year_month