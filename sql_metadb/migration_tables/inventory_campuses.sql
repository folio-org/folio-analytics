DROP TABLE IF EXISTS inventory_campuses;

CREATE TABLE inventory_campuses AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'code')::varchar(65535) AS code,
    jsonb_extract_path_text(jsonb, 'institutionId')::varchar(36) AS institution_id,
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.loccampus;

ALTER TABLE inventory_campuses ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_campuses (code);

CREATE INDEX ON inventory_campuses (institution_id);

CREATE INDEX ON inventory_campuses (name);

