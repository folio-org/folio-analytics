DROP TABLE IF EXISTS inventory_ill_policies;

CREATE TABLE inventory_ill_policies AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.ill_policy;

ALTER TABLE inventory_ill_policies ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_ill_policies (name);

CREATE INDEX ON inventory_ill_policies (source);

VACUUM ANALYZE inventory_ill_policies;
