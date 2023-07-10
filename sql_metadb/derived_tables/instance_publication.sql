--metadb:table instance_publication

-- This derived table extracts publication information from the FOLIO
-- instance record

DROP TABLE IF EXISTS instance_publication;

CREATE TABLE instance_publication AS 
SELECT 
    i.id AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    jsonb_extract_path_text(pub.jsonb, 'place') AS publication_place,
    jsonb_extract_path_text(pub.jsonb, 'publisher') AS publisher,
    jsonb_extract_path_text(pub.jsonb, 'role') AS publication_role,
    jsonb_extract_path_text(pub.jsonb, 'dateOfPublication') AS date_of_publication,
    pub.ordinality AS publication_ordinality
FROM 
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'publication')) WITH ORDINALITY AS pub (jsonb);

