DROP TABLE IF EXISTS local.instance_series;

-- Create a local table for series statemnts in the instance records.
CREATE TABLE local.instance_series AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_array_elements_text(json_extract_path(instances.data, 'series')) AS series
FROM
    inventory_instances AS instances;

CREATE INDEX ON local.instance_series (instance_id);

CREATE INDEX ON local.instance_series (instance_hrid);

CREATE INDEX ON local.instance_series (series);

