--metadb:table instance_identifiers

-- Create derived table to extract instance identifiers and value

DROP TABLE IF EXISTS instance_identifiers;

CREATE TABLE instance_identifiers AS
SELECT
    inst.id AS instance_id,
    inst.jsonb->>'hrid' AS instance_hrid,
    (ident.jsonb->>'identifierTypeId')::uuid AS identifier_type_id,
    idtype.name AS identifier_type_name,
    ident.jsonb->>'value' AS identifier,
    ident.ordinality AS identifier_ordinality
FROM
    folio_inventory.instance AS inst
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(inst.jsonb, 'identifiers')) WITH ORDINALITY AS ident (jsonb)
    LEFT JOIN folio_inventory.identifier_type__t AS idtype ON (ident.jsonb->>'identifierTypeId')::uuid = idtype.id;

