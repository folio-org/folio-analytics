--metadb:table instance_series

-- This derived table extracts series statements from the FOLIO
-- Instance record

DROP TABLE IF EXISTS instance_series;

CREATE TABLE instance_series AS 
SELECT 
    i.id AS instance_id,
    i.jsonb->>'hrid' AS instance_hrid,
    s.jsonb #>> '{}' AS series,
    s.ordinality AS series_ordinality
FROM 
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'series')) WITH ORDINALITY AS s (jsonb);

