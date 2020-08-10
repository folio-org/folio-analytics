-- create instances_formatIDs local table
CREATE TABLE local.instances_formatIDs AS
SELECT
    id AS instances_id,
    json_array_elements(
          json_extract_path(data, 'instanceFormatIds') ) :: VARCHAR
    AS instance_format_id
FROM inventory_instances;
-- PostgreSQL-specific
CREATE INDEX ON local.instances_formatIDs (instances_id);
CREATE INDEX ON local.instances_formatIDs (instance_format_id);
VACUUM local.instances_formatIDs;
ANALYZE local.instances_formatIDs;
