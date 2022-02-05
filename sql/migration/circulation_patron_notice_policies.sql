DROP TABLE IF EXISTS circulation_patron_notice_policies;

CREATE TABLE circulation_patron_notice_policies AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'active')::bool AS active,
    jsonb_extract_path_text(jsonb, 'description')::varchar(65535) AS description,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_circulation.patron_notice_policy;

ALTER TABLE circulation_patron_notice_policies ADD PRIMARY KEY (id);

CREATE INDEX ON circulation_patron_notice_policies (description);

CREATE INDEX ON circulation_patron_notice_policies (name);

VACUUM ANALYZE circulation_patron_notice_policies;
