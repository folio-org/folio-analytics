DROP TABLE IF EXISTS acquisitions_units;

CREATE TABLE acquisitions_units AS
SELECT
    id::varchar(36),
    (jsonb->>'isDeleted')::bool AS is_deleted,
    (jsonb->>'name')::varchar AS name,
    (jsonb->>'protectCreate')::bool AS protect_create,
    (jsonb->>'protectDelete')::bool AS protect_delete,
    (jsonb->>'protectRead')::bool AS protect_read,
    (jsonb->>'protectUpdate')::bool AS protect_update,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_orders.acquisitions_unit;

ALTER TABLE acquisitions_units ADD PRIMARY KEY (id);

CREATE INDEX ON acquisitions_units (is_deleted);

CREATE INDEX ON acquisitions_units (name);

CREATE INDEX ON acquisitions_units (protect_create);

CREATE INDEX ON acquisitions_units (protect_delete);

CREATE INDEX ON acquisitions_units (protect_read);

CREATE INDEX ON acquisitions_units (protect_update);

VACUUM ANALYZE acquisitions_units;
