DROP TABLE IF EXISTS inventory_instance_statuses;

CREATE TABLE inventory_instance_statuses AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.instance_status;

ALTER TABLE inventory_instance_statuses ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_instance_statuses (code);

CREATE INDEX ON inventory_instance_statuses (name);

CREATE INDEX ON inventory_instance_statuses (source);

VACUUM ANALYZE inventory_instance_statuses;
