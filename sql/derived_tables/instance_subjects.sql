
-- Create a local table for series in the instance record.

DROP TABLE IF EXISTS instance_series;

CREATE TABLE instance_series AS
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    json_extract_path_text(series.data, 'value') AS series,
    series.ordinality AS series_ordinality
FROM
    inventory_instances AS instances
   CROSS JOIN json_array_elements(json_extract_path(instances.data, 'series'))
   WITH ORDINALITY AS series (data);
   
CREATE INDEX ON instance_series (instance_id);

CREATE INDEX ON instance_series (instance_hrid);

CREATE INDEX ON instance_series (series);

CREATE INDEX ON instance_series (series_ordinality);

VACUUM ANALYZE instance_series;

COMMENT ON COLUMN instance_series.instance_id IS 'UUID of the instance record';

COMMENT ON COLUMN instance_series.instance_hrid IS 'A human readable system-assigned sequential ID which maps to the Instance ID';

COMMENT ON COLUMN instance_series.series IS 'Series title value';

COMMENT ON COLUMN instance_series.series_ordinality IS 'Series title value ordinality';


