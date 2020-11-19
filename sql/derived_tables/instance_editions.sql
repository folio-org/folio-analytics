DROP TABLE IF EXISTS local.instance_editions;

CREATE TABLE local.instance_editions AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'editions')) AS edition
FROM
    inventory_instances AS instances;

CREATE INDEX ON local.instance_editions (instance_id);

CREATE INDEX ON local.instance_editions (instance_hrid);

CREATE INDEX ON local.instance_editions (edition);

