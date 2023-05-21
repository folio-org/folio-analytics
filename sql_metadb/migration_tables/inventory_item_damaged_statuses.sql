DROP TABLE IF EXISTS inventory_item_damaged_statuses;

CREATE TABLE inventory_item_damaged_statuses AS
SELECT
    id::varchar(36),
    jsonb_extract_path_text(jsonb, 'name')::varchar(65535) AS name,
    jsonb_extract_path_text(jsonb, 'source')::varchar(65535) AS source,
    jsonb_pretty(jsonb)::json AS data
FROM
    folio_inventory.item_damaged_status;

ALTER TABLE inventory_item_damaged_statuses ADD PRIMARY KEY (id);

CREATE INDEX ON inventory_item_damaged_statuses (name);

CREATE INDEX ON inventory_item_damaged_statuses (source);

