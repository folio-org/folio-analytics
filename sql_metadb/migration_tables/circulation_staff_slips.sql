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

ALTER TABLE circulation_staff_slips ADD PRIMARY KEY (id);

CREATE INDEX ON circulation_staff_slips (active);

CREATE INDEX ON circulation_staff_slips (description);

CREATE INDEX ON circulation_staff_slips (name);

CREATE INDEX ON circulation_staff_slips (template);

VACUUM ANALYZE circulation_staff_slips;
