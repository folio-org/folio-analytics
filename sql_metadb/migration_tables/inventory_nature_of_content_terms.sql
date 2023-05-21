DROP TABLE IF EXISTS inventory_nature_of_content_terms;

CREATE TABLE inventory_nature_of_content_terms AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.nature_of_content_term;

ALTER TABLE inventory_nature_of_content_terms ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_nature_of_content_terms (name);

CREATE INDEX ON inventory_nature_of_content_terms (source);

