DROP TABLE IF EXISTS organization_categories;

CREATE TABLE organization_categories AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'value')::varchar(65535) AS value,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_organizations.categories;

