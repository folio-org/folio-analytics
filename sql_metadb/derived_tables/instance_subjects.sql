--metadb:table instance_subjects

-- This derived table extracts subjects from the FOLIO Instance record

DROP TABLE IF EXISTS instance_subjects;

CREATE TABLE instance_subjects AS 
SELECT 
    i.id AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    s.jsonb #>> '{}' AS subjects,
    s.ordinality AS subjects_ordinality
FROM 
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'subjects')) WITH ORDINALITY AS s (jsonb);
