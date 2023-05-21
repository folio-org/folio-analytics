DROP TABLE IF EXISTS inventory_electronic_access_relationships;

CREATE TABLE inventory_electronic_access_relationships AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.electronic_access_relationship;

ALTER TABLE inventory_electronic_access_relationships ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_electronic_access_relationships (name);

CREATE INDEX ON inventory_electronic_access_relationships (source);

