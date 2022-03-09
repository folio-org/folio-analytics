-- Create table for electronic access points for holdings records

DROP TABLE IF EXISTS holdings_electronic_access;

CREATE TABLE holdings_electronic_access AS
SELECT
    h.instanceid AS instance_id,
    jsonb_extract_path_text(i.jsonb, 'hrid') AS instance_hrid,
    h.id AS holdings_id,
    jsonb_extract_path_text(h.jsonb, 'hrid') AS holdings_hrid,
    jsonb_extract_path_text(eaccess.jsonb, 'relationshipId')::uuid AS relationship_id,
    jsonb_extract_path_text(ear.jsonb, 'name') AS relationship_name,
    jsonb_extract_path_text(eaccess.jsonb, 'uri') AS uri,
    jsonb_extract_path_text(eaccess.jsonb, 'linkText') AS link_text,
    jsonb_extract_path_text(eaccess.jsonb, 'materialsSpecification') AS material_specification,
    jsonb_extract_path_text(eaccess.jsonb, 'publicNote') AS public_note,
    eaccess.ordinality AS eaccess_ordinality
FROM
    folio_inventory.holdings_record AS h
    LEFT JOIN folio_inventory.instance AS i ON h.instanceid = i.id
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(h.jsonb, 'electronicAccess')) WITH ORDINALITY AS eaccess (jsonb)
    LEFT JOIN folio_inventory.electronic_access_relationship AS ear ON jsonb_extract_path_text(eaccess.jsonb, 'relationshipId')::uuid = ear.id;

CREATE INDEX ON holdings_electronic_access (instance_id);

CREATE INDEX ON holdings_electronic_access (instance_hrid);

CREATE INDEX ON holdings_electronic_access (holdings_id);

CREATE INDEX ON holdings_electronic_access (holdings_hrid);

CREATE INDEX ON holdings_electronic_access (relationship_id);

CREATE INDEX ON holdings_electronic_access (relationship_name);

CREATE INDEX ON holdings_electronic_access (uri);

CREATE INDEX ON holdings_electronic_access (link_text);

CREATE INDEX ON holdings_electronic_access (material_specification);

CREATE INDEX ON holdings_electronic_access (public_note);

CREATE INDEX ON holdings_electronic_access (eaccess_ordinality);

VACUUM ANALYZE holdings_electronic_access;

