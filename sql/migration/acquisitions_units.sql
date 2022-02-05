DROP TABLE IF EXISTS acquisitions_units;

CREATE TABLE acquisitions_units AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'isDeleted')::bool AS is_deleted,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'protectCreate')::bool AS protect_create,
    jsonb_extract_path_text(jsonb, 'protectDelete')::bool AS protect_delete,
    jsonb_extract_path_text(jsonb, 'protectRead')::bool AS protect_read,
    jsonb_extract_path_text(jsonb, 'protectUpdate')::bool AS protect_update,
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
