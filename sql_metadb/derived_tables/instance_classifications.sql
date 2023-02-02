--metadb:table instance_classifications

-- This derived table extracts classification values, ids, and names
-- from the instance.

DROP TABLE IF EXISTS instance_classifications;

CREATE TABLE instance_classifications AS 
SELECT
    inst.id AS instance_id,
    inst.hrid AS instance_hrid,
    jsonb_extract_path_text(instclass.jsonb, 'classificationNumber') AS classification_number,
    jsonb_extract_path_text(instclass.jsonb, 'classificationTypeId')::uuid AS classification_type_id,
    instclass.ordinality AS classification_ordinality,
    classtype.name AS classification_name
FROM
    folio_inventory.instance__t AS inst
    LEFT JOIN folio_inventory.instance ON instance.id::uuid = inst.id::uuid
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(instance.jsonb, 'classifications')) WITH ORDINALITY AS instclass (jsonb)
    LEFT JOIN folio_inventory.classification_type__t AS classtype ON jsonb_extract_path_text(instclass.jsonb, 'classificationTypeId')::uuid = classtype.id::uuid ;

CREATE INDEX ON instance_classifications (instance_id);

CREATE INDEX ON instance_classifications (instance_hrid);

CREATE INDEX ON instance_classifications (classification_number);

CREATE INDEX ON instance_classifications (classification_type_id);

CREATE INDEX ON instance_classifications (classification_ordinality);

CREATE INDEX ON instance_classifications (classification_name);

VACUUM ANALYZE instance_classifications;
