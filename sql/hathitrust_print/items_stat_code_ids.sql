--create items_statcodeIDs
CREATE TABLE local.items_statcodeIDs AS
SELECT
    id AS items_id,
    json_array_elements(
          json_extract_path(data, 'statisticalCodeIds') ) :: VARCHAR
    AS items_statcode_id
FROM inventory_items;
-- PostgreSQL-specific
CREATE INDEX ON local.items_statcodeIDs (items_id);
CREATE INDEX ON local.items_statcodeIDs (items_statcode_id);
VACUUM local.items_statcodeIDs;
ANALYZE local.items_statcodeIDs;
