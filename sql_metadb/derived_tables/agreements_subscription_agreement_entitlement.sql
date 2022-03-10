DROP TABLE IF EXISTS agreements_subscription_agreement_entitlement;

-- Creates a derived table on subscription_agreement with entitlement and 
-- order_line to add po_line_id
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

CREATE INDEX ON agreements_subscription_agreement_entitlement (subscription_agreement_id);

CREATE INDEX ON agreements_subscription_agreement_entitlement (subscription_agreement_name);

CREATE INDEX ON agreements_subscription_agreement_entitlement (subscription_agreement_local_reference);

CREATE INDEX ON agreements_subscription_agreement_entitlement (subscription_agreement_type);

CREATE INDEX ON agreements_subscription_agreement_entitlement (subscription_agreement_type_value);

CREATE INDEX ON agreements_subscription_agreement_entitlement (subscription_agreement_type_label);

CREATE INDEX ON agreements_subscription_agreement_entitlement (subscription_agreement_status);

CREATE INDEX ON agreements_subscription_agreement_entitlement (subscription_agreement_status_value);

CREATE INDEX ON agreements_subscription_agreement_entitlement (subscription_agreement_status_label);

CREATE INDEX ON agreements_subscription_agreement_entitlement (entitlement_id);

CREATE INDEX ON agreements_subscription_agreement_entitlement (entitlement_active_to);

CREATE INDEX ON agreements_subscription_agreement_entitlement (entitlement_active_from);

CREATE INDEX ON agreements_subscription_agreement_entitlement (entitlement_subscription_agreement_id);

CREATE INDEX ON agreements_subscription_agreement_entitlement (entitlement_resource_fk);

CREATE INDEX ON agreements_subscription_agreement_entitlement (entitlement_authority);

CREATE INDEX ON agreements_subscription_agreement_entitlement (entitlement_reference);

CREATE INDEX ON agreements_subscription_agreement_entitlement (po_line_id);

VACUUM ANALYZE agreements_subscription_agreement_entitlement;
