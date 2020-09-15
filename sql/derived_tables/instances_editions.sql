DROP TABLE IF EXISTS local.instances_editions;

CREATE TABLE local.instances_editions AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'editions')) AS edition_statement
FROM
    inventory_instances AS instances;

CREATE INDEX ON local.instances_editions (instance_id);

CREATE INDEX ON local.instances_editions (instance_hrid);

CREATE INDEX ON local.instances_editions (edition_statement);

VACUUM ANALYZE local.instances_editions;

