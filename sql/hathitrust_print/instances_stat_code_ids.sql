--create instance_statcodeIDs
CREATE TABLE local.instances_statcodeIDs AS
SELECT
    id AS instances_id,
    json_array_elements(
          json_extract_path(data, 'statisticalCodeIds') ) :: VARCHAR
    AS instance_statcode_id
FROM inventory_instances;
-- PostgreSQL-specific
CREATE INDEX ON local.instances_statcodeIDs (instances_id);
CREATE INDEX ON local.instances_statcodeIDs (instance_statcode_id);
VACUUM local.instances_statcodeIDs;
ANALYZE local.instances_statcodeIDs;
