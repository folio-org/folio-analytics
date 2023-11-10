DROP TABLE IF EXISTS circulation_staff_slips;

CREATE TABLE circulation_staff_slips AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'active')::boolean AS active,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'template')::varchar(65535) AS template,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.staff_slips;

