--metadb:table instance_formats

-- Create derived table for instance formats bringing together the identifier and name
-- Note: Because of inaccurate data in FOLIO, instance_format_id is a varchar and the ift.id has to be cast as a varchar.

DROP TABLE IF EXISTS instance_formats;

CREATE TABLE instance_formats AS
WITH instances AS (
    SELECT
        i.id AS instance_id,
        jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
        instance_format_ids.jsonb #>> '{}' AS instance_format_id,
        instance_format_ids.ordinality AS instance_format_ordinality
    FROM
        folio_inventory.instance AS i
        CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'instanceFormatIds')) WITH ORDINALITY AS instance_format_ids (jsonb)
)
SELECT
    it.instance_id,
    it.instance_hrid,
    it.instance_format_id,
    it.instance_format_ordinality,
    ift.code AS instance_format_code,
    ift.name AS instance_format_name,
    ift.source AS instance_format_source
FROM
    instances AS it
    LEFT JOIN folio_inventory.instance_format__t AS ift ON it.instance_format_id = ift.id::varchar;


