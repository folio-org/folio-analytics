--metadb:table users_addresses

-- Create a derived table that takes the user_users table and unpacks
-- the address array into a normalized table

DROP TABLE IF EXISTS users_addresses;

CREATE TABLE users_addresses AS
SELECT
    uu.id AS user_id,
    jsonb_extract_path_text(addresses.jsonb, 'id') AS address_id, --no data created by FOLIO for this field, leaving as text
    jsonb_extract_path_text(addresses.jsonb, 'countryId') AS address_country_id,
    jsonb_extract_path_text(addresses.jsonb, 'addressLine1') AS address_line_1,
    jsonb_extract_path_text(addresses.jsonb, 'addressLine2') AS address_line_2,
    jsonb_extract_path_text(addresses.jsonb, 'city') AS address_city,
    jsonb_extract_path_text(addresses.jsonb, 'region') AS address_region,
    jsonb_extract_path_text(addresses.jsonb, 'postalCode') AS address_postal_code,
    jsonb_extract_path_text(addresses.jsonb, 'addressTypeId')::uuid AS address_type_id,
    ua.address_type AS address_type_name,
    ua.desc AS address_type_description,
    jsonb_extract_path_text(addresses.jsonb, 'primaryAddress')::boolean AS is_primary_address
FROM
    folio_users.users AS uu
    CROSS JOIN jsonb_array_elements(jsonb_extract_path(jsonb, 'personal', 'addresses')) AS addresses (jsonb)
    LEFT JOIN folio_users.addresstype__t AS ua ON jsonb_extract_path_text(addresses.jsonb, 'addressTypeId')::uuid = ua.id;


