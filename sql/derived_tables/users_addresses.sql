DROP TABLE IF EXISTS users_addresses;

-- Create a derived table that takes the user_users table and unpacks
-- the address array into a normalized table
CREATE TABLE users_addresses AS
SELECT
    uu.id AS user_id,
    (addresses.data #>> '{id}')::uuid AS address_id,
    addresses.data #>> '{countryId}' AS address_country_id,
    addresses.data #>> '{addressLine1}' AS address_line_1,
    addresses.data #>> '{addressLine2}' AS address_line_2,
    addresses.data #>> '{city}' AS address_city,
    addresses.data #>> '{region}' AS address_region,
    addresses.data #>> '{postalCode}' AS address_postal_code,
    (addresses.data #>> '{addressTypeId}')::uuid AS address_type_id,
    ua.address_type AS address_type_name,
    ua.desc AS address_type_description,
    (addresses.data #>> '{primaryAddress}')::boolean AS is_primary_address
FROM
    user_users AS uu
    CROSS JOIN LATERAL jsonb_array_elements((data #> '{personal,addresses}')::jsonb) AS addresses (data)
    LEFT JOIN user_addresstypes AS ua ON (addresses.data #>> '{addressTypeId}')::uuid = ua.id::uuid;

