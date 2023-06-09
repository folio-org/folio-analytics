DROP TABLE IF EXISTS po_lines_tags;

-- Create a local table for tags in po_lines.
CREATE TABLE po_lines_tags AS
SELECT
    pol.id AS pol_id,
    tags.data #>> '{}' AS pol_tag,
    tags.ordinality AS pol_tag_ordinality
FROM
    po_lines AS pol
    CROSS JOIN LATERAL jsonb_array_elements((data->'tags'->'tagList')::jsonb)
    WITH ORDINALITY AS tags (data);

