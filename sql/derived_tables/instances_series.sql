DROP TABLE IF EXISTS local.instances_series;

CREATE TABLE local.instances_series AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'series')) AS series_statement
FROM
    inventory_instances AS instances;

CREATE INDEX ON local.instances_series (instance_id);

CREATE INDEX ON local.instances_series (instance_hrid);

CREATE INDEX ON local.instances_series (series_statement);

