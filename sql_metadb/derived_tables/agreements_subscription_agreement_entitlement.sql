--metadb:table agreements_subscription_agreement_entitlement
--metadb:require folio_agreements.entitlement.ent_id uuid
--metadb:require folio_agreements.entitlement.ent_active_to date
--metadb:require folio_agreements.entitlement.ent_active_from date
--metadb:require folio_agreements.entitlement.ent_owner_fk uuid
--metadb:require folio_agreements.entitlement.ent_resource_fk uuid
--metadb:require folio_agreements.entitlement.ent_authority text
--metadb:require folio_agreements.entitlement.ent_reference text
--metadb:require folio_agreements.order_line.pol_owner_fk uuid
--metadb:require folio_agreements.order_line.pol_orders_fk uuid

-- Creates a derived table on subscription_agreement with entitlement and
-- order_line to add po_line_id

DROP TABLE IF EXISTS agreements_subscription_agreement_entitlement;

CREATE TABLE agreements_subscription_agreement_entitlement AS
SELECT
    sa_id AS subscription_agreement_id,
    sa_name AS subscription_agreement_name,
    sa_local_reference AS subscription_agreement_local_reference,
    sa_agreement_type AS subscription_agreement_type,
    sat.rdv_value AS subscription_agreement_type_value,
    sat.rdv_label AS subscription_agreement_type_label,
    sa_agreement_status AS subscription_agreement_status,
    sas.rdv_value AS subscription_agreement_status_value,
    sas.rdv_label AS subscription_agreement_status_label,
    ent.ent_id AS entitlement_id,
    ent.ent_active_to AS entitlement_active_to,
    ent.ent_active_from AS entitlement_active_from,
    ent.ent_owner_fk AS entitlement_subscription_agreement_id,
    ent.ent_resource_fk AS entitlement_resource_fk,
    ent.ent_authority AS entitlement_authority,
    ent.ent_reference AS entitlement_reference,
    ol.pol_orders_fk::uuid AS po_line_id
FROM
    folio_agreements.subscription_agreement AS sa
    LEFT JOIN folio_agreements.entitlement AS ent ON sa.sa_id = ent.ent_owner_fk
    LEFT JOIN folio_agreements.order_line AS ol ON ent.ent_id = ol.pol_owner_fk
   	LEFT JOIN folio_agreements.refdata_value AS sat ON sa_agreement_type = sat.rdv_id
    LEFT JOIN folio_agreements.refdata_value AS sas ON sa_agreement_status = sas.rdv_id;

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.subscription_agreement_id IS 'UUID of Agreement';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.subscription_agreement_name IS 'A name for the agreement assigned by the institution';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.subscription_agreement_local_reference IS 'Where an agreement has been created through an integration / data import from an external system the sa_local_reference is used to store a reference/identifier for the agreement in the external system to support ongoing data synchronisation/updates';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.subscription_agreement_type IS 'ID of reference data value for agreement type';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.subscription_agreement_type_value IS 'Describes the type of the agreement';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.subscription_agreement_type_label IS 'Displayed name of agreement type';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.subscription_agreement_status IS 'ID of reference data value for agreement status';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.subscription_agreement_status_value IS 'Describes the current status of the agreement (e.g. Active, Closed)';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.subscription_agreement_status_label IS 'Displayed name of agreement status';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.entitlement_id IS 'UUID of Entitlement (aka Agreement Line)';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.entitlement_active_to IS 'Date to which the entitlement was active in format yyyy-MM-dd. No time or timezone';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.entitlement_active_from IS 'Date from which the entitlement was active in format yyyy-MM-dd. No time or timezone';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.entitlement_subscription_agreement_id IS 'ID of Agreement to which the entitlement belongs';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.entitlement_resource_fk IS 'ID of the resource (mod_agreements.erm_resource.id, mod_agreements.package.id, mod_agreements.package_content_item.id ) which the Entitlement gives access to';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.entitlement_authority IS 'Where an entitlement gives access to a resource described in a source other than the mod_agreements internal knowledgebase, the ent_authority is a way of identifying where the definition of the resource is held ';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.entitlement_reference IS 'Where an entitlement gives access to a resource described in a source other than the mod_agreements internal knowledgebase, the ent_reference is the ID for the resource in the source identified by ent_authority ';

COMMENT ON COLUMN agreements_subscription_agreement_entitlement.po_line_id IS 'UUID of purchase order line in Orders app';

