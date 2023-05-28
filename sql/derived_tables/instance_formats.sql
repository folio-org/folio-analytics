DROP TABLE IF EXISTS instance_formats;

CREATE TABLE instance_formats AS
WITH instances AS (
    SELECT
        id,
        hrid,
        instance_format_ids.data #>> '{}' AS instance_format_id,
        instance_format_ids.ordinality AS instance_format_ordinality
    FROM
        inventory_instances
        CROSS JOIN LATERAL json_array_elements(json_extract_path(data, 'instanceFormatIds'))
        WITH ORDINALITY AS instance_format_ids (data)
)
SELECT
    instances.id AS instance_id,
    instances.hrid AS instance_hrid,
    instances.instance_format_id AS format_id,
    instances.instance_format_ordinality AS format_ordinality,
    formats.code AS format_code,
    formats.name AS format_name,
    formats.source AS format_source
FROM
    instances
    LEFT JOIN inventory_instance_formats AS formats ON instances.instance_format_id = formats.id;

