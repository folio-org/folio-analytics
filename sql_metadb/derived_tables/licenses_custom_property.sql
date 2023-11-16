--metadb:table licenses_custom_property
--metadb:require folio_licenses.license.custom_properties_id integer
--metadb:require folio_licenses.license.lic_id uuid
--metadb:require folio_licenses.license.lic_name text
--metadb:require folio_licenses.custom_property_container.id integer
--metadb:require folio_licenses.custom_property.parent_id integer
--metadb:require folio_licenses.custom_property.definition_id text
--metadb:require folio_licenses.custom_property.id integer
--metadb:require folio_licenses.custom_property_definition.pd_id uuid
--metadb:require folio_licenses.custom_property_definition.pd_label text
--metadb:require folio_licenses.custom_property_definition.pd_description text
--metadb:require folio_licenses.custom_property_text.id integer
--metadb:require folio_licenses.custom_property_text.value text
--metadb:require folio_licenses.custom_property_integer.id integer
--metadb:require folio_licenses.custom_property_integer.value integer
--metadb:require folio_licenses.custom_property_decimal.id integer
--metadb:require folio_licenses.custom_property_decimal.value numeric
--metadb:require folio_licenses.custom_property_local_date.id integer
--metadb:require folio_licenses.custom_property_local_date.value timestamp

/*
 * Creates a derived table that contains information about the 
 * custom properties (e.g. terms) for licenses from the app license.
 * The custom properties can defined in the settings from FOLIO.
 */ 

DROP TABLE IF EXISTS stdombek.licenses_custom_property;

CREATE TABLE stdombek.licenses_custom_property AS
SELECT 
    license.lic_id AS license_id,
    license.lic_name AS license_name,
    custom_property.definition_id :: uuid AS custom_property_definition_id,
    custom_property_definition.pd_label AS custom_property_definition_name,
    custom_property_definition.pd_description AS custom_property_definition_description,
    custom_property_text.value AS custom_property_text_value,
    custom_property_integer.value AS custom_property_integer_value,
    custom_property_decimal.value AS custom_property_decimal_value,
    custom_property_local_date.value AS custom_property_local_date_value
FROM 
    folio_licenses.license
    LEFT JOIN folio_licenses.custom_property_container ON custom_property_container.id = license.custom_properties_id 
    LEFT JOIN folio_licenses.custom_property ON custom_property.parent_id = custom_property_container.id 
    LEFT JOIN folio_licenses.custom_property_definition ON custom_property_definition.pd_id = custom_property.definition_id :: uuid
    LEFT JOIN folio_licenses.custom_property_text ON custom_property_text.id = custom_property.id
    LEFT JOIN folio_licenses.custom_property_integer ON custom_property_integer.id = custom_property.id
    LEFT JOIN folio_licenses.custom_property_decimal ON custom_property_decimal.id = custom_property.id 
    LEFT JOIN folio_licenses.custom_property_local_date ON custom_property_local_date.id = custom_property.id
;

COMMENT ON COLUMN stdombek.licenses_custom_property.license_id IS 'The UUID of the license';

COMMENT ON COLUMN stdombek.licenses_custom_property.license_name IS 'The name of the license';

COMMENT ON COLUMN stdombek.licenses_custom_property.custom_property_definition_id IS 'UUID of the custom property';

COMMENT ON COLUMN stdombek.licenses_custom_property.custom_property_definition_name IS 'Name of the custom property';

COMMENT ON COLUMN stdombek.licenses_custom_property.custom_property_definition_description IS 'Description of the custom property';

COMMENT ON COLUMN stdombek.licenses_custom_property.custom_property_text_value IS 'The value of text based custom property';

COMMENT ON COLUMN stdombek.licenses_custom_property.custom_property_integer_value IS 'The value of integer based custom property';

COMMENT ON COLUMN stdombek.licenses_custom_property.custom_property_decimal_value IS 'The value of decimal based custom property';

COMMENT ON COLUMN stdombek.licenses_custom_property.custom_property_local_date_value IS 'The value of date based custom property';
