--metadb:table instance_series

-- This derived table extracts series statements from the FOLIO
-- Instance record

DROP TABLE IF EXISTS instance_series;

CREATE TABLE instance_series AS 
SELECT 
    inst.id AS instance_id,
    inst.hrid AS instance_hrid,
    instseries.jsonb #>> '{}' AS series,
    instseries.ordinality AS series_ordinality
FROM 
    folio_inventory.instance__t AS inst
    LEFT JOIN folio_inventory.instance ON instance.id::uuid = inst.id::uuid
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(instance.jsonb, 'series')) WITH ORDINALITY AS instseries (jsonb);

CREATE INDEX ON instance_series (instance_id);

CREATE INDEX ON instance_series (instance_hrid);

CREATE INDEX ON instance_series (series);

CREATE INDEX ON instance_series (series_ordinality);

