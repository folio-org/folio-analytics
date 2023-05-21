DROP TABLE IF EXISTS inventory_instance_formats;

CREATE TABLE inventory_instance_formats AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'readOnly')::boolean AS read_only,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.instance_format;

ALTER TABLE inventory_instance_formats ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_instance_formats (code);

CREATE INDEX ON inventory_instance_formats (name);

CREATE INDEX ON inventory_instance_formats (read_only);

CREATE INDEX ON inventory_instance_formats (source);

