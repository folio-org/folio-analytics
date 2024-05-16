--metadb:function instance_languages

DROP FUNCTION IF EXISTS instance_languages;

CREATE FUNCTION instance_languages()
RETURNS TABLE(
    instance_id uuid,
    instance_hrid text,
    instance_language text,
    language_ordinality bigint)
AS $$
SELECT
    instances.id AS instance_id,
    jsonb_extract_path_text(instances.jsonb, 'hrid') AS instance_hrid,
    languages.jsonb #>> '{}' AS instance_language,
    languages.ordinality AS language_ordinality
FROM
    folio_inventory.instance AS instances
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'languages')) WITH ORDINALITY AS languages (jsonb)
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
