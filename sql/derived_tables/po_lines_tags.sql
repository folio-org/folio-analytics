DROP TABLE IF EXISTS po_lines_tags;

-- Create a local table for tags in po_lines.
CREATE TABLE po_lines_tags AS
SELECT
    pol.id AS pol_id,
    tags.data #>> '{}' AS pol_tag,
    tags.ordinality AS pol_tag_ordinality
FROM
    po_lines AS pol
    CROSS JOIN LATERAL json_array_elements(json_extract_path(data, 'tags', 'tagList'))
    WITH ORDINALITY AS tags (data);

CREATE INDEX ON po_lines_tags (pol_id);

CREATE INDEX ON po_lines_tags (pol_tag);

CREATE INDEX ON po_lines_tags (pol_tag_ordinality);


VACUUM ANALYZE  po_lines_tags;
