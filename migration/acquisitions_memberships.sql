DROP TABLE IF EXISTS acquisitions_memberships;

CREATE TABLE acquisitions_memberships AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'acquisitionsUnitId')::varchar(36) AS acquisitions_unit_id,
    jsonb_extract_path_text(jsonb, 'userId')::varchar(36) AS user_id,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_orders.acquisitions_unit_membership;

ALTER TABLE acquisitions_memberships ADD PRIMARY KEY (id);

CREATE INDEX ON acquisitions_memberships (acquisitions_unit_id);

CREATE INDEX ON acquisitions_memberships (user_id);

VACUUM ANALYZE acquisitions_memberships;
