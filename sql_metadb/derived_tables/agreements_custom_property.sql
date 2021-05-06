/*
 * Creates a derived table on agreements custom properties
 */
DROP TABLE IF EXISTS folio_derived.agreements_custom_property;

CREATE TABLE folio_derived.agreements_custom_property AS
select
	agreements_custom_property_container.id as "custom_property_container_id", -- ID that can be linked to the "custom_properties_id" attribute in the "folio_agreements.subscription_agreement" table
	agreements_custom_property.id as "custom_property_id",
	agreements_custom_property.note as "custom_property_note",
	agreements_custom_property.public_note as "custom_property_public_note",
	agreements_custom_property_definition.pd_id as "custom_property_definition_uuid",
	agreements_custom_property_definition.pd_name as "custom_property_definition_pd_name",
	agreements_custom_property_definition.pd_type as "custom_property_definition_pd_type",
	agreements_custom_property_definition.pd_description as "custom_property_definition_pd_description",
	agreements_custom_property_definition.pd_label as "custom_property_definition_pd_label",
	agreements_custom_property_integer.id as "custom_property_integer_id",
	agreements_custom_property_integer.value as "custom_property_integer_value",
	agreements_custom_property_text.id as "custom_property_text_id",
	agreements_custom_property_text.value as "custom_property_text_value"
from 
	folio_agreements.custom_property_container as agreements_custom_property_container
	left join 
	folio_agreements.custom_property as agreements_custom_property on agreements_custom_property_container.id = agreements_custom_property.parent_id
	left join 
	folio_agreements.custom_property_definition as agreements_custom_property_definition on agreements_custom_property.definition_id = agreements_custom_property_definition.pd_id
	left join 
	folio_agreements.custom_property_integer as agreements_custom_property_integer on agreements_custom_property_integer.id = agreements_custom_property.id
	left join 
	folio_agreements.custom_property_text as agreements_custom_property_text on agreements_custom_property_text.id = agreements_custom_property.id;

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_container_id);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_id);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_note);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_public_note);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_uuid);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_pd_name);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_pd_type);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_pd_description);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_definition_pd_label);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_integer_id);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_integer_value);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_text_id);

CREATE INDEX ON folio_derived.agreements_custom_property (custom_property_text_value);