-- Create a derived table for series statements in the instance records.

DROP TABLE IF EXISTS instance_series;

CREATE TABLE instance_series AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    series.data->>'value' AS series,
    series.ordinality AS series_ordinality
FROM
    inventory_instances AS instances
   CROSS JOIN jsonb_array_elements((instances.data->'series')::jsonb)
   WITH ORDINALITY AS series (data);
   
COMMENT ON COLUMN instance_series.instance_id IS 'UUID of the instance record';

COMMENT ON COLUMN instance_series.instance_hrid IS 'A human readable system-assigned sequential ID which maps to the Instance ID';

COMMENT ON COLUMN instance_series.series IS 'Series title value';

COMMENT ON COLUMN instance_series.series_ordinality IS 'Series title value ordinality';
