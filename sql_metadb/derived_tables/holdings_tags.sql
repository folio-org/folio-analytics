--metadb:table holdings_tags

-- This derived table extracts tags from the holdings record.

DROP TABLE IF EXISTS holdings_tags;

CREATE TABLE holdings_tags AS 
SELECT 
    h.instance_id,
    h.id AS holdings_id,
    h.hrid AS holdings_hrid,
    tags.jsonb #>> '{}' AS holdings_tag,
    tags.ordinality AS holdings_tag_ordinality
FROM 
    folio_inventory.holdings_record__t AS h
    LEFT JOIN folio_inventory.holdings_record ON holdings_record.id = h.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(holdings_record.jsonb, 'tags', 'tagList')) WITH ORDINALITY AS tags (jsonb);
    
