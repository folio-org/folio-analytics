-- create derived table to extract instance identifiers and value 

DROP TABLE IF EXISTS instance_identifiers;

CREATE TABLE instance_identifiers AS
SELECT
    instances.id AS instance_id,
    jsonb_extract_path_text(instances.jsonb, 'hrid') AS instance_hrid,
    jsonb_extract_path_text(idents.jsonb, 'identifierTypeId') AS identifier_type_id,
    itt.name AS identifier_type_name,
    jsonb_extract_path_text(idents.jsonb, 'value') AS identifier,
    idents.ordinality AS identifier_ordinality
FROM
    folio_inventory.instance AS instances
    CROSS JOIN LATERAL jsonb_array_elements(jsonb_extract_path(instances.jsonb, 'identifiers'))
    WITH ORDINALITY AS idents(jsonb)
    LEFT JOIN folio_inventory.identifier_type__t AS itt 
    ON jsonb_extract_path_text(idents.jsonb, 'identifierTypeId')::uuid = itt.id
    ;
    
CREATE INDEX ON instance_identifiers (instance_id);

CREATE INDEX ON instance_identifiers (instance_hrid);

CREATE INDEX ON instance_identifiers (identifier_type_id);

CREATE INDEX ON instance_identifiers (identifier_type_name);

CREATE INDEX ON instance_identifiers (identifier);

CREATE INDEX ON instance_identifiers (identifier_ordinaliry);

VACUUM ANALYZE instance_identifiers;
