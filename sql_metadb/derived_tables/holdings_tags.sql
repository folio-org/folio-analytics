-- This derived table extracts tags from the holdings record.
DROP TABLE IF EXISTS holdings_tags;

CREATE TABLE holdings_tags AS 
SELECT 
    hd.instance_id,
    hd.id AS holding_id,
    hd.hrid AS holding_hrid,
    hldtags.jsonb #>> '{}' AS holding_tag,
    hldtags.ordinality AS holding_tag_ordinality
FROM 
    folio_inventory.holdings_record__t AS hd
    LEFT JOIN folio_inventory.holdings_record AS hdr ON hdr.id = hd.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(hdr.jsonb, 'tags', 'tagList'))
    WITH ORDINALITY AS hldtags (jsonb);
    
CREATE INDEX ON holdings_tags (instance_id);

CREATE INDEX ON holdings_tags (holdins_id);

CREATE INDEX ON holdings_tags (holding_hrid);

CREATE INDEX ON holdings_tags (holding_tag);

CREATE INDEX ON holdings_tags (holding_tag_ordinality);

VACUUM ANALYZE holdings_tags;
