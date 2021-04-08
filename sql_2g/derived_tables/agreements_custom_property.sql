DROP TABLE IF EXISTS folio_reporting.agreements_custom_property;

-- Creates a derived table on agreements_custom_property and
-- resolves the definition name from erm_agreements_custom_property_definition
CREATE TABLE folio_reporting.agreements_custom_property AS
SELECT
    id AS custom_property_id,
    definition_id AS custom_property_definition_id,
    cpd.pd_name AS custom_property_definition_name,
    parent_id AS custom_property_parent_id
FROM
    folio_agreements.custom_property AS cp
    LEFT JOIN folio_agreements.custom_property_definition AS cpd ON cp.definition_id = cpd.pd_id;

CREATE INDEX ON folio_reporting.agreements_custom_property (custom_property_id);

CREATE INDEX ON folio_reporting.agreements_custom_property (custom_property_definition_id);

CREATE INDEX ON folio_reporting.agreements_custom_property (custom_property_definition_name);

CREATE INDEX ON folio_reporting.agreements_custom_property (custom_property_parent_id);

