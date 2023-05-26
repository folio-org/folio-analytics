--metadb:table instance_subjects

-- This derived table extracts subjects from the FOLIO Instance record

DROP TABLE IF EXISTS instance_subjects;

CREATE TABLE instance_subjects AS 
SELECT 
    (instance.jsonb->>'id')::uuid AS instance_id,
    instance.jsonb->>'hrid' AS instance_hrid,
    instsubjects.jsonb #>> '{}' AS subjects,
    instsubjects.ordinality AS subjects_ordinality
FROM 
    folio_inventory.instance
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(instance.jsonb, 'subjects')) WITH ORDINALITY AS instsubjects (jsonb);
