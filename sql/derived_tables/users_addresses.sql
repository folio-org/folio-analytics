DROP TABLE IF EXISTS local.angelazoss_users_addresses;

-- Create a derived table that takes the user_users table and unpacks
-- the address array into a normalized table
CREATE TABLE local.angelazoss_users_addresses AS
WITH address_array AS (
    SELECT
        uu.id AS user_id,
        json_extract_path_text(json_array_elements(json_extract_path(uu.data, 'personal', 'addresses')), 'id') AS address_id,
        json_extract_path_text(json_array_elements(json_extract_path(uu.data, 'personal', 'addresses')), 'countryId') AS address_country_id,
        json_extract_path_text(json_array_elements(json_extract_path(uu.data, 'personal', 'addresses')), 'addressLine1') AS address_line_1,
        json_extract_path_text(json_array_elements(json_extract_path(uu.data, 'personal', 'addresses')), 'addressLine2') AS address_line_2,
        json_extract_path_text(json_array_elements(json_extract_path(uu.data, 'personal', 'addresses')), 'city') AS address_city,
        json_extract_path_text(json_array_elements(json_extract_path(uu.data, 'personal', 'addresses')), 'region') AS address_region,
        json_extract_path_text(json_array_elements(json_extract_path(uu.data, 'personal', 'addresses')), 'postalCode') AS address_postal_code,
        json_extract_path_text(json_array_elements(json_extract_path(uu.data, 'personal', 'addresses')), 'addressTypeId') AS address_type_id,
        json_extract_path_text(json_array_elements(json_extract_path(uu.data, 'personal', 'addresses')), 'primaryAddress') AS is_primary_address
    FROM
        user_users AS uu
)
SELECT
    address_array.user_id,
    address_array.address_id,
    address_array.address_country_id,
    address_array.address_line_1,
    address_array.address_line_2,
    address_array.address_city,
    address_array.address_region,
    address_array.address_postal_code,
    address_array.address_type_id,
    --	ua.address_type AS address_type_name,
    --	ua.desc AS address_type_description,
    address_array.is_primary_address
FROM
    address_array
    --LEFT JOIN	user_address_types AS ua
    --    ON address_array.address_type_id = ua.id
;

CREATE INDEX ON local.angelazoss_users_addresses (user_id);

CREATE INDEX ON local.angelazoss_users_addresses (address_id);

CREATE INDEX ON local.angelazoss_users_addresses (address_country_id);

CREATE INDEX ON local.angelazoss_users_addresses (address_line_1);

CREATE INDEX ON local.angelazoss_users_addresses (address_line_2);

CREATE INDEX ON local.angelazoss_users_addresses (address_city);

CREATE INDEX ON local.angelazoss_users_addresses (address_region);

CREATE INDEX ON local.angelazoss_users_addresses (address_postal_code);

CREATE INDEX ON local.angelazoss_users_addresses (address_type_id);

--CREATE INDEX ON local.angelazoss_users_addresses (address_type_name);

--CREATE INDEX ON local.angelazoss_users_addresses (address_type_description);

CREATE INDEX ON local.angelazoss_users_addresses (is_primary_address);

VACUUM local.angelazoss_users_addresses;

ANALYZE local.angelazoss_users_addresses;

