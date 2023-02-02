--metadb:table instance_tags

-- This derived table extracts tags from the instance record.

DROP TABLE IF EXISTS instance_tags;

CREATE TABLE instance_tags AS
SELECT
    i.id AS instance_id,
    i.hrid AS instance_hrid,
    taglist.jsonb #>> '{}' AS instance_tag,
    taglist.ordinality AS instance_tag_ordinality
FROM
    folio_inventory.instance__t AS i
    LEFT JOIN folio_inventory.instance AS inst ON inst.id = i.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'tags', 'tagList')) WITH ORDINALITY AS taglist (jsonb);

CREATE INDEX ON instance_tags (instance_id);

CREATE INDEX ON instance_tags (instance_hrid);

CREATE INDEX ON instance_tags (instance_tag);

CREATE INDEX ON instance_tags (instance_tag_ordinality);

VACUUM ANALYZE instance_tags;
