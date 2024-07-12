SELECT
  a.id as station_id,
  a.name as station_name,
  active as station_is_active,
  b.contact_name as station_owner,
  c.location_name as station_location,
  a.address as station_address,
  a.gmaps_link as station_geolocation
FROM {{ ref('stg_odoo__fleet_vehicle_stations') }} a
LEFT JOIN {{ ref('dim_contacts') }} b ON a.partner_id = b.contact_id
LEFT JOIN {{ ref('dim_locations') }} c ON a.operation_city_id = c.location_id