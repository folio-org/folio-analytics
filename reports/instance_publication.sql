--metadb:function instance_publication

DROP FUNCTION IF EXISTS instance_publication;

CREATE FUNCTION instance_publication()
RETURNS TABLE(
    instance_id uuid,
    instance_hrid text,
    publication_place text,
    publisher text,
    publication_role text,
    date_of_publication text,
    publication_ordinality bigint)
AS $$
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
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'publication')) WITH ORDINALITY AS pub (jsonb)
$$
LANGUAGE SQL
STABLE
PARALLEL SAFE;
