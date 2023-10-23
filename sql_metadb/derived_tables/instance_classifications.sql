--metadb:table instance_classifications

-- This derived table extracts classification values, ids, and names
-- from the instance.

DROP TABLE IF EXISTS instance_classifications;

CREATE TABLE instance_classifications AS 
SELECT
    i.id AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    jsonb_extract_path_text(instclass.jsonb, 'classificationNumber') AS classification_number,
    jsonb_extract_path_text(instclass.jsonb, 'classificationTypeId')::uuid AS classification_type_id,
    instclass.ordinality AS classification_ordinality,
    classtype.name AS classification_name
FROM
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'classifications')) WITH ORDINALITY AS instclass (jsonb)
    LEFT JOIN folio_inventory.classification_type__t AS classtype
        ON jsonb_extract_path_text(instclass.jsonb, 'classificationTypeId')::uuid = classtype.id;

