DROP TABLE IF EXISTS organization_contacts;

CREATE TABLE organization_contacts AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'firstName')::varchar(65535) AS first_name,
    jsonb_extract_path_text(jsonb, 'inactive')::boolean AS inactive,
    jsonb_extract_path_text(jsonb, 'language')::varchar(65535) AS language,
    jsonb_extract_path_text(jsonb, 'lastName')::varchar(65535) AS last_name,
    jsonb_extract_path_text(jsonb, 'notes')::varchar(65535) AS notes,
    jsonb_extract_path_text(jsonb, 'prefix')::varchar(65535) AS prefix,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_organizations.contacts;

