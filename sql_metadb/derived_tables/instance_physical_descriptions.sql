--metadb:table instance_physical_descriptions

-- This derived Metadb table extracts information in the physical
-- description including extent, illustrations, size.

DROP TABLE IF EXISTS instance_physical_descriptions;

CREATE TABLE instance_physical_descriptions AS
SELECT
    i.id AS instance_id,
    i.hrid AS instance_hrid,
    physdesc.jsonb #>> '{}' AS physical_description,
    physdesc.ordinality AS physical_description_ordinality
FROM
    folio_inventory.instance__t AS i
    LEFT JOIN folio_inventory.instance AS inst ON inst.id = i.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'physicalDescriptions')) WITH ORDINALITY AS physdesc (jsonb);

