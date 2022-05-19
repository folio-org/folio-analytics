-- metadb -- item_tags
-- This table creates a listing of items and their tag(s).

DROP TABLE IF EXISTS item_tags;

CREATE TABLE item_tags AS
SELECT
    i.id AS item_id,
    it.hrid AS item_hrid,
    tags.data #>> '{}' AS item_tag,
    tags.ordinality AS item_tag_ordinality
FROM
    folio_inventory.item AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'tags', 'tagList')) WITH ORDINALITY AS tags(data)
    LEFT JOIN folio_inventory.item__t AS it ON i.id = it.id;

CREATE INDEX ON item_tags (item_id);

CREATE INDEX ON item_tags (item_hrid);

CREATE INDEX ON item_tags (item_tag);

CREATE INDEX ON item_tags (item_tag_ordinality);

VACUUM ANALYZE item_tags;
