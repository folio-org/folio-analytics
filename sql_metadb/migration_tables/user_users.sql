DROP TABLE IF EXISTS user_users;

CREATE TABLE user_users AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'active')::boolean AS active,
    jsonb_extract_path_text(jsonb, 'barcode')::varchar(65535) AS barcode,
    jsonb_extract_path_text(jsonb, 'createdDate')::timestamptz AS created_date,
    jsonb_extract_path_text(jsonb, 'enrollmentDate')::timestamptz AS enrollment_date,
    jsonb_extract_path_text(jsonb, 'expirationDate')::timestamptz AS expiration_date,
    jsonb_extract_path_text(jsonb, 'patronGroup')::varchar(36) AS patron_group,
    jsonb_extract_path_text(jsonb, 'type')::varchar(65535) AS type,
    jsonb_extract_path_text(jsonb, 'updatedDate')::timestamptz AS updated_date,
    jsonb_extract_path_text(jsonb, 'username')::varchar(65535) AS username,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_users.users;

