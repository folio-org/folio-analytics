--metadb:function instance_physical_descriptions

DROP FUNCTION IF EXISTS instance_physical_descriptions;

CREATE FUNCTION instance_physical_descriptions()
RETURNS TABLE(
    instance_id uuid,
    instance_hrid text,
    physical_description text,
    physical_description_ordinality bigint)
AS $$
SELECT
    i.id AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    physdesc.jsonb #>> '{}' AS physical_description,
    physdesc.ordinality AS physical_description_ordinality
FROM
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'physicalDescriptions')) WITH ORDINALITY AS physdesc (jsonb)
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
