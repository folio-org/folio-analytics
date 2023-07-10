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

COMMENT ON COLUMN po_lines_tags.pol_id IS 'UUID identifying this purchase order line';

COMMENT ON COLUMN po_lines_tags.pol_tag IS 'Arbitrary tags associated with this purchase order line';

COMMENT ON COLUMN po_lines_tags.pol_tag_ordinality IS 'The ordinality of the tag associated with the po line';


