DROP TABLE IF EXISTS holdings_electronic_access;

-- Create table for electronic access points for holdings records
CREATE TABLE holdings_electronic_access AS
SELECT
    holdings.id AS holdings_id,
    holdings.hrid AS holdings_hrid,
    electronic_access.data #>> '{linkText}' AS link_text,
    electronic_access.data #>> '{materialsSpecification}' AS materials_specification,
    electronic_access.data #>> '{publicNote}' AS public_note,
    electronic_access.data #>> '{relationshipId}' AS relationship_id,
    inventory_electronic_access_relationships.name AS relationship_name,
    electronic_access.data #>> '{uri}' AS uri
FROM
    inventory_holdings AS holdings
    CROSS JOIN jsonb_array_elements((data #> '{electronicAccess}')::jsonb) AS electronic_access(data)
    LEFT JOIN inventory_electronic_access_relationships ON electronic_access.data #>> '{relationshipId}' = inventory_electronic_access_relationships.id;

