DROP TABLE IF EXISTS local.instance_formats;

CREATE TABLE local.instance_formats AS
WITH instances AS (
    SELECT
        id,
        hrid,
        json_array_elements_text(json_extract_path(data, 'instanceFormatIds')) AS instance_format_id
    FROM
        inventory_instances
)
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    instances.instance_format_id,
    formats.code AS format_code,
    formats.name AS format_name,
    formats.source AS format_source
FROM
    instances
    LEFT JOIN inventory_instance_formats AS formats ON instances.instance_format_id = formats.id;

CREATE INDEX ON local.instance_formats (instance_id);

CREATE INDEX ON local.instance_formats (instance_hrid);

CREATE INDEX ON local.instance_formats (instance_format_id);

CREATE INDEX ON local.instance_formats (format_code);

CREATE INDEX ON local.instance_formats (format_name);

CREATE INDEX ON local.instance_formats (format_source);

VACUUM local.instance_formats;

ANALYZE local.instance_formats;

