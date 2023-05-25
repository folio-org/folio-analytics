--metadb:table instance_subjects

-- This derived table extracts subjects from the FOLIO Instance record

DROP TABLE IF EXISTS instance_subjects;

CREATE TABLE instance_subjects AS 
SELECT 
    inst.id AS instance_id,
    inst.hrid AS instance_hrid,
    instsubjects.jsonb #>> '{}' AS subjects,
    instsubjects.ordinality AS subjects_ordinality
FROM 
    folio_inventory.instance__t AS inst
    LEFT JOIN folio_inventory.instance ON instance.id = inst.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(instance.jsonb, 'subjects')) WITH ORDINALITY AS instsubjects (jsonb);

