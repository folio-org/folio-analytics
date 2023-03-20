--metadb:table po_lines_tags

-- Creates a derived table for tags in purchase order lines.

DROP TABLE IF EXISTS po_lines_tags;

CREATE TABLE po_lines_tags AS
SELECT
    pol.id AS pol_id,
    tags.data #>> '{}' AS pol_tag,
    tags.ordinality AS pol_tag_ordinality
FROM
    folio_orders.po_line AS pol
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(jsonb, 'tags', 'tagList')) WITH ORDINALITY AS tags (data);

CREATE INDEX ON po_lines_tags (pol_id);

CREATE INDEX ON po_lines_tags (pol_tag);

CREATE INDEX ON po_lines_tags (pol_tag_ordinality);

COMMENT ON COLUMN po_lines_tags.pol_id IS 'description';

COMMENT ON COLUMN po_lines_tags.pol_tag IS 'description';

COMMENT ON COLUMN po_lines_tags.pol_tag_ordinality IS 'description';

VACUUM ANALYZE po_lines_tags;

