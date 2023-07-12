--metadb:table instance_physical_descriptions

-- This derived Metadb table extracts information in the physical
-- description including extent, illustrations, size.

DROP TABLE IF EXISTS instance_physical_descriptions;

CREATE TABLE instance_physical_descriptions AS
SELECT
    i.id AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    physdesc.jsonb #>> '{}' AS physical_description,
    physdesc.ordinality AS physical_description_ordinality
FROM
    folio_inventory.instance AS i
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(i.jsonb, 'physicalDescriptions')) WITH ORDINALITY AS physdesc (jsonb);

