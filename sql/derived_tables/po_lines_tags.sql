DROP TABLE IF EXISTS folio_reporting.po_lines_tags;

-- Create a local table for tags in po_lines.

CREATE TABLE folio_reporting.po_lines_tags AS
SELECT
    pol.id AS pol_id,
    tags #>> '{}' AS pol_tag
FROM
    po_lines AS pol
    CROSS JOIN json_array_elements(
        json_extract_path(data, 'tags', 'tagList')) AS tags;

CREATE INDEX ON folio_reporting.po_lines_tags (pol_id);

CREATE INDEX ON folio_reporting.po_lines_tags (pol_tag);

