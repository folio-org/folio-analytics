--metadb:table instance_tags

-- This derived table extracts tags from the instance record.

DROP TABLE IF EXISTS instance_tags;

CREATE TABLE instance_tags AS
SELECT
    i.id AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    taglist.jsonb #>> '{}' AS instance_tag,
    taglist.ordinality AS instance_tag_ordinality
FROM
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'tags', 'tagList')) WITH ORDINALITY AS taglist (jsonb);

