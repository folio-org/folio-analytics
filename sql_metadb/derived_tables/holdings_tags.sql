-- This derived table extracts tags from the holdings record.
DROP TABLE IF EXISTS holdings_tags;

CREATE TABLE holdings_tags AS 
SELECT 
    hd.instance_id,
    hd.id AS holdings_id,
    hd.hrid AS holdings_hrid,
    hldtags.jsonb #>> '{}' AS holdings_tag,
    hldtags.ordinality AS holdings_tag_ordinality
FROM 
    folio_inventory.holdings_record__t AS hd
    LEFT JOIN folio_inventory.holdings_record AS hdr ON hdr.id = hd.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(hdr.jsonb, 'tags', 'tagList'))
    WITH ORDINALITY AS hldtags (jsonb);
    
CREATE INDEX ON holdings_tags (instance_id);

CREATE INDEX ON holdings_tags (holdings_id);

CREATE INDEX ON holdings_tags (holdings_hrid);

CREATE INDEX ON holdings_tags (holdings_tag);

CREATE INDEX ON holdings_tags (holdings_tag_ordinality);

VACUUM ANALYZE holdings_tags;
